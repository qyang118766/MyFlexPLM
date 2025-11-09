-- Migration: Refactor Version Control System
-- Add isLatest field and update constraints for version-controlled entities

-- =====================================================
-- 1. Add isLatest column to versioned entities
-- =====================================================

-- Products
ALTER TABLE products
ADD COLUMN IF NOT EXISTS is_latest BOOLEAN NOT NULL DEFAULT TRUE;

CREATE INDEX IF NOT EXISTS idx_products_latest
ON products(style_code, is_latest)
WHERE is_latest = TRUE;

-- Materials
ALTER TABLE materials
ADD COLUMN IF NOT EXISTS is_latest BOOLEAN NOT NULL DEFAULT TRUE;

CREATE INDEX IF NOT EXISTS idx_materials_latest
ON materials(material_code, is_latest)
WHERE is_latest = TRUE;

-- Suppliers
ALTER TABLE suppliers
ADD COLUMN IF NOT EXISTS is_latest BOOLEAN NOT NULL DEFAULT TRUE;

CREATE INDEX IF NOT EXISTS idx_suppliers_latest
ON suppliers(supplier_code, is_latest)
WHERE is_latest = TRUE;

-- =====================================================
-- 2. Drop UNIQUE constraints on code fields
--    (since we now have multiple versions per code)
-- =====================================================

-- Products: Drop unique constraint on style_code
ALTER TABLE products
DROP CONSTRAINT IF EXISTS products_style_code_key;

-- Materials: Drop unique constraint on material_code
ALTER TABLE materials
DROP CONSTRAINT IF EXISTS materials_material_code_key;

-- Suppliers: Drop unique constraint on supplier_code
ALTER TABLE suppliers
DROP CONSTRAINT IF EXISTS suppliers_supplier_code_key;

-- =====================================================
-- 3. Add composite unique constraints
--    (code + version + iteration must be unique)
-- =====================================================

-- Products
ALTER TABLE products
ADD CONSTRAINT products_code_version_iteration_unique
UNIQUE (style_code, version, iteration);

-- Materials
ALTER TABLE materials
ADD CONSTRAINT materials_code_version_iteration_unique
UNIQUE (material_code, version, iteration);

-- Suppliers
ALTER TABLE suppliers
ADD CONSTRAINT suppliers_code_version_iteration_unique
UNIQUE (supplier_code, version, iteration);

-- =====================================================
-- 4. Add constraint: only one latest version per code
-- =====================================================

-- Products: Only one row can be latest for each style_code
CREATE UNIQUE INDEX IF NOT EXISTS idx_products_one_latest_per_code
ON products(style_code)
WHERE is_latest = TRUE;

-- Materials: Only one row can be latest for each material_code
CREATE UNIQUE INDEX IF NOT EXISTS idx_materials_one_latest_per_code
ON materials(material_code)
WHERE is_latest = TRUE;

-- Suppliers: Only one row can be latest for each supplier_code
CREATE UNIQUE INDEX IF NOT EXISTS idx_suppliers_one_latest_per_code
ON suppliers(supplier_code)
WHERE is_latest = TRUE;

-- =====================================================
-- 5. Update existing records to set isLatest
--    (For each code, mark the highest iteration as latest)
-- =====================================================

-- Products: Mark latest versions
WITH latest_products AS (
  SELECT DISTINCT ON (style_code)
    id
  FROM products
  ORDER BY style_code, version DESC, iteration DESC
)
UPDATE products
SET is_latest = (id IN (SELECT id FROM latest_products));

-- Materials: Mark latest versions
WITH latest_materials AS (
  SELECT DISTINCT ON (material_code)
    id
  FROM materials
  ORDER BY material_code, version DESC, iteration DESC
)
UPDATE materials
SET is_latest = (id IN (SELECT id FROM latest_materials));

-- Suppliers: Mark latest versions
WITH latest_suppliers AS (
  SELECT DISTINCT ON (supplier_code)
    id
  FROM suppliers
  ORDER BY supplier_code, version DESC, iteration DESC
)
UPDATE suppliers
SET is_latest = (id IN (SELECT id FROM latest_suppliers));

-- =====================================================
-- 6. Create helper function to get latest version ID
-- =====================================================

CREATE OR REPLACE FUNCTION get_latest_version_id(
  p_table_name TEXT,
  p_code_field TEXT,
  p_code_value TEXT
)
RETURNS UUID AS $$
DECLARE
  v_id UUID;
  v_query TEXT;
BEGIN
  v_query := format(
    'SELECT id FROM %I WHERE %I = $1 AND is_latest = TRUE LIMIT 1',
    p_table_name,
    p_code_field
  );

  EXECUTE v_query INTO v_id USING p_code_value;

  RETURN v_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- 7. Add comments for documentation
-- =====================================================

COMMENT ON COLUMN products.is_latest IS 'Indicates if this is the current/latest version of the product. Only one version per style_code can be latest.';
COMMENT ON COLUMN products.version IS 'Major version letter (A-Z). Currently only A is used.';
COMMENT ON COLUMN products.iteration IS 'Minor version number. Increments with each update (A.1, A.2, A.3, etc.)';

COMMENT ON COLUMN materials.is_latest IS 'Indicates if this is the current/latest version of the material. Only one version per material_code can be latest.';
COMMENT ON COLUMN materials.version IS 'Major version letter (A-Z). Currently only A is used.';
COMMENT ON COLUMN materials.iteration IS 'Minor version number. Increments with each update (A.1, A.2, A.3, etc.)';

COMMENT ON COLUMN suppliers.is_latest IS 'Indicates if this is the current/latest version of the supplier. Only one version per supplier_code can be latest.';
COMMENT ON COLUMN suppliers.version IS 'Major version letter (A-Z). Currently only A is used.';
COMMENT ON COLUMN suppliers.iteration IS 'Minor version number. Increments with each update (A.1, A.2, A.3, etc.)';
