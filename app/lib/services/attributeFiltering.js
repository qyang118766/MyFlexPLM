/**
 * Attribute Filtering Service
 *
 * Handles filtering attributes based on type hierarchy scope.
 * An attribute is visible to a type node if:
 * 1. It has no type_node_id (global attribute), OR
 * 2. It is defined on an ancestor node (parent, grandparent, etc.)
 *
 * Attributes defined on sibling nodes, cousin nodes, etc. are NOT visible.
 */

import { createClient } from '@/lib/supabase/server';

/**
 * Get the complete ancestry path from root to the given node
 * @param {object} supabase - Supabase client
 * @param {string} typeNodeId - The type node ID to get ancestors for
 * @returns {Promise<string[]>} Array of ancestor node IDs, from root to current node
 */
export async function getAncestorPath(supabase, typeNodeId) {
  if (!typeNodeId) {
    return [];
  }

  const path = [];
  let currentId = typeNodeId;

  // Walk up the tree from current node to root
  while (currentId) {
    path.unshift(currentId); // Add to beginning of array

    const { data: node, error } = await supabase
      .from('entity_type_nodes')
      .select('parent_id')
      .eq('id', currentId)
      .single();

    if (error || !node) {
      break;
    }

    currentId = node.parent_id;
  }

  return path;
}

/**
 * Get all attributes visible to a specific type node
 * Includes:
 * - Global attributes (type_node_id = NULL)
 * - Attributes scoped to any ancestor node
 *
 * @param {object} supabase - Supabase client
 * @param {string} entityType - Entity type (e.g., 'product', 'material')
 * @param {string} typeNodeId - The type node ID to get attributes for
 * @returns {Promise<Array>} Array of attribute definitions
 */
export async function getVisibleAttributes(supabase, entityType, typeNodeId) {
  // Get the full ancestor path
  const ancestorPath = await getAncestorPath(supabase, typeNodeId);

  // Build query
  let query = supabase
    .from('attribute_definitions')
    .select('*')
    .eq('entity_type', entityType)
    .eq('is_active', true);

  // Filter by scope: global OR in ancestor path
  if (ancestorPath.length > 0) {
    query = query.or(`type_node_id.is.null,type_node_id.in.(${ancestorPath.join(',')})`);
  } else {
    // If no type node selected, only show global attributes
    query = query.is('type_node_id', null);
  }

  query = query.order('order_index', { ascending: true }).order('created_at', { ascending: true });

  const { data, error } = await query;

  if (error) {
    console.error('Error fetching visible attributes:', error);
    return [];
  }

  return data || [];
}

/**
 * Check if a type node is an ancestor of (or equal to) another node
 * @param {object} supabase - Supabase client
 * @param {string} ancestorId - Potential ancestor node ID
 * @param {string} descendantId - Descendant node ID
 * @returns {Promise<boolean>} True if ancestorId is an ancestor of or equal to descendantId
 */
export async function isAncestorOf(supabase, ancestorId, descendantId) {
  if (ancestorId === descendantId) {
    return true;
  }

  const ancestorPath = await getAncestorPath(supabase, descendantId);
  return ancestorPath.includes(ancestorId);
}
