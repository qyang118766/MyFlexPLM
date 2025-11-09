# Version Control System Refactoring

## Overview

This document describes the refactoring of the version control system in FlexLite PLM from inline version management code to a centralized, reusable module.

## Changes Summary

### 1. **Centralized Version Control Module**

Created `app/lib/services/versionControl.js` - a centralized module that handles all version control operations for versioned entities (Products, Materials, and Suppliers).

**Key Functions:**

- `initializeVersion()` - Initialize version for new entities (A.1)
- `executeVersionedUpdate()` - Create new version on update
- `getLatestVersion()` - Retrieve the latest version of an entity
- `getVersionHistory()` - Get all versions of an entity
- `markAsLatestVersion()` - Manually mark a specific version as latest
- `formatVersion()` - Format version for display

### 2. **Database Schema Changes**

**Migration:** `supabase/migrations/20250109000001_refactor_version_control.sql`

#### Added `is_latest` Column

Added `is_latest` boolean field to version-controlled entities:
- `products.is_latest`
- `materials.is_latest`
- `suppliers.is_latest`

This field marks which version is the current/active version of each item.

#### Removed UNIQUE Constraints on Code Fields

Since version control creates multiple rows for the same item code, the UNIQUE constraint on code fields was removed:
- ~~`products.style_code UNIQUE`~~ → Removed
- ~~`materials.material_code UNIQUE`~~ → Removed
- ~~`suppliers.supplier_code UNIQUE`~~ → Removed

#### Added Composite UNIQUE Constraints

To maintain data integrity, added composite UNIQUE constraints on `(code, version, iteration)`:
- `products(style_code, version, iteration)` UNIQUE
- `materials(material_code, version, iteration)` UNIQUE
- `suppliers(supplier_code, version, iteration)` UNIQUE

This ensures no duplicate version numbers for the same item.

#### Added UNIQUE Index for Latest Versions

Created partial unique indexes to ensure only ONE version can be marked as latest per item:
- `products(style_code) WHERE is_latest = TRUE` UNIQUE
- `materials(material_code) WHERE is_latest = TRUE` UNIQUE
- `suppliers(supplier_code) WHERE is_latest = TRUE` UNIQUE

#### Performance Indexes

Added indexes for efficient latest version queries:
- `idx_products_latest ON products(style_code, is_latest) WHERE is_latest = TRUE`
- `idx_materials_latest ON materials(material_code, is_latest) WHERE is_latest = TRUE`
- `idx_suppliers_latest ON suppliers(supplier_code, is_latest) WHERE is_latest = TRUE`

### 3. **Updated Server Actions**

Refactored three server action files to use the version control module:

#### Products (`app/lib/actions/products.js`)

**Before:**
```javascript
// Create: Manual version initialization
const payload = {
  ...fields,
  version: 'A',
  iteration: 1,
};

// Update: Manual version increment
const payload = {
  ...fields,
  version: previousVersion.version || 'A',
  iteration: (previousVersion.iteration || 0) + 1,
};
await supabase.from('products').insert(payload);
```

**After:**
```javascript
import { initializeVersion, executeVersionedUpdate } from '@/lib/services/versionControl';

// Create: Use module
const versionFields = initializeVersion();
const payload = {
  ...fields,
  ...versionFields,
};

// Update: Use module
const result = await executeVersionedUpdate('products', styleCode, payload, userIdentifier);
```

#### Materials (`app/lib/actions/materials.js`)

Same refactoring pattern as products.

#### Suppliers (`app/lib/actions/suppliers.js`)

Same refactoring pattern as products.

### 4. **Updated List Pages**

Modified list pages to only display the latest versions:

#### Products List (`app/app/products/page.js`)
```javascript
// Added filter for latest versions
const { data: products } = await supabase
  .from('products')
  .select('...')
  .eq('is_latest', true)  // ← Added
  .order('created_at', { ascending: false });
```

#### Materials List (`app/app/materials/page.js`)
```javascript
const { data: materials } = await supabase
  .from('materials')
  .select('*')
  .eq('is_latest', true)  // ← Added
  .order('created_at', { ascending: false });
```

#### Suppliers List (`app/app/suppliers/page.js`)
```javascript
const { data: suppliers } = await supabase
  .from('suppliers')
  .select('*')
  .eq('is_latest', true)  // ← Added
  .order('created_at', { ascending: false });
```

### 5. **Non-Versioned Entities**

**Seasons** and **Colors** remain NON-versioned:
- No `version` or `iteration` fields
- No `is_latest` field
- Updates modify existing records (UPDATE operation)
- Only have audit fields: `create_by`, `update_by`

This matches the user requirement: "对于season和color不再进行版本管理，对应数据库字段也可以删除"

## Versioning Strategy

### How It Works

1. **Create Operation:**
   - New item created with version A.1
   - `is_latest` set to `true`
   - Single record exists

2. **Update Operation:**
   - Current version's `is_latest` set to `false`
   - New record inserted with:
     - Same code (style_code/material_code/supplier_code)
     - Same version letter (A)
     - Incremented iteration (e.g., A.2 → A.3)
     - `is_latest` set to `true`
   - Preserves original `create_by`, updates `update_by`

3. **Query for Latest:**
   - Always filter by `is_latest = true`
   - Returns single record per item

4. **Query Version History:**
   - Filter by code field
   - Order by version DESC, iteration DESC
   - Returns all versions of an item

### Version Format

**Format:** `{MajorVersion}.{Iteration}`

- **MajorVersion:** Single letter A-Z (currently only 'A' used)
- **Iteration:** Number starting from 1, increments with each update
- **Examples:** A.1, A.2, A.3, A.4, etc.

**Future:** Major version letters (B, C, etc.) can be implemented when needed for major releases.

## Benefits of Refactoring

### 1. **Code Reusability**
- Version logic defined once, used by all entities
- Consistent behavior across Products, Materials, Suppliers

### 2. **Maintainability**
- Single source of truth for version control logic
- Easy to modify version behavior (e.g., add B, C versions)
- Centralized testing and debugging

### 3. **Data Integrity**
- Database constraints enforce version uniqueness
- Impossible to have multiple "latest" versions
- Audit trail preserved automatically

### 4. **Performance**
- Indexed queries for latest versions
- Efficient filtering using partial indexes
- No need to scan all versions to find latest

### 5. **Extensibility**
- Easy to add new versioned entities
- Version history queries available out of the box
- Can implement version comparison features

## Migration Steps

### 1. Run Database Migration

```bash
# The migration will:
# - Add is_latest column
# - Remove UNIQUE constraints on code fields
# - Add composite UNIQUE constraints
# - Create indexes
# - Mark existing latest versions
```

### 2. Deploy Code Changes

All code changes are backward compatible. The new `is_latest` field is added with a default value of `true`, so existing queries will continue to work.

### 3. Verify System

After deployment:
- Test creating new products/materials/suppliers
- Test updating existing items
- Verify version increments correctly
- Check that lists show only latest versions

## Future Enhancements

### 1. **Version History UI**
Create pages to view all versions of an item:
- Timeline view of changes
- Diff between versions
- Restore previous version

### 2. **Major Version Increments**
Implement logic for incrementing major versions (A→B→C):
- Manual major version increment by admin
- Auto-increment on specific events
- Version release workflow

### 3. **Version Comparison**
Add ability to compare two versions:
- Side-by-side field comparison
- Highlight changed fields
- Show audit trail (who changed what)

### 4. **Version Rollback**
Allow reverting to a previous version:
- Select old version
- Create new version with old data
- Preserve complete audit trail

## API Reference

### `initializeVersion()`

Initialize version fields for a new entity.

**Returns:**
```javascript
{
  version: 'A',
  iteration: 1,
  is_latest: true
}
```

**Usage:**
```javascript
const versionFields = initializeVersion();
const payload = { ...data, ...versionFields };
```

---

### `executeVersionedUpdate(entityType, code, payload, userId)`

Execute a versioned update operation.

**Parameters:**
- `entityType` (string): 'products' | 'materials' | 'suppliers'
- `code` (string): The item code (style_code, material_code, supplier_code)
- `payload` (object): Data for the new version (excluding version fields)
- `userId` (string): User identifier for audit

**Returns:**
```javascript
{
  success: boolean,
  data: object,        // New version record
  previousVersion: object,  // Old version record
  error: string        // Error message if failed
}
```

**Example:**
```javascript
const result = await executeVersionedUpdate(
  'products',
  'FLEX-001',
  { name: 'Updated Name', status: 'production' },
  'user@example.com'
);

if (result.success) {
  console.log('New version:', result.data);
  console.log('Previous version:', result.previousVersion);
}
```

---

### `getLatestVersion(entityType, code)`

Get the latest version of an item.

**Parameters:**
- `entityType` (string): 'products' | 'materials' | 'suppliers'
- `code` (string): The item code

**Returns:** Promise<object | null>

**Example:**
```javascript
const latestProduct = await getLatestVersion('products', 'FLEX-001');
console.log('Current version:', formatVersion(latestProduct.version, latestProduct.iteration));
```

---

### `getVersionHistory(entityType, code)`

Get all versions of an item.

**Parameters:**
- `entityType` (string): 'products' | 'materials' | 'suppliers'
- `code` (string): The item code

**Returns:** Promise<array>

**Example:**
```javascript
const history = await getVersionHistory('products', 'FLEX-001');
history.forEach(version => {
  console.log(`${formatVersion(version.version, version.iteration)} - ${version.updated_at}`);
});
```

---

### `formatVersion(version, iteration)`

Format version and iteration as a display string.

**Parameters:**
- `version` (string): Major version letter (A-Z)
- `iteration` (number): Iteration number

**Returns:** string

**Example:**
```javascript
formatVersion('A', 3);  // Returns: "A.3"
formatVersion('B', 1);  // Returns: "B.1"
```

## Database Schema Reference

### Products Table (Versioned)

```sql
CREATE TABLE products (
  id UUID PRIMARY KEY,
  style_code VARCHAR NOT NULL,
  name VARCHAR NOT NULL,
  gender VARCHAR,
  status VARCHAR,
  season_id UUID,
  type_id UUID,
  attributes JSONB,

  -- Version control fields
  version CHAR(1) NOT NULL DEFAULT 'A',
  iteration SMALLINT NOT NULL DEFAULT 1,
  is_latest BOOLEAN NOT NULL DEFAULT TRUE,

  -- Audit fields
  create_by TEXT,
  update_by TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  -- Constraints
  CONSTRAINT products_code_version_iteration_unique
    UNIQUE (style_code, version, iteration)
);

-- Only one latest version per style_code
CREATE UNIQUE INDEX idx_products_one_latest_per_code
  ON products(style_code) WHERE is_latest = TRUE;
```

### Materials Table (Versioned)

Same structure as products, with `material_code` instead of `style_code`.

### Suppliers Table (Versioned)

Same structure as products, with `supplier_code` instead of `style_code`, plus `region` field.

### Seasons Table (NOT Versioned)

```sql
CREATE TABLE seasons (
  id UUID PRIMARY KEY,
  code VARCHAR UNIQUE NOT NULL,
  name VARCHAR NOT NULL,
  year INTEGER,
  status VARCHAR,
  type_id UUID,
  attributes JSONB,

  -- Audit fields only (no versioning)
  create_by TEXT,
  update_by TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Colors Table (NOT Versioned)

Same as seasons - no version fields, only audit fields.

---

**Date:** 2025-01-09
**Status:** ✅ Implementation Complete
**Entities Refactored:** Products, Materials, Suppliers
**Migration:** 20250109000001_refactor_version_control.sql
