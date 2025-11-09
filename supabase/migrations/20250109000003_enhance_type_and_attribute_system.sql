-- Migration: Enhance Type Manager and Attribute Manager
-- Adds support for:
-- 1. Restricting child node creation on type nodes
-- 2. Scoping attributes to specific type hierarchy levels

-- =====================================================
-- 1. Add can_have_children to entity_type_nodes
-- =====================================================

-- Add column to control whether a type node can have children
ALTER TABLE entity_type_nodes
  ADD COLUMN can_have_children BOOLEAN NOT NULL DEFAULT true;

COMMENT ON COLUMN entity_type_nodes.can_have_children IS
  'Controls whether this type node can have child nodes. When false, the node is a leaf type.';

-- =====================================================
-- 2. Add type_node_id to attribute_definitions
-- =====================================================

-- Add nullable FK to scope attributes to specific type hierarchy levels
ALTER TABLE attribute_definitions
  ADD COLUMN type_node_id UUID REFERENCES entity_type_nodes(id) ON DELETE CASCADE;

COMMENT ON COLUMN attribute_definitions.type_node_id IS
  'Optional scope: if set, this attribute only applies to the specified type node and its descendants. If null, applies to all nodes of the entity_type.';

-- =====================================================
-- 3. Add display_order to entity_type_nodes
-- =====================================================

-- Add display order for UI rendering
ALTER TABLE entity_type_nodes
  ADD COLUMN display_order INTEGER NOT NULL DEFAULT 0;

COMMENT ON COLUMN entity_type_nodes.display_order IS
  'Order for displaying nodes among siblings in the type tree UI.';

-- =====================================================
-- 4. Add max_length to attribute_definitions
-- =====================================================

-- Add max length for string fields
ALTER TABLE attribute_definitions
  ADD COLUMN max_length INTEGER;

COMMENT ON COLUMN attribute_definitions.max_length IS
  'Maximum length for string/text fields. Only applicable when data_type is string.';

-- Add unique constraint for boolean
ALTER TABLE attribute_definitions
  ADD COLUMN is_unique BOOLEAN NOT NULL DEFAULT false;

COMMENT ON COLUMN attribute_definitions.is_unique IS
  'Whether this attribute value must be unique across all items of this type.';

-- =====================================================
-- 5. Create indexes for performance
-- =====================================================

-- Index for querying attributes by type node
CREATE INDEX IF NOT EXISTS idx_attribute_definitions_type_node_id
  ON attribute_definitions(type_node_id);

-- Index for querying type nodes by parent
CREATE INDEX IF NOT EXISTS idx_entity_type_nodes_parent_entity
  ON entity_type_nodes(parent_id, entity_type);

-- Index for display ordering
CREATE INDEX IF NOT EXISTS idx_entity_type_nodes_display_order
  ON entity_type_nodes(display_order);

-- =====================================================
-- 6. Create helper function to get inherited attributes
-- =====================================================

-- Function to get all attributes for a type node (including inherited)
CREATE OR REPLACE FUNCTION get_type_node_attributes(
  p_type_node_id UUID,
  p_entity_type TEXT
)
RETURNS TABLE (
  id UUID,
  entity_type TEXT,
  key TEXT,
  label TEXT,
  data_type TEXT,
  required BOOLEAN,
  order_index INTEGER,
  options JSONB,
  is_active BOOLEAN,
  max_length INTEGER,
  is_unique BOOLEAN,
  type_node_id UUID,
  inherited BOOLEAN
) AS $$
BEGIN
  RETURN QUERY
  WITH RECURSIVE node_path AS (
    -- Start with the current node
    SELECT n.id, n.parent_id, 0 as depth
    FROM entity_type_nodes n
    WHERE n.id = p_type_node_id

    UNION ALL

    -- Recursively get parent nodes
    SELECT n.id, n.parent_id, np.depth + 1
    FROM entity_type_nodes n
    INNER JOIN node_path np ON n.id = np.parent_id
  )
  SELECT DISTINCT ON (ad.key)
    ad.id,
    ad.entity_type,
    ad.key,
    ad.label,
    ad.data_type,
    ad.required,
    ad.order_index,
    ad.options,
    ad.is_active,
    ad.max_length,
    ad.is_unique,
    ad.type_node_id,
    (ad.type_node_id != p_type_node_id) as inherited
  FROM attribute_definitions ad
  WHERE
    ad.entity_type = p_entity_type
    AND ad.is_active = true
    AND (
      -- Global attributes (no type_node_id)
      ad.type_node_id IS NULL
      OR
      -- Attributes scoped to this node or any ancestor
      ad.type_node_id IN (SELECT id FROM node_path)
    )
  ORDER BY ad.key, depth ASC; -- Prefer closer ancestors
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION get_type_node_attributes IS
  'Returns all active attributes for a type node, including inherited attributes from parent nodes. Attributes defined on closer ancestors take precedence.';

-- =====================================================
-- 7. Update existing data
-- =====================================================

-- All existing nodes can have children by default
UPDATE entity_type_nodes
  SET can_have_children = true
  WHERE can_have_children IS NULL;

-- Set display order based on current creation order
WITH ordered_nodes AS (
  SELECT id, ROW_NUMBER() OVER (PARTITION BY parent_id, entity_type ORDER BY created_at) - 1 as new_order
  FROM entity_type_nodes
)
UPDATE entity_type_nodes n
  SET display_order = o.new_order
  FROM ordered_nodes o
  WHERE n.id = o.id;
