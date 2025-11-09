'use server';

import { revalidatePath } from 'next/cache';
import { createClient } from '@/lib/supabase/server';

/**
 * 辅助函数：标准化文本
 */
function normalizeText(value) {
  if (value === null || value === undefined) return null;
  const trimmed = value.toString().trim();
  return trimmed.length > 0 ? trimmed : null;
}

/**
 * 辅助函数：检查用户是否为管理员
 */
async function checkAdmin(supabase) {
  const { data: { user }, error: authError } = await supabase.auth.getUser();
  if (authError || !user) {
    throw new Error('Unauthorized access');
  }

  const { data: userData, error: userError } = await supabase
    .from('users')
    .select('is_admin')
    .eq('id', user.id)
    .single();

  if (userError || !userData?.is_admin) {
    throw new Error('Administrator required');
  }

  return user;
}

/**
 * 列出所有枚举值（可选按类型筛选）
 */
export async function listEnums(enumType = null) {
  const supabase = await createClient();

  let query = supabase
    .from('enums')
    .select('*')
    .order('enum_type', { ascending: true })
    .order('order_index', { ascending: true })
    .order('enum_value', { ascending: true });

  if (enumType) {
    query = query.eq('enum_type', enumType);
  }

  const { data, error } = await query;

  if (error) {
    console.error('Error listing enums:', error);
    return { success: false, error: error.message };
  }

  return { success: true, data: data || [] };
}

/**
 * 获取所有枚举类型列表
 */
export async function getEnumTypes() {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('enums')
    .select('enum_type')
    .order('enum_type', { ascending: true });

  if (error) {
    console.error('Error getting enum types:', error);
    return { success: false, error: error.message };
  }

  // 去重
  const uniqueTypes = [...new Set((data || []).map(item => item.enum_type))];
  return { success: true, data: uniqueTypes };
}

/**
 * 创建新的枚举值
 */
export async function createEnumValue(formData) {
  const supabase = await createClient();

  try {
    // 检查管理员权限
    await checkAdmin(supabase);

    const enumType = normalizeText(formData.get('enum_type'));
    const enumValue = normalizeText(formData.get('enum_value'));
    const label = normalizeText(formData.get('label'));
    const orderIndex = parseInt(formData.get('order_index') || '0', 10);
    const isActive = formData.get('is_active') === 'true';

    if (!enumType || !enumValue || !label) {
      throw new Error('枚举类型、值和标签为必填项');
    }

    // 检查是否已存在
    const { data: existing } = await supabase
      .from('enums')
      .select('id')
      .eq('enum_type', enumType)
      .eq('enum_value', enumValue)
      .maybeSingle();

    if (existing) {
      throw new Error('The enumeration value already exists');
    }

    const { data, error } = await supabase
      .from('enums')
      .insert({
        enum_type: enumType,
        enum_value: enumValue,
        label: label,
        order_index: orderIndex,
        is_active: isActive
      })
      .select()
      .single();

    if (error) {
      throw new Error(error.message);
    }

    revalidatePath('/admin/enums');
    return { success: true, data };

  } catch (error) {
    console.error('Error creating enum value:', error);
    return { success: false, error: error.message };
  }
}

/**
 * 更新枚举值
 */
export async function updateEnumValue(id, formData) {
  const supabase = await createClient();

  try {
    // 检查管理员权限
    await checkAdmin(supabase);

    const label = normalizeText(formData.get('label'));
    const orderIndex = parseInt(formData.get('order_index') || '0', 10);
    const isActive = formData.get('is_active') === 'true';

    if (!label) {
      throw new Error('Tags are required fields');
    }

    const { data, error } = await supabase
      .from('enums')
      .update({
        label: label,
        order_index: orderIndex,
        is_active: isActive,
        updated_at: new Date().toISOString()
      })
      .eq('id', id)
      .select()
      .single();

    if (error) {
      throw new Error(error.message);
    }

    revalidatePath('/admin/enums');
    return { success: true, data };

  } catch (error) {
    console.error('Error updating enum value:', error);
    return { success: false, error: error.message };
  }
}

/**
 * 删除枚举值（硬删除）
 * 注意：这可能会导致数据完整性问题，建议使用软删除（设置 is_active = false）
 */
export async function deleteEnumValue(id) {
  const supabase = await createClient();

  try {
    // 检查管理员权限
    await checkAdmin(supabase);

    const { error } = await supabase
      .from('enums')
      .delete()
      .eq('id', id);

    if (error) {
      throw new Error(error.message);
    }

    revalidatePath('/admin/enums');
    return { success: true };

  } catch (error) {
    console.error('Error deleting enum value:', error);
    return { success: false, error: error.message };
  }
}

/**
 * 切换枚举值的活跃状态
 */
export async function toggleEnumValue(id, isActive) {
  const supabase = await createClient();

  try {
    // 检查管理员权限
    await checkAdmin(supabase);

    const { data, error } = await supabase
      .from('enums')
      .update({
        is_active: isActive,
        updated_at: new Date().toISOString()
      })
      .eq('id', id)
      .select()
      .single();

    if (error) {
      throw new Error(error.message);
    }

    revalidatePath('/admin/enums');
    return { success: true, data };

  } catch (error) {
    console.error('Error toggling enum value:', error);
    return { success: false, error: error.message };
  }
}

/**
 * 批量更新枚举值的排序
 */
export async function updateEnumOrders(updates) {
  const supabase = await createClient();

  try {
    // 检查管理员权限
    await checkAdmin(supabase);

    // 批量更新
    const promises = updates.map(({ id, order_index }) =>
      supabase
        .from('enums')
        .update({ order_index, updated_at: new Date().toISOString() })
        .eq('id', id)
    );

    const results = await Promise.all(promises);

    const hasError = results.some(result => result.error);
    if (hasError) {
      throw new Error('Partial update failed');
    }

    revalidatePath('/admin/enums');
    return { success: true };

  } catch (error) {
    console.error('Error updating enum orders:', error);
    return { success: false, error: error.message };
  }
}
