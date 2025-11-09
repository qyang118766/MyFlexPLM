# User Permissions System Implementation Progress

## Overview

This document tracks the implementation progress of the hierarchical user permissions system for FlexLite PLM.

## Requirements

1. **User & Group Management** (`/admin/users`)
   - Admin can add new users with initial passwords
   - Groups with hierarchical structure (e.g., Design, Review with subgroups)
   - Assign users to multiple groups
   - Admin accounts bypass all permissions

2. **Dynamic Permission Control**
   - When creating type nodes or attributes, assign permissions
   - Multi-select groups with permission levels:
     - **None**: Hidden from group
     - **Read**: Read-only access
     - **Write**: Full control (read/write)
   - Default: "All" (全部用户可见可写)
   - Admin accounts always have full access

## Implementation Status

### ✅ Phase 1: Database & Backend (COMPLETED)

#### 1. Database Migration
**File:** `supabase/migrations/20250109000004_create_user_permissions_system.sql`

**Created Tables:**
- `groups` - Hierarchical user groups
  - `id`, `name`, `code`, `parent_id`, `description`, `display_order`

- `user_groups` - User-group relationships (many-to-many)
  - `user_id`, `group_id`

- `type_node_permissions` - Permissions for type nodes
  - `type_node_id`, `group_id`, `permission_level` (none/read/write)

- `attribute_permissions` - Permissions for attributes
  - `attribute_id`, `group_id`, `permission_level` (none/read/write)

**Added Column:**
- `users.role` - User role (admin/user)

**Created Functions:**
- `get_user_groups(user_id)` - Returns all groups including parent groups
- `check_type_node_permission(user_id, type_node_id, required_level)` - Check permission
- `check_attribute_permission(user_id, attribute_id, required_level)` - Check permission

**Default Data:**
- Design group
- Review group

#### 2. Server Actions Created

**Group Management** (`app/lib/actions/groups.js`):
- `createGroup(formData)` - Create new group
- `updateGroup(formData)` - Update group
- `deleteGroup(formData)` - Delete group (checks for children and users)

**User Management** (`app/lib/actions/users.js`):
- `createUser(formData)` - Create user with initial password
- `updateUser(formData)` - Update user info and group assignments
- `resetUserPassword(formData)` - Admin resets user password
- `deleteUser(formData)` - Delete user
- `getCurrentUser()` - Get current logged-in user

**Permission Management** (`app/lib/actions/permissions.js`):
- `updateTypeNodePermissions(typeNodeId, permissions)` - Set permissions for type node
- `updateAttributePermissions(attributeId, permissions)` - Set permissions for attribute
- `getTypeNodePermissions(typeNodeId)` - Get permissions for type node
- `getAttributePermissions(attributeId)` - Get permissions for attribute

#### 3. UI Components Created

**Users & Groups Page** (`app/app/admin/users/page.js`):
- Server component that loads users, groups, and user-group relationships

**UserGroupManager Component** (`app/components/UserGroupManager.js`):
- Tabbed interface (Users / Groups)
- User list with role badges, group assignments
- Actions: Edit, Reset Password, Delete
- Group tree view with expand/collapse
- Actions: Add Child, Edit, Delete
- Dialogs for creating/editing users and groups
- Password reset dialog

**AppLayout Update**:
- Added "Users & Groups" to admin navigation menu

### 🔄 Phase 2: Permission Integration (IN PROGRESS)

#### 4. Permission Selector Component (TODO)
**File:** `app/components/PermissionSelector.js` (NOT YET CREATED)

This component needs to be created to allow selecting groups and permission levels when creating/editing type nodes and attributes.

**Features Needed:**
- Group multi-select with checkboxes
- Permission level dropdown for each group (None/Read/Write)
- "All Users" default option
- Visual summary of selected permissions

#### 5. Type Manager Updates (TODO)

**File:** `app/components/TypeTreeView.js` (NEEDS UPDATE)

**Required Changes:**
- Add "Permissions" button/section to context menu or edit dialog
- Integrate `PermissionSelector` component
- Call `updateTypeNodePermissions()` when saving
- Display permission indicators on nodes (e.g., lock icon if restricted)

#### 6. Attribute Manager Updates (TODO)

**File:** `app/components/AttributeManager.js` (NEEDS UPDATE)

**Required Changes:**
- Add permissions field to attribute creation/edit form
- Integrate `PermissionSelector` component
- Call `updateAttributePermissions()` when saving
- Display permission indicators in attribute list

### 📝 Phase 3: Permission Filtering (TODO)

#### 7. Permission Filtering Service (TODO)
**File:** `app/lib/services/permissionFiltering.js` (NOT YET CREATED)

This service will filter type nodes and attributes based on current user's permissions.

**Functions Needed:**
```javascript
// Filter type nodes user can access
export async function getAccessibleTypeNodes(supabase, entityType, userId, requiredLevel = 'read')

// Filter attributes user can access
export async function getAccessibleAttributes(supabase, entityType, typeNodeId, userId, requiredLevel = 'read')

// Check if user can perform action
export async function canUserAccess(supabase, userId, resourceType, resourceId, requiredLevel)
```

#### 8. Apply Permission Filtering (TODO)

Update these files to check permissions:

**Product Pages:**
- `app/app/products/create/page.js` - Filter type nodes and attributes
- `app/app/products/edit/page.js` - Filter attributes, check write permission

**Material Pages:**
- `app/app/materials/create/page.js` - Filter type nodes and attributes
- `app/app/materials/edit/page.js` - Filter attributes, check write permission

**Supplier Pages:**
- `app/app/suppliers/create/page.js` - Filter type nodes and attributes
- `app/app/suppliers/edit/page.js` - Filter attributes, check write permission

**Type Manager:**
- `app/app/admin/types/page.js` - Filter visible type nodes

**Attribute Manager:**
- `app/app/admin/attributes/page.js` - Filter visible attributes

### 🧪 Phase 4: Testing (TODO)

Test scenarios needed:

1. **Admin User:**
   - Can see and edit everything (bypass all permissions)

2. **User in Design Group:**
   - Can see type nodes assigned to Design with "read" or "write"
   - Cannot see type nodes with "none" permission
   - Can only edit if permission is "write"

3. **User in Multiple Groups:**
   - Gets highest permission level among all groups
   - Example: If in Group A (read) and Group B (write), gets write permission

4. **User with No Groups:**
   - Only sees resources with "All Users" default permission

## Database Backup

Created before implementation:
- **File:** `backups/backup_20251109_130617_before_permissions.sql`
- **Size:** 382KB

## Next Steps

To complete the permission system:

1. Create `PermissionSelector` component
2. Update `TypeTreeView` to add permission configuration
3. Update `AttributeManager` to add permission configuration
4. Create `permissionFiltering` service
5. Update all product/material/supplier pages to apply permission filtering
6. Test with different user roles and group assignments

## Usage Example

Once completed, the workflow will be:

### Creating a Type Node with Permissions

1. Navigate to `/admin/types`
2. Right-click on a node → "Add Child"
3. Fill in name and code
4. Click "Permissions" section
5. Select groups:
   - ☑ Design (Permission: Write)
   - ☑ Review (Permission: Read)
6. Default for others: None
7. Save

**Result:**
- Admin users: Can see and edit
- Design group members: Can see and edit
- Review group members: Can see but not edit
- Other users: Cannot see this type node

### Creating an Attribute with Permissions

1. Navigate to `/admin/attributes`
2. Click "Add Attribute"
3. Fill in attribute details
4. Select "Scope to Type" (optional)
5. Click "Permissions" section
6. Select groups:
   - ☑ Design (Permission: Write)
   - Default for others: Read
7. Save

**Result:**
- Admin users: Can see and edit
- Design group members: Can see and edit
- All other users: Can see but not edit

## Technical Notes

### Permission Hierarchy

1. **Admin role** always bypasses all permissions
2. **User role** checks permissions:
   - If user belongs to multiple groups, take **highest** permission
   - Permission levels: `none < read < write`
   - If no group-specific permission, use default permission
   - If no default permission set, assume `write` (full access for all)

### NULL group_id Semantics

In `type_node_permissions` and `attribute_permissions`:
- `group_id = NULL` means "default permission for users not in any specific group"
- This is the "All Users" option in the UI

### RLS Policies

- All permission tables have RLS enabled
- Users can read their own group memberships
- Only admins can modify groups and permissions
- This ensures non-admin users cannot escalate their own permissions

## Files Created

1. `supabase/migrations/20250109000004_create_user_permissions_system.sql`
2. `app/lib/actions/groups.js`
3. `app/lib/actions/users.js`
4. `app/lib/actions/permissions.js`
5. `app/app/admin/users/page.js`
6. `app/components/UserGroupManager.js`
7. `backups/backup_20251109_130617_before_permissions.sql`

## Files Updated

1. `app/components/AppLayout.js` - Added "Users & Groups" menu item

## Files to Create

1. `app/components/PermissionSelector.js`
2. `app/lib/services/permissionFiltering.js`

## Files to Update

1. `app/components/TypeTreeView.js`
2. `app/components/AttributeManager.js`
3. `app/app/products/create/page.js`
4. `app/app/products/edit/page.js`
5. `app/app/materials/create/page.js`
6. `app/app/materials/edit/page.js`
7. `app/app/suppliers/create/page.js`
8. `app/app/suppliers/edit/page.js`
9. `app/app/admin/types/page.js`
10. `app/app/admin/attributes/page.js`

## Estimated Remaining Work

- Permission Selector Component: ~200 lines
- Type Manager Updates: ~100 lines
- Attribute Manager Updates: ~100 lines
- Permission Filtering Service: ~300 lines
- Page Updates (10 files): ~500 lines total
- Testing and refinement: 2-3 hours

**Total Estimated:** ~1200 lines of code + testing
