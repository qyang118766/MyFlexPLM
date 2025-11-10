'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { revalidatePath } from 'next/cache';

/**
 * Get all permissions for a group
 */
export async function getGroupPermissions(groupId) {
  try {
    const supabase = await createClient();

    const { data, error } = await supabase
      .from('type_node_permissions')
      .select(`
        id,
        type_node_id,
        permission_level,
        created_at,
        updated_at,
        type_node:entity_type_nodes(
          id,
          name,
          code,
          entity_type,
          parent_id
        )
      `)
      .eq('group_id', groupId)
      .order('created_at');

    if (error) throw error;

    return { success: true, data: data || [] };
  } catch (error) {
    console.error('Error in getGroupPermissions:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Get parent group's permissions for validation
 */
export async function getParentGroupPermissions(groupId) {
  try {
    const supabase = await createClient();

    // Get parent group ID
    const { data: group, error: groupError } = await supabase
      .from('groups')
      .select('parent_id')
      .eq('id', groupId)
      .single();

    if (groupError) throw groupError;
    if (!group.parent_id) {
      return { success: true, data: [] }; // No parent = no restrictions
    }

    // Get parent's permissions
    return getGroupPermissions(group.parent_id);
  } catch (error) {
    console.error('Error in getParentGroupPermissions:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Validate that child group permissions don't exceed parent group permissions
 */
function validateChildPermissions(permissions, parentPermissions) {
  const permissionValues = {
    'none': 1,
    'read': 2,
    'edit': 3,
    'create': 4,
    'delete': 5,
    'full': 6
  };

  // Build parent permission map
  const parentPermMap = {};
  parentPermissions.forEach(perm => {
    parentPermMap[perm.type_node_id] = permissionValues[perm.permission_level] || 0;
  });

  // Check each child permission
  for (const [nodeId, level] of Object.entries(permissions)) {
    const childValue = permissionValues[level] || 0;
    const parentValue = parentPermMap[nodeId];

    // If parent has no permission for this node, child can't have it either
    if (parentValue === undefined) {
      return {
        valid: false,
        error: `Parent group has no permission for node ${nodeId}`
      };
    }

    // Child permission cannot exceed parent permission
    if (childValue > parentValue) {
      return {
        valid: false,
        error: `Child group permission (${level}) exceeds parent permission for node ${nodeId}`
      };
    }
  }

  return { valid: true };
}

/**
 * Save group permissions
 * permissions: { nodeId: 'read', nodeId2: 'write', ... }
 */
export async function saveGroupPermissions(groupId, permissions, entityType = null) {
  try {
    const adminClient = createAdminClient();
    const supabase = await createClient();

    // Get parent permissions if this is a child group
    const parentPermsResult = await getParentGroupPermissions(groupId);
    if (!parentPermsResult.success) {
      throw new Error('Failed to get parent permissions');
    }

    // Validate against parent permissions
    if (parentPermsResult.data && parentPermsResult.data.length > 0) {
      const validation = validateChildPermissions(permissions, parentPermsResult.data);
      if (!validation.valid) {
        return { success: false, error: validation.error };
      }
    }

    // Delete existing permissions for this group (and entity type if specified)
    let deleteQuery = adminClient
      .from('type_node_permissions')
      .delete()
      .eq('group_id', groupId);

    if (entityType) {
      // Only delete permissions for nodes of this entity type
      const { data: nodeIds } = await supabase
        .from('entity_type_nodes')
        .select('id')
        .eq('entity_type', entityType);

      if (nodeIds && nodeIds.length > 0) {
        deleteQuery = deleteQuery.in('type_node_id', nodeIds.map(n => n.id));
      }
    }

    const { error: deleteError } = await deleteQuery;
    if (deleteError) throw deleteError;

    // Insert new permissions
    if (Object.keys(permissions).length > 0) {
      const permissionRecords = Object.entries(permissions)
        .filter(([_, level]) => level !== 'none') // Don't store 'none' explicitly
        .map(([nodeId, level]) => ({
          group_id: groupId,
          type_node_id: nodeId,
          permission_level: level
        }));

      if (permissionRecords.length > 0) {
        const { error: insertError } = await adminClient
          .from('type_node_permissions')
          .insert(permissionRecords);

        if (insertError) throw insertError;
      }
    }

    revalidatePath('/admin/groups');
    return { success: true };
  } catch (error) {
    console.error('Error in saveGroupPermissions:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Get all type nodes for a specific entity type
 */
export async function getTypeNodesForEntity(entityType) {
  try {
    const supabase = await createClient();

    const { data, error } = await supabase
      .from('entity_type_nodes')
      .select('*')
      .eq('entity_type', entityType)
      .order('name');

    if (error) throw error;

    return { success: true, data: data || [] };
  } catch (error) {
    console.error('Error in getTypeNodesForEntity:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Get effective permission for a user on a specific type node
 */
export async function getUserEffectivePermission(userId, typeNodeId) {
  try {
    const adminClient = createAdminClient();

    const { data, error } = await adminClient
      .rpc('get_effective_type_node_permission', {
        p_user_id: userId,
        p_type_node_id: typeNodeId
      });

    if (error) throw error;

    return { success: true, permission: data };
  } catch (error) {
    console.error('Error in getUserEffectivePermission:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Check if user has required permission
 */
export async function checkUserPermission(userId, typeNodeId, requiredLevel) {
  try {
    const adminClient = createAdminClient();

    const { data, error } = await adminClient
      .rpc('check_type_node_permission', {
        p_user_id: userId,
        p_type_node_id: typeNodeId,
        p_required_level: requiredLevel
      });

    if (error) throw error;

    return { success: true, hasPermission: data };
  } catch (error) {
    console.error('Error in checkUserPermission:', error);
    return { success: false, error: error.message };
  }
}
