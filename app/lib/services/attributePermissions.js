'use server';

import { createClient } from '@/lib/supabase/server';

/**
 * Get effective attribute permission for current user
 * @param {string} attributeId - UUID of attribute definition
 * @returns {Promise<{success: boolean, data?: string, error?: string}>}
 */
export async function getUserAttributePermission(attributeId) {
  const supabase = await createClient();

  const {
    data: { user },
    error: userError,
  } = await supabase.auth.getUser();

  if (userError || !user) {
    return { success: false, error: 'Not authenticated' };
  }

  // Check if user is superadmin
  const { data: userData } = await supabase
    .from('users')
    .select('is_superadmin')
    .eq('id', user.id)
    .single();

  if (userData?.is_superadmin) {
    return { success: true, data: 'editable' };
  }

  // Use database function to calculate effective permission
  const { data, error } = await supabase.rpc('get_effective_attribute_permission', {
    p_attribute_id: attributeId,
    p_user_id: user.id,
  });

  if (error) {
    console.error('Error getting attribute permission:', error);
    return { success: false, error: error.message };
  }

  return { success: true, data: data || 'hidden' };
}

/**
 * Get attribute permissions for multiple attributes
 * Returns a map of attributeId -> permission level
 * @param {string[]} attributeIds - Array of attribute definition UUIDs
 * @returns {Promise<{success: boolean, data?: Object, error?: string}>}
 */
export async function getBulkAttributePermissions(attributeIds) {
  if (!attributeIds || attributeIds.length === 0) {
    return { success: true, data: {} };
  }

  const supabase = await createClient();

  const {
    data: { user },
    error: userError,
  } = await supabase.auth.getUser();

  if (userError || !user) {
    return { success: false, error: 'Not authenticated' };
  }

  // Check if user is superadmin
  const { data: userData } = await supabase
    .from('users')
    .select('is_superadmin')
    .eq('id', user.id)
    .single();

  if (userData?.is_superadmin) {
    // Superadmin has editable permission on all attributes
    const permissions = {};
    attributeIds.forEach((id) => {
      permissions[id] = 'editable';
    });
    return { success: true, data: permissions };
  }

  // Get permissions for each attribute
  const permissions = {};
  for (const attrId of attributeIds) {
    const result = await getUserAttributePermission(attrId);
    if (result.success) {
      permissions[attrId] = result.data;
    } else {
      permissions[attrId] = 'hidden';
    }
  }

  return { success: true, data: permissions };
}

/**
 * Get filtered and annotated attributes with permission levels
 * @param {Object} supabase - Supabase client
 * @param {string} entityType - Entity type (product, material, etc.)
 * @param {string} typeNodeId - Type node UUID
 * @param {boolean} includeHidden - Whether to include hidden attributes (default: false)
 * @returns {Promise<Array>} Attributes with permission_level field
 */
export async function getAttributesWithPermissions(supabase, entityType, typeNodeId, includeHidden = false) {
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return [];
  }

  // Check if user is superadmin
  const { data: userData } = await supabase
    .from('users')
    .select('is_superadmin')
    .eq('id', user.id)
    .single();

  // Get all visible attributes for this type node (using existing filtering)
  const { getVisibleAttributes } = await import('./attributeFiltering');
  const attributes = await getVisibleAttributes(supabase, entityType, typeNodeId);

  if (!attributes || attributes.length === 0) {
    return [];
  }

  // If superadmin, all attributes are editable
  if (userData?.is_superadmin) {
    return attributes.map(attr => ({
      ...attr,
      permission_level: 'editable',
    }));
  }

  // Get permissions for all attributes
  const attributeIds = attributes.map(attr => attr.id);
  const permissionsResult = await getBulkAttributePermissions(attributeIds);

  if (!permissionsResult.success) {
    console.error('Error getting bulk permissions:', permissionsResult.error);
    return [];
  }

  const permissions = permissionsResult.data;

  // Annotate attributes with their permission levels
  const annotatedAttributes = attributes.map(attr => ({
    ...attr,
    permission_level: permissions[attr.id] || 'hidden',
  }));

  // Filter out hidden attributes unless includeHidden is true
  if (!includeHidden) {
    return annotatedAttributes.filter(attr => attr.permission_level !== 'hidden');
  }

  return annotatedAttributes;
}

/**
 * Save attribute permission for a group
 * @param {string} attributeId - Attribute definition UUID
 * @param {string} groupId - Group UUID
 * @param {string} permissionLevel - Permission level (hidden/read-only/editable/null for default)
 * @returns {Promise<{success: boolean, error?: string}>}
 */
export async function saveAttributeGroupPermission(attributeId, groupId, permissionLevel) {
  const supabase = await createClient();

  // If permissionLevel is null or 'default', delete the override
  if (!permissionLevel || permissionLevel === 'default') {
    const { error } = await supabase
      .from('attribute_group_permissions')
      .delete()
      .eq('attribute_definition_id', attributeId)
      .eq('group_id', groupId);

    if (error) {
      return { success: false, error: error.message };
    }

    return { success: true };
  }

  // Validate permission level
  if (!['hidden', 'read-only', 'editable'].includes(permissionLevel)) {
    return { success: false, error: 'Invalid permission level' };
  }

  // Upsert the permission
  const { error } = await supabase
    .from('attribute_group_permissions')
    .upsert({
      attribute_definition_id: attributeId,
      group_id: groupId,
      permission_level: permissionLevel,
      updated_at: new Date().toISOString(),
    }, {
      onConflict: 'attribute_definition_id,group_id',
    });

  if (error) {
    return { success: false, error: error.message };
  }

  return { success: true };
}

/**
 * Get attribute permissions for all groups
 * @param {string} attributeId - Attribute definition UUID
 * @returns {Promise<{success: boolean, data?: Array, error?: string}>}
 */
export async function getAttributeGroupPermissions(attributeId) {
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
 * Calculate default permission for an attribute based on group's type node permission
 * @param {string} attributeId - Attribute definition UUID
 * @param {string} groupId - Group UUID
 * @returns {Promise<{success: boolean, data?: string, error?: string}>}
 */
export async function getDefaultAttributePermissionForGroup(attributeId, groupId) {
  const supabase = await createClient();

  // Get attribute's type node
  const { data: attribute } = await supabase
    .from('attribute_definitions')
    .select('type_node_id, entity_type')
    .eq('id', attributeId)
    .single();

  if (!attribute || !attribute.type_node_id) {
    return { success: true, data: 'editable' }; // No scope = no restrictions
  }

  // Get group's permission for this type node
  const { data: typePermission } = await supabase
    .from('type_node_permissions')
    .select('permission_level')
    .eq('type_node_id', attribute.type_node_id)
    .eq('group_id', groupId)
    .single();

  if (!typePermission) {
    // No explicit permission, check parent nodes
    // For now, default to hidden
    return { success: true, data: 'hidden' };
  }

  // Map type permission to attribute permission
  const typeLevel = typePermission.permission_level;
  let attrLevel;

  switch (typeLevel) {
    case 'none':
      attrLevel = 'hidden';
      break;
    case 'read':
      attrLevel = 'read-only';
      break;
    case 'edit':
    case 'create':
    case 'delete':
    case 'full':
      attrLevel = 'editable';
      break;
    default:
      attrLevel = 'hidden';
  }

  return { success: true, data: attrLevel };
}
