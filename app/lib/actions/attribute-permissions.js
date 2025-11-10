'use server';

import { createClient } from '@/lib/supabase/server';
import { revalidatePath } from 'next/cache';

/**
 * Get attribute permissions for all groups
 * @param {string} attributeId - Attribute definition UUID
 * @returns {Promise<{success: boolean, data?: Array, error?: string}>}
 */
export async function getAttributePermissions(attributeId) {
  const supabase = await createClient();

  const { data, error } = await supabase
    .from('attribute_group_permissions')
    .select('group_id, permission_level')
    .eq('attribute_definition_id', attributeId);

  if (error) {
    return { success: false, error: error.message };
  }

  return { success: true, data: data || [] };
}

/**
 * Update attribute permissions for all groups
 * @param {string} attributeId - Attribute definition UUID
 * @param {Array} permissions - Array of {group_id, permission_level}
 * @returns {Promise<{success: boolean, error?: string}>}
 */
export async function updateAttributePermissions(attributeId, permissions) {
  const supabase = await createClient();

  // Delete existing permissions for this attribute
  const { error: deleteError } = await supabase
    .from('attribute_group_permissions')
    .delete()
    .eq('attribute_definition_id', attributeId);

  if (deleteError) {
    return { success: false, error: deleteError.message };
  }

  // Insert new permissions (only those that are not 'default')
  const permissionsToInsert = permissions
    .filter(p => p.permission_level && p.permission_level !== 'default')
    .map(p => ({
      attribute_definition_id: attributeId,
      group_id: p.group_id,
      permission_level: p.permission_level,
    }));

  if (permissionsToInsert.length > 0) {
    const { error: insertError } = await supabase
      .from('attribute_group_permissions')
      .insert(permissionsToInsert);

    if (insertError) {
      return { success: false, error: insertError.message };
    }
  }

  revalidatePath('/admin/attributes');
  return { success: true };
}
