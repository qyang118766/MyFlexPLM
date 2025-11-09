-- FlexLite PLM Initial Schema Migration
-- 完整的数据库表结构定义

-- =====================================================
-- 1. 启用必要的扩展
-- =====================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- 2. 自定义枚举类型
-- =====================================================

-- 实体类型枚举
CREATE TYPE entity_type_enum AS ENUM (
  'season',
  'product',
  'material',
  'supplier',
  'color'
);

-- 属性数据类型枚举
CREATE TYPE attribute_data_type_enum AS ENUM (
  'string',
  'number',
  'boolean',
  'date',
  'enum'
);

-- Season 状态枚举
CREATE TYPE season_status_enum AS ENUM (
  'planned',
  'active',
  'archived'
);

-- Product 状态枚举
CREATE TYPE product_status_enum AS ENUM (
  'development',
  'pre-production',
  'production',
  'inactive'
);

-- Material 状态枚举
CREATE TYPE material_status_enum AS ENUM (
  'in_development',
  'active',
  'dropped',
  'rfq'
);

-- Supplier 状态枚举
CREATE TYPE supplier_status_enum AS ENUM (
  'active',
  'inactive'
);

-- Color 状态枚举
CREATE TYPE color_status_enum AS ENUM (
  'active',
  'inactive'
);

-- BOM 状态枚举
CREATE TYPE bom_status_enum AS ENUM (
  'draft',
  'active',
  'archived'
);

-- =====================================================
-- 3. Type Manager 相关表
-- =====================================================

-- 实体类型节点表（树形结构）
CREATE TABLE entity_type_nodes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  entity_type entity_type_enum NOT NULL,
  parent_id UUID REFERENCES entity_type_nodes(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  code VARCHAR(100),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 索引
CREATE INDEX idx_entity_type_nodes_entity_type ON entity_type_nodes(entity_type);
CREATE INDEX idx_entity_type_nodes_parent_id ON entity_type_nodes(parent_id);

-- 属性定义表
CREATE TABLE attribute_definitions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  entity_type entity_type_enum NOT NULL,
  key VARCHAR(100) NOT NULL,
  label VARCHAR(255) NOT NULL,
  data_type attribute_data_type_enum NOT NULL,
  required BOOLEAN NOT NULL DEFAULT FALSE,
  order_index INTEGER NOT NULL DEFAULT 0,
  options JSONB,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(entity_type, key)
);

-- 索引
CREATE INDEX idx_attribute_definitions_entity_type ON attribute_definitions(entity_type);
CREATE INDEX idx_attribute_definitions_is_active ON attribute_definitions(is_active);

-- =====================================================
-- 4. 用户表
-- =====================================================

-- 用户表（关联 Supabase Auth）
CREATE TABLE users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL UNIQUE,
  display_name VARCHAR(255),
  is_admin BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 索引
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_is_admin ON users(is_admin);

-- =====================================================
-- 5. 核心实体表
-- =====================================================

-- 5.1 Seasons（季度/季节表）
CREATE TABLE seasons (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  code VARCHAR(100) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  year INTEGER NOT NULL,
  status season_status_enum NOT NULL DEFAULT 'planned',
  type_id UUID REFERENCES entity_type_nodes(id) ON DELETE RESTRICT,
  attributes JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 索引
CREATE INDEX idx_seasons_code ON seasons(code);
CREATE INDEX idx_seasons_status ON seasons(status);
CREATE INDEX idx_seasons_type_id ON seasons(type_id);
CREATE INDEX idx_seasons_year ON seasons(year);

-- 5.2 Products（产品表）
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  style_code VARCHAR(100) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  gender VARCHAR(50),
  status product_status_enum NOT NULL DEFAULT 'development',
  season_id UUID REFERENCES seasons(id) ON DELETE SET NULL,
  type_id UUID REFERENCES entity_type_nodes(id) ON DELETE RESTRICT,
  attributes JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 索引
CREATE INDEX idx_products_style_code ON products(style_code);
CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_products_season_id ON products(season_id);
CREATE INDEX idx_products_type_id ON products(type_id);

-- 5.3 Materials（物料表）
CREATE TABLE materials (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  material_code VARCHAR(100) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  status material_status_enum NOT NULL DEFAULT 'in_development',
  type_id UUID REFERENCES entity_type_nodes(id) ON DELETE RESTRICT,
  attributes JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 索引
CREATE INDEX idx_materials_material_code ON materials(material_code);
CREATE INDEX idx_materials_status ON materials(status);
CREATE INDEX idx_materials_type_id ON materials(type_id);

-- 5.4 Suppliers（供应商表）
CREATE TABLE suppliers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  supplier_code VARCHAR(100) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  region VARCHAR(100),
  status supplier_status_enum NOT NULL DEFAULT 'active',
  type_id UUID REFERENCES entity_type_nodes(id) ON DELETE RESTRICT,
  attributes JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 索引
CREATE INDEX idx_suppliers_supplier_code ON suppliers(supplier_code);
CREATE INDEX idx_suppliers_status ON suppliers(status);
CREATE INDEX idx_suppliers_type_id ON suppliers(type_id);

-- 5.5 Colors（颜色表）
CREATE TABLE colors (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  color_code VARCHAR(100) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  rgb_hex VARCHAR(7),
  status color_status_enum NOT NULL DEFAULT 'active',
  type_id UUID REFERENCES entity_type_nodes(id) ON DELETE RESTRICT,
  attributes JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 索引
CREATE INDEX idx_colors_color_code ON colors(color_code);
CREATE INDEX idx_colors_status ON colors(status);
CREATE INDEX idx_colors_type_id ON colors(type_id);

-- =====================================================
-- 6. 关系表
-- =====================================================

-- 6.1 Material-Supplier 关联表（物料-供应商-价格）
CREATE TABLE material_suppliers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  material_id UUID NOT NULL REFERENCES materials(id) ON DELETE CASCADE,
  supplier_id UUID NOT NULL REFERENCES suppliers(id) ON DELETE CASCADE,
  price NUMERIC(12, 2),
  currency VARCHAR(10) DEFAULT 'USD',
  attributes JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(material_id, supplier_id)
);

-- 索引
CREATE INDEX idx_material_suppliers_material_id ON material_suppliers(material_id);
CREATE INDEX idx_material_suppliers_supplier_id ON material_suppliers(supplier_id);

-- 6.2 Material-Color 关联表（物料-颜色）
CREATE TABLE material_colors (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  material_id UUID NOT NULL REFERENCES materials(id) ON DELETE CASCADE,
  color_id UUID NOT NULL REFERENCES colors(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(material_id, color_id)
);

-- 索引
CREATE INDEX idx_material_colors_material_id ON material_colors(material_id);
CREATE INDEX idx_material_colors_color_id ON material_colors(color_id);

-- 6.3 Product BOM 表（产品物料清单）
CREATE TABLE product_boms (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  status bom_status_enum NOT NULL DEFAULT 'draft',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 索引
CREATE INDEX idx_product_boms_product_id ON product_boms(product_id);
CREATE INDEX idx_product_boms_status ON product_boms(status);

-- 6.4 BOM Items 表（BOM行项目 - 单层BOM）
CREATE TABLE bom_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  bom_id UUID NOT NULL REFERENCES product_boms(id) ON DELETE CASCADE,
  line_number INTEGER NOT NULL,
  material_id UUID NOT NULL REFERENCES materials(id) ON DELETE RESTRICT,
  color_id UUID REFERENCES colors(id) ON DELETE SET NULL,
  supplier_id UUID REFERENCES suppliers(id) ON DELETE SET NULL,
  quantity NUMERIC(12, 4) NOT NULL,
  unit VARCHAR(50) NOT NULL,
  attributes JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE(bom_id, line_number)
);

-- 索引
CREATE INDEX idx_bom_items_bom_id ON bom_items(bom_id);
CREATE INDEX idx_bom_items_material_id ON bom_items(material_id);
CREATE INDEX idx_bom_items_color_id ON bom_items(color_id);
CREATE INDEX idx_bom_items_supplier_id ON bom_items(supplier_id);

-- =====================================================
-- 7. 触发器：自动更新 updated_at 字段
-- =====================================================

-- 创建通用的更新时间戳函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 为所有需要的表创建触发器
CREATE TRIGGER update_entity_type_nodes_updated_at BEFORE UPDATE ON entity_type_nodes
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_attribute_definitions_updated_at BEFORE UPDATE ON attribute_definitions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_seasons_updated_at BEFORE UPDATE ON seasons
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_materials_updated_at BEFORE UPDATE ON materials
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_suppliers_updated_at BEFORE UPDATE ON suppliers
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_colors_updated_at BEFORE UPDATE ON colors
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_material_suppliers_updated_at BEFORE UPDATE ON material_suppliers
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_material_colors_updated_at BEFORE UPDATE ON material_colors
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_product_boms_updated_at BEFORE UPDATE ON product_boms
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_bom_items_updated_at BEFORE UPDATE ON bom_items
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- 8. Row Level Security (RLS) 策略
-- =====================================================

-- 启用所有表的 RLS
ALTER TABLE entity_type_nodes ENABLE ROW LEVEL SECURITY;
ALTER TABLE attribute_definitions ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE seasons ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE materials ENABLE ROW LEVEL SECURITY;
ALTER TABLE suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE colors ENABLE ROW LEVEL SECURITY;
ALTER TABLE material_suppliers ENABLE ROW LEVEL SECURITY;
ALTER TABLE material_colors ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_boms ENABLE ROW LEVEL SECURITY;
ALTER TABLE bom_items ENABLE ROW LEVEL SECURITY;

-- 为所有表创建基本的策略（MVP: 所有已认证用户可以访问）
-- 在未来可以基于 users.is_admin 或其他角色来细化权限

-- Entity Type Nodes
CREATE POLICY "Authenticated users can view entity_type_nodes" ON entity_type_nodes
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can insert entity_type_nodes" ON entity_type_nodes
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update entity_type_nodes" ON entity_type_nodes
  FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete entity_type_nodes" ON entity_type_nodes
  FOR DELETE USING (auth.role() = 'authenticated');

-- Attribute Definitions
CREATE POLICY "Authenticated users can view attribute_definitions" ON attribute_definitions
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can insert attribute_definitions" ON attribute_definitions
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update attribute_definitions" ON attribute_definitions
  FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete attribute_definitions" ON attribute_definitions
  FOR DELETE USING (auth.role() = 'authenticated');

-- Users
CREATE POLICY "Authenticated users can view users" ON users
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can insert users" ON users
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update users" ON users
  FOR UPDATE USING (auth.role() = 'authenticated');

-- Seasons
CREATE POLICY "Authenticated users can view seasons" ON seasons
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can insert seasons" ON seasons
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update seasons" ON seasons
  FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete seasons" ON seasons
  FOR DELETE USING (auth.role() = 'authenticated');

-- Products
CREATE POLICY "Authenticated users can view products" ON products
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can insert products" ON products
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update products" ON products
  FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete products" ON products
  FOR DELETE USING (auth.role() = 'authenticated');

-- Materials
CREATE POLICY "Authenticated users can view materials" ON materials
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can insert materials" ON materials
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update materials" ON materials
  FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete materials" ON materials
  FOR DELETE USING (auth.role() = 'authenticated');

-- Suppliers
CREATE POLICY "Authenticated users can view suppliers" ON suppliers
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can insert suppliers" ON suppliers
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update suppliers" ON suppliers
  FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete suppliers" ON suppliers
  FOR DELETE USING (auth.role() = 'authenticated');

-- Colors
CREATE POLICY "Authenticated users can view colors" ON colors
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can insert colors" ON colors
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update colors" ON colors
  FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete colors" ON colors
  FOR DELETE USING (auth.role() = 'authenticated');

-- Material Suppliers
CREATE POLICY "Authenticated users can view material_suppliers" ON material_suppliers
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can insert material_suppliers" ON material_suppliers
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update material_suppliers" ON material_suppliers
  FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete material_suppliers" ON material_suppliers
  FOR DELETE USING (auth.role() = 'authenticated');

-- Material Colors
CREATE POLICY "Authenticated users can view material_colors" ON material_colors
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can insert material_colors" ON material_colors
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update material_colors" ON material_colors
  FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete material_colors" ON material_colors
  FOR DELETE USING (auth.role() = 'authenticated');

-- Product BOMs
CREATE POLICY "Authenticated users can view product_boms" ON product_boms
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can insert product_boms" ON product_boms
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update product_boms" ON product_boms
  FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete product_boms" ON product_boms
  FOR DELETE USING (auth.role() = 'authenticated');

-- BOM Items
CREATE POLICY "Authenticated users can view bom_items" ON bom_items
  FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can insert bom_items" ON bom_items
  FOR INSERT WITH CHECK (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can update bom_items" ON bom_items
  FOR UPDATE USING (auth.role() = 'authenticated');
CREATE POLICY "Authenticated users can delete bom_items" ON bom_items
  FOR DELETE USING (auth.role() = 'authenticated');

-- =====================================================
-- 完成
-- =====================================================
