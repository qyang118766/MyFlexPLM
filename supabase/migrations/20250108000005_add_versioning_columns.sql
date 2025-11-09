-- Add versioning columns to products, materials, and suppliers tables

ALTER TABLE products
  ADD COLUMN IF NOT EXISTS version CHAR(1) NOT NULL DEFAULT 'A',
  ADD COLUMN IF NOT EXISTS iteration SMALLINT NOT NULL DEFAULT 1;

ALTER TABLE products
  ADD CONSTRAINT products_version_check CHECK (version ~ '^[A-Z]$'),
  ADD CONSTRAINT products_iteration_check CHECK (iteration BETWEEN 1 AND 999);


ALTER TABLE materials
  ADD COLUMN IF NOT EXISTS version CHAR(1) NOT NULL DEFAULT 'A',
  ADD COLUMN IF NOT EXISTS iteration SMALLINT NOT NULL DEFAULT 1;

ALTER TABLE materials
  ADD CONSTRAINT materials_version_check CHECK (version ~ '^[A-Z]$'),
  ADD CONSTRAINT materials_iteration_check CHECK (iteration BETWEEN 1 AND 999);


ALTER TABLE suppliers
  ADD COLUMN IF NOT EXISTS version CHAR(1) NOT NULL DEFAULT 'A',
  ADD COLUMN IF NOT EXISTS iteration SMALLINT NOT NULL DEFAULT 1;

ALTER TABLE suppliers
  ADD CONSTRAINT suppliers_version_check CHECK (version ~ '^[A-Z]$'),
  ADD CONSTRAINT suppliers_iteration_check CHECK (iteration BETWEEN 1 AND 999);
