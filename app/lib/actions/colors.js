'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { getEnumValuesList, ENUM_TYPES } from '@/lib/services/enums';

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
    .eq('entity_type', 'color')
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

export async function createColor(formData) {
  const supabase = await createClient();
  const userIdentifier = await getCurrentUserIdentifier(supabase);
  const validStatuses = await getEnumValuesList(ENUM_TYPES.COLOR_STATUS);

  const colorCode = normalizeText(formData.get('color_code'));
  const name = normalizeText(formData.get('name'));
  const rgbHex = normalizeText(formData.get('rgb_hex'));
  const typeId = normalizeText(formData.get('type_id'));
  const status = normalizeSelect(formData.get('status'), validStatuses, 'active');

  if (!colorCode || !name) {
    throw new Error('Color code and name are required.');
  }

  if (!typeId) {
    throw new Error('Color type must be selected.');
  }

  const attributeDefs = await fetchAttributeDefs(supabase);
  const attributesPayload = buildAttributesPayload(attributeDefs, formData);
  const timestamp = new Date().toISOString();

  const payload = {
    color_code: colorCode,
    name,
    rgb_hex: rgbHex,
    type_id: typeId,
    status,
    attributes: Object.keys(attributesPayload).length > 0 ? attributesPayload : null,
    create_by: userIdentifier,
    update_by: userIdentifier,
    updated_at: timestamp,
  };

  const { error } = await supabase.from('colors').insert(payload);

  if (error) {
    throw new Error(error.message);
  }

  revalidatePath('/colors');
  redirect('/colors');
}

export async function updateColor(formData) {
  const supabase = await createClient();
  const userIdentifier = await getCurrentUserIdentifier(supabase);
  const validStatuses = await getEnumValuesList(ENUM_TYPES.COLOR_STATUS);

  const colorId = normalizeText(formData.get('color_id'));
  if (!colorId) {
    throw new Error('Color id is required.');
  }

  const { data: existingColor, error: fetchError } = await supabase
    .from('colors')
    .select('create_by, type_id')
    .eq('id', colorId)
    .single();

  if (fetchError || !existingColor) {
    throw new Error('Color not found.');
  }

  const colorCode = normalizeText(formData.get('color_code'));
  const name = normalizeText(formData.get('name'));
  const rgbHex = normalizeText(formData.get('rgb_hex'));
  const typeId = normalizeText(formData.get('type_id')) || existingColor.type_id;
  const status = normalizeSelect(formData.get('status'), validStatuses, 'active');

  if (!colorCode || !name) {
    throw new Error('Color code and name are required.');
  }

  if (!typeId) {
    throw new Error('Color type must be selected.');
  }

  const attributeDefs = await fetchAttributeDefs(supabase);
  const attributesPayload = buildAttributesPayload(attributeDefs, formData);
  const timestamp = new Date().toISOString();

  const { error } = await supabase
    .from('colors')
    .update({
      color_code: colorCode,
      name,
      rgb_hex: rgbHex,
      type_id: typeId,
      status,
      attributes: Object.keys(attributesPayload).length > 0 ? attributesPayload : null,
      update_by: userIdentifier,
      updated_at: timestamp,
      create_by: existingColor.create_by ?? userIdentifier,
    })
    .eq('id', colorId);

  if (error) {
    throw new Error(error.message);
  }

  revalidatePath('/colors');
  redirect('/colors');
}

export async function deleteColor(formData) {
  const supabase = await createClient();
  const colorId = normalizeText(formData.get('color_id'));

  if (!colorId) {
    throw new Error('Color id is required.');
  }

  const { error } = await supabase.from('colors').delete().eq('id', colorId);

  if (error) {
    throw new Error(error.message);
  }

  revalidatePath('/colors');
}

