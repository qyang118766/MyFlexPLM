'use server';

import { revalidatePath } from 'next/cache';
import { redirect } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { getEnumValuesList, ENUM_TYPES } from '@/lib/services/enums';

const SEASON_TYPES = [
  { value: 'spring', label: 'Spring', code: 'SP' },
  { value: 'summer', label: 'Summer', code: 'SU' },
  { value: 'fall', label: 'Fall', code: 'FA' },
  { value: 'winter', label: 'Winter', code: 'WI' },
  { value: 'spring_summer', label: 'Spring / Summer', code: 'SS' },
  { value: 'fall_winter', label: 'Fall / Winter', code: 'FW' },
];

function normalizeText(value) {
  if (value === null || value === undefined) return null;
  const trimmed = value.toString().trim();
  return trimmed.length > 0 ? trimmed : null;
}

function normalizeYear(value) {
  const text = normalizeText(value);
  if (!text) return null;
  const numeric = parseInt(text, 10);
  return Number.isFinite(numeric) ? numeric : null;
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
  const payload = {};
  attributeDefs?.forEach((attribute) => {
    const formKey = `attribute_${attribute.key}`;
    const value = parseAttributeValue(formData.get(formKey), attribute.data_type, attribute.options);
    if (value !== null && value !== undefined && value !== '') {
      payload[attribute.key] = value;
    }
  });
  return payload;
}

export async function createSeason(formData) {
  const supabase = await createClient();
  const userIdentifier = await getCurrentUserIdentifier(supabase);
  const validStatuses = await getEnumValuesList(ENUM_TYPES.SEASON_STATUS);

  const seasonType = normalizeText(formData.get('season_type'));
  const typeMeta = SEASON_TYPES.find((type) => type.value === seasonType);
  const year = normalizeYear(formData.get('year'));

  if (!typeMeta) {
    throw new Error('Season type is required.');
  }

  if (!year) {
    throw new Error('Year is required.');
  }

  const status = normalizeSelect(formData.get('status'), validStatuses, 'planned');
  const derivedName = `${year} ${typeMeta.label}`;
  const derivedCode = `${typeMeta.code}${year}`;

  const { data: attributeDefs, error: attributesError } = await supabase
    .from('attribute_definitions')
    .select('id, key, data_type, options, required')
    .eq('entity_type', 'season')
    .eq('is_active', true)
    .order('order_index', { ascending: true })
    .order('created_at', { ascending: true });

  if (attributesError) {
    throw new Error(attributesError.message);
  }

  const attributesPayload = buildAttributesPayload(attributeDefs, formData);
  const timestamp = new Date().toISOString();

  const { error } = await supabase.from('seasons').insert({
    code: derivedCode,
    name: derivedName,
    year,
    status,
    attributes: Object.keys(attributesPayload).length > 0 ? attributesPayload : null,
    create_by: userIdentifier,
    update_by: userIdentifier,
    updated_at: timestamp,
  });

  if (error) {
    throw new Error(error.message);
  }

  revalidatePath('/seasons');
  redirect('/seasons');
}

export async function updateSeason(formData) {
  const supabase = await createClient();
  const userIdentifier = await getCurrentUserIdentifier(supabase);
  const validStatuses = await getEnumValuesList(ENUM_TYPES.SEASON_STATUS);

  const seasonId = normalizeText(formData.get('season_id'));
  if (!seasonId) {
    throw new Error('Season id is required.');
  }

  const seasonType = normalizeText(formData.get('season_type'));
  const typeMeta = SEASON_TYPES.find((type) => type.value === seasonType);
  const year = normalizeYear(formData.get('year'));

  if (!typeMeta) {
    throw new Error('Season type is required.');
  }

  if (!year) {
    throw new Error('Year is required.');
  }

  const status = normalizeSelect(formData.get('status'), validStatuses, 'planned');
  const derivedName = `${year} ${typeMeta.label}`;
  const derivedCode = `${typeMeta.code}${year}`;

  const { data: attributeDefs, error: attributesError } = await supabase
    .from('attribute_definitions')
    .select('id, key, data_type, options, required')
    .eq('entity_type', 'season')
    .eq('is_active', true)
    .order('order_index', { ascending: true })
    .order('created_at', { ascending: true });

  if (attributesError) {
    throw new Error(attributesError.message);
  }

  const attributesPayload = buildAttributesPayload(attributeDefs, formData);
  const timestamp = new Date().toISOString();

  const { error } = await supabase
    .from('seasons')
    .update({
      code: derivedCode,
      name: derivedName,
      year,
      status,
      attributes: Object.keys(attributesPayload).length > 0 ? attributesPayload : null,
      update_by: userIdentifier,
      updated_at: timestamp,
    })
    .eq('id', seasonId);

  if (error) {
    throw new Error(error.message);
  }

  revalidatePath('/seasons');
  redirect('/seasons');
}

export async function deleteSeason(formData) {
  const supabase = await createClient();
  const seasonId = normalizeText(formData.get('season_id'));

  if (!seasonId) {
    throw new Error('Season id is required.');
  }

  const { error } = await supabase.from('seasons').delete().eq('id', seasonId);

  if (error) {
    throw new Error(error.message);
  }

  revalidatePath('/seasons');
}

