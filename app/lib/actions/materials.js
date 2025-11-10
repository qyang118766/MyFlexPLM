'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { getEnumValuesList, ENUM_TYPES } from '@/lib/services/enums';
import { createVersionedItem, executeVersionedUpdate } from '@/lib/services/versionControl';
import { assertPermission } from '@/lib/permissions';

function normalizeText(value) {
  if (value === null || value === undefined) return null;
  const trimmed = value.toString().trim();
  return trimmed.length > 0 ? trimmed : null;
}

function normalizeSelect(value, allowed, fallback) {
  const text = normalizeText(value);
  if (!text) return fallback;
  return allowed.includes(text) ? text : fallback;
}

function parseOptions(rawOptions) {
  if (!rawOptions) return null;
  if (typeof rawOptions === 'string') {
    try {
      return JSON.parse(rawOptions);
    } catch {
      return null;
    }
  }
  return rawOptions;
}

function parseAttributeValue(value, dataType, options) {
  if (value === null || value === undefined) return null;
  const trimmed = value.toString().trim();
  if (trimmed.length === 0) return null;

  switch (dataType) {
    case 'number': {
      const parsed = parseFloat(trimmed);
      return Number.isFinite(parsed) ? parsed : null;
    }
    case 'boolean':
      return trimmed === 'true';
    case 'date':
      return trimmed;
    case 'enum': {
      const parsedOptions = parseOptions(options);
      const allowed = Array.isArray(parsedOptions?.values)
        ? parsedOptions.values
        : Array.isArray(parsedOptions)
        ? parsedOptions
        : [];
      return allowed.includes(trimmed) ? trimmed : null;
    }
    default:
      return trimmed;
  }
}

async function fetchAttributeDefs(supabase) {
  const { data, error } = await supabase
    .from('attribute_definitions')
    .select('id, key, data_type, options, required')
    .eq('entity_type', 'material')
    .eq('is_active', true)
    .order('order_index', { ascending: true })
    .order('created_at', { ascending: true });

  if (error) {
    throw new Error(error.message);
  }

  return data ?? [];
}

function buildAttributesPayload(attributeDefs, formData) {
  const payload = {};
  attributeDefs.forEach((attribute) => {
    const formKey = `attribute_${attribute.key}`;
    const value = parseAttributeValue(formData.get(formKey), attribute.data_type, attribute.options);
    if (value !== null && value !== undefined && value !== '') {
      payload[attribute.key] = value;
    }
  });
  return payload;
}

async function getCurrentUserIdentifier(supabase) {
  const {
    data: { user },
  } = await supabase.auth.getUser();
  return (
    user?.user_metadata?.role_name ||
    user?.user_metadata?.role ||
    user?.email ||
    user?.id ||
    null
  );
}

export async function createMaterial(formData) {
  const supabase = await createClient();
  const userIdentifier = await getCurrentUserIdentifier(supabase);
  const validStatuses = await getEnumValuesList(ENUM_TYPES.MATERIAL_STATUS);

  const materialCode = normalizeText(formData.get('material_code'));
  const name = normalizeText(formData.get('name'));
  const typeId = normalizeText(formData.get('type_id'));
  const status = normalizeSelect(formData.get('status'), validStatuses, 'in_development');

  if (!materialCode || !name) {
    throw new Error('Material code and name are required.');
  }

  if (!typeId) {
    throw new Error('Material type must be selected.');
  }

  // Check permission - user must have 'create' or higher permission for this type node
  await assertPermission(typeId, 'create', 'You do not have permission to create materials of this type.');

  const attributeDefs = await fetchAttributeDefs(supabase);
  const attributesPayload = buildAttributesPayload(attributeDefs, formData);
  const timestamp = new Date().toISOString();

  // Prepare payload WITHOUT code and version fields (createVersionedItem handles those)
  const payload = {
    name,
    type_id: typeId,
    status,
    attributes: Object.keys(attributesPayload).length > 0 ? attributesPayload : null,
    updated_at: timestamp,
  };

  // Use version control module to create master record and first version
  const result = await createVersionedItem('materials', materialCode, payload, userIdentifier);

  if (!result.success) {
    throw new Error(result.error || 'Failed to create material');
  }

  revalidatePath('/materials');
  redirect('/materials');
}

export async function updateMaterial(formData) {
  const supabase = await createClient();
  const userIdentifier = await getCurrentUserIdentifier(supabase);
  const validStatuses = await getEnumValuesList(ENUM_TYPES.MATERIAL_STATUS);

  const materialId = normalizeText(formData.get('material_id'));
  if (!materialId) {
    throw new Error('Material id is required.');
  }

  // Fetch existing material to get material_code and other preserved fields
  const { data: existingMaterial, error: existingError } = await supabase
    .from('materials')
    .select('material_code, type_id')
    .eq('id', materialId)
    .single();

  if (existingError || !existingMaterial) {
    throw new Error('Material not found.');
  }

  // Check permission - user must have 'edit' or higher permission for this type node
  await assertPermission(existingMaterial.type_id, 'edit', 'You do not have permission to edit this material.');

  const materialCode = existingMaterial.material_code;
  const name = normalizeText(formData.get('name'));
  const typeId = normalizeText(formData.get('type_id')) || existingMaterial.type_id;
  const status = normalizeSelect(formData.get('status'), validStatuses, 'in_development');

  if (!name) {
    throw new Error('Material name is required.');
  }

  if (!typeId) {
    throw new Error('Material type must be selected.');
  }

  const attributeDefs = await fetchAttributeDefs(supabase);
  const attributesPayload = buildAttributesPayload(attributeDefs, formData);
  const timestamp = new Date().toISOString();

  // Prepare payload WITHOUT version fields (executeVersionedUpdate handles those)
  const payload = {
    name,
    type_id: typeId,
    status,
    attributes: Object.keys(attributesPayload).length > 0 ? attributesPayload : null,
    updated_at: timestamp,
  };

  // Use version control module to execute versioned update
  const result = await executeVersionedUpdate('materials', materialCode, payload, userIdentifier);

  if (!result.success) {
    throw new Error(result.error || 'Failed to update material');
  }

  revalidatePath('/materials');
  redirect('/materials');
}

export async function deleteMaterial(formData) {
  const supabase = await createClient();
  const materialId = normalizeText(formData.get('material_id'));

  if (!materialId) {
    throw new Error('Material id is required.');
  }

  // Get material's type_id before deleting
  const { data: material, error: fetchError } = await supabase
    .from('materials')
    .select('type_id')
    .eq('id', materialId)
    .single();

  if (fetchError || !material) {
    throw new Error('Material not found.');
  }

  // Check permission - user must have 'delete' or 'full' permission for this type node
  await assertPermission(material.type_id, 'delete', 'You do not have permission to delete this material.');

  const { error } = await supabase.from('materials').delete().eq('id', materialId);

  if (error) {
    throw new Error(error.message);
  }

  revalidatePath('/materials');
}

