'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { getEnumValuesList, ENUM_TYPES } from '@/lib/services/enums';
import { createVersionedItem, executeVersionedUpdate } from '@/lib/services/versionControl';

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
    .eq('entity_type', 'supplier')
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

export async function createSupplier(formData) {
  const supabase = await createClient();
  const userIdentifier = await getCurrentUserIdentifier(supabase);
  const validStatuses = await getEnumValuesList(ENUM_TYPES.SUPPLIER_STATUS);

  const supplierCode = normalizeText(formData.get('supplier_code'));
  const name = normalizeText(formData.get('name'));
  const region = normalizeText(formData.get('region'));
  const typeId = normalizeText(formData.get('type_id'));
  const status = normalizeSelect(formData.get('status'), validStatuses, 'active');

  if (!supplierCode || !name) {
    throw new Error('Supplier code and name are required.');
  }

  if (!typeId) {
    throw new Error('Supplier type must be selected.');
  }

  const attributeDefs = await fetchAttributeDefs(supabase);
  const attributesPayload = buildAttributesPayload(attributeDefs, formData);
  const timestamp = new Date().toISOString();

  // Prepare payload WITHOUT code and version fields (createVersionedItem handles those)
  const payload = {
    name,
    region,
    type_id: typeId,
    status,
    attributes: Object.keys(attributesPayload).length > 0 ? attributesPayload : null,
    updated_at: timestamp,
  };

  // Use version control module to create master record and first version
  const result = await createVersionedItem('suppliers', supplierCode, payload, userIdentifier);

  if (!result.success) {
    throw new Error(result.error || 'Failed to create supplier');
  }

  revalidatePath('/suppliers');
  redirect('/suppliers');
}

export async function updateSupplier(formData) {
  const supabase = await createClient();
  const userIdentifier = await getCurrentUserIdentifier(supabase);
  const validStatuses = await getEnumValuesList(ENUM_TYPES.SUPPLIER_STATUS);

  const supplierId = normalizeText(formData.get('supplier_id'));
  if (!supplierId) {
    throw new Error('Supplier id is required.');
  }

  // Fetch existing supplier to get supplier_code and other preserved fields
  const { data: existingSupplier, error: existingError } = await supabase
    .from('suppliers')
    .select('supplier_code, type_id')
    .eq('id', supplierId)
    .single();

  if (existingError || !existingSupplier) {
    throw new Error('Supplier not found.');
  }

  const supplierCode = existingSupplier.supplier_code;
  const name = normalizeText(formData.get('name'));
  const region = normalizeText(formData.get('region'));
  const typeId = normalizeText(formData.get('type_id')) || existingSupplier.type_id;
  const status = normalizeSelect(formData.get('status'), validStatuses, 'active');

  if (!name) {
    throw new Error('Supplier name is required.');
  }

  if (!typeId) {
    throw new Error('Supplier type must be selected.');
  }

  const attributeDefs = await fetchAttributeDefs(supabase);
  const attributesPayload = buildAttributesPayload(attributeDefs, formData);
  const timestamp = new Date().toISOString();

  // Prepare payload WITHOUT version fields (executeVersionedUpdate handles those)
  const payload = {
    name,
    region,
    type_id: typeId,
    status,
    attributes: Object.keys(attributesPayload).length > 0 ? attributesPayload : null,
    updated_at: timestamp,
  };

  // Use version control module to execute versioned update
  const result = await executeVersionedUpdate('suppliers', supplierCode, payload, userIdentifier);

  if (!result.success) {
    throw new Error(result.error || 'Failed to update supplier');
  }

  revalidatePath('/suppliers');
  redirect('/suppliers');
}

export async function deleteSupplier(formData) {
  const supabase = await createClient();
  const supplierId = normalizeText(formData.get('supplier_id'));

  if (!supplierId) {
    throw new Error('Supplier id is required.');
  }

  const { error } = await supabase.from('suppliers').delete().eq('id', supplierId);

  if (error) {
    throw new Error(error.message);
  }

  revalidatePath('/suppliers');
}

