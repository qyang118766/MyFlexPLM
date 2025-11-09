'use server';

import { createClient } from '@/lib/supabase/server';
import { revalidatePath } from 'next/cache';

/**
 * Create a new attribute definition
 */
export async function createAttribute(formData) {
  try {
    const supabase = await createClient();

    const entityType = formData.get('entity_type');
    const key = formData.get('key');
    const label = formData.get('label');
    const dataType = formData.get('data_type');
    const required = formData.get('required') === 'true';
    const isUnique = formData.get('is_unique') === 'true';
    const maxLength = formData.get('max_length') || null;
    const typeNodeId = formData.get('type_node_id') || null;
    const options = formData.get('options');

    if (!entityType || !key || !label || !dataType) {
      throw new Error('Entity type, key, label, and data type are required');
    }

    // Get next order index
    const { data: existingAttrs } = await supabase
      .from('attribute_definitions')
      .select('order_index')
      .eq('entity_type', entityType)
      .order('order_index', { ascending: false })
      .limit(1);

    const orderIndex = existingAttrs && existingAttrs.length > 0
      ? existingAttrs[0].order_index + 1
      : 0;

    // Parse options if provided
    let parsedOptions = null;
    if (options) {
      try {
        parsedOptions = JSON.parse(options);
      } catch (e) {
        throw new Error('Invalid JSON format for options');
      }
    }

    const { data, error } = await supabase
      .from('attribute_definitions')
      .insert({
        entity_type: entityType,
        key,
        label,
        data_type: dataType,
        required,
        is_unique: isUnique,
        max_length: maxLength ? parseInt(maxLength) : null,
        type_node_id: typeNodeId,
        options: parsedOptions,
        order_index: orderIndex,
        is_active: true,
      })
      .select()
      .single();

    if (error) {
      console.error('Error creating attribute:', error);
      throw new Error(error.message);
    }

    revalidatePath('/admin/attributes');
    return { success: true, data };
  } catch (error) {
    console.error('Error in createAttribute:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Update an existing attribute definition
 */
export async function updateAttribute(formData) {
  try {
    const supabase = await createClient();

    const id = formData.get('id');
    const key = formData.get('key');
    const label = formData.get('label');
    const dataType = formData.get('data_type');
    const required = formData.get('required') === 'true';
    const isUnique = formData.get('is_unique') === 'true';
    const maxLength = formData.get('max_length') || null;
    const typeNodeId = formData.get('type_node_id') || null;
    const options = formData.get('options');

    if (!id || !key || !label || !dataType) {
      throw new Error('ID, key, label, and data type are required');
    }

    // Parse options if provided
    let parsedOptions = null;
    if (options) {
      try {
        parsedOptions = JSON.parse(options);
      } catch (e) {
        throw new Error('Invalid JSON format for options');
      }
    }

    const { data, error } = await supabase
      .from('attribute_definitions')
      .update({
        key,
        label,
        data_type: dataType,
        required,
        is_unique: isUnique,
        max_length: maxLength ? parseInt(maxLength) : null,
        type_node_id: typeNodeId,
        options: parsedOptions,
        updated_at: new Date().toISOString(),
      })
      .eq('id', id)
      .select()
      .single();

    if (error) {
      console.error('Error updating attribute:', error);
      throw new Error(error.message);
    }

    revalidatePath('/admin/attributes');
    return { success: true, data };
  } catch (error) {
    console.error('Error in updateAttribute:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Toggle attribute active status
 */
export async function toggleAttributeStatus(formData) {
  try {
    const supabase = await createClient();

    const id = formData.get('id');
    const isActive = formData.get('is_active') === 'true';

    if (!id) {
      throw new Error('ID is required');
    }

    const { data, error } = await supabase
      .from('attribute_definitions')
      .update({
        is_active: isActive,
        updated_at: new Date().toISOString(),
      })
      .eq('id', id)
      .select()
      .single();

    if (error) {
      console.error('Error toggling attribute status:', error);
      throw new Error(error.message);
    }

    revalidatePath('/admin/attributes');
    return { success: true, data };
  } catch (error) {
    console.error('Error in toggleAttributeStatus:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Delete an attribute definition
 */
export async function deleteAttribute(formData) {
  try {
    const supabase = await createClient();

    const id = formData.get('id');

    if (!id) {
      throw new Error('ID is required');
    }

    const { error } = await supabase
      .from('attribute_definitions')
      .delete()
      .eq('id', id);

    if (error) {
      console.error('Error deleting attribute:', error);
      throw new Error(error.message);
    }

    revalidatePath('/admin/attributes');
    return { success: true };
  } catch (error) {
    console.error('Error in deleteAttribute:', error);
    return { success: false, error: error.message };
  }
}
