-- Create attribute_group_permissions table for fine-grained attribute access control
-- This table stores explicit permission overrides for attributes per group
-- Default permissions are inherited from type node permissions

CREATE TABLE IF NOT EXISTS attribute_group_permissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  attribute_definition_id UUID NOT NULL REFERENCES attribute_definitions(id) ON DELETE CASCADE,
  group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  permission_level VARCHAR(20) NOT NULL CHECK (permission_level IN ('hidden', 'read-only', 'editable')),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(attribute_definition_id, group_id)
);

-- Index for faster lookups
CREATE INDEX idx_attribute_group_permissions_attribute ON attribute_group_permissions(attribute_definition_id);
CREATE INDEX idx_attribute_group_permissions_group ON attribute_group_permissions(group_id);

-- Function to get default attribute permission based on type node permission
-- If user has read permission on type node -> read-only on attributes
-- If user has edit/create/delete/full permission on type node -> editable on attributes
-- If user has none permission on type node -> hidden on attributes
CREATE OR REPLACE FUNCTION get_default_attribute_permission(
  p_type_node_id UUID,
  p_user_id UUID
) RETURNS VARCHAR AS $$
DECLARE
  v_type_permission VARCHAR;
BEGIN
  -- Get the user's effective permission for the type node
  SELECT get_effective_type_node_permission(p_type_node_id, p_user_id)
  INTO v_type_permission;

  -- Map type permission to attribute permission
  CASE v_type_permission
    WHEN 'none' THEN RETURN 'hidden';
    WHEN 'read' THEN RETURN 'read-only';
    WHEN 'edit', 'create', 'delete', 'full' THEN RETURN 'editable';
    ELSE RETURN 'hidden';
  END CASE;
END;
$$ LANGUAGE plpgsql;

-- Helper function to compare permission strictness
-- Returns the stricter of two permissions
-- hidden is strictest, editable is most permissive
CREATE OR REPLACE FUNCTION get_stricter_permission(p1 VARCHAR, p2 VARCHAR) RETURNS VARCHAR AS $$
BEGIN
  IF p1 = 'hidden' OR p2 = 'hidden' THEN RETURN 'hidden';
  END IF;
  IF p1 = 'read-only' OR p2 = 'read-only' THEN RETURN 'read-only';
  END IF;
  RETURN 'editable';
END;
$$ LANGUAGE plpgsql;

-- Function to get effective attribute permission for a user
-- Considers all groups the user belongs to and applies strictest permission
-- Priority: explicit override > default from type permission
-- Strictest rule: hidden > read-only > editable
CREATE OR REPLACE FUNCTION get_effective_attribute_permission(
  p_attribute_id UUID,
  p_user_id UUID
) RETURNS VARCHAR AS $$
DECLARE
  v_permission VARCHAR := 'editable'; -- Start with most permissive
  v_group_permission VARCHAR;
  v_default_permission VARCHAR;
  v_type_node_id UUID;
  v_group_record RECORD;
  v_has_groups BOOLEAN := FALSE;
BEGIN
  -- Get the attribute's type node
  SELECT type_node_id INTO v_type_node_id
  FROM attribute_definitions
  WHERE id = p_attribute_id;

  -- Loop through all groups the user belongs to
  FOR v_group_record IN
    SELECT group_id
    FROM user_groups
    WHERE user_id = p_user_id
  LOOP
    v_has_groups := TRUE;

    -- Check if there's an explicit permission override
    SELECT permission_level INTO v_group_permission
    FROM attribute_group_permissions
    WHERE attribute_definition_id = p_attribute_id
      AND group_id = v_group_record.group_id;

    IF v_group_permission IS NOT NULL THEN
      -- Use explicit permission
      v_permission := get_stricter_permission(v_permission, v_group_permission);
    ELSIF v_type_node_id IS NOT NULL THEN
      -- Calculate default permission from type node permission only if attribute has scope
      v_default_permission := get_default_attribute_permission(v_type_node_id, p_user_id);
      v_permission := get_stricter_permission(v_permission, v_default_permission);
    END IF;

    -- If already hidden, no need to check further
    IF v_permission = 'hidden' THEN
      RETURN 'hidden';
    END IF;
  END LOOP;

  -- If user has no groups, return editable (no restrictions)
  IF NOT v_has_groups THEN
    RETURN 'editable';
  END IF;

  RETURN v_permission;
END;
$$ LANGUAGE plpgsql;

-- Enable RLS on attribute_group_permissions
ALTER TABLE attribute_group_permissions ENABLE ROW LEVEL SECURITY;

-- RLS policies for attribute_group_permissions
CREATE POLICY "Superadmins can manage attribute permissions"
  ON attribute_group_permissions FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.is_superadmin = true
    )
  );

CREATE POLICY "Users can view attribute permissions for their groups"
  ON attribute_group_permissions FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM user_groups
      WHERE user_groups.user_id = auth.uid()
      AND user_groups.group_id = attribute_group_permissions.group_id
    )
  );

COMMENT ON TABLE attribute_group_permissions IS 'Stores explicit attribute visibility and editability permissions per group. When not specified, permissions are inherited from type node permissions.';
COMMENT ON COLUMN attribute_group_permissions.permission_level IS 'hidden: attribute is completely hidden; read-only: attribute is visible but not editable; editable: attribute can be modified';
