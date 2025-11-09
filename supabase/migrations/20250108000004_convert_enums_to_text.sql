-- 将所有实体表的 status 字段从 ENUM 类型改为 TEXT
-- 这样就完全依赖 enums 表管理枚举值，实现真正的动态枚举

-- =====================================================
-- 1. Seasons 表
-- =====================================================
-- 修改 status 字段为 TEXT
ALTER TABLE seasons
  ALTER COLUMN status TYPE TEXT;

-- 添加注释
COMMENT ON COLUMN seasons.status IS 'Status of the season. Valid values are managed in the enums table (enum_type=season_status)';

-- =====================================================
-- 2. Products 表
-- =====================================================
-- 修改 status 字段为 TEXT
ALTER TABLE products
  ALTER COLUMN status TYPE TEXT;

-- 修改 gender 字段为 TEXT
ALTER TABLE products
  ALTER COLUMN gender TYPE TEXT;

-- 添加注释
COMMENT ON COLUMN products.status IS 'Status of the product. Valid values are managed in the enums table (enum_type=product_status)';
COMMENT ON COLUMN products.gender IS 'Gender category. Valid values are managed in the enums table (enum_type=product_gender)';

-- =====================================================
-- 3. Materials 表
-- =====================================================
-- 修改 status 字段为 TEXT
ALTER TABLE materials
  ALTER COLUMN status TYPE TEXT;

COMMENT ON COLUMN materials.status IS 'Status of the material. Valid values are managed in the enums table (enum_type=material_status)';

-- =====================================================
-- 4. Suppliers 表
-- =====================================================
-- 修改 status 字段为 TEXT
ALTER TABLE suppliers
  ALTER COLUMN status TYPE TEXT;

COMMENT ON COLUMN suppliers.status IS 'Status of the supplier. Valid values are managed in the enums table (enum_type=supplier_status)';

-- =====================================================
-- 5. Colors 表
-- =====================================================
-- 修改 status 字段为 TEXT
ALTER TABLE colors
  ALTER COLUMN status TYPE TEXT;

COMMENT ON COLUMN colors.status IS 'Status of the color. Valid values are managed in the enums table (enum_type=color_status)';

-- =====================================================
-- 6. Product BOMs 表
-- =====================================================
-- 修改 status 字段为 TEXT
ALTER TABLE product_boms
  ALTER COLUMN status TYPE TEXT;

COMMENT ON COLUMN product_boms.status IS 'Status of the BOM. Valid values are managed in the enums table (enum_type=bom_status)';

-- =====================================================
-- 注意事项
-- =====================================================
-- 1. PostgreSQL ENUM 类型仍然存在，但不再被使用
-- 2. 如需删除这些 ENUM 类型，需要确保没有其他依赖
-- 3. 应用层（Server Actions）会继续验证枚举值的有效性
-- 4. 现在可以通过 enums 表的 UI 完全管理所有枚举值，无需 SQL 迁移

-- =====================================================
-- 可选：删除未使用的 ENUM 类型（谨慎操作）
-- =====================================================
-- 以下语句被注释，如果确认没有其他依赖可以取消注释执行
-- DROP TYPE IF EXISTS season_status_enum;
-- DROP TYPE IF EXISTS product_status_enum;
-- DROP TYPE IF EXISTS material_status_enum;
-- DROP TYPE IF EXISTS supplier_status_enum;
-- DROP TYPE IF EXISTS color_status_enum;
-- DROP TYPE IF EXISTS bom_status_enum;
