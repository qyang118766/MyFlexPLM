'use server';

import { createClient } from '@/lib/supabase/server';
import { revalidatePath } from 'next/cache';

/**
 * Create a new group
 */
export async function createGroup(formData) {
  try {
    const supabase = await createClient();

    const name = formData.get('name');
    const code = formData.get('code');
    const parentId = formData.get('parent_id') || null;
    const description = formData.get('description');

    if (!name) {
      throw new Error('Group name is required');
    }

    // Get display order (next in sequence for this parent)
    const { data: siblings } = await supabase
      .from('groups')
      .select('display_order')
      .eq('parent_id', parentId)
      .order('display_order', { ascending: false })
      .limit(1);

    const displayOrder = siblings && siblings.length > 0
      ? siblings[0].display_order + 1
      : 0;

    const { data, error } = await supabase
      .from('groups')
      .insert({
        name,
        code: code || null,
        parent_id: parentId,
        description: description || null,
        display_order: displayOrder,
      })
      .select()
      .single();

    if (error) {
      console.error('Error creating group:', error);
      throw new Error(error.message);
    }

    revalidatePath('/admin/users');
    return { success: true, data };
  } catch (error) {
    console.error('Error in createGroup:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Update an existing group
 */
export async function updateGroup(formData) {
  try {
    const supabase = await createClient();

    const id = formData.get('id');
    const name = formData.get('name');
    const code = formData.get('code');
    const description = formData.get('description');

    if (!id || !name) {
      throw new Error('ID and name are required');
    }

    const { data, error } = await supabase
      .from('groups')
      .update({
        name,
        code: code || null,
        description: description || null,
        updated_at: new Date().toISOString(),
      })
      .eq('id', id)
      .select()
      .single();

    if (error) {
      console.error('Error updating group:', error);
      throw new Error(error.message);
    }

    revalidatePath('/admin/users');
    return { success: true, data };
  } catch (error) {
    console.error('Error in updateGroup:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Delete a group
 */
export async function deleteGroup(formData) {
  try {
    const supabase = await createClient();

    const id = formData.get('id');

    if (!id) {
      throw new Error('ID is required');
    }

    // Check if group has children
    const { data: children } = await supabase
      .from('groups')
      .select('id')
      .eq('parent_id', id)
      .limit(1);

    if (children && children.length > 0) {
      throw new Error('Cannot delete a group that has child groups. Delete children first.');
    }

    // Check if group has users
    const { data: users } = await supabase
      .from('user_groups')
      .select('id')
      .eq('group_id', id)
      .limit(1);

    if (users && users.length > 0) {
      throw new Error('Cannot delete a group that has users assigned. Remove users first.');
    }

    const { error } = await supabase
      .from('groups')
      .delete()
      .eq('id', id);

    if (error) {
      console.error('Error deleting group:', error);
      throw new Error(error.message);
    }

    revalidatePath('/admin/users');
    return { success: true };
  } catch (error) {
    console.error('Error in deleteGroup:', error);
    return { success: false, error: error.message };
  }
}
