/**
 * 枚举服务层
 * 从数据库 enums 表读取枚举值，替代原有的配置文件方式
 */

import { createClient } from '@/lib/supabase/server';

/**
 * 获取指定类型的所有活跃枚举值
 * @param {string} enumType - 枚举类型，如 'season_status', 'product_status'
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

  return (data || []).map(item => ({
    value: item.enum_value,
    label: item.label
  }));
}

/**
 * 获取指定类型的所有活跃枚举值（仅返回值数组，用于验证）
 * @param {string} enumType - 枚举类型
 * @returns {Promise<Array<string>>}
 */
export async function getEnumValuesList(enumType) {
  const values = await getEnumValues(enumType);
  return values.map(v => v.value);
}

/**
 * 获取所有枚举类型及其值
 * @returns {Promise<Object>} 按类型分组的枚举对象
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

  // 按 enum_type 分组
  const grouped = {};
  (data || []).forEach(item => {
    if (!grouped[item.enum_type]) {
      grouped[item.enum_type] = [];
    }
    grouped[item.enum_type].push({
      value: item.enum_value,
      label: item.label,
      order: item.order_index
    });
  });

  return grouped;
}

/**
 * 检查枚举值是否有效
 * @param {string} enumType - 枚举类型
 * @param {string} value - 要检查的值
 * @returns {Promise<boolean>}
 */
export async function isValidEnumValue(enumType, value) {
  const validValues = await getEnumValuesList(enumType);
  return validValues.includes(value);
}

/**
 * 获取枚举值的显示标签
 * @param {string} enumType - 枚举类型
 * @param {string} value - 枚举值
 * @returns {Promise<string|null>}
 */
export async function getEnumLabel(enumType, value) {
  const values = await getEnumValues(enumType);
  const found = values.find(v => v.value === value);
  return found ? found.label : null;
}

/**
 * 预定义的枚举类型常量（用于代码引用）
 */
export const ENUM_TYPES = {
  SEASON_STATUS: 'season_status',
  PRODUCT_STATUS: 'product_status',
  PRODUCT_GENDER: 'product_gender',
  MATERIAL_STATUS: 'material_status',
  SUPPLIER_STATUS: 'supplier_status',
  COLOR_STATUS: 'color_status',
  BOM_STATUS: 'bom_status'
};

/**
 * 辅助函数：标准化选择值（用于表单处理）
 * @param {string|null} value - 原始值
 * @param {Array<string>} validValues - 有效值列表
 * @param {string} defaultValue - 默认值
 * @returns {string}
 */
export function normalizeEnumValue(value, validValues, defaultValue) {
  if (!value) return defaultValue;
  const trimmed = value.trim();
  return validValues.includes(trimmed) ? trimmed : defaultValue;
}
