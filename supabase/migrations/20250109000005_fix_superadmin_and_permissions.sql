-- Migration: Fix Superadmin and Update Permission Policies

-- =====================================================
-- 1. Replace is_admin with is_superadmin
-- =====================================================

-- Add is_superadmin column
ALTER TABLE users
  ADD COLUMN IF NOT EXISTS is_superadmin BOOLEAN NOT NULL DEFAULT false;

-- Migrate existing is_admin data to is_superadmin
UPDATE users SET is_superadmin = is_admin WHERE is_admin = true;

-- Set admin role users to superadmin
UPDATE users SET is_superadmin = true WHERE role = 'admin';

-- Drop policies that depend on is_admin
DROP POLICY IF EXISTS "枚举表仅管理员可修改" ON enums;

-- Drop old is_admin column
ALTER TABLE users DROP COLUMN IF EXISTS is_admin;

-- Recreate enum policy using role instead of is_admin
CREATE POLICY "枚举表仅管理员可修改"
  ON enums FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.role = 'admin'
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.role = 'admin'
    )
  );

COMMENT ON COLUMN users.is_superadmin IS 'Superadmin flag - bypasses all permissions and restrictions. Reserved for admin accounts only.';

-- =====================================================
-- 2. Update RLS Policies to use role check
-- =====================================================

-- Helper function to check if current user is admin
CREATE OR REPLACE FUNCTION is_current_user_admin()
RETURNS BOOLEAN AS $$
BEGIN
  RETURN (SELECT role FROM users WHERE id = auth.uid()) = 'admin';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Drop old policies and recreate with role-based checks
DROP POLICY IF EXISTS "Enable insert for admin users on groups" ON groups;
DROP POLICY IF EXISTS "Enable update for admin users on groups" ON groups;
DROP POLICY IF EXISTS "Enable delete for admin users on groups" ON groups;

DROP POLICY IF EXISTS "Enable insert for admin users on user_groups" ON user_groups;
DROP POLICY IF EXISTS "Enable delete for admin users on user_groups" ON user_groups;

DROP POLICY IF EXISTS "Enable insert for admin users on type_node_permissions" ON type_node_permissions;
DROP POLICY IF EXISTS "Enable update for admin users on type_node_permissions" ON type_node_permissions;
DROP POLICY IF EXISTS "Enable delete for admin users on type_node_permissions" ON type_node_permissions;

DROP POLICY IF EXISTS "Enable insert for admin users on attribute_permissions" ON attribute_permissions;
DROP POLICY IF EXISTS "Enable update for admin users on attribute_permissions" ON attribute_permissions;
DROP POLICY IF EXISTS "Enable delete for admin users on attribute_permissions" ON attribute_permissions;

-- Groups policies
CREATE POLICY "Enable insert for admin users on groups"
  ON groups FOR INSERT
  TO authenticated
  WITH CHECK (is_current_user_admin());

CREATE POLICY "Enable update for admin users on groups"
  ON groups FOR UPDATE
  TO authenticated
  USING (is_current_user_admin());

CREATE POLICY "Enable delete for admin users on groups"
  ON groups FOR DELETE
  TO authenticated
  USING (is_current_user_admin());

-- User Groups policies
CREATE POLICY "Enable insert for admin users on user_groups"
  ON user_groups FOR INSERT
  TO authenticated
  WITH CHECK (is_current_user_admin());

CREATE POLICY "Enable delete for admin users on user_groups"
  ON user_groups FOR DELETE
  TO authenticated
  USING (is_current_user_admin());

-- Type Node Permissions policies
CREATE POLICY "Enable insert for admin users on type_node_permissions"
  ON type_node_permissions FOR INSERT
  TO authenticated
  WITH CHECK (is_current_user_admin());

CREATE POLICY "Enable update for admin users on type_node_permissions"
  ON type_node_permissions FOR UPDATE
  TO authenticated
  USING (is_current_user_admin());

CREATE POLICY "Enable delete for admin users on type_node_permissions"
  ON type_node_permissions FOR DELETE
  TO authenticated
  USING (is_current_user_admin());

-- Attribute Permissions policies
CREATE POLICY "Enable insert for admin users on attribute_permissions"
  ON attribute_permissions FOR INSERT
  TO authenticated
  WITH CHECK (is_current_user_admin());

CREATE POLICY "Enable update for admin users on attribute_permissions"
  ON attribute_permissions FOR UPDATE
  TO authenticated
  USING (is_current_user_admin());

CREATE POLICY "Enable delete for admin users on attribute_permissions"
  ON attribute_permissions FOR DELETE
  TO authenticated
  USING (is_current_user_admin());

-- =====================================================
-- 3. Update permission check functions
-- =====================================================

-- Update check_type_node_permission to use role instead of is_admin
CREATE OR REPLACE FUNCTION check_type_node_permission(
  p_user_id UUID,
  p_type_node_id UUID,
  p_required_level VARCHAR
)
RETURNS BOOLEAN AS $$
DECLARE
  v_user_role VARCHAR;
  v_permission_level VARCHAR;
  v_default_permission VARCHAR;
BEGIN
  -- Admin users have full access
  SELECT role INTO v_user_role FROM users WHERE id = p_user_id;
  IF v_user_role = 'admin' THEN
    RETURN TRUE;
  END IF;

  -- Get default permission (group_id IS NULL)
  SELECT permission_level INTO v_default_permission
  FROM type_node_permissions
  WHERE type_node_id = p_type_node_id
    AND group_id IS NULL
  LIMIT 1;

  -- If no default permission set, assume 'write' (full access for all)
  v_default_permission := COALESCE(v_default_permission, 'write');

  -- Get highest permission level for user's groups
  SELECT MAX(
    CASE permission_level
      WHEN 'write' THEN 3
      WHEN 'read' THEN 2
      WHEN 'none' THEN 1
      ELSE 0
    END
  ) INTO v_permission_level
  FROM type_node_permissions tnp
  WHERE tnp.type_node_id = p_type_node_id
    AND tnp.group_id IN (SELECT group_id FROM get_user_groups(p_user_id));

  -- Convert back to permission level name
  v_permission_level := CASE v_permission_level
    WHEN 3 THEN 'write'
    WHEN 2 THEN 'read'
    WHEN 1 THEN 'none'
    ELSE v_default_permission
  END;

  -- Check if permission level meets requirement
  RETURN CASE
    WHEN p_required_level = 'write' THEN v_permission_level = 'write'
    WHEN p_required_level = 'read' THEN v_permission_level IN ('read', 'write')
    ELSE v_permission_level != 'none'
  END;
END;
$$ LANGUAGE plpgsql;

-- Update check_attribute_permission to use role instead of is_admin
CREATE OR REPLACE FUNCTION check_attribute_permission(
  p_user_id UUID,
  p_attribute_id UUID,
  p_required_level VARCHAR
)
RETURNS BOOLEAN AS $$
DECLARE
  v_user_role VARCHAR;
  v_permission_level VARCHAR;
  v_default_permission VARCHAR;
BEGIN
  -- Admin users have full access
  SELECT role INTO v_user_role FROM users WHERE id = p_user_id;
  IF v_user_role = 'admin' THEN
    RETURN TRUE;
  END IF;

  -- Get default permission (group_id IS NULL)
  SELECT permission_level INTO v_default_permission
  FROM attribute_permissions
  WHERE attribute_id = p_attribute_id
    AND group_id IS NULL
  LIMIT 1;

  -- If no default permission set, assume 'write' (full access for all)
  v_default_permission := COALESCE(v_default_permission, 'write');

  -- Get highest permission level for user's groups
  SELECT MAX(
    CASE permission_level
      WHEN 'write' THEN 3
      WHEN 'read' THEN 2
      WHEN 'none' THEN 1
      ELSE 0
    END
  ) INTO v_permission_level
  FROM attribute_permissions ap
  WHERE ap.attribute_id = p_attribute_id
    AND ap.group_id IN (SELECT group_id FROM get_user_groups(p_user_id));

  -- Convert back to permission level name
  v_permission_level := CASE v_permission_level
    WHEN 3 THEN 'write'
    WHEN 2 THEN 'read'
    WHEN 1 THEN 'none'
    ELSE v_default_permission
  END;

  -- Check if permission level meets requirement
  RETURN CASE
    WHEN p_required_level = 'write' THEN v_permission_level = 'write'
    WHEN p_required_level = 'read' THEN v_permission_level IN ('read', 'write')
    ELSE v_permission_level != 'none'
  END;
END;
$$ LANGUAGE plpgsql;
