-- FlexLite PLM Enums Table Migration
-- 创建枚举管理表，用于动态管理系统枚举值

-- =====================================================
-- 1. 创建 enums 表
-- =====================================================
CREATE TABLE enums (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  enum_type VARCHAR(50) NOT NULL,           -- 枚举类型，如 'season_status', 'product_status'
  enum_value VARCHAR(100) NOT NULL,         -- 枚举值
  label VARCHAR(255) NOT NULL,              -- 显示标签（用于UI）
  order_index INTEGER NOT NULL DEFAULT 0,   -- 排序顺序
  is_active BOOLEAN NOT NULL DEFAULT TRUE,  -- 是否启用
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

  -- 确保同一类型的枚举值唯一
  UNIQUE(enum_type, enum_value)
);

-- 索引
CREATE INDEX idx_enums_enum_type ON enums(enum_type);
CREATE INDEX idx_enums_is_active ON enums(is_active);

-- =====================================================
-- 2. 从 PostgreSQL ENUM 类型初始化数据
-- =====================================================

-- Season Status
INSERT INTO enums (enum_type, enum_value, label, order_index) VALUES
  ('season_status', 'planned', 'Planned', 1),
  ('season_status', 'active', 'Active', 2),
  ('season_status', 'archived', 'Archived', 3);

-- Product Status
INSERT INTO enums (enum_type, enum_value, label, order_index) VALUES
  ('product_status', 'development', 'Development', 1),
  ('product_status', 'pre-production', 'Pre-Production', 2),
  ('product_status', 'production', 'Production', 3),
  ('product_status', 'inactive', 'Inactive', 4);

-- Product Gender
INSERT INTO enums (enum_type, enum_value, label, order_index) VALUES
  ('product_gender', 'unisex', 'Unisex', 1),
  ('product_gender', 'women', 'Women', 2),
  ('product_gender', 'men', 'Men', 3),
  ('product_gender', 'kids', 'Kids', 4);

-- Material Status
INSERT INTO enums (enum_type, enum_value, label, order_index) VALUES
  ('material_status', 'in_development', 'In Development', 1),
  ('material_status', 'active', 'Active', 2),
  ('material_status', 'dropped', 'Dropped', 3),
  ('material_status', 'rfq', 'RFQ', 4);

-- Supplier Status
INSERT INTO enums (enum_type, enum_value, label, order_index) VALUES
  ('supplier_status', 'active', 'Active', 1),
  ('supplier_status', 'inactive', 'Inactive', 2);

-- Color Status
INSERT INTO enums (enum_type, enum_value, label, order_index) VALUES
  ('color_status', 'active', 'Active', 1),
  ('color_status', 'inactive', 'Inactive', 2);

-- BOM Status
INSERT INTO enums (enum_type, enum_value, label, order_index) VALUES
  ('bom_status', 'draft', 'Draft', 1),
  ('bom_status', 'active', 'Active', 2),
  ('bom_status', 'archived', 'Archived', 3);

-- =====================================================
-- 3. 更新触发器（自动更新 updated_at）
-- =====================================================
CREATE OR REPLACE FUNCTION update_enums_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_enums_updated_at
  BEFORE UPDATE ON enums
  FOR EACH ROW
  EXECUTE FUNCTION update_enums_updated_at();

-- =====================================================
-- 4. RLS (Row Level Security) 策略
-- =====================================================
ALTER TABLE enums ENABLE ROW LEVEL SECURITY;

-- 所有用户可以读取枚举
CREATE POLICY "枚举表所有用户可读"
  ON enums FOR SELECT
  TO authenticated
  USING (true);

-- 只有管理员可以修改枚举
CREATE POLICY "枚举表仅管理员可修改"
  ON enums FOR ALL
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM users
      WHERE users.id = auth.uid()
      AND users.is_admin = TRUE
    )
  );

-- =====================================================
-- 5. 辅助函数：获取枚举值列表
-- =====================================================
CREATE OR REPLACE FUNCTION get_enum_values(p_enum_type VARCHAR)
RETURNS TABLE(enum_value VARCHAR, label VARCHAR) AS $$
BEGIN
  RETURN QUERY
  SELECT e.enum_value, e.label
  FROM enums e
  WHERE e.enum_type = p_enum_type
    AND e.is_active = TRUE
  ORDER BY e.order_index, e.enum_value;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON TABLE enums IS '系统枚举值管理表，用于动态管理各种状态和选项';
COMMENT ON FUNCTION get_enum_values IS '获取指定类型的所有活跃枚举值';
