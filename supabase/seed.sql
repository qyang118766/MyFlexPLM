-- FlexLite PLM Seed Data
-- 初始化基础数据和示例数据

-- =====================================================
-- 1. 实体类型节点（Type Tree）
-- =====================================================

-- Season 类型树
INSERT INTO entity_type_nodes (id, entity_type, parent_id, name, code) VALUES
  ('11111111-1111-1111-1111-111111111111', 'season', NULL, 'Season Types', 'SEASON_ROOT'),
  ('11111111-1111-1111-1111-111111111112', 'season', '11111111-1111-1111-1111-111111111111', 'Spring/Summer', 'SS'),
  ('11111111-1111-1111-1111-111111111113', 'season', '11111111-1111-1111-1111-111111111111', 'Fall/Winter', 'FW'),
  ('11111111-1111-1111-1111-111111111114', 'season', '11111111-1111-1111-1111-111111111111', 'Holiday', 'HOLIDAY');

-- Product 类型树
INSERT INTO entity_type_nodes (id, entity_type, parent_id, name, code) VALUES
  ('22222222-2222-2222-2222-222222222221', 'product', NULL, 'Product Types', 'PRODUCT_ROOT'),
  ('22222222-2222-2222-2222-222222222222', 'product', '22222222-2222-2222-2222-222222222221', 'Apparel', 'APPAREL'),
  ('22222222-2222-2222-2222-222222222223', 'product', '22222222-2222-2222-2222-222222222222', 'Mens', 'MENS'),
  ('22222222-2222-2222-2222-222222222224', 'product', '22222222-2222-2222-2222-222222222222', 'Womens', 'WOMENS'),
  ('22222222-2222-2222-2222-222222222225', 'product', '22222222-2222-2222-2222-222222222223', 'Tops', 'MENS_TOPS'),
  ('22222222-2222-2222-2222-222222222226', 'product', '22222222-2222-2222-2222-222222222223', 'Bottoms', 'MENS_BOTTOMS'),
  ('22222222-2222-2222-2222-222222222227', 'product', '22222222-2222-2222-2222-222222222224', 'Tops', 'WOMENS_TOPS'),
  ('22222222-2222-2222-2222-222222222228', 'product', '22222222-2222-2222-2222-222222222224', 'Bottoms', 'WOMENS_BOTTOMS'),
  ('22222222-2222-2222-2222-222222222229', 'product', '22222222-2222-2222-2222-222222222221', 'Accessories', 'ACCESSORIES');

-- Material 类型树
INSERT INTO entity_type_nodes (id, entity_type, parent_id, name, code) VALUES
  ('33333333-3333-3333-3333-333333333331', 'material', NULL, 'Material Types', 'MATERIAL_ROOT'),
  ('33333333-3333-3333-3333-333333333332', 'material', '33333333-3333-3333-3333-333333333331', 'Fabric', 'FABRIC'),
  ('33333333-3333-3333-3333-333333333333', 'material', '33333333-3333-3333-3333-333333333332', 'Cotton', 'COTTON'),
  ('33333333-3333-3333-3333-333333333334', 'material', '33333333-3333-3333-3333-333333333332', 'Polyester', 'POLYESTER'),
  ('33333333-3333-3333-3333-333333333335', 'material', '33333333-3333-3333-3333-333333333332', 'Wool', 'WOOL'),
  ('33333333-3333-3333-3333-333333333336', 'material', '33333333-3333-3333-3333-333333333331', 'Trim', 'TRIM'),
  ('33333333-3333-3333-3333-333333333337', 'material', '33333333-3333-3333-3333-333333333336', 'Zipper', 'ZIPPER'),
  ('33333333-3333-3333-3333-333333333338', 'material', '33333333-3333-3333-3333-333333333336', 'Button', 'BUTTON');

-- Supplier 类型树
INSERT INTO entity_type_nodes (id, entity_type, parent_id, name, code) VALUES
  ('44444444-4444-4444-4444-444444444441', 'supplier', NULL, 'Supplier Types', 'SUPPLIER_ROOT'),
  ('44444444-4444-4444-4444-444444444442', 'supplier', '44444444-4444-4444-4444-444444444441', 'Fabric Mill', 'FABRIC_MILL'),
  ('44444444-4444-4444-4444-444444444443', 'supplier', '44444444-4444-4444-4444-444444444441', 'Trim Supplier', 'TRIM_SUPPLIER'),
  ('44444444-4444-4444-4444-444444444444', 'supplier', '44444444-4444-4444-4444-444444444441', 'Factory', 'FACTORY');

-- Color 类型树
INSERT INTO entity_type_nodes (id, entity_type, parent_id, name, code) VALUES
  ('55555555-5555-5555-5555-555555555551', 'color', NULL, 'Color Types', 'COLOR_ROOT'),
  ('55555555-5555-5555-5555-555555555552', 'color', '55555555-5555-5555-5555-555555555551', 'Basic Colors', 'BASIC'),
  ('55555555-5555-5555-5555-555555555553', 'color', '55555555-5555-5555-5555-555555555551', 'Seasonal Colors', 'SEASONAL');

-- =====================================================
-- 2. 属性定义（Attribute Definitions）
-- =====================================================

-- Season 属性
INSERT INTO attribute_definitions (entity_type, key, label, data_type, required, order_index, is_active) VALUES
  ('season', 'description', 'Description', 'string', false, 1, true),
  ('season', 'start_date', 'Start Date', 'date', false, 2, true),
  ('season', 'end_date', 'End Date', 'date', false, 3, true);

-- Product 属性
INSERT INTO attribute_definitions (entity_type, key, label, data_type, required, order_index, options, is_active) VALUES
  ('product', 'brand', 'Brand', 'string', false, 1, NULL, true),
  ('product', 'description', 'Description', 'string', false, 2, NULL, true),
  ('product', 'target_price', 'Target Price ($)', 'number', false, 3, NULL, true),
  ('product', 'size_range', 'Size Range', 'enum', false, 4, '{"values": ["XS-XL", "S-XXL", "One Size"]}', true);

-- Material 属性
INSERT INTO attribute_definitions (entity_type, key, label, data_type, required, order_index, options, is_active) VALUES
  ('material', 'composition', 'Composition', 'string', false, 1, NULL, true),
  ('material', 'weight', 'Weight (g/m²)', 'number', false, 2, NULL, true),
  ('material', 'width', 'Width (cm)', 'number', false, 3, NULL, true),
  ('material', 'care_instructions', 'Care Instructions', 'string', false, 4, NULL, true);

-- Supplier 属性
INSERT INTO attribute_definitions (entity_type, key, label, data_type, required, order_index, is_active) VALUES
  ('supplier', 'contact_person', 'Contact Person', 'string', false, 1, true),
  ('supplier', 'email', 'Email', 'string', false, 2, true),
  ('supplier', 'phone', 'Phone', 'string', false, 3, true),
  ('supplier', 'address', 'Address', 'string', false, 4, true),
  ('supplier', 'payment_terms', 'Payment Terms', 'string', false, 5, true);

-- Color 属性
INSERT INTO attribute_definitions (entity_type, key, label, data_type, required, order_index, is_active) VALUES
  ('color', 'pantone_code', 'Pantone Code', 'string', false, 1, true),
  ('color', 'cmyk', 'CMYK', 'string', false, 2, true);

-- =====================================================
-- 3. 示例数据
-- =====================================================

-- 示例 Seasons
INSERT INTO seasons (code, name, year, status, type_id, attributes) VALUES
  ('SS25', 'Spring/Summer 2025', 2025, 'active', '11111111-1111-1111-1111-111111111112', '{"description": "Spring Summer 2025 Collection", "start_date": "2025-01-01", "end_date": "2025-06-30"}'),
  ('FW25', 'Fall/Winter 2025', 2025, 'planned', '11111111-1111-1111-1111-111111111113', '{"description": "Fall Winter 2025 Collection", "start_date": "2025-07-01", "end_date": "2025-12-31"}');

-- 示例 Colors
INSERT INTO colors (color_code, name, rgb_hex, status, type_id, attributes) VALUES
  ('BLK', 'Black', '#000000', 'active', '55555555-5555-5555-5555-555555555552', '{}'),
  ('WHT', 'White', '#FFFFFF', 'active', '55555555-5555-5555-5555-555555555552', '{}'),
  ('NVY', 'Navy', '#001F3F', 'active', '55555555-5555-5555-5555-555555555552', '{}'),
  ('GRY', 'Grey', '#808080', 'active', '55555555-5555-5555-5555-555555555552', '{}'),
  ('RED', 'Red', '#FF4136', 'active', '55555555-5555-5555-5555-555555555552', '{}');

-- 示例 Suppliers (Master + Detail with versioning)
INSERT INTO supplier_master (supplier_code, created_by) VALUES
  ('FAB001', 'system'),
  ('TRIM001', 'system'),
  ('FACT001', 'system');

INSERT INTO suppliers (supplier_code, name, region, status, type_id, attributes, version, iteration, is_latest, create_by, update_by) VALUES
  ('FAB001', 'Premium Fabrics Co.', 'Asia', 'active', '44444444-4444-4444-4444-444444444442', '{"contact_person": "John Doe", "email": "john@premiumfabrics.com"}', 'A', 1, true, 'system', 'system'),
  ('TRIM001', 'Global Trim Supply', 'Europe', 'active', '44444444-4444-4444-4444-444444444443', '{"contact_person": "Jane Smith", "email": "jane@globaltrim.com"}', 'A', 1, true, 'system', 'system'),
  ('FACT001', 'Quality Manufacturing Ltd.', 'Asia', 'active', '44444444-4444-4444-4444-444444444444', '{"contact_person": "Mike Chen", "email": "mike@qualitymfg.com"}', 'A', 1, true, 'system', 'system');

-- 示例 Materials (Master + Detail with versioning)
INSERT INTO material_master (material_code, created_by) VALUES
  ('COT-001', 'system'),
  ('POL-001', 'system'),
  ('ZIP-001', 'system'),
  ('BTN-001', 'system');

INSERT INTO materials (material_code, name, status, type_id, attributes, version, iteration, is_latest, create_by, update_by) VALUES
  ('COT-001', '100% Cotton Jersey', 'active', '33333333-3333-3333-3333-333333333333', '{"composition": "100% Cotton", "weight": 180, "width": 150}', 'A', 1, true, 'system', 'system'),
  ('POL-001', 'Polyester Performance', 'active', '33333333-3333-3333-3333-333333333334', '{"composition": "100% Polyester", "weight": 150, "width": 160}', 'A', 1, true, 'system', 'system'),
  ('ZIP-001', 'YKK Metal Zipper 5"', 'active', '33333333-3333-3333-3333-333333333337', '{}', 'A', 1, true, 'system', 'system'),
  ('BTN-001', 'Plastic Button 15mm', 'active', '33333333-3333-3333-3333-333333333338', '{}', 'A', 1, true, 'system', 'system');

-- 关联 Materials 和 Suppliers
INSERT INTO material_suppliers (material_id, supplier_id, price, currency) VALUES
  ((SELECT id FROM materials WHERE material_code = 'COT-001' AND is_latest = true), (SELECT id FROM suppliers WHERE supplier_code = 'FAB001' AND is_latest = true), 8.50, 'USD'),
  ((SELECT id FROM materials WHERE material_code = 'POL-001' AND is_latest = true), (SELECT id FROM suppliers WHERE supplier_code = 'FAB001' AND is_latest = true), 6.75, 'USD'),
  ((SELECT id FROM materials WHERE material_code = 'ZIP-001' AND is_latest = true), (SELECT id FROM suppliers WHERE supplier_code = 'TRIM001' AND is_latest = true), 1.20, 'USD'),
  ((SELECT id FROM materials WHERE material_code = 'BTN-001' AND is_latest = true), (SELECT id FROM suppliers WHERE supplier_code = 'TRIM001' AND is_latest = true), 0.15, 'USD');

-- 关联 Materials 和 Colors
INSERT INTO material_colors (material_id, color_id) VALUES
  ((SELECT id FROM materials WHERE material_code = 'COT-001' AND is_latest = true), (SELECT id FROM colors WHERE color_code = 'BLK')),
  ((SELECT id FROM materials WHERE material_code = 'COT-001' AND is_latest = true), (SELECT id FROM colors WHERE color_code = 'WHT')),
  ((SELECT id FROM materials WHERE material_code = 'COT-001' AND is_latest = true), (SELECT id FROM colors WHERE color_code = 'NVY')),
  ((SELECT id FROM materials WHERE material_code = 'POL-001' AND is_latest = true), (SELECT id FROM colors WHERE color_code = 'BLK')),
  ((SELECT id FROM materials WHERE material_code = 'POL-001' AND is_latest = true), (SELECT id FROM colors WHERE color_code = 'RED'));

-- 示例 Products (Master + Detail with versioning)
INSERT INTO product_master (style_code, created_by) VALUES
  ('MT-SS25-001', 'system'),
  ('WT-SS25-001', 'system');

INSERT INTO products (style_code, name, gender, status, season_id, type_id, attributes, version, iteration, is_latest, create_by, update_by) VALUES
  ('MT-SS25-001', 'Basic Cotton T-Shirt', 'Mens', 'development',
   (SELECT id FROM seasons WHERE code = 'SS25'),
   '22222222-2222-2222-2222-222222222225',
   '{"brand": "FlexLite", "description": "Classic crew neck t-shirt", "target_price": 29.99, "size_range": "S-XXL"}',
   'A', 1, true, 'system', 'system'),

  ('WT-SS25-001', 'Performance Tank Top', 'Womens', 'development',
   (SELECT id FROM seasons WHERE code = 'SS25'),
   '22222222-2222-2222-2222-222222222227',
   '{"brand": "FlexLite", "description": "Athletic tank with moisture wicking", "target_price": 34.99, "size_range": "XS-XL"}',
   'A', 1, true, 'system', 'system');

-- 示例 BOMs
INSERT INTO product_boms (product_id, name, status) VALUES
  ((SELECT id FROM products WHERE style_code = 'MT-SS25-001' AND is_latest = true), 'Default BOM', 'draft'),
  ((SELECT id FROM products WHERE style_code = 'WT-SS25-001' AND is_latest = true), 'Default BOM', 'draft');

-- 示例 BOM Items
INSERT INTO bom_items (bom_id, line_number, material_id, color_id, supplier_id, quantity, unit) VALUES
  (
    (SELECT id FROM product_boms WHERE product_id = (SELECT id FROM products WHERE style_code = 'MT-SS25-001' AND is_latest = true)),
    10,
    (SELECT id FROM materials WHERE material_code = 'COT-001' AND is_latest = true),
    (SELECT id FROM colors WHERE color_code = 'WHT'),
    (SELECT id FROM suppliers WHERE supplier_code = 'FAB001' AND is_latest = true),
    1.2,
    'yards'
  ),
  (
    (SELECT id FROM product_boms WHERE product_id = (SELECT id FROM products WHERE style_code = 'MT-SS25-001' AND is_latest = true)),
    20,
    (SELECT id FROM materials WHERE material_code = 'BTN-001' AND is_latest = true),
    NULL,
    (SELECT id FROM suppliers WHERE supplier_code = 'TRIM001' AND is_latest = true),
    4,
    'pieces'
  );

INSERT INTO bom_items (bom_id, line_number, material_id, color_id, supplier_id, quantity, unit) VALUES
  (
    (SELECT id FROM product_boms WHERE product_id = (SELECT id FROM products WHERE style_code = 'WT-SS25-001' AND is_latest = true)),
    10,
    (SELECT id FROM materials WHERE material_code = 'POL-001' AND is_latest = true),
    (SELECT id FROM colors WHERE color_code = 'BLK'),
    (SELECT id FROM suppliers WHERE supplier_code = 'FAB001' AND is_latest = true),
    0.9,
    'yards'
  );

-- =====================================================
-- 完成
-- =====================================================
