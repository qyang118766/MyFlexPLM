import { createClient } from '@/lib/supabase/server';
import UserGroupManager from '@/components/UserGroupManager';

export default async function UsersPage() {
  const supabase = await createClient();

  const [
    { data: users, error: usersError },
    { data: groups, error: groupsError },
    { data: userGroups, error: userGroupsError }
  ] = await Promise.all([
    supabase
      .from('users')
      .select('*')
      .order('created_at', { ascending: false }),
    supabase
      .from('groups')
      .select('*')
      .order('display_order', { ascending: true }),
    supabase
      .from('user_groups')
      .select('*')
  ]);

  if (usersError || groupsError || userGroupsError) {
    const error = usersError || groupsError || userGroupsError;
    return (
      <div className="text-red-600">
        Error loading data: {error.message}
      </div>
    );
  }

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Users & Groups</h1>
        <p className="mt-2 text-sm text-gray-600">
          Manage users, groups, and role assignments
        </p>
      </div>

      <UserGroupManager
        users={users || []}
        groups={groups || []}
        userGroups={userGroups || []}
      />
    </div>
  );
}
