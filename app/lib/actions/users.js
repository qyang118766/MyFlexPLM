'use server';

import { createClient } from '@/lib/supabase/server';
import { createAdminClient } from '@/lib/supabase/admin';
import { revalidatePath } from 'next/cache';

/**
 * Create a new user with initial password
 */
export async function createUser(formData) {
  try {
    // Use admin client for auth operations
    const adminClient = createAdminClient();
    // Use regular client for database operations with RLS
    const supabase = await createClient();

    const email = formData.get('email');
    const displayName = formData.get('display_name');
    const initialPassword = formData.get('initial_password');
    const role = formData.get('role') || 'user';
    const groupIds = formData.get('group_ids'); // JSON string array

    if (!email || !displayName || !initialPassword) {
      throw new Error('Email, display name, and initial password are required');
    }

    // Create user in Supabase Auth using admin client
    // The trigger will automatically create the user record in public.users
    const { data: authData, error: authError } = await adminClient.auth.admin.createUser({
      email,
      password: initialPassword,
      email_confirm: true, // Auto-confirm email for admin-created users
      user_metadata: {
        display_name: displayName
      }
    });

    if (authError) {
      throw new Error(`Failed to create auth user: ${authError.message}`);
    }

    // Wait a moment for the trigger to complete
    await new Promise(resolve => setTimeout(resolve, 100));

    // Update the user record created by trigger with the correct role and superadmin status
    const { data: userData, error: userError } = await adminClient
      .from('users')
      .update({
        display_name: displayName,
        role,
        is_superadmin: role === 'admin',
      })
      .eq('id', authData.user.id)
      .select()
      .single();

    if (userError) {
      // Rollback: Delete auth user (cascade will delete user record)
      await adminClient.auth.admin.deleteUser(authData.user.id);
      throw new Error(`Failed to update user record: ${userError.message}`);
    }

    // Assign groups if provided (using admin client)
    if (groupIds) {
      const groups = JSON.parse(groupIds);
      if (groups.length > 0) {
        const userGroupRecords = groups.map(groupId => ({
          user_id: authData.user.id,
          group_id: groupId,
        }));

        const { error: groupError } = await adminClient
          .from('user_groups')
          .insert(userGroupRecords);

        if (groupError) {
          console.error('Error assigning groups:', groupError);
          // Don't rollback user creation, just log the error
        }
      }
    }

    revalidatePath('/admin/users');
    return { success: true, data: userData };
  } catch (error) {
    console.error('Error in createUser:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Update user information and group assignments
 */
export async function updateUser(formData) {
  try {
    const supabase = await createClient();

    const userId = formData.get('user_id');
    const displayName = formData.get('display_name');
    const role = formData.get('role');
    const groupIds = formData.get('group_ids'); // JSON string array

    if (!userId || !displayName) {
      throw new Error('User ID and display name are required');
    }

    // Update user record
    const { data, error } = await supabase
      .from('users')
      .update({
        display_name: displayName,
        role,
        is_superadmin: role === 'admin',
        updated_at: new Date().toISOString(),
      })
      .eq('id', userId)
      .select()
      .single();

    if (error) {
      throw new Error(`Failed to update user: ${error.message}`);
    }

    // Update group assignments
    if (groupIds !== null) {
      // Delete existing group assignments
      await supabase
        .from('user_groups')
        .delete()
        .eq('user_id', userId);

      // Insert new group assignments
      const groups = JSON.parse(groupIds);
      if (groups.length > 0) {
        const userGroupRecords = groups.map(groupId => ({
          user_id: userId,
          group_id: groupId,
        }));

        const { error: groupError } = await supabase
          .from('user_groups')
          .insert(userGroupRecords);

        if (groupError) {
          console.error('Error updating groups:', groupError);
        }
      }
    }

    revalidatePath('/admin/users');
    return { success: true, data };
  } catch (error) {
    console.error('Error in updateUser:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Reset user password (admin only)
 */
export async function resetUserPassword(formData) {
  try {
    const adminClient = createAdminClient();

    const userId = formData.get('user_id');
    const newPassword = formData.get('new_password');

    if (!userId || !newPassword) {
      throw new Error('User ID and new password are required');
    }

    // Update password using Supabase Admin API
    const { data, error } = await adminClient.auth.admin.updateUserById(userId, {
      password: newPassword,
    });

    if (error) {
      throw new Error(`Failed to reset password: ${error.message}`);
    }

    return { success: true };
  } catch (error) {
    console.error('Error in resetUserPassword:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Delete a user
 */
export async function deleteUser(formData) {
  try {
    const adminClient = createAdminClient();

    const userId = formData.get('user_id');

    if (!userId) {
      throw new Error('User ID is required');
    }

    // Delete from users table (cascade will delete user_groups)
    const { error: dbError } = await adminClient
      .from('users')
      .delete()
      .eq('id', userId);

    if (dbError) {
      throw new Error(`Failed to delete user record: ${dbError.message}`);
    }

    // Delete from Supabase Auth
    const { error: authError } = await adminClient.auth.admin.deleteUser(userId);

    if (authError) {
      console.error('Error deleting auth user:', authError);
      // User record already deleted, just log the error
    }

    revalidatePath('/admin/users');
    return { success: true };
  } catch (error) {
    console.error('Error in deleteUser:', error);
    return { success: false, error: error.message };
  }
}

/**
 * Get current user's information
 */
export async function getCurrentUser() {
  try {
    const supabase = await createClient();

    const { data: { user: authUser } } = await supabase.auth.getUser();

    if (!authUser) {
      return { success: false, error: 'Not authenticated' };
    }

    const { data: user, error } = await supabase
      .from('users')
      .select('*')
      .eq('id', authUser.id)
      .single();

    if (error) {
      throw new Error(error.message);
    }

    return { success: true, data: user };
  } catch (error) {
    console.error('Error in getCurrentUser:', error);
    return { success: false, error: error.message };
  }
}
