# FlexLite PLM - User Manual

## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [User & Group Management](#user--group-management)
4. [Permission System](#permission-system)
5. [Type Manager](#type-manager)
6. [Attribute Manager](#attribute-manager)
7. [Managing Entities](#managing-entities)
8. [Bill of Materials (BOM)](#bill-of-materials-bom)
9. [Dashboard](#dashboard)

---

## Introduction

FlexLite PLM is a lightweight Product Lifecycle Management system designed for managing fashion and apparel products. It provides comprehensive tools for managing:

- **Products** - Style information, specifications, and versions
- **Materials** - Fabric and component library
- **Suppliers** - Vendor and manufacturer management
- **Colors** - Color standards and palettes
- **Seasons** - Collection and season planning
- **Bill of Materials** - Product composition and costing

### Key Features

- **Hierarchical Type System** - Organize entities into customizable type trees
- **Dynamic Attributes** - Add custom fields without database changes
- **Advanced Permissions** - Fine-grained control at type and attribute levels
- **User & Group Management** - Organize users into hierarchical groups
- **Version Control** - Track changes with version history (A-Z, 1-999 iterations)

---

## Getting Started

### System Requirements

- Modern web browser (Chrome, Firefox, Safari, Edge)
- Internet connection
- Login credentials provided by your administrator

### Logging In

1. Navigate to the FlexLite PLM URL
2. Enter your email address
3. Enter your password
4. Click **Sign In**

### Initial Setup (Admin Only)

When first setting up the system:

1. Log in with the default admin account (`admin@example.com`)
2. Navigate to **Admin > User Management**
3. Create user groups for your organization
4. Add users and assign them to appropriate groups
5. Configure permissions for each group
6. Set up entity types in **Admin > Type Manager**
7. Define custom attributes in **Admin > Attribute Manager**

---

## User & Group Management

### Accessing User Management

Navigate to **Admin > User Management** from the left sidebar.

### User Groups

Groups allow you to organize users and assign permissions collectively.

#### Creating a Group

1. Click **Create Group** button
2. Fill in the group details:
   - **Name** - Display name (e.g., "Design Team")
   - **Code** - Unique identifier (e.g., "DESIGN")
   - **Description** - Optional description
   - **Parent Group** - Select a parent to create hierarchy
3. Click **Create Group**

#### Group Hierarchy

Groups can be nested to create organizational structures:

```
Company
├── Management
├── Design Team
│   ├── Senior Designers
│   └── Junior Designers
├── Sourcing Team
└── Production Team
```

**Benefits of hierarchy:**
- Inherit permissions from parent groups
- Better organization and visibility
- Easier bulk permission management

### Managing Users

#### Creating a User

1. Click **Create User** button
2. Fill in user details:
   - **Email** - User's email address (used for login)
   - **Display Name** - User's full name
   - **Password** - Initial password (user should change on first login)
   - **Groups** - Select one or more groups
   - **Admin** - Check if user should have full admin access
3. Click **Create User**

#### Editing Users

1. Find the user in the user list
2. Click the **Edit** button
3. Update user information or group membership
4. Click **Update User**

#### Resetting Passwords

1. Edit the user
2. Enter a new password in the **New Password** field
3. Click **Update User**
4. Notify the user of their new password

### Super Admin

The **Super Admin** role has unrestricted access to all features and data, bypassing all permission checks.

**Warning:** Use super admin accounts carefully. For daily operations, use regular accounts with appropriate group permissions.

---

## Permission System

FlexLite PLM uses a two-tier permission system:

1. **Type-Level Permissions** - Control access to entity types
2. **Attribute-Level Permissions** - Control access to specific attributes

### Type-Level Permissions

These permissions control what users can do with entire entity types (e.g., all Products, all Materials).

#### Permission Levels

| Level | Description |
|-------|-------------|
| **None** | No access - entity type is completely hidden |
| **Read** | View-only access - can browse and view details |
| **Edit** | Can modify existing records (but not create or delete) |
| **Create** | Can create new records and edit existing ones |
| **Delete** | Can delete records, create, and edit |
| **Full** | Complete control - create, read, update, delete |

#### Setting Type Permissions

1. Go to **Admin > User Management**
2. Click **Edit Permissions** for a group
3. Find the entity type in the permissions list
4. Select the appropriate permission level from the dropdown
5. Click **Save Permissions**

#### Permission Inheritance

When you set permissions on a parent type node, child nodes inherit those permissions by default. For example:

- Setting **Read** on "Material > Fabric" means all fabric subtypes inherit **Read** permission
- You can override inherited permissions on specific child nodes

### Attribute-Level Permissions

Control visibility and editability of individual fields within entity types.

#### Permission Levels

| Level | Description |
|-------|-------------|
| **Hidden** | Attribute is completely hidden from view |
| **Read Only** | Attribute is visible but cannot be edited |
| **Editable** | Attribute can be viewed and modified |
| **Default** | Use the type-level permission |

#### Setting Attribute Permissions

1. Go to **Admin > User Management**
2. Click **Edit Permissions** for a group
3. Click **Attribute Permissions** tab
4. Find the entity type and attribute
5. Select the permission level
6. Click **Save Permissions**

### Permission Resolution

When a user belongs to multiple groups:

- **Type permissions:** The **strictest** (most restrictive) permission applies
- **Attribute permissions:** The **strictest** permission applies

**Example:**
- User is in "Design Team" (Edit permission on Products)
- User is also in "Reviewers" (Read permission on Products)
- Result: User has **Read** permission (more restrictive)

---

## Type Manager

The Type Manager allows you to organize entities into hierarchical taxonomies.

### Accessing Type Manager

Navigate to **Admin > Type Manager** from the left sidebar.

### Understanding Entity Types

Each core entity has its own type hierarchy:

- **Product** - Style types (e.g., Apparel > Womens > Tops > T-Shirts)
- **Material** - Material categories (e.g., Fabric > Knit > Jersey)
- **Supplier** - Supplier categories (e.g., Manufacturers > Knit Mills)
- **Color** - Color groups (e.g., Seasonal Colors > Spring 2025)
- **Season** - Season types (e.g., Collections > Spring/Summer)

### Creating Type Nodes

1. Select an entity type from the tabs
2. Right-click on a node (or root) and select **Add Child**
3. Enter:
   - **Name** - Display name (e.g., "T-Shirts")
   - **Code** - Short code (e.g., "TSH")
4. Click **Create**

### Managing Type Nodes

#### Editing

1. Right-click on a node
2. Select **Edit**
3. Update name or code
4. Click **Update**

#### Deleting

1. Right-click on a node
2. Select **Delete**
3. Confirm deletion

**Warning:** You cannot delete nodes that:
- Have child nodes (delete children first)
- Are assigned to existing entities

### Best Practices

- **Plan your hierarchy** before creating many records
- **Keep hierarchies shallow** (2-4 levels) for ease of use
- **Use consistent naming** across entity types
- **Create codes** that are meaningful and searchable

---

## Attribute Manager

The Attribute Manager lets you define custom fields for entity types without changing the database schema.

### Accessing Attribute Manager

Navigate to **Admin > Attribute Manager** from the left sidebar.

### Understanding Attributes

Attributes are custom fields that extend the base entity structure. Each attribute has:

- **Key** - Internal identifier (e.g., `brand`, `season_year`)
- **Label** - Display name (e.g., "Brand", "Season Year")
- **Data Type** - The type of data stored
- **Required** - Whether the field must be filled in
- **Scope** - Which type nodes can use this attribute

### Data Types

| Type | Description | Example |
|------|-------------|---------|
| **String** | Text input | Brand name, description |
| **Number** | Numeric input | Quantity, price, size |
| **Boolean** | True/False checkbox | Is organic, is active |
| **Date** | Date picker | Launch date, deadline |
| **Enum** | Dropdown selection | Status, category |

### Creating Attributes

1. Select an entity type from the tabs
2. Click **Create New Attribute**
3. Fill in the form:
   - **Key** - Unique identifier (lowercase, no spaces)
   - **Label** - Display name
   - **Data Type** - Select from dropdown
   - **Required** - Check if mandatory
   - **Entity Type** - Pre-selected
   - **Applicable Types** - Select which type nodes can use this attribute
   - **Order** - Display order (higher = shown first)
4. For **Enum** type, click **Add Option** to define dropdown choices
5. Click **Create Attribute**

### Attribute Scope

The **Applicable Types** setting determines where an attribute appears:

- **Applied to a parent node:** Attribute is available to that node and all descendants
- **Applied to a specific node:** Only that node and its descendants see the attribute

**Example:**
- Create `brand` attribute for "Product > Apparel"
- The `brand` field will appear for all products under Apparel
- Products under other types (e.g., Accessories) won't see it

### Editing Attributes

1. Find the attribute in the list
2. Click **Edit**
3. Modify settings (cannot change Key or Entity Type)
4. Click **Update Attribute**

### Deactivating Attributes

Instead of deleting attributes (which would lose data):

1. Edit the attribute
2. Uncheck **Active**
3. Click **Update Attribute**

Inactive attributes are hidden but data is preserved.

---

## Managing Entities

### Products

Products represent styles, SKUs, or items in your catalog.

#### Creating a Product

1. Navigate to **Products** from the sidebar
2. Click **Create New Product**
3. **Step 1:** Select a product type from the tree
4. **Step 2:** Fill in the form:
   - **Style Code** - Unique identifier (e.g., "TSH-001")
   - **Name** - Product name
   - **Gender** - Target gender
   - **Status** - Development stage
   - **Season** - Optional season assignment
   - **Custom Attributes** - Fields based on selected type
5. Click **Create Product**

#### Viewing Products

1. Click on a product in the list
2. View tabs:
   - **Details** - Product information
   - **BOM** - Bill of materials (see BOM section)

#### Editing Products

1. Navigate to a product
2. Click **Edit** button
3. Modify fields (if you have edit permission)
4. Click **Update Product**

### Materials

Materials represent fabrics, trims, components, and supplies.

#### Creating a Material

1. Navigate to **Materials**
2. Click **Create New Material**
3. Select material type
4. Fill in:
   - **Material Code** - Unique identifier
   - **Name** - Material name
   - **Status** - Development status
   - **Custom Attributes**
5. Click **Create Material**

#### Linking Suppliers

1. View a material
2. Click **Add Supplier** (if implemented)
3. Select supplier and enter price information

#### Linking Colors

1. View a material
2. Click **Add Color** (if implemented)
3. Select applicable colors

### Suppliers

Suppliers represent vendors, manufacturers, and mills.

#### Creating a Supplier

1. Navigate to **Suppliers**
2. Click **Create New Supplier**
3. Select supplier type
4. Fill in:
   - **Supplier Code** - Unique identifier
   - **Name** - Company name
   - **Region** - Geographic location
   - **Status** - Active/Inactive
   - **Custom Attributes**
5. Click **Create Supplier**

### Colors

Colors represent your color standards and palettes.

#### Creating a Color

1. Navigate to **Colors**
2. Click **Create New Color**
3. Select color type (if type hierarchy exists)
4. Fill in:
   - **Color Code** - Unique identifier (e.g., "BLK", "NAV")
   - **Name** - Color name (e.g., "Black", "Navy")
   - **RGB Hex** - Color code (e.g., "#000000")
   - **Status** - Active/Inactive
   - **Custom Attributes**
5. Click **Create Color**

### Seasons

Seasons represent collections, delivery periods, or planning cycles.

#### Creating a Season

1. Navigate to **Seasons**
2. Click **Create New Season**
3. Fill in:
   - **Code** - Season code (e.g., "SS25")
   - **Name** - Season name (e.g., "Spring/Summer 2025")
   - **Year** - Year
   - **Status** - Planning stage
   - **Custom Attributes**
4. Click **Create Season**

---

## Bill of Materials (BOM)

The BOM defines what materials go into a product, including quantities and specifications.

### Accessing BOM

1. Navigate to a product
2. Click the **BOM** tab

### BOM Structure

Each BOM contains line items with:
- **Line Number** - Sequential order
- **Material** - Selected from material library
- **Color** - Optional color variant
- **Supplier** - Optional source
- **Quantity** - Amount required
- **Unit** - Unit of measurement (e.g., yards, meters, pieces)

### Adding BOM Items

1. In the BOM tab, click **Add Item**
2. Fill in the dialog:
   - **Material** - Search and select a material
   - **Color** - Optional color selection
   - **Supplier** - Optional supplier
   - **Quantity** - Amount needed
   - **Unit** - Unit of measure
3. Click **Add**

### Editing BOM Items

1. Click **Edit** on a BOM line
2. Modify fields
3. Click **Update**

### Changing Material Variants

For materials with multiple colors or suppliers:

1. Click **Change Color** to select a different color variant
2. Click **Change Supplier** to select a different source

### Deleting BOM Items

1. Click **Delete** on a BOM line
2. Confirm deletion

### BOM Best Practices

- **Maintain accurate quantities** for costing accuracy
- **Specify suppliers** when source matters for quality or price
- **Use color variants** to track color-specific materials
- **Keep BOMs up to date** as product designs evolve

---

## Dashboard

The dashboard provides an overview of your PLM data and quick access to reports.

### Season Dashboard

1. Navigate to **Dashboard**
2. In the Season Dashboard card:
   - **Select Season** - Choose a season to analyze
   - **Group By** - Choose how to aggregate data (e.g., by product status)
   - Click **Run** to generate the report
3. View the aggregated results

### Custom Dashboards

(Placeholder for future custom dashboard features)

---

## Tips & Best Practices

### General

- **Use consistent naming conventions** across all entity types
- **Assign entities to types** for better organization and permission control
- **Review permissions regularly** to ensure appropriate access
- **Use seasons** to organize products into collections

### Performance

- **Use filters** when browsing large lists
- **Search by code** for faster lookups
- **Close unused tabs** to keep interface responsive

### Data Quality

- **Require key attributes** (mark as required in Attribute Manager)
- **Standardize units** of measurement across BOMs
- **Validate supplier information** before assigning to materials
- **Keep color standards current** and archive unused colors

### Security

- **Use strong passwords** and change them regularly
- **Limit super admin accounts** to only essential personnel
- **Review user access** when people change roles
- **Set attribute permissions** for sensitive data (pricing, costing)

---

## Troubleshooting

### Cannot Access a Feature

**Check:**
1. Your group's type-level permissions for that entity
2. Your user account is in the correct group
3. The feature requires a specific permission level

**Solution:** Contact your administrator to adjust permissions.

### Cannot See Custom Attributes

**Check:**
1. The attribute is marked as **Active**
2. The attribute scope includes your entity's type
3. Your group has appropriate attribute permissions

**Solution:** Admin should verify attribute configuration and permissions.

### Changes Not Saving

**Check:**
1. You have **Edit** or higher permission
2. All required fields are filled in
3. Your session hasn't expired

**Solution:** Refresh the page and log in again if needed.

### BOM Items Not Appearing

**Check:**
1. Materials exist in the material library
2. You have permission to view materials
3. BOM has been saved properly

**Solution:** Verify material library and refresh the page.

---

## Support

For technical support or feature requests:
- Contact your system administrator
- Report issues on the project GitHub repository
- Refer to the technical documentation for advanced configuration

---

## Appendix: Glossary

| Term | Definition |
|------|------------|
| **Entity** | Core data objects (Product, Material, Supplier, Color, Season) |
| **Type Node** | A node in the hierarchical type tree |
| **Attribute** | Custom field added to an entity type |
| **Scope** | Which type nodes an attribute applies to |
| **BOM** | Bill of Materials - list of components in a product |
| **Permission Level** | The access level assigned to a user group |
| **Super Admin** | User with unrestricted system access |
| **Type Hierarchy** | Tree structure organizing entity types |
| **JSONB** | Database format for storing custom attributes |
| **RLS** | Row Level Security - database-level access control |

---

**Document Version:** 1.0
**Last Updated:** January 2025
**System Version:** FlexLite PLM v0.1.0
