# Attribute Scope Fix

## Issue Description

When defining an attribute scoped to a specific type node (e.g., "Minimum Age" for Product Types > Apparel > Kids), the attribute was incorrectly visible to:
- Parent nodes (Apparel, Product root)
- Sibling nodes (Womens, Mens)
- All other nodes in the hierarchy

This violated the expected scoping behavior where attributes should only be visible to the node they're defined on and its descendants (children, grandchildren, etc.).

## Root Cause

All create and edit pages for Products, Materials, and Suppliers were directly querying the `attribute_definitions` table without considering the `type_node_id` scope:

```javascript
// INCORRECT - shows all attributes
await supabase
  .from('attribute_definitions')
  .select('*')
  .eq('entity_type', 'product')
  .eq('is_active', true)
```

This query returns all attributes for the entity type, regardless of their scope.

## Solution

### 1. Created Attribute Filtering Service

**File:** `app/lib/services/attributeFiltering.js`

This service provides functions to properly filter attributes based on type hierarchy:

**Key Function:** `getVisibleAttributes(supabase, entityType, typeNodeId)`

Logic:
1. Get the complete ancestry path from root to the current node
2. Query attributes where:
   - `type_node_id` IS NULL (global attributes), OR
   - `type_node_id` IN (ancestor path)

**Helper Functions:**
- `getAncestorPath()` - Walks up the tree to build the full ancestry path
- `isAncestorOf()` - Checks if one node is an ancestor of another

### 2. Updated All Form Pages

Updated 8 files to use the new filtering service:

**Products:**
- `app/app/products/create/page.js`
- `app/app/products/edit/page.js`

**Materials:**
- `app/app/materials/create/page.js`
- `app/app/materials/edit/page.js`

**Suppliers:**
- `app/app/suppliers/create/page.js`
- `app/app/suppliers/edit/page.js`

**Changes made:**
1. Added import: `import { getVisibleAttributes } from '@/lib/services/attributeFiltering';`
2. Replaced direct database query with: `const attributeDefs = await getVisibleAttributes(supabase, 'product', typeId);`

## How It Works

### Example Hierarchy

```
Product (root)
└─ Apparel
   ├─ Womens
   │  └─ Tops
   ├─ Mens
   └─ Kids
```

### Example Attribute Definitions

1. **Brand** (Global) - `type_node_id = NULL`
2. **Fabric Type** - Scoped to `Apparel`
3. **Minimum Age** - Scoped to `Kids`
4. **Size Range** - Scoped to `Womens`

### Visibility Matrix

| Type Node | Visible Attributes |
|-----------|-------------------|
| Product (root) | Brand (global only) |
| Apparel | Brand, Fabric Type |
| Womens | Brand, Fabric Type, Size Range |
| Tops | Brand, Fabric Type, Size Range |
| Mens | Brand, Fabric Type |
| Kids | Brand, Fabric Type, Minimum Age |

### Query Logic for "Kids" Node

When loading the form for a product with `type_id = Kids`:

1. **Get Ancestor Path:**
   - Start at Kids
   - Walk up: Kids → Apparel → Product (root)
   - Result: `[product_root_id, apparel_id, kids_id]`

2. **Query Attributes:**
   ```sql
   SELECT * FROM attribute_definitions
   WHERE entity_type = 'product'
     AND is_active = true
     AND (
       type_node_id IS NULL  -- Global attributes
       OR type_node_id IN (product_root_id, apparel_id, kids_id)
     )
   ORDER BY order_index, created_at
   ```

3. **Result:**
   - Brand (global)
   - Fabric Type (defined on Apparel, which is an ancestor)
   - Minimum Age (defined on Kids itself)

4. **NOT included:**
   - Size Range (defined on Womens, which is a sibling)

## Inheritance vs Scoping

This implementation uses **downward inheritance** (attributes flow down from parent to children):

- If an attribute is defined on node X, it's visible to X and all descendants of X
- Attributes do NOT flow upward to parents
- Attributes do NOT flow sideways to siblings

This is the opposite of the database function `get_type_node_attributes()` which was initially created for **upward inheritance**. That function is still available but is not used by forms.

## Testing

### Test Case 1: Kids-Scoped Attribute

1. Create attribute "Minimum Age" scoped to Product > Apparel > Kids
2. Create product with type = Kids
   - ✅ Should see: Brand, Fabric Type, Minimum Age
3. Create product with type = Womens
   - ✅ Should see: Brand, Fabric Type, Size Range
   - ❌ Should NOT see: Minimum Age

### Test Case 2: Global Attribute

1. Create attribute "Brand" with no scope (global)
2. Create products with any type
   - ✅ Should see: Brand (always visible)

### Test Case 3: Parent-Scoped Attribute

1. Create attribute "Fabric Type" scoped to Product > Apparel
2. Create product with type = Apparel
   - ✅ Should see: Brand, Fabric Type
3. Create product with type = Kids (child of Apparel)
   - ✅ Should see: Brand, Fabric Type, Minimum Age
4. Create product with type = Product (parent of Apparel)
   - ❌ Should NOT see: Fabric Type

## Database Backup

A backup was created before making changes:
- **File:** `backups/backup_20251109_121301.sql`
- **Size:** 380KB

## Files Changed

1. **New File:**
   - `app/lib/services/attributeFiltering.js` (new filtering service)

2. **Updated Files:**
   - `app/app/products/create/page.js`
   - `app/app/products/edit/page.js`
   - `app/app/materials/create/page.js`
   - `app/app/materials/edit/page.js`
   - `app/app/suppliers/create/page.js`
   - `app/app/suppliers/edit/page.js`

## Performance Considerations

The `getAncestorPath()` function walks up the tree recursively, making one database query per level. For a deep hierarchy (e.g., 10 levels), this could result in 10 sequential queries.

**Current Implementation:** Acceptable for typical PLM hierarchies (3-5 levels)

**Future Optimization (if needed):**
- Use a recursive CTE to get all ancestors in a single query
- Cache ancestor paths in memory/Redis
- Denormalize the path in the database (e.g., store full path as array)

## Related Documentation

- Type Manager and Attribute Manager implementation: `TYPE_ATTRIBUTE_MANAGER_IMPLEMENTATION.md`
- Master-detail refactoring: `MASTER_TABLE_REFACTORING.md`
