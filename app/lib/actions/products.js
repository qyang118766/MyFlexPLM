'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { getEnumValuesList, ENUM_TYPES } from '@/lib/services/enums';
import { createVersionedItem, executeVersionedUpdate } from '@/lib/services/versionControl';
import { assertPermission, checkUserPermission } from '@/lib/permissions';

function normalizeText(value) {
  if (value === null || value === undefined) return null;
  const trimmed = value.toString().trim();
  return trimmed.length > 0 ? trimmed : null;
}

function normalizeSelect(value, allowedValues, fallback = null) {
  const normalized = normalizeText(value);
  if (!normalized) {
    return fallback;
  }
  return allowedValues.includes(normalized) ? normalized : fallback;
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

function buildAttributesPayload(attributeDefs, formData) {
  const attributesPayload = {};
  attributeDefs?.forEach((attribute) => {
    const formKey = `attribute_${attribute.key}`;
    const value = parseAttributeValue(formData.get(formKey), attribute.data_type, attribute.options);

    if (value !== null && value !== undefined && value !== '') {
      attributesPayload[attribute.key] = value;
    }
  });
  return attributesPayload;
}

export async function createProduct(formData) {
  const supabase = await createClient();
  const userIdentifier = await getCurrentUserIdentifier(supabase);

  const validGenders = await getEnumValuesList(ENUM_TYPES.PRODUCT_GENDER);
  const validStatuses = await getEnumValuesList(ENUM_TYPES.PRODUCT_STATUS);

  const styleCode = normalizeText(formData.get('style_code'));
  const name = normalizeText(formData.get('name'));
  const typeId = normalizeText(formData.get('type_id'));

  if (!styleCode || !name) {
    throw new Error('Style code and name are required.');
  }

  if (!typeId) {
    throw new Error('Product type must be selected.');
  }

  // Check permission - user must have 'create' or higher permission for this type node
  await assertPermission(typeId, 'create', 'You do not have permission to create products of this type.');

  const gender = normalizeSelect(formData.get('gender'), validGenders, 'unisex');
  const status = normalizeSelect(formData.get('status'), validStatuses, 'development');
  const seasonId = normalizeText(formData.get('season_id'));

  const { data: attributeDefs, error: attributeError } = await supabase
    .from('attribute_definitions')
    .select('id, key, data_type, options, required')
    .eq('entity_type', 'product')
    .eq('is_active', true);

  if (attributeError) {
    throw new Error(attributeError.message);
  }

  const attributesPayload = buildAttributesPayload(attributeDefs, formData);
  const timestamp = new Date().toISOString();

  // Prepare payload WITHOUT code and version fields (createVersionedItem handles those)
  const payload = {
    name,
    gender,
    status,
    type_id: typeId,
    season_id: seasonId || null,
    attributes: Object.keys(attributesPayload).length > 0 ? attributesPayload : null,
    updated_at: timestamp,
  };

  // Use version control module to create master record and first version
  const result = await createVersionedItem('products', styleCode, payload, userIdentifier);

  if (!result.success) {
    throw new Error(result.error || 'Failed to create product');
  }

  revalidatePath('/products');
  redirect('/products');
}

export async function updateProduct(formData) {
  const supabase = await createClient();
  const userIdentifier = await getCurrentUserIdentifier(supabase);

  const validGenders = await getEnumValuesList(ENUM_TYPES.PRODUCT_GENDER);
  const validStatuses = await getEnumValuesList(ENUM_TYPES.PRODUCT_STATUS);

  const productId = normalizeText(formData.get('product_id'));
  if (!productId) {
    throw new Error('Product id is required.');
  }

  // Fetch existing product to get style_code and other preserved fields
  const { data: existingProduct, error: existingError } = await supabase
    .from('products')
    .select('style_code, type_id')
    .eq('id', productId)
    .single();

  if (existingError || !existingProduct) {
    throw new Error('Product not found.');
  }

  // Check permission - user must have 'edit' or higher permission for this type node
  await assertPermission(existingProduct.type_id, 'edit', 'You do not have permission to edit this product.');

  const styleCode = existingProduct.style_code;
  const name = normalizeText(formData.get('name'));
  const typeId = normalizeText(formData.get('type_id')) || existingProduct.type_id;

  if (!name) {
    throw new Error('Product name is required.');
  }

  if (!typeId) {
    throw new Error('Product type must be selected.');
  }

  const gender = normalizeSelect(formData.get('gender'), validGenders, 'unisex');
  const status = normalizeSelect(formData.get('status'), validStatuses, 'development');
  const seasonId = normalizeText(formData.get('season_id'));

  const { data: attributeDefs, error: attributeError } = await supabase
    .from('attribute_definitions')
    .select('id, key, data_type, options, required')
    .eq('entity_type', 'product')
    .eq('is_active', true);

  if (attributeError) {
    throw new Error(attributeError.message);
  }

  const attributesPayload = buildAttributesPayload(attributeDefs, formData);
  const timestamp = new Date().toISOString();

  // Prepare payload WITHOUT version fields (executeVersionedUpdate handles those)
  const payload = {
    name,
    gender,
    status,
    type_id: typeId,
    season_id: seasonId || null,
    attributes: Object.keys(attributesPayload).length > 0 ? attributesPayload : null,
    updated_at: timestamp,
  };

  // Use version control module to execute versioned update
  const result = await executeVersionedUpdate('products', styleCode, payload, userIdentifier);

  if (!result.success) {
    throw new Error(result.error || 'Failed to update product');
  }

  revalidatePath('/products');
  redirect('/products');
}

