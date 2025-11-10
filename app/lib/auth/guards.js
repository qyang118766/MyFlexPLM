'use server';

/**
 * Shared admin guard helper.
 * Ensures the current Supabase session belongs to an admin user
 * and returns a friendly identifier for auditing.
 */
export async function requireAdminUser(supabase) {
  const {
    data: { user },
    error,
  } = await supabase.auth.getUser();

  if (error || !user) {
    const guardError = new Error('Unauthorized');
    guardError.statusCode = 401;
    throw guardError;
  }

  const { data: profile, error: profileError } = await supabase
    .from('users')
    .select('role, is_superadmin, display_name')
    .eq('id', user.id)
    .single();

  const toBoolean = (value) => {
    return (
      value === true ||
      value === 'true' ||
      value === 't' ||
      value === '1' ||
      value === 1
    );
  };

  const role = profile?.role;
  const isRoleAdmin = typeof role === 'string' && role.toLowerCase() === 'admin';
  const isSuperAdmin = toBoolean(profile?.is_superadmin);

  if (profileError || (!isRoleAdmin && !isSuperAdmin)) {
    const guardError = new Error('Administrator required');
    guardError.statusCode = 403;
    throw guardError;
  }

  const identifier =
    user.user_metadata?.role_name ||
    user.user_metadata?.role ||
    profile?.display_name ||
    user.email ||
    user.id;

  return { user, profile, identifier };
}
