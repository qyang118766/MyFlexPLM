# FlexLite PLM - System Overview

## Executive Summary

FlexLite PLM is a lightweight, web-based Product Lifecycle Management system designed for fashion and apparel companies. Built with Next.js 16 and Supabase, it provides comprehensive tools for managing products, materials, suppliers, colors, seasons, and bills of materials with advanced permission controls.

**Key Capabilities:**
- Hierarchical entity type management with custom attributes
- Fine-grained permission system (type-level and attribute-level)
- User and group management with hierarchical organization
- Dynamic attribute system without database schema changes
- Single-level BOM management with material, color, and supplier variants
- Server-side rendering for optimal performance

---

## Architecture

### Technology Stack

| Layer | Technology | Version | Purpose |
|-------|-----------|---------|---------|
| **Frontend** | Next.js (App Router) | 16.0.1 | React framework with SSR |
| **UI Framework** | React | 19.2.0 | Component library |
| **Styling** | Tailwind CSS | 4.x | Utility-first CSS |
| **Component Library** | shadcn/ui | Latest | Pre-built UI components |
| **Backend** | Next.js Server Components | 16.0.1 | Server-side logic |
| **Database** | PostgreSQL (Supabase) | Latest | Relational database |
| **Authentication** | Supabase Auth | Latest | User authentication |
| **Hosting** | Vercel | Latest | Serverless deployment |

### Architecture Pattern

- **Server Components First**: All data fetching happens on the server
- **Server Actions**: Form submissions and mutations via server actions
- **No API Layer**: Direct database queries from server components
- **Row-Level Security**: Database-level permission enforcement
- **JSONB for Flexibility**: Dynamic attributes stored as JSON

---

## Core Features

### 1. Entity Management

Five core entity types form the foundation of the system:

#### Products
- **Purpose**: Manage styles, SKUs, and product specifications
- **Key Fields**:
  - `style_code` (unique identifier)
  - `name`, `gender`, `status`
  - `season_id` (optional link to season)
  - `type_id` (hierarchical type classification)
  - `attributes` (JSONB for custom fields)
- **Related Entities**: Seasons, BOMs
- **Statuses**: Development, Pre-Production, Production, Inactive

#### Materials
- **Purpose**: Central library of fabrics, trims, and components
- **Key Fields**:
  - `material_code` (unique identifier)
  - `name`, `status`
  - `type_id` (material taxonomy)
  - `attributes` (JSONB)
- **Related Entities**: Suppliers (via `material_suppliers`), Colors (via `material_colors`)
- **Statuses**: In Development, Active, Dropped, RFQ

#### Suppliers
- **Purpose**: Vendor and manufacturer management
- **Key Fields**:
  - `supplier_code` (unique identifier)
  - `name`, `region`, `status`
  - `type_id` (supplier taxonomy)
  - `attributes` (JSONB)
- **Related Entities**: Materials (via `material_suppliers`)
- **Statuses**: Active, Inactive

#### Colors
- **Purpose**: Standardized color palette management
- **Key Fields**:
  - `color_code` (unique identifier)
  - `name`, `rgb_hex`
  - `status`
  - `type_id` (color grouping)
  - `attributes` (JSONB)
- **Related Entities**: Materials (via `material_colors`)
- **Statuses**: Active, Inactive

#### Seasons
- **Purpose**: Collection and seasonal planning
- **Key Fields**:
  - `code` (unique identifier)
  - `name`, `year`, `status`
  - `type_id` (season taxonomy)
  - `attributes` (JSONB)
- **Related Entities**: Products
- **Statuses**: Planned, Active, Archived

### 2. Type Management System

Each entity type supports hierarchical classification through the **Type Manager**.

#### Type Tree Structure
```
entity_type_nodes
├── id (UUID)
├── entity_type (enum: product, material, supplier, color, season)
├── parent_id (FK to self, nullable)
├── name
├── code
└── timestamps
```

**Example Hierarchy:**
```
Product
├── Apparel
│   ├── Womens
│   │   ├── Tops
│   │   └── Bottoms
│   └── Mens
└── Accessories
```

**Benefits:**
- Organize entities into meaningful categories
- Apply permissions at any level of the hierarchy
- Support attribute scoping to specific branches
- Enable filtered browsing and reporting

#### Implementation
- **Database**: `entity_type_nodes` table with self-referential `parent_id`
- **UI**: Tree view with expand/collapse and context menu
- **API**: Server actions for CRUD operations
- **Permission Integration**: Type-level permissions check node hierarchy

### 3. Dynamic Attribute System

Custom fields can be added to any entity type without database schema changes.

#### Attribute Definition Structure
```
attribute_definitions
├── id (UUID)
├── entity_type (enum)
├── key (internal name)
├── label (display name)
├── data_type (string, number, boolean, date, enum)
├── required (boolean)
├── order_index (display order)
├── options (JSONB for enum choices)
├── is_active (boolean)
└── type_scope (array of type_id for scoping)
```

#### Attribute Scoping
Attributes can be scoped to specific type nodes:
- **Global**: Available to all entities of a type
- **Scoped**: Only available to specific type branches

**Example:**
- `brand` attribute scoped to "Product > Apparel"
- `mill_width` attribute scoped to "Material > Fabric"
- `lead_time` attribute scoped to "Supplier > Manufacturers"

#### Data Types

| Type | Storage | UI Component | Validation |
|------|---------|--------------|------------|
| **String** | Text | `<input type="text">` | Max length |
| **Number** | Numeric | `<input type="number">` | Min/max |
| **Boolean** | Boolean | `<input type="checkbox">` | N/A |
| **Date** | Timestamp | `<input type="date">` | Date range |
| **Enum** | String | `<select>` | Valid option |

#### Implementation
- **Storage**: All custom values stored in `attributes` JSONB column
- **Rendering**: Forms dynamically generate fields based on definitions
- **Validation**: Server-side validation against definitions
- **Permissions**: Attribute-level permissions control visibility/editability

### 4. Permission System

Two-tier permission system provides fine-grained access control.

#### Type-Level Permissions

Control access to entire entity types at any hierarchy level.

**Permission Levels:**

| Level | Create | Read | Update | Delete | Code |
|-------|--------|------|--------|--------|------|
| None | ✗ | ✗ | ✗ | ✗ | `none` |
| Read | ✗ | ✓ | ✗ | ✗ | `read` |
| Edit | ✗ | ✓ | ✓ | ✗ | `edit` |
| Create | ✓ | ✓ | ✓ | ✗ | `create` |
| Delete | ✓ | ✓ | ✓ | ✓ | `delete` |
| Full | ✓ | ✓ | ✓ | ✓ | `full` |

**Hierarchy Inheritance:**
- Permissions set on parent nodes apply to all descendants
- Child nodes can have more restrictive (but not more permissive) permissions
- Effective permission is the strictest in the path from root to node

**Database Structure:**
```sql
CREATE TABLE type_permissions (
  id UUID PRIMARY KEY,
  group_id UUID REFERENCES user_groups(id),
  entity_type TEXT,
  type_node_id UUID REFERENCES entity_type_nodes(id),
  permission_level TEXT,
  UNIQUE(group_id, entity_type, type_node_id)
);
```

#### Attribute-Level Permissions

Control visibility and editability of individual attributes.

**Permission Levels:**

| Level | Visible | Editable | Code |
|-------|---------|----------|------|
| Hidden | ✗ | ✗ | `hidden` |
| Read Only | ✓ | ✗ | `readonly` |
| Editable | ✓ | ✓ | `editable` |
| Default | (inherit from type permission) | (inherit from type permission) | `default` |

**Database Structure:**
```sql
CREATE TABLE attribute_permissions (
  id UUID PRIMARY KEY,
  group_id UUID REFERENCES user_groups(id),
  attribute_id UUID REFERENCES attribute_definitions(id),
  permission_level TEXT,
  UNIQUE(group_id, attribute_id)
);
```

#### Permission Resolution

When a user belongs to multiple groups:

1. **Collect all permissions** from all groups
2. **Apply strictest rule**:
   - Type permissions: Most restrictive wins
   - Attribute permissions: Most restrictive wins
3. **Super Admin override**: Super admins bypass all checks

**Example:**
```
User Groups:
- Design Team: Product = Edit, brand attribute = Editable
- Reviewers: Product = Read, brand attribute = Readonly

Effective Permission:
- Product = Read (more restrictive)
- brand = Readonly (more restrictive)
```

#### Permission Service Architecture

**Service File:** `app/lib/services/attributePermissions.js`

**Key Functions:**

1. **`getUserPermissionSummary()`**
   - Fetches all groups for current user
   - Aggregates type permissions across all groups
   - Returns strictest effective permissions
   - Used for: Authorization checks in create/edit pages

2. **`getAttributesWithPermissions(supabase, entityType, typeId)`**
   - Fetches attribute definitions for entity type
   - Filters by type scope (only applicable attributes)
   - Applies user's attribute permissions
   - Returns: Attributes with effective visibility and editability
   - Used for: Dynamic form rendering, view page filtering

3. **`getEffectiveTypePermission(typePermissions, typeId)`**
   - Traverses type hierarchy from node to root
   - Collects all applicable permissions
   - Returns strictest permission level
   - Used for: Type-level authorization

### 5. User & Group Management

Hierarchical organization of users with permission assignment.

#### User Groups Structure

```
user_groups
├── id (UUID)
├── name
├── code
├── description
├── parent_id (FK to self, nullable)
├── level (integer depth)
└── timestamps
```

**Hierarchy Support:**
- Groups can nest to any depth
- Supports organizational structures
- Permission inheritance from parent groups
- Simplified bulk permission management

**Example Hierarchy:**
```
Company
├── Management (level 0)
├── Design Team (level 0)
│   ├── Senior Designers (level 1)
│   └── Junior Designers (level 1)
└── Sourcing Team (level 0)
```

#### User Management

```
users
├── id (UUID, matches Supabase auth.users.id)
├── email
├── display_name
├── is_superadmin (boolean)
└── timestamps

user_group_memberships
├── user_id (FK to users)
├── group_id (FK to user_groups)
└── timestamps
```

**Features:**
- Users can belong to multiple groups
- Email-based authentication via Supabase
- Super admin role for unrestricted access
- Display name for UI personalization

#### Permission Management UI

**Located at:** `/admin/user-management`

**Features:**
1. **Group Management**
   - Hierarchical tree view
   - Create/edit/delete groups
   - Parent group selection with dropdown

2. **User Management**
   - User list with group membership
   - Create users with password
   - Assign to multiple groups
   - Super admin toggle

3. **Permission Editor**
   - Type permissions table
   - Attribute permissions table
   - Bulk permission assignment
   - Visual permission indicators

**Components:**
- `UserGroupManager.js` - Main management interface
- `HierarchicalGroupSelector.js` - Hierarchical group picker
- `PermissionSelector.js` - Permission level selector

### 6. Bill of Materials (BOM)

Single-level BOM management for products.

#### BOM Structure

```
product_boms
├── id (UUID)
├── product_id (FK)
├── name
├── status (draft, active, archived)
└── timestamps

bom_items
├── id (UUID)
├── bom_id (FK)
├── line_number
├── material_id (FK)
├── color_id (FK, nullable)
├── supplier_id (FK, nullable)
├── quantity
├── unit
├── attributes (JSONB)
└── timestamps
```

**Features:**
- One BOM per product (default: "Default BOM")
- Multiple line items per BOM
- Material selection from library
- Optional color and supplier variants
- Quantity and unit tracking
- Custom attributes per line item

**Variants:**
- **Color Variant**: Specify which color of a material
- **Source Variant**: Specify which supplier to source from
- **Pricing Integration**: Links to `material_suppliers` for costing

#### BOM Operations

**Server Actions:** `app/lib/actions/bom.js`

1. **Create BOM Item**: Add new line to BOM
2. **Update BOM Item**: Edit quantity, unit, variants
3. **Delete BOM Item**: Remove line from BOM
4. **Replace Material**: Swap material while keeping other details
5. **Change Color**: Update color variant
6. **Change Supplier**: Update source variant

---

## Database Schema

### Core Entity Tables

All core entities follow a consistent pattern:

```sql
CREATE TABLE {entity_name} (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  {code_field} TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  status TEXT NOT NULL,
  type_id UUID REFERENCES entity_type_nodes(id),
  attributes JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  create_by TEXT,
  update_by TEXT
);
```

**Benefits of this pattern:**
- Consistent structure across all entities
- Easy to add new entity types
- JSONB flexibility for custom fields
- Audit trail with created_by/updated_by

### Relationship Tables

#### Material-Supplier Link
```sql
CREATE TABLE material_suppliers (
  id UUID PRIMARY KEY,
  material_id UUID REFERENCES materials(id) ON DELETE CASCADE,
  supplier_id UUID REFERENCES suppliers(id) ON DELETE CASCADE,
  price NUMERIC,
  currency TEXT,
  attributes JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### Material-Color Link
```sql
CREATE TABLE material_colors (
  id UUID PRIMARY KEY,
  material_id UUID REFERENCES materials(id) ON DELETE CASCADE,
  color_id UUID REFERENCES colors(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(material_id, color_id)
);
```

### Permission Tables

Designed for scalability and complex hierarchies:

```sql
-- Type-level permissions
CREATE TABLE type_permissions (
  id UUID PRIMARY KEY,
  group_id UUID REFERENCES user_groups(id) ON DELETE CASCADE,
  entity_type TEXT NOT NULL,
  type_node_id UUID REFERENCES entity_type_nodes(id),
  permission_level TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(group_id, entity_type, type_node_id)
);

-- Attribute-level permissions
CREATE TABLE attribute_permissions (
  id UUID PRIMARY KEY,
  group_id UUID REFERENCES user_groups(id) ON DELETE CASCADE,
  attribute_id UUID REFERENCES attribute_definitions(id) ON DELETE CASCADE,
  permission_level TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(group_id, attribute_id)
);
```

### Security

#### Row Level Security (RLS)

**Policy Pattern:**
```sql
-- Enable RLS on table
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Allow read based on group permissions
CREATE POLICY "Users can view products they have permission for"
ON products FOR SELECT
USING (
  auth.uid() IN (
    SELECT user_id FROM user_permissions_view
    WHERE entity_type = 'product'
    AND permission_level IN ('read', 'edit', 'create', 'delete', 'full')
  )
);
```

**Current State:**
- RLS enabled on core tables
- Policies enforce read/write permissions
- Service role bypasses RLS for admin operations

---

## Implementation Details

### Server Components & Actions

#### Data Fetching Pattern

**File:** `app/app/products/page.js`

```javascript
import { createClient } from '@/lib/supabase/server';

export default async function ProductsPage() {
  const supabase = await createClient();

  // Direct database query
  const { data: products } = await supabase
    .from('products')
    .select('*, seasons(name)')
    .order('created_at', { ascending: false });

  return <ProductList products={products} />;
}
```

**Benefits:**
- No API layer needed
- Fast server-side rendering
- Automatic authentication context
- RLS enforces permissions

#### Mutation Pattern

**File:** `app/lib/actions/products.js`

```javascript
'use server';

import { createClient } from '@/lib/supabase/server';

export async function createProduct(formData) {
  const supabase = await createClient();

  // Validate permissions
  const permissionResult = await getUserPermissionSummary();
  const productPermission = permissionResult.data?.entityPermissions?.product;

  if (!['create', 'delete', 'full'].includes(productPermission)) {
    return { success: false, error: 'Permission denied' };
  }

  // Insert product
  const { data, error } = await supabase
    .from('products')
    .insert({ ...formData })
    .select()
    .single();

  if (error) return { success: false, error: error.message };

  return { success: true, data };
}
```

**Benefits:**
- Server-side validation
- Permission checks before mutations
- Type-safe error handling
- Direct database access

### Component Architecture

#### Page Structure

All entity pages follow a consistent structure:

```
/app/app/{entity}/
├── page.js              # List view
├── create/
│   └── page.js          # Create form (multi-step if needed)
├── edit/
│   └── page.js          # Edit form
└── view/
    └── page.js          # Detail view
```

#### Reusable Components

**Location:** `app/components/`

Key components:
- `TypeTreeView.js` - Hierarchical type browser
- `AttributeManager.js` - Attribute CRUD interface
- `UserGroupManager.js` - User/group management
- `HierarchicalGroupSelector.js` - Nested group picker
- `PermissionSelector.js` - Permission level dropdown

### Type & Attribute Scoping

#### Type Path Resolution

**File:** `app/lib/data/typeNodes.js`

```javascript
// Build path from node to root
export async function buildTypePath(supabase, typeId) {
  const path = [];
  let currentId = typeId;

  while (currentId) {
    const { data: node } = await supabase
      .from('entity_type_nodes')
      .select('*')
      .eq('id', currentId)
      .single();

    if (!node) break;
    path.unshift(node);
    currentId = node.parent_id;
  }

  return path;
}

// Format path for display
export function formatTypePath(path) {
  return path.map(node => node.name).join(' > ');
}
```

#### Attribute Scoping Service

**File:** `app/lib/services/attributePermissions.js`

```javascript
export async function getAttributesWithPermissions(supabase, entityType, typeId) {
  // 1. Fetch all attribute definitions for entity type
  const { data: allAttributes } = await supabase
    .from('attribute_definitions')
    .select('*')
    .eq('entity_type', entityType)
    .eq('is_active', true);

  // 2. Filter by type scope
  let applicableAttributes = allAttributes.filter(attr => {
    if (!attr.type_scope || attr.type_scope.length === 0) return true;

    // Check if typeId is in scope or is descendant of scoped node
    return attr.type_scope.some(scopedTypeId => {
      return isNodeInScope(typeId, scopedTypeId);
    });
  });

  // 3. Apply user's attribute permissions
  const { data: userGroups } = await getUserGroups();
  const { data: attributePermissions } = await supabase
    .from('attribute_permissions')
    .select('*')
    .in('group_id', userGroups.map(g => g.id));

  // 4. Calculate effective permission for each attribute
  applicableAttributes = applicableAttributes.map(attr => {
    const permissions = attributePermissions
      .filter(p => p.attribute_id === attr.id)
      .map(p => p.permission_level);

    const effectivePermission = getStrictestAttributePermission(permissions);

    return {
      ...attr,
      effectivePermission,
      visible: effectivePermission !== 'hidden',
      editable: effectivePermission === 'editable'
    };
  });

  // 5. Return only visible attributes
  return applicableAttributes.filter(attr => attr.visible);
}
```

---

## Security Considerations

### Authentication

- **Method**: Email/password via Supabase Auth
- **Session Management**: Supabase handles JWT tokens
- **Password Policy**: Minimum 6 characters (can be strengthened)
- **Password Reset**: Via Supabase email templates

### Authorization

- **Database Level**: Row Level Security (RLS) policies
- **Application Level**: Permission checks in server actions
- **UI Level**: Conditional rendering based on permissions
- **API Level**: N/A (no REST API, all server components)

### Data Protection

- **Encryption**: All data encrypted at rest (Supabase)
- **Transport**: HTTPS only
- **Sensitive Fields**: Can be hidden via attribute permissions
- **Audit Trail**: `created_by`, `updated_by` fields on all entities

### Best Practices

1. **Principle of Least Privilege**: Default to restrictive permissions
2. **Super Admin Sparingly**: Limit super admin accounts
3. **Regular Audits**: Review user group memberships
4. **Attribute Permissions**: Hide sensitive data (pricing, cost)
5. **Validation**: Server-side validation on all inputs

---

## Performance Optimizations

### Database

- **Indexes**: On all foreign keys and frequently queried columns
- **JSONB Indexing**: GIN indexes on `attributes` columns
- **Connection Pooling**: Supabase handles connection management
- **Query Optimization**: Use `select()` to limit returned columns

### Frontend

- **Server Components**: Reduce client-side JavaScript
- **Code Splitting**: Automatic with Next.js App Router
- **Image Optimization**: Next.js `<Image>` component
- **Caching**: Next.js automatic caching of server components

### Rendering Strategy

- **Products/Materials/Suppliers/Colors/Seasons**: Server-side rendered lists
- **Type Manager**: Client component for interactive tree
- **Forms**: Server components with progressive enhancement
- **BOM Editor**: Client component for interactive editing

---

## Deployment

### Vercel Configuration

**File:** `vercel.json`

```json
{
  "buildCommand": "cd app && npm install && npm run build",
  "outputDirectory": "app/.next",
  "framework": "nextjs",
  "installCommand": "cd app && npm install"
}
```

**Monorepo Structure:**
```
MyFlexPLM/
├── app/                 # Next.js application (root for Vercel)
│   ├── app/            # App Router pages
│   ├── components/     # React components
│   ├── lib/            # Utilities and services
│   └── package.json
├── supabase/           # Database migrations
└── vercel.json         # Vercel config
```

**Environment Variables:**
- `NEXT_PUBLIC_SUPABASE_URL` - Supabase project URL
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` - Supabase anon key
- `NODE_ENV` - Production environment

**Build Process:**
1. Vercel detects Next.js framework
2. Changes directory to `app/`
3. Runs `npm install`
4. Runs `npm run build`
5. Deploys `.next` directory

### Database Migrations

**Location:** `supabase/migrations/`

**Migration Files:**
1. `20250101000000_initial_schema.sql` - Core tables
2. `20250101000001_type_system.sql` - Type hierarchy
3. `20250101000002_attribute_system.sql` - Dynamic attributes
4. `20250101000003_permissions.sql` - Permission tables
5. `20250101000004_user_groups.sql` - User management
6. `20250109000005_fix_superadmin_and_permissions.sql` - Permission fixes

**Applying Migrations:**
```bash
# Local development
npx supabase db reset

# Production
npx supabase db push
```

---

## Future Enhancements

### Planned Features

1. **Version Control**
   - A-Z versions for major revisions
   - 1-999 iterations for minor changes
   - Version history and diff viewing

2. **Approval Workflows**
   - RFA (Request for Approval) process
   - Multi-stage approval chains
   - Email notifications

3. **Advanced Reporting**
   - Custom report builder
   - Pivot tables and charts
   - Export to Excel/PDF

4. **Multi-level BOM**
   - Nested sub-assemblies
   - Costing rollup
   - Material explosion

5. **Document Management**
   - File attachments to entities
   - Version control for documents
   - Spec sheet generation

6. **Integrations**
   - ERP system sync
   - PLM vendor integrations
   - REST API for external tools

### Extensibility

The system is designed for easy extension:

- **Add Entity Types**: Add to enum, create table following pattern
- **Add Attributes**: Use Attribute Manager UI
- **Add Permissions**: Extend permission tables
- **Custom Pages**: Add to `app/app/` directory
- **Custom Components**: Add to `app/components/`

---

## Troubleshooting

### Common Issues

#### Build Errors

**Symptom**: `Error: Cannot find module '@tailwindcss/postcss'`

**Solution**: Check `postcss.config.mjs` and ensure Tailwind CSS v4 is properly configured.

#### Permission Denied

**Symptom**: User cannot access features they should have permission for

**Solution**:
1. Check user group membership
2. Verify group has appropriate type/attribute permissions
3. Check RLS policies in database
4. Confirm user is not super admin (which might be confusing)

#### Attributes Not Showing

**Symptom**: Custom attributes don't appear on forms

**Solution**:
1. Verify attribute is marked as active
2. Check type scope includes the entity's type
3. Confirm attribute permission is not "hidden"
4. Check `getAttributesWithPermissions()` logic

#### BOM Items Not Saving

**Symptom**: BOM line items don't persist

**Solution**:
1. Check material exists in library
2. Verify product has a default BOM
3. Check user has edit permission on product
4. Review server action error logs

---

## Appendix

### Key File Locations

#### Configuration
- `app/next.config.mjs` - Next.js configuration
- `app/tailwind.config.js` - Tailwind CSS configuration
- `app/postcss.config.mjs` - PostCSS configuration
- `vercel.json` - Vercel deployment settings

#### Core Services
- `app/lib/supabase/server.js` - Server-side Supabase client
- `app/lib/supabase/client.js` - Client-side Supabase client
- `app/lib/services/attributePermissions.js` - Permission service
- `app/lib/data/typeNodes.js` - Type hierarchy utilities

#### Server Actions
- `app/lib/actions/products.js` - Product CRUD
- `app/lib/actions/materials.js` - Material CRUD
- `app/lib/actions/suppliers.js` - Supplier CRUD
- `app/lib/actions/colors.js` - Color CRUD
- `app/lib/actions/seasons.js` - Season CRUD
- `app/lib/actions/bom.js` - BOM operations
- `app/lib/actions/users.js` - User/group management

#### Pages
- `app/app/page.js` - Dashboard
- `app/app/products/` - Product pages
- `app/app/materials/` - Material pages
- `app/app/suppliers/` - Supplier pages
- `app/app/colors/` - Color pages
- `app/app/seasons/` - Season pages
- `app/app/admin/types/` - Type Manager
- `app/app/admin/attributes/` - Attribute Manager
- `app/app/admin/user-management/` - User Management

### Database ERD Summary

```
entity_type_nodes
└─┬─ type_permissions
  └── user_groups
      └─┬─ user_group_memberships
        ├── users
        └─┬─ attribute_permissions
          └── attribute_definitions

products
├── seasons
├── entity_type_nodes (type_id)
└── product_boms
    └── bom_items
        ├── materials
        │   ├── material_suppliers
        │   │   └── suppliers
        │   └── material_colors
        │       └── colors
        ├── colors
        └── suppliers
```

### API Reference (Server Actions)

All server actions return: `{ success: boolean, data?: any, error?: string }`

**Products:**
- `createProduct(formData)` - Create new product
- `updateProduct(id, formData)` - Update existing product
- `deleteProduct(id)` - Delete product

**Materials:**
- `createMaterial(formData)` - Create new material
- `updateMaterial(id, formData)` - Update existing material
- `deleteMaterial(id)` - Delete material

**Suppliers:**
- `createSupplier(formData)` - Create new supplier
- `updateSupplier(id, formData)` - Update existing supplier
- `deleteSupplier(id)` - Delete supplier

**Colors:**
- `createColor(formData)` - Create new color
- `updateColor(id, formData)` - Update existing color
- `deleteColor(id)` - Delete color

**Seasons:**
- `createSeason(formData)` - Create new season
- `updateSeason(id, formData)` - Update existing season
- `deleteSeason(id)` - Delete season

**BOM:**
- `createBOMItem(bomId, itemData)` - Add line item
- `updateBOMItem(itemId, itemData)` - Update line item
- `deleteBOMItem(itemId)` - Remove line item

**Users:**
- `createUser(userData)` - Create new user
- `updateUser(id, userData)` - Update user
- `createUserGroup(groupData)` - Create group
- `updateUserGroup(id, groupData)` - Update group
- `updateTypePermissions(groupId, permissions)` - Set type permissions
- `updateAttributePermissions(groupId, permissions)` - Set attribute permissions

---

**Document Version:** 1.0
**Last Updated:** January 2025
**System Version:** FlexLite PLM v0.1.0
