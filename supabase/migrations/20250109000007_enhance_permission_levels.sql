-- Migration: Enhance Permission Levels for Granular Control
-- Expands permission levels from (none, read, write) to (none, read, edit, create, delete, full)

-- =====================================================
-- 1. Update Type Node Permissions
-- =====================================================

-- Drop existing constraint
ALTER TABLE type_node_permissions
  DROP CONSTRAINT IF EXISTS type_node_permissions_permission_level_check;

-- Update constraint to include new permission levels
ALTER TABLE type_node_permissions
  ADD CONSTRAINT type_node_permissions_permission_level_check
  CHECK (permission_level IN ('none', 'read', 'edit', 'create', 'delete', 'full'));

-- Migrate existing 'write' permissions to 'full'
UPDATE type_node_permissions
SET permission_level = 'full'
WHERE permission_level = 'write';

COMMENT ON COLUMN type_node_permissions.permission_level IS
  'Permission levels: none (hidden), read (view only), edit (modify existing), create (create new), delete (delete records), full (all operations)';

-- =====================================================
-- 2. Update Attribute Permissions
-- =====================================================

-- Drop existing constraint
ALTER TABLE attribute_permissions
  DROP CONSTRAINT IF EXISTS attribute_permissions_permission_level_check;

-- Update constraint to include new permission levels
ALTER TABLE attribute_permissions
  ADD CONSTRAINT attribute_permissions_permission_level_check
  CHECK (permission_level IN ('none', 'read', 'edit', 'create', 'delete', 'full'));

-- Migrate existing 'write' permissions to 'full'
UPDATE attribute_permissions
SET permission_level = 'full'
WHERE permission_level = 'write';

COMMENT ON COLUMN attribute_permissions.permission_level IS
  'Permission levels: none (hidden), read (view only), edit (modify existing), create (create new), delete (delete records), full (all operations)';

-- =====================================================
-- 3. Create Function to Calculate Effective Permission
-- =====================================================

-- Function to get numeric value for permission level
CREATE OR REPLACE FUNCTION get_permission_level_value(p_level VARCHAR)
RETURNS INTEGER AS $$
BEGIN
  RETURN CASE p_level
    WHEN 'full' THEN 6
    WHEN 'delete' THEN 5
    WHEN 'create' THEN 4
    WHEN 'edit' THEN 3
    WHEN 'read' THEN 2
    WHEN 'none' THEN 1
    ELSE 0
  END;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION get_permission_level_value IS
  'Converts permission level string to numeric value for comparison. Higher value = more permissions.';

-- Function to get permission level name from value
CREATE OR REPLACE FUNCTION get_permission_level_name(p_value INTEGER)
RETURNS VARCHAR AS $$
BEGIN
  RETURN CASE p_value
    WHEN 6 THEN 'full'
    WHEN 5 THEN 'delete'
    WHEN 4 THEN 'create'
    WHEN 3 THEN 'edit'
    WHEN 2 THEN 'read'
    WHEN 1 THEN 'none'
    ELSE 'none'
  END;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

COMMENT ON FUNCTION get_permission_level_name IS
  'Converts numeric permission value back to level name.';

-- =====================================================
-- 4. Function to Get Effective Permission for Type Node
-- =====================================================

-- This function calculates the effective permission for a type node considering:
-- 1. Direct permissions on the node
-- 2. Inherited permissions from parent nodes (向下覆盖)
-- 3. Group hierarchy (子组继承父组)
CREATE OR REPLACE FUNCTION get_effective_type_node_permission(
  p_user_id UUID,
  p_type_node_id UUID
)
RETURNS VARCHAR AS $$
DECLARE
  v_user_role VARCHAR;
  v_max_permission_value INTEGER := 0;
  v_current_permission_value INTEGER;
  v_node_id UUID;
BEGIN
  -- Admin users have full access
  SELECT role INTO v_user_role FROM users WHERE id = p_user_id;
  IF v_user_role = 'admin' THEN
    RETURN 'full';
  END IF;

  -- Get all user's groups (including parent groups)
  -- For each group, traverse up the type node tree to find permissions
  WITH RECURSIVE
    -- Get user's groups
    user_group_ids AS (
      SELECT group_id FROM get_user_groups(p_user_id)
    ),
    -- Traverse up the type node tree
    node_tree AS (
      SELECT id, parent_id, 0 as depth
      FROM entity_type_nodes
      WHERE id = p_type_node_id

      UNION ALL

      SELECT tn.id, tn.parent_id, nt.depth + 1
      FROM entity_type_nodes tn
      INNER JOIN node_tree nt ON tn.id = nt.parent_id
    )
  SELECT MAX(get_permission_level_value(tnp.permission_level))
  INTO v_max_permission_value
  FROM type_node_permissions tnp
  INNER JOIN node_tree nt ON tnp.type_node_id = nt.id
  WHERE tnp.group_id IN (SELECT group_id FROM user_group_ids);

  -- If no permission found, check for default permission (group_id IS NULL)
  IF v_max_permission_value IS NULL OR v_max_permission_value = 0 THEN
    WITH RECURSIVE node_tree AS (
      SELECT id, parent_id, 0 as depth
      FROM entity_type_nodes
      WHERE id = p_type_node_id

      UNION ALL

      SELECT tn.id, tn.parent_id, nt.depth + 1
      FROM entity_type_nodes tn
      INNER JOIN node_tree nt ON tn.id = nt.parent_id
    )
    SELECT MAX(get_permission_level_value(tnp.permission_level))
    INTO v_max_permission_value
    FROM type_node_permissions tnp
    INNER JOIN node_tree nt ON tnp.type_node_id = nt.id
    WHERE tnp.group_id IS NULL;
  END IF;

  -- Default to 'full' if no restrictions set
  v_max_permission_value := COALESCE(v_max_permission_value, 6);

  RETURN get_permission_level_name(v_max_permission_value);
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION get_effective_type_node_permission IS
  'Calculates effective permission for a type node, considering node hierarchy and group hierarchy.';

-- =====================================================
-- 5. Function to Check Permission
-- =====================================================

CREATE OR REPLACE FUNCTION check_type_node_permission(
  p_user_id UUID,
  p_type_node_id UUID,
  p_required_level VARCHAR
)
RETURNS BOOLEAN AS $$
DECLARE
  v_effective_permission VARCHAR;
  v_effective_value INTEGER;
  v_required_value INTEGER;
BEGIN
  v_effective_permission := get_effective_type_node_permission(p_user_id, p_type_node_id);
  v_effective_value := get_permission_level_value(v_effective_permission);
  v_required_value := get_permission_level_value(p_required_level);

  RETURN v_effective_value >= v_required_value;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION check_type_node_permission IS
  'Checks if user has required permission level for a type node.';

-- =====================================================
-- 6. Function to Get Parent Group Permissions (for validation)
-- =====================================================

-- This ensures child groups cannot have more permissions than parent groups
CREATE OR REPLACE FUNCTION get_parent_group_max_permission(
  p_group_id UUID,
  p_type_node_id UUID
)
RETURNS VARCHAR AS $$
DECLARE
  v_parent_id UUID;
  v_max_permission_value INTEGER := 6; -- Start with full permission
  v_current_permission_value INTEGER;
BEGIN
  -- Get parent group
  SELECT parent_id INTO v_parent_id
  FROM groups
  WHERE id = p_group_id;

  -- If no parent, return full permission
  IF v_parent_id IS NULL THEN
    RETURN 'full';
  END IF;

  -- Recursively check parent permissions
  WITH RECURSIVE
    parent_groups AS (
      SELECT id, parent_id
      FROM groups
      WHERE id = v_parent_id

      UNION ALL

      SELECT g.id, g.parent_id
      FROM groups g
      INNER JOIN parent_groups pg ON g.id = pg.parent_id
    ),
    node_tree AS (
      SELECT id, parent_id, 0 as depth
      FROM entity_type_nodes
      WHERE id = p_type_node_id

      UNION ALL

      SELECT tn.id, tn.parent_id, nt.depth + 1
      FROM entity_type_nodes tn
      INNER JOIN node_tree nt ON tn.id = nt.parent_id
    )
  SELECT MIN(get_permission_level_value(tnp.permission_level))
  INTO v_max_permission_value
  FROM type_node_permissions tnp
  INNER JOIN node_tree nt ON tnp.type_node_id = nt.id
  INNER JOIN parent_groups pg ON tnp.group_id = pg.id;

  -- Default to full if parent has no restrictions
  v_max_permission_value := COALESCE(v_max_permission_value, 6);

  RETURN get_permission_level_name(v_max_permission_value);
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION get_parent_group_max_permission IS
  'Returns the maximum permission a child group can have based on parent group permissions.';
