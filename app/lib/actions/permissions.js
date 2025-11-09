'use server';

import { createClient } from '@/lib/supabase/server';
import { revalidatePath } from 'next/cache';

/**
 * Update permissions for a type node
 * @param {string} typeNodeId - Type node ID
 * @param {Array} permissions - Array of {groupId, permissionLevel} or {groupId: null, permissionLevel} for default
 */
export async function updateTypeNodePermissions(typeNodeId, permissions) {
  try {
    const supabase = await createClient();

    if (!typeNodeId) {
      throw new Error('Type node ID is required');
    }

    // Delete existing permissions
    await supabase
      .from('type_node_permissions')
      .delete()
      .eq('type_node_id', typeNodeId);

    // Insert new permissions
    if (permissions && permissions.length > 0) {
      const records = permissions.map(p => ({
        type_node_id: typeNodeId,
        group_id: p.groupId,
        permission_level: p.permissionLevel,
      }));

      const { error } = await supabase
        .from('type_node_permissions')
        .insert(records);

      if (error) {
        throw new Error(`Failed to update permissions: ${error.message}`);
      }
    }

    revalidatePath('/admin/types');
    return { success: true };
  } catch (error) {
    console.error('Error in updateTypeNodePermissions:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Update permissions for an attribute
 * @param {string} attributeId - Attribute ID
 * @param {Array} permissions - Array of {groupId, permissionLevel} or {groupId: null, permissionLevel} for default
 */
export async function updateAttributePermissions(attributeId, permissions) {
  try {
    const supabase = await createClient();

    if (!attributeId) {
      throw new Error('Attribute ID is required');
    }

    // Delete existing permissions
    await supabase
      .from('attribute_permissions')
      .delete()
      .eq('attribute_id', attributeId);

    // Insert new permissions
    if (permissions && permissions.length > 0) {
      const records = permissions.map(p => ({
        attribute_id: attributeId,
        group_id: p.groupId,
        permission_level: p.permissionLevel,
      }));

      const { error } = await supabase
        .from('attribute_permissions')
        .insert(records);

      if (error) {
        throw new Error(`Failed to update permissions: ${error.message}`);
      }
    }

    revalidatePath('/admin/attributes');
    return { success: true };
  } catch (error) {
    console.error('Error in updateAttributePermissions:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Get permissions for a type node
 */
export async function getTypeNodePermissions(typeNodeId) {
  try {
    const supabase = await createClient();

    const { data, error } = await supabase
      .from('type_node_permissions')
      .select(`
        *,
        groups (id, name, code)
      `)
      .eq('type_node_id', typeNodeId);

    if (error) {
      throw new Error(error.message);
    }

    return { success: true, data: data || [] };
  } catch (error) {
    console.error('Error in getTypeNodePermissions:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Get permissions for an attribute
 */
export async function getAttributePermissions(attributeId) {
  try {
    const supabase = await createClient();

    const { data, error } = await supabase
      .from('attribute_permissions')
      .select(`
        *,
        groups (id, name, code)
      `)
      .eq('attribute_id', attributeId);

    if (error) {
      throw new Error(error.message);
    }

    return { success: true, data: data || [] };
  } catch (error) {
    console.error('Error in getAttributePermissions:', error);
    return { success: false, error: error.message };
  }
}
