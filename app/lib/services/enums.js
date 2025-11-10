/**
 * Enumeration service helpers.
 * Fetches enum definitions from the database instead of static config files.
 */

import { createClient } from '@/lib/supabase/server';

/**
 * Fetch all active enum entries for a given type.
 * @param {string} enumType e.g. 'season_status', 'product_status'
 * @returns {Promise<Array<{value: string, label: string}>>}
 */
export async function getEnumValues(enumType) {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('enums')
    .select('enum_value, label')
    .eq('enum_type', enumType)
    .eq('is_active', true)
    .order('order_index', { ascending: true })
    .order('enum_value', { ascending: true });

  if (error) {
    console.error(`Error fetching enum values for ${enumType}:`, error);
    return [];
  }

  return (data || []).map((item) => ({
    value: item.enum_value,
    label: item.label,
  }));
}

/**
 * Fetch active enum entries for a type and return only the value list.
 * Useful for validation and form defaults.
 * @param {string} enumType
 * @returns {Promise<Array<string>>}
 */
export async function getEnumValuesList(enumType) {
  const values = await getEnumValues(enumType);
  return values.map((value) => value.value);
}

/**
 * Fetch every enum grouped by enum_type.
 * @returns {Promise<Object>} Object keyed by enum_type with arrays of entries.
 */
export async function getAllEnums() {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('enums')
    .select('*')
    .eq('is_active', true)
    .order('enum_type', { ascending: true })
    .order('order_index', { ascending: true });

  if (error) {
    console.error('Error fetching all enums:', error);
    return {};
  }

  const grouped = {};
  (data || []).forEach((item) => {
    if (!grouped[item.enum_type]) {
      grouped[item.enum_type] = [];
    }
    grouped[item.enum_type].push({
      value: item.enum_value,
      label: item.label,
      order: item.order_index,
    });
  });

  return grouped;
}

/**
 * Check whether a value is valid within an enum type.
 * @param {string} enumType
 * @param {string} value
 * @returns {Promise<boolean>}
 */
export async function isValidEnumValue(enumType, value) {
  const validValues = await getEnumValuesList(enumType);
  return validValues.includes(value);
}

/**
 * Get the human-friendly label for a value.
 * @param {string} enumType
 * @param {string} value
 * @returns {Promise<string|null>}
 */
export async function getEnumLabel(enumType, value) {
  const values = await getEnumValues(enumType);
  const found = values.find((entry) => entry.value === value);
  return found ? found.label : null;
}

/**
 * Predefined enum type constants used throughout the codebase.
 */
export const ENUM_TYPES = {
  SEASON_STATUS: 'season_status',
  PRODUCT_STATUS: 'product_status',
  PRODUCT_GENDER: 'product_gender',
  MATERIAL_STATUS: 'material_status',
  SUPPLIER_STATUS: 'supplier_status',
  COLOR_STATUS: 'color_status',
  BOM_STATUS: 'bom_status',
};

/**
 * Helper: normalize select input (used in forms).
 * @param {string|null} value - raw input
 * @param {Array<string>} validValues - allowed values
 * @param {string} defaultValue - fallback value
 * @returns {string}
 */
export function normalizeEnumValue(value, validValues, defaultValue) {
  if (!value) return defaultValue;
  const trimmed = value.trim();
  return validValues.includes(trimmed) ? trimmed : defaultValue;
}

