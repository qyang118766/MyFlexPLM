'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';

/**
 * Permission levels in order (from lowest to highest)
 */
const PERMISSION_LEVELS = {
  none: 0,
  read: 1,
  edit: 2,
  create: 3,
  delete: 4,
  full: 5
};

/**
 * Get current user's effective permission for a type node
 */
export async function getUserPermissionForNode(typeNodeId) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return { success: false, permission: 'none' };
    }

    // Get user info
    const { data: userData } = await supabase
      .from('users')
      .select('role, is_superadmin')
      .eq('id', user.id)
      .single();

    // Superadmin and admin users have full access
    if (userData?.is_superadmin || userData?.role === 'admin') {
      return { success: true, permission: 'full' };
    }

    const adminClient = createAdminClient();

    // Call the database function to get effective permission
    const { data, error } = await adminClient
      .rpc('get_effective_type_node_permission', {
        p_user_id: user.id,
        p_type_node_id: typeNodeId
      });

    if (error) throw error;

    return { success: true, permission: data || 'none' };
  } catch (error) {
    console.error('Error getting user permission:', error);
    return { success: false, permission: 'none' };
  }
}

/**
 * Check if user has required permission level for a type node
 */
export async function checkUserPermission(typeNodeId, requiredLevel = 'read') {
  const result = await getUserPermissionForNode(typeNodeId);

  if (!result.success) {
    return false;
  }

  const userLevel = PERMISSION_LEVELS[result.permission] || 0;
  const required = PERMISSION_LEVELS[requiredLevel] || 0;

  return userLevel >= required;
}

/**
 * Get all type nodes the user has access to for a given entity type
 */
export async function getUserAccessibleTypeNodes(entityType) {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return { success: false, data: [] };
    }

    // Get user info
    const { data: userData } = await supabase
      .from('users')
      .select('role, is_superadmin')
      .eq('id', user.id)
      .single();

    // Get all type nodes for this entity type
    const { data: allNodes, error: nodesError } = await supabase
      .from('entity_type_nodes')
      .select('*')
      .eq('entity_type', entityType);

    if (nodesError) throw nodesError;

    // Superadmin and admin users can see all nodes
    if (userData?.is_superadmin || userData?.role === 'admin') {
      return { success: true, data: allNodes || [] };
    }

    // For regular users, filter nodes based on permissions
    const accessibleNodes = [];
    for (const node of allNodes || []) {
      const hasAccess = await checkUserPermission(node.id, 'read');
      if (hasAccess) {
        accessibleNodes.push(node);
      }
    }

    return { success: true, data: accessibleNodes };
  } catch (error) {
    console.error('Error getting accessible type nodes:', error);
    return { success: false, data: [] };
  }
}

/**
 * Get user's permission summary for all entity types
 */
export async function getUserPermissionSummary() {
  try {
    const supabase = await createClient();
    const { data: { user } } = await supabase.auth.getUser();

    if (!user) {
      return { success: false, data: null };
    }

    // Get user info
    const { data: userData } = await supabase
      .from('users')
      .select('role, is_superadmin')
      .eq('id', user.id)
      .single();

    const summary = {
      isAdmin: userData?.is_superadmin || userData?.role === 'admin',
      entityPermissions: {}
    };

    // If admin, they have full access to everything
    if (summary.isAdmin) {
      const entityTypes = ['product', 'material', 'supplier', 'season', 'color'];
      entityTypes.forEach(type => {
        summary.entityPermissions[type] = 'full';
      });
      return { success: true, data: summary };
    }

    // For regular users, check root node permissions for each entity type
    const { data: rootNodes } = await supabase
      .from('entity_type_nodes')
      .select('id, entity_type')
      .is('parent_id', null);

    for (const node of rootNodes || []) {
      const result = await getUserPermissionForNode(node.id);
      summary.entityPermissions[node.entity_type] = result.permission || 'none';
    }

    return { success: true, data: summary };
  } catch (error) {
    console.error('Error getting permission summary:', error);
    return { success: false, data: null };
  }
}

/**
 * Assert that user has required permission, throw error if not
 */
export async function assertPermission(typeNodeId, requiredLevel = 'read', errorMessage) {
  const hasPermission = await checkUserPermission(typeNodeId, requiredLevel);

  if (!hasPermission) {
    throw new Error(errorMessage || `Insufficient permissions. Required: ${requiredLevel}`);
  }

  return true;
}

/**
 * Get permission for entity by finding its type node
 */
export async function getEntityPermission(entityType, typeNodeId) {
  if (!typeNodeId) {
    // If no type node specified, check root permission for entity type
    const supabase = await createClient();
    const { data: rootNode } = await supabase
      .from('entity_type_nodes')
      .select('id')
      .eq('entity_type', entityType)
      .is('parent_id', null)
      .single();

    if (!rootNode) {
      return { success: false, permission: 'none' };
    }

    return getUserPermissionForNode(rootNode.id);
  }

  return getUserPermissionForNode(typeNodeId);
}
