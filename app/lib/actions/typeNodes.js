'use server';

import { createClient } from '@/lib/supabase/server';
import { revalidatePath } from 'next/cache';

/**
 * Create a new type node
 */
export async function createTypeNode(formData) {
  try {
    const supabase = await createClient();

    const entityType = formData.get('entity_type');
    const name = formData.get('name');
    const code = formData.get('code');
    const parentId = formData.get('parent_id') || null;
    const canHaveChildren = formData.get('can_have_children') === 'true';

    if (!entityType || !name) {
      throw new Error('Entity type and name are required');
    }

    // Get display order (next in sequence for this parent)
    const { data: siblings } = await supabase
      .from('entity_type_nodes')
      .select('display_order')
      .eq('entity_type', entityType)
      .eq('parent_id', parentId)
      .order('display_order', { ascending: false })
      .limit(1);

    const displayOrder = siblings && siblings.length > 0
      ? siblings[0].display_order + 1
      : 0;

    const { data, error } = await supabase
      .from('entity_type_nodes')
      .insert({
        entity_type: entityType,
        name,
        code: code || null,
        parent_id: parentId,
        can_have_children: canHaveChildren,
        display_order: displayOrder,
      })
      .select()
      .single();

    if (error) {
      console.error('Error creating type node:', error);
      throw new Error(error.message);
    }

    revalidatePath('/admin/types');
    return { success: true, data };
  } catch (error) {
    console.error('Error in createTypeNode:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Update an existing type node
 */
export async function updateTypeNode(formData) {
  try {
    const supabase = await createClient();

    const id = formData.get('id');
    const name = formData.get('name');
    const code = formData.get('code');
    const canHaveChildren = formData.get('can_have_children') === 'true';

    if (!id || !name) {
      throw new Error('ID and name are required');
    }

    const { data, error } = await supabase
      .from('entity_type_nodes')
      .update({
        name,
        code: code || null,
        can_have_children: canHaveChildren,
        updated_at: new Date().toISOString(),
      })
      .eq('id', id)
      .select()
      .single();

    if (error) {
      console.error('Error updating type node:', error);
      throw new Error(error.message);
    }

    revalidatePath('/admin/types');
    return { success: true, data };
  } catch (error) {
    console.error('Error in updateTypeNode:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Delete a type node
 */
export async function deleteTypeNode(formData) {
  try {
    const supabase = await createClient();

    const id = formData.get('id');

    if (!id) {
      throw new Error('ID is required');
    }

    // Check if node has children
    const { data: children } = await supabase
      .from('entity_type_nodes')
      .select('id')
      .eq('parent_id', id)
      .limit(1);

    if (children && children.length > 0) {
      throw new Error('Cannot delete a node that has children. Delete children first.');
    }

    const { error } = await supabase
      .from('entity_type_nodes')
      .delete()
      .eq('id', id);

    if (error) {
      console.error('Error deleting type node:', error);
      throw new Error(error.message);
    }

    revalidatePath('/admin/types');
    return { success: true };
  } catch (error) {
    console.error('Error in deleteTypeNode:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Reorder type nodes
 */
export async function reorderTypeNodes(formData) {
  try {
    const supabase = await createClient();

    const nodeUpdates = JSON.parse(formData.get('node_updates'));

    // Update display order for multiple nodes
    const updates = nodeUpdates.map((update) =>
      supabase
        .from('entity_type_nodes')
        .update({ display_order: update.display_order })
        .eq('id', update.id)
    );

    await Promise.all(updates);

    revalidatePath('/admin/types');
    return { success: true };
  } catch (error) {
    console.error('Error in reorderTypeNodes:', error);
    return { success: false, error: error.message };
  }
}
