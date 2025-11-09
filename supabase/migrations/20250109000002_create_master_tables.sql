-- Migration: Create Master Tables for Version-Controlled Entities
-- Separates item identity (master) from version data (detail)

-- =====================================================
-- 1. Create Master Tables
-- =====================================================

-- Product Master: Unique style codes
CREATE TABLE IF NOT EXISTS product_master (
  style_code VARCHAR PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by TEXT NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Material Master: Unique material codes
CREATE TABLE IF NOT EXISTS material_master (
  material_code VARCHAR PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by TEXT NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Supplier Master: Unique supplier codes
CREATE TABLE IF NOT EXISTS supplier_master (
  supplier_code VARCHAR PRIMARY KEY,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by TEXT NOT NULL,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =====================================================
-- 2. Add Foreign Key Constraints
-- =====================================================

-- Products table: Reference product_master
ALTER TABLE products
  DROP CONSTRAINT IF EXISTS products_code_version_iteration_unique;

ALTER TABLE products
  ADD CONSTRAINT fk_products_master
  FOREIGN KEY (style_code)
  REFERENCES product_master(style_code)
  ON DELETE CASCADE;

-- Keep composite unique on (code, version, iteration)
ALTER TABLE products
  ADD CONSTRAINT products_code_version_iteration_unique
  UNIQUE (style_code, version, iteration);

-- Materials table: Reference material_master
ALTER TABLE materials
  DROP CONSTRAINT IF EXISTS materials_code_version_iteration_unique;

ALTER TABLE materials
  ADD CONSTRAINT fk_materials_master
  FOREIGN KEY (material_code)
  REFERENCES material_master(material_code)
  ON DELETE CASCADE;

ALTER TABLE materials
  ADD CONSTRAINT materials_code_version_iteration_unique
  UNIQUE (material_code, version, iteration);

-- Suppliers table: Reference supplier_master
ALTER TABLE suppliers
  DROP CONSTRAINT IF EXISTS suppliers_code_version_iteration_unique;

ALTER TABLE suppliers
  ADD CONSTRAINT fk_suppliers_master
  FOREIGN KEY (supplier_code)
  REFERENCES supplier_master(supplier_code)
  ON DELETE CASCADE;

ALTER TABLE suppliers
  ADD CONSTRAINT suppliers_code_version_iteration_unique
  UNIQUE (supplier_code, version, iteration);

-- =====================================================
-- 3. Migrate Existing Data to Master Tables
-- =====================================================

-- Product Master: Insert distinct style codes
INSERT INTO product_master (style_code, created_at, created_by)
SELECT DISTINCT ON (style_code)
  style_code,
  created_at,
  COALESCE(create_by, 'system') as created_by
FROM products
WHERE style_code IS NOT NULL
ORDER BY style_code, created_at ASC
ON CONFLICT (style_code) DO NOTHING;

-- Material Master: Insert distinct material codes
INSERT INTO material_master (material_code, created_at, created_by)
SELECT DISTINCT ON (material_code)
  material_code,
  created_at,
  COALESCE(create_by, 'system') as created_by
FROM materials
WHERE material_code IS NOT NULL
ORDER BY material_code, created_at ASC
ON CONFLICT (material_code) DO NOTHING;

-- Supplier Master: Insert distinct supplier codes
INSERT INTO supplier_master (supplier_code, created_at, created_by)
SELECT DISTINCT ON (supplier_code)
  supplier_code,
  created_at,
  COALESCE(create_by, 'system') as created_by
FROM suppliers
WHERE supplier_code IS NOT NULL
ORDER BY supplier_code, created_at ASC
ON CONFLICT (supplier_code) DO NOTHING;

-- =====================================================
-- 4. Create Indexes for Performance
-- =====================================================

-- Master tables indexes (already primary keys, but explicit for clarity)
CREATE INDEX IF NOT EXISTS idx_product_master_created_at
  ON product_master(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_material_master_created_at
  ON material_master(created_at DESC);

CREATE INDEX IF NOT EXISTS idx_supplier_master_created_at
  ON supplier_master(created_at DESC);

-- Detail tables: Index on code for JOIN performance
CREATE INDEX IF NOT EXISTS idx_products_style_code_latest
  ON products(style_code, is_latest) WHERE is_latest = TRUE;

CREATE INDEX IF NOT EXISTS idx_materials_code_latest
  ON materials(material_code, is_latest) WHERE is_latest = TRUE;

CREATE INDEX IF NOT EXISTS idx_suppliers_code_latest
  ON suppliers(supplier_code, is_latest) WHERE is_latest = TRUE;

-- =====================================================
-- 5. Create Views for Convenient Querying
-- =====================================================

-- View: Latest Products with Master info
CREATE OR REPLACE VIEW products_latest AS
SELECT
  p.*,
  pm.created_at as master_created_at,
  pm.created_by as master_created_by
FROM product_master pm
INNER JOIN products p ON pm.style_code = p.style_code
WHERE p.is_latest = TRUE;

-- View: Latest Materials with Master info
CREATE OR REPLACE VIEW materials_latest AS
SELECT
  m.*,
  mm.created_at as master_created_at,
  mm.created_by as master_created_by
FROM material_master mm
INNER JOIN materials m ON mm.material_code = m.material_code
WHERE m.is_latest = TRUE;

-- View: Latest Suppliers with Master info
CREATE OR REPLACE VIEW suppliers_latest AS
SELECT
  s.*,
  sm.created_at as master_created_at,
  sm.created_by as master_created_by
FROM supplier_master sm
INNER JOIN suppliers s ON sm.supplier_code = s.supplier_code
WHERE s.is_latest = TRUE;

-- =====================================================
-- 6. Enable Row Level Security (RLS)
-- =====================================================

-- Enable RLS on master tables
ALTER TABLE product_master ENABLE ROW LEVEL SECURITY;
ALTER TABLE material_master ENABLE ROW LEVEL SECURITY;
ALTER TABLE supplier_master ENABLE ROW LEVEL SECURITY;

-- Create policies (allow authenticated users to read/write)
-- Product Master
CREATE POLICY "Enable read access for authenticated users on product_master"
  ON product_master FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable insert for authenticated users on product_master"
  ON product_master FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Enable update for authenticated users on product_master"
  ON product_master FOR UPDATE
  TO authenticated
  USING (true);

-- Material Master
CREATE POLICY "Enable read access for authenticated users on material_master"
  ON material_master FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable insert for authenticated users on material_master"
  ON material_master FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Enable update for authenticated users on material_master"
  ON material_master FOR UPDATE
  TO authenticated
  USING (true);

-- Supplier Master
CREATE POLICY "Enable read access for authenticated users on supplier_master"
  ON supplier_master FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Enable insert for authenticated users on supplier_master"
  ON supplier_master FOR INSERT
  TO authenticated
  WITH CHECK (true);

CREATE POLICY "Enable update for authenticated users on supplier_master"
  ON supplier_master FOR UPDATE
  TO authenticated
  USING (true);

-- =====================================================
-- 7. Add Triggers to Update updated_at
-- =====================================================

-- Trigger function to update updated_at
CREATE OR REPLACE FUNCTION update_master_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Product Master trigger
DROP TRIGGER IF EXISTS set_product_master_updated_at ON product_master;
CREATE TRIGGER set_product_master_updated_at
  BEFORE UPDATE ON product_master
  FOR EACH ROW
  EXECUTE FUNCTION update_master_updated_at();

-- Material Master trigger
DROP TRIGGER IF EXISTS set_material_master_updated_at ON material_master;
CREATE TRIGGER set_material_master_updated_at
  BEFORE UPDATE ON material_master
  FOR EACH ROW
  EXECUTE FUNCTION update_master_updated_at();

-- Supplier Master trigger
DROP TRIGGER IF EXISTS set_supplier_master_updated_at ON supplier_master;
CREATE TRIGGER set_supplier_master_updated_at
  BEFORE UPDATE ON supplier_master
  FOR EACH ROW
  EXECUTE FUNCTION update_master_updated_at();

-- =====================================================
-- 8. Add Comments for Documentation
-- =====================================================

COMMENT ON TABLE product_master IS 'Master table for products. Each style_code appears exactly once. Contains item identity and creation metadata.';
COMMENT ON TABLE material_master IS 'Master table for materials. Each material_code appears exactly once. Contains item identity and creation metadata.';
COMMENT ON TABLE supplier_master IS 'Master table for suppliers. Each supplier_code appears exactly once. Contains item identity and creation metadata.';

COMMENT ON COLUMN product_master.style_code IS 'Unique product identifier. Primary key. Referenced by products table versions.';
COMMENT ON COLUMN material_master.material_code IS 'Unique material identifier. Primary key. Referenced by materials table versions.';
COMMENT ON COLUMN supplier_master.supplier_code IS 'Unique supplier identifier. Primary key. Referenced by suppliers table versions.';

COMMENT ON VIEW products_latest IS 'Convenient view joining product_master with latest version from products table.';
COMMENT ON VIEW materials_latest IS 'Convenient view joining material_master with latest version from materials table.';
COMMENT ON VIEW suppliers_latest IS 'Convenient view joining supplier_master with latest version from suppliers table.';
