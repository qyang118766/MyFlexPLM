-- Add create_by and update_by columns to all core entity tables

ALTER TABLE products
  ADD COLUMN IF NOT EXISTS create_by TEXT,
  ADD COLUMN IF NOT EXISTS update_by TEXT;

ALTER TABLE materials
  ADD COLUMN IF NOT EXISTS create_by TEXT,
  ADD COLUMN IF NOT EXISTS update_by TEXT;

ALTER TABLE suppliers
  ADD COLUMN IF NOT EXISTS create_by TEXT,
  ADD COLUMN IF NOT EXISTS update_by TEXT;

ALTER TABLE seasons
  ADD COLUMN IF NOT EXISTS create_by TEXT,
  ADD COLUMN IF NOT EXISTS update_by TEXT;

ALTER TABLE colors
  ADD COLUMN IF NOT EXISTS create_by TEXT,
  ADD COLUMN IF NOT EXISTS update_by TEXT;
