# Type Manager and Attribute Manager Implementation

This document describes the enhanced Type Manager and Attribute Manager features implemented for FlexLite PLM.

## Overview

The Type Manager and Attribute Manager have been completely redesigned to provide:

1. **Hierarchical Type Management**: Visual tree-based interface for managing entity type hierarchies
2. **Flexible Attribute Scoping**: Ability to scope attributes to specific nodes in the type hierarchy
3. **Attribute Inheritance**: Child type nodes automatically inherit attributes from parent nodes

## Database Changes

### Migration: `20250109000003_enhance_type_and_attribute_system.sql`

#### New Fields Added

**entity_type_nodes table:**
- `can_have_children` (boolean): Controls whether a type node can have child nodes
- `display_order` (integer): Order for displaying nodes among siblings

**attribute_definitions table:**
- `type_node_id` (uuid, nullable): FK to entity_type_nodes for scoping attributes to specific hierarchy levels
- `max_length` (integer, nullable): Maximum length for string fields
- `is_unique` (boolean): Whether the attribute value must be unique

#### Helper Function

**`get_type_node_attributes(p_type_node_id, p_entity_type)`**

This PostgreSQL function returns all active attributes for a given type node, including inherited attributes from parent nodes. Attributes defined on closer ancestors take precedence over those defined further up the hierarchy.

Example usage:
```sql
SELECT * FROM get_type_node_attributes(
  '123e4567-e89b-12d3-a456-426614174000'::uuid,
  'product'
);
```

## Features Implemented

### 1. Type Manager (`/admin/types`)

#### Tree View Display
- Visual hierarchical tree structure for each entity type (Product, Material, Supplier, Color, Season)
- Expand/collapse functionality for nodes with children
- Visual indicators:
  - Folder icon for nodes
  - Code badges
  - "Leaf" badge for nodes that cannot have children

#### Right-Click Context Menu
- **Add Child**: Create a child node under the selected node (only if `can_have_children = true`)
- **Edit**: Modify the node's name, code, and can_have_children setting
- **Delete**: Remove the node (only if it has no children)

#### Node Creation/Editing
Form fields:
- **Name** (required): Display name of the type node
- **Code** (optional): Short code identifier
- **Can have children** (checkbox): Controls whether this node can have child nodes

#### Features
- Automatic display order management
- Prevention of deleting nodes with children
- Prevention of adding children to leaf nodes

### 2. Attribute Manager (`/admin/attributes`)

#### Enhanced Attribute Definition
Form fields:
- **Key** (required): Internal name (lowercase, underscores allowed, pattern: `[a-z_][a-z0-9_]*`)
- **Display Label** (required): User-facing label
- **Data Type** (required): Dropdown with options:
  - Text (String)
  - Number
  - Boolean (Yes/No)
  - Date
  - Enum (Select from options)
- **Max Length** (optional, for string type): Character limit
- **Options** (required for enum type): JSON array of choices
- **Scope to Type** (optional): Type hierarchy level selector
- **Required** (checkbox): Whether the field must be filled
- **Unique** (checkbox): Whether duplicate values are allowed

#### Type Scoping Feature
- Click "Scope to Type" to open a tree picker
- Select a specific node in the type hierarchy
- The attribute will only appear for:
  - The selected type node
  - All descendant nodes (children, grandchildren, etc.)
- If no scope is set, the attribute applies globally to all nodes of that entity type

#### Visual Indicators
- **Data Type Badge**: Shows the data type with max length for strings
- **Scope Display**: Shows the full path in the hierarchy (e.g., "Product > Apparel > Women")
- **Flag Badges**:
  - Required (red)
  - Unique (purple)
- **Status Toggle**: Click to activate/deactivate attributes

#### Table View
Columns:
- Key
- Label
- Data Type
- Scope (hierarchy path)
- Flags (Required, Unique)
- Status (Active/Inactive - clickable to toggle)
- Actions (Edit, Delete)

## Usage Examples

### Example 1: Creating a Type Hierarchy for Products

1. Navigate to `/admin/types`
2. Under "Product Type Hierarchy", click "Add Root Type"
3. Create root node: Name = "Apparel", Code = "APP", Can have children = ✓
4. Right-click on "Apparel", select "Add Child"
5. Create child node: Name = "Womens", Code = "WOMENS", Can have children = ✓
6. Right-click on "Womens", select "Add Child"
7. Create child node: Name = "Tops", Code = "TOPS", Can have children = ✗

Result:
```
Apparel (APP)
  └─ Womens (WOMENS)
      └─ Tops (TOPS) [Leaf]
```

### Example 2: Creating a Scoped Attribute

Requirement: Add a "Sale Number" attribute only for Product > Apparel > Womens and its children

1. Navigate to `/admin/attributes`
2. Under "Product Attributes", click "Add Attribute"
3. Fill in the form:
   - Key: `sale_number`
   - Display Label: `Sale Number`
   - Data Type: `Text (String)`
   - Max Length: `50`
   - Scope to Type: Click and select "Product > Apparel > Womens"
   - Required: ✓
   - Unique: ✓
4. Click "Create"

Result:
- The "Sale Number" field will appear in product forms for:
  - Product > Apparel > Womens
  - Product > Apparel > Womens > Tops
  - Any other descendants of Womens
- The field will NOT appear for:
  - Product > Apparel (parent)
  - Other product types

### Example 3: Creating an Enum Attribute

1. Navigate to `/admin/attributes`
2. Under "Material Attributes", click "Add Attribute"
3. Fill in the form:
   - Key: `fabric_weight`
   - Display Label: `Fabric Weight`
   - Data Type: `Enum (Select from options)`
   - Options: `["Lightweight", "Medium", "Heavyweight"]`
   - Required: ✓
4. Click "Create"

Result:
- Material forms will show a dropdown field "Fabric Weight" with three options

## File Structure

### New/Modified Files

**Database:**
- `supabase/migrations/20250109000003_enhance_type_and_attribute_system.sql` - Migration adding new fields and helper function

**Server Actions:**
- `app/lib/actions/typeNodes.js` - CRUD operations for type nodes
- `app/lib/actions/attributes.js` - CRUD operations for attributes

**Components:**
- `app/components/TypeTreeView.js` - Tree view component with right-click context menu
- `app/components/AttributeManager.js` - Attribute table and form with type scoping

**Pages:**
- `app/app/admin/types/page.js` - Updated to use TypeTreeView component
- `app/app/admin/attributes/page.js` - Updated to use AttributeManager component

**Backup:**
- `backups/backup_20251109_015231.sql` - Database backup created before implementation

## Technical Implementation Details

### Attribute Inheritance

The `get_type_node_attributes()` PostgreSQL function implements attribute inheritance using a recursive CTE (Common Table Expression):

1. Starts with the current type node
2. Recursively walks up the parent chain
3. Collects all attributes defined at each level
4. Returns attributes with a flag indicating if they're inherited
5. Uses `DISTINCT ON (ad.key)` to handle conflicts, preferring attributes defined on closer ancestors

### Type Tree Rendering

The `TypeTreeView` component:
- Builds a tree structure from a flat array of nodes using `buildTree()` recursively
- Maintains expand/collapse state in component state
- Uses CSS padding based on nesting level for visual hierarchy
- Implements event delegation for right-click context menu
- Uses portals for modal dialogs to avoid z-index issues

### Attribute Scoping UI

The `TypeNodePicker` component:
- Displays type nodes in a tree structure
- Highlights the currently selected node
- Allows clicking to select a scope
- Shows full hierarchy path in the main form

## API Reference

### Server Actions

#### Type Node Actions (`app/lib/actions/typeNodes.js`)

**`createTypeNode(formData)`**
- Creates a new type node
- FormData fields: entity_type, name, code, parent_id, can_have_children
- Returns: `{ success: boolean, data?: object, error?: string }`

**`updateTypeNode(formData)`**
- Updates an existing type node
- FormData fields: id, name, code, can_have_children
- Returns: `{ success: boolean, data?: object, error?: string }`

**`deleteTypeNode(formData)`**
- Deletes a type node (only if it has no children)
- FormData fields: id
- Returns: `{ success: boolean, error?: string }`

#### Attribute Actions (`app/lib/actions/attributes.js`)

**`createAttribute(formData)`**
- Creates a new attribute definition
- FormData fields: entity_type, key, label, data_type, required, is_unique, max_length, type_node_id, options
- Returns: `{ success: boolean, data?: object, error?: string }`

**`updateAttribute(formData)`**
- Updates an existing attribute definition
- FormData fields: id, key, label, data_type, required, is_unique, max_length, type_node_id, options
- Returns: `{ success: boolean, data?: object, error?: string }`

**`toggleAttributeStatus(formData)`**
- Activates or deactivates an attribute
- FormData fields: id, is_active
- Returns: `{ success: boolean, data?: object, error?: string }`

**`deleteAttribute(formData)`**
- Deletes an attribute definition
- FormData fields: id
- Returns: `{ success: boolean, error?: string }`

## Future Enhancements

Potential improvements for future iterations:

1. **Drag-and-Drop Reordering**: Allow reordering type nodes and attributes via drag-and-drop
2. **Bulk Operations**: Import/export type hierarchies and attributes via CSV or JSON
3. **Attribute Validation Rules**: Add custom validation rules beyond just required/unique
4. **Conditional Attributes**: Show/hide attributes based on values of other attributes
5. **Attribute Groups**: Group related attributes into collapsible sections in forms
6. **Type Node Icons**: Custom icons for different type nodes
7. **Audit Trail**: Track who created/modified type nodes and attributes
8. **Attribute History**: Version control for attribute definition changes

## Testing Checklist

- [ ] Navigate to `/admin/types` and verify tree view renders correctly
- [ ] Create a root type node for each entity type
- [ ] Create child nodes and verify hierarchy
- [ ] Test right-click context menu on various nodes
- [ ] Edit a node and verify changes persist
- [ ] Try to add child to a leaf node (should be prevented)
- [ ] Try to delete a node with children (should be prevented)
- [ ] Navigate to `/admin/attributes`
- [ ] Create a global attribute (no type scoping)
- [ ] Create a scoped attribute using type picker
- [ ] Create attributes with different data types
- [ ] Create an enum attribute with JSON options
- [ ] Toggle attribute status (active/inactive)
- [ ] Edit an attribute and verify changes persist
- [ ] Delete an attribute
- [ ] Verify scoped attributes only appear for appropriate type nodes in product/material/supplier forms

## Notes

- The database backup was created at: `backups/backup_20251109_015231.sql`
- All migrations have been successfully applied
- The implementation follows the existing FlexLite PLM architecture patterns
- Server components are used for initial data loading
- Client components handle interactive UI elements
- Server actions handle all data mutations
