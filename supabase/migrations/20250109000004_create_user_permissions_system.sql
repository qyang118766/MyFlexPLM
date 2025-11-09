-- Migration: Create User Permissions System
-- Implements hierarchical groups, user-group relationships, and granular permissions

-- =====================================================
-- 1. Create Groups Table (Hierarchical)
-- =====================================================

CREATE TABLE IF NOT EXISTS groups (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name VARCHAR NOT NULL,
  code VARCHAR,
  parent_id UUID REFERENCES groups(id) ON DELETE CASCADE,
  description TEXT,
  display_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_groups_parent_id ON groups(parent_id);
CREATE INDEX IF NOT EXISTS idx_groups_display_order ON groups(display_order);

COMMENT ON TABLE groups IS 'Hierarchical user groups for permission management';
COMMENT ON COLUMN groups.parent_id IS 'Parent group ID for hierarchical structure';

-- =====================================================
-- 2. Extend Users Table
-- =====================================================

-- Add role column to users table
ALTER TABLE users
  ADD COLUMN IF NOT EXISTS role VARCHAR NOT NULL DEFAULT 'user';

COMMENT ON COLUMN users.role IS 'User role: admin, user';

-- Update existing admin users
UPDATE users SET role = 'admin' WHERE is_admin = true;

-- =====================================================
-- 3. Create User-Group Relationship Table
-- =====================================================

CREATE TABLE IF NOT EXISTS user_groups (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(user_id, group_id)
);

CREATE INDEX IF NOT EXISTS idx_user_groups_user_id ON user_groups(user_id);
CREATE INDEX IF NOT EXISTS idx_user_groups_group_id ON user_groups(group_id);

COMMENT ON TABLE user_groups IS 'Many-to-many relationship between users and groups';

-- =====================================================
-- 4. Create Type Node Permissions Table
-- =====================================================

CREATE TABLE IF NOT EXISTS type_node_permissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  type_node_id UUID NOT NULL REFERENCES entity_type_nodes(id) ON DELETE CASCADE,
  group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
  permission_level VARCHAR NOT NULL CHECK (permission_level IN ('none', 'read', 'write')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_type_node_permissions_type_node_id ON type_node_permissions(type_node_id);
CREATE INDEX IF NOT EXISTS idx_type_node_permissions_group_id ON type_node_permissions(group_id);

COMMENT ON TABLE type_node_permissions IS 'Permissions for type nodes. NULL group_id means default permission for all users.';
COMMENT ON COLUMN type_node_permissions.permission_level IS 'none: hidden, read: read-only, write: full control';
COMMENT ON COLUMN type_node_permissions.group_id IS 'NULL means this is the default permission for all users';

-- =====================================================
-- 5. Create Attribute Permissions Table
-- =====================================================

CREATE TABLE IF NOT EXISTS attribute_permissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  attribute_id UUID NOT NULL REFERENCES attribute_definitions(id) ON DELETE CASCADE,
  group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
  permission_level VARCHAR NOT NULL CHECK (permission_level IN ('none', 'read', 'write')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_attribute_permissions_attribute_id ON attribute_permissions(attribute_id);
CREATE INDEX IF NOT EXISTS idx_attribute_permissions_group_id ON attribute_permissions(group_id);

COMMENT ON TABLE attribute_permissions IS 'Permissions for attributes. NULL group_id means default permission for all users.';
COMMENT ON COLUMN attribute_permissions.permission_level IS 'none: hidden, read: read-only, write: full control';
COMMENT ON COLUMN attribute_permissions.group_id IS 'NULL means this is the default permission for all users';

-- =====================================================
-- 6. Insert Default Groups
-- =====================================================

-- Insert Design and Review groups
INSERT INTO groups (name, code, description, display_order) VALUES
  ('Design', 'DESIGN', 'Design team members', 0),
  ('Review', 'REVIEW', 'Review team members', 1)
ON CONFLICT DO NOTHING;

-- =====================================================
-- 7. Create Helper Functions
-- =====================================================

-- Function to get all groups a user belongs to (including parent groups)
CREATE OR REPLACE FUNCTION get_user_groups(p_user_id UUID)
RETURNS TABLE (
  group_id UUID,
  group_name VARCHAR,
  group_code VARCHAR
) AS $$
BEGIN
  RETURN QUERY
  WITH RECURSIVE group_hierarchy AS (
    -- Start with direct groups
    SELECT g.id, g.name, g.code, g.parent_id
    FROM groups g
    INNER JOIN user_groups ug ON g.id = ug.group_id
    WHERE ug.user_id = p_user_id

    UNION ALL

    -- Add parent groups recursively
    SELECT g.id, g.name, g.code, g.parent_id
    FROM groups g
    INNER JOIN group_hierarchy gh ON g.id = gh.parent_id
  )
  SELECT DISTINCT id, name, code
  FROM group_hierarchy;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION get_user_groups IS 'Returns all groups a user belongs to, including parent groups through hierarchy';

-- Function to check if user has permission for a type node
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

COMMENT ON FUNCTION check_type_node_permission IS 'Checks if a user has the required permission level for a type node';

-- Function to check if user has permission for an attribute
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

COMMENT ON FUNCTION check_attribute_permission IS 'Checks if a user has the required permission level for an attribute';

-- =====================================================
-- 8. Enable Row Level Security (RLS)
-- =====================================================

ALTER TABLE groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE type_node_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE attribute_permissions ENABLE ROW LEVEL SECURITY;

-- Groups: All authenticated users can read, only admins can write
CREATE POLICY "Enable read access for authenticated users on groups"
  ON groups FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable insert for admin users on groups"
  ON groups FOR INSERT
  TO authenticated
  WITH CHECK ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

CREATE POLICY "Enable update for admin users on groups"
  ON groups FOR UPDATE
  TO authenticated
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

CREATE POLICY "Enable delete for admin users on groups"
  ON groups FOR DELETE
  TO authenticated
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

-- User Groups: Users can read their own groups, admins can manage all
CREATE POLICY "Enable read access for users on their own user_groups"
  ON user_groups FOR SELECT
  TO authenticated
  USING (user_id = auth.uid() OR (SELECT role FROM users WHERE id = auth.uid()) = 'admin');

CREATE POLICY "Enable insert for admin users on user_groups"
  ON user_groups FOR INSERT
  TO authenticated
  WITH CHECK ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

CREATE POLICY "Enable delete for admin users on user_groups"
  ON user_groups FOR DELETE
  TO authenticated
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

-- Type Node Permissions: All can read, only admins can write
CREATE POLICY "Enable read access for authenticated users on type_node_permissions"
  ON type_node_permissions FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable insert for admin users on type_node_permissions"
  ON type_node_permissions FOR INSERT
  TO authenticated
  WITH CHECK ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

CREATE POLICY "Enable update for admin users on type_node_permissions"
  ON type_node_permissions FOR UPDATE
  TO authenticated
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

CREATE POLICY "Enable delete for admin users on type_node_permissions"
  ON type_node_permissions FOR DELETE
  TO authenticated
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

-- Attribute Permissions: All can read, only admins can write
CREATE POLICY "Enable read access for authenticated users on attribute_permissions"
  ON attribute_permissions FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable insert for admin users on attribute_permissions"
  ON attribute_permissions FOR INSERT
  TO authenticated
  WITH CHECK ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

CREATE POLICY "Enable update for admin users on attribute_permissions"
  ON attribute_permissions FOR UPDATE
  TO authenticated
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

CREATE POLICY "Enable delete for admin users on attribute_permissions"
  ON attribute_permissions FOR DELETE
  TO authenticated
  USING ((SELECT role FROM users WHERE id = auth.uid()) = 'admin');

-- =====================================================
-- 9. Create Triggers
-- =====================================================

-- Trigger to update updated_at on groups
CREATE TRIGGER set_groups_updated_at
  BEFORE UPDATE ON groups
  FOR EACH ROW
  EXECUTE FUNCTION update_master_updated_at();

-- Trigger to update updated_at on permissions
CREATE TRIGGER set_type_node_permissions_updated_at
  BEFORE UPDATE ON type_node_permissions
  FOR EACH ROW
  EXECUTE FUNCTION update_master_updated_at();

CREATE TRIGGER set_attribute_permissions_updated_at
  BEFORE UPDATE ON attribute_permissions
  FOR EACH ROW
  EXECUTE FUNCTION update_master_updated_at();
