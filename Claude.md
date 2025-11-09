# FlexLite PLM – Claude Spec (JS Only, MVP)

Lightweight internal PLM-style app inspired by FlexPLM.  
Core focus: Seasons, Products, Materials, Suppliers, Colors and a single-level BOM editor.

This spec is for a code agent (Claude Code) when running `/init` in an empty repo.

---

## 1. Tech Stack & Rules

**Stack**

- Next.js (App Router, latest)
- React Server Components (RSC) for backend logic
- **JavaScript only** – `.js` / `.jsx` (no TypeScript)
- shadcn/ui + Tailwind CSS
- Supabase:
  - PostgreSQL database
  - Auth (email + password, used as “username/password”)
- Hosting target: Vercel

**Rules for the agent**

- Do NOT use TypeScript or `.ts` / `.tsx`.
- Prefer RSC + server actions instead of a separate Node backend.
- Keep schema and code simple and readable for future agentic updates.

---

## 2. Domain & Scope (MVP)

Internal single-tenant tool, English UI only.

**Core classes**

1. Season  
2. Product  
3. Material  
4. Supplier  
5. Color  

**Relationships**

- Product may or may not be linked to a Season.
- Each Product has a **single-level BOM** (no nested BOMs).
- BOM items pick Materials from the Material Library.
- Materials can exist without a Supplier.  
  - Pricing/quoting uses a separate Material–Supplier link.
- Materials can be linked to Colors.
- BOM item can specify:
  - Material
  - Color variant
  - Source variant (Supplier)

**Permissions**

- Auth via Supabase email/password.
- One `admin` user with full permissions for MVP.
- Permissions data model should allow future groups/roles, but only `admin` is used now.

**Out of scope for MVP**

- Approval workflows / RFA processes (will be added later).
- Multi-tenant support.
- Advanced dashboards, reports and analytics.

---

## 3. Data Model (Minimal)

Design tables to be easy to extend.  
Each core table has:
- A few base columns (~5)
- `type_id` referencing a generic **Type Tree**
- `attributes` JSONB for dynamic/custom columns

### 3.1 Type Tree & Attributes (Type Manager)

Used to implement a “Type Manager” where admins can define:

- Subtypes in a **tree** for each core class  
  (e.g. Product → Apparel → Womens → Tops)
- Dynamic attributes that appear as extra columns/fields

**Table: `entity_type_nodes`**

- `id` (PK, UUID)
- `entity_type` (`'season' | 'product' | 'material' | 'supplier' | 'color'`)
- `parent_id` (nullable FK → `entity_type_nodes.id`)
- `name` (display name)
- `code` (optional short code)
- `created_at`, `updated_at`

**Table: `attribute_definitions`**

- `id` (PK, UUID)
- `entity_type` (same enum as above)
- `key` (internal name, e.g. `brand`)
- `label` (display label)
- `data_type` (`'string' | 'number' | 'boolean' | 'date' | 'enum'`)
- `required` (boolean)
- `order_index` (number for UI ordering)
- `options` (JSONB, e.g. enum values)
- `is_active` (boolean)
- `created_at`, `updated_at`

Each core entity table includes `attributes` (JSONB).  
Type Manager UI lets admin add/edit attribute_definitions and type tree nodes; forms and tables render additional fields/columns based on these definitions.

### 3.2 Core Tables (Base Fields)

Keep base fields small; everything else can go into `attributes`.

**Table: `seasons`**

- `id` (PK, UUID)
- `code` (string, unique)
- `name` (string)
- `year` (integer)
- `status` (`planned | active | archived` as text)
- `type_id` (FK → `entity_type_nodes.id` where `entity_type = 'season'`)
- `attributes` (JSONB)
- `created_at`, `updated_at`

**Table: `products`**

- `id` (PK, UUID)
- `style_code` (string, unique)
- `name` (string)
- `gender` (string)
- `status` (`development | pre-production | production | inactive`)
- `season_id` (nullable FK → `seasons.id`)
- `type_id` (FK → `entity_type_nodes.id` where `entity_type = 'product'`)
- `attributes` (JSONB)
- `created_at`, `updated_at`

**Table: `materials`**

- `id` (PK, UUID)
- `material_code` (string, unique)
- `name` (string)
- `status` (`in_development | active | dropped | rfq`)
- `type_id` (FK → `entity_type_nodes.id` where `entity_type = 'material'`)
- `attributes` (JSONB)
- `created_at`, `updated_at`

**Table: `suppliers`**

- `id` (PK, UUID)
- `supplier_code` (string, unique)
- `name` (string)
- `region` (string)
- `status` (`active | inactive`)
- `type_id` (FK → `entity_type_nodes.id` where `entity_type = 'supplier'`)
- `attributes` (JSONB)
- `created_at`, `updated_at`

**Table: `colors`**

- `id` (PK, UUID)
- `color_code` (string, unique)
- `name` (string)
- `rgb_hex` (string, optional)
- `status` (`active | inactive`)
- `type_id` (FK → `entity_type_nodes.id` where `entity_type = 'color'`)
- `attributes` (JSONB)
- `created_at`, `updated_at`

### 3.3 Relations: Material–Supplier, Material–Color, Product–BOM

**Table: `material_suppliers`**

- `id` (PK, UUID)
- `material_id` (FK → `materials.id`)
- `supplier_id` (FK → `suppliers.id`)
- `price` (numeric, nullable)
- `currency` (string, e.g. `USD`)
- `attributes` (JSONB)
- `created_at`, `updated_at`

**Table: `material_colors`**

- `id` (PK, UUID)
- `material_id` (FK → `materials.id`)
- `color_id` (FK → `colors.id`)
- `created_at`, `updated_at`

**Table: `product_boms`**

- `id` (PK, UUID)
- `product_id` (FK → `products.id`)
- `name` (string, e.g. `Default BOM`)
- `status` (`draft | active | archived`)
- `created_at`, `updated_at`

**Table: `bom_items`**

Single-level BOM items.

- `id` (PK, UUID)
- `bom_id` (FK → `product_boms.id`)
- `line_number` (integer)
- `material_id` (FK → `materials.id`)
- `color_id` (nullable FK → `colors.id`)        // color variant
- `supplier_id` (nullable FK → `suppliers.id`)  // source variant
- `quantity` (numeric)
- `unit` (string)
- `attributes` (JSONB)
- `created_at`, `updated_at`

### 3.4 Users (Admin Only for MVP)

**Table: `users`**

- `id` (UUID, matches Supabase Auth user id)
- `email`
- `display_name`
- `is_admin` (boolean)
- `created_at`, `updated_at`

For MVP all pages assume `is_admin = true`.

---

## 4. UI / Pages (Layout similar to FlexPLM)

Use shadcn/ui + Tailwind.  
Layout roughly matches the screenshots:

- Top bar: app name (`FlexLite PLM`), search box placeholder, user menu.
- Left panel: navigation + libraries (tree style).
- Right/main area: forms, lists and dashboards.

### 4.1 Main Navigation

- Dashboard (`/`)
- Seasons (`/seasons`)
- Products (`/products`)
- Materials (`/materials`)
- Suppliers (`/suppliers`)
- Colors (`/colors`)
- Admin
  - Type Manager (`/admin/types`)
  - Attribute Manager (`/admin/attributes`)

### 4.2 Screen Sketches

**Dashboard**

- Card: Welcome / Notice.
- Simple “Season dashboard” card:
  - Season select
  - Group-by select (e.g. by product status)
  - `Run` button → show a simple aggregated list/table.
- Other dashboard cards can be placeholders for now.

**Products**

- `/products`:
  - Left: product type tree from `entity_type_nodes`.
  - Top: filter bar (keyword, season, status).
  - Center: product table.
  - Actions: View/Edit, Open BOM, Create New.
- `/products/new`:
  - Step 1: pick product type from tree.
  - Step 2: form with base fields + dynamic attributes.
- `/products/[id]`:
  - Tabs: Details, BOM.
- `/products/[id]/bom`:
  - Single BOM table:
    - Material, Color, Supplier, Qty, Unit, line actions.
  - Actions:
    - Add line (dialog: pick material, optional color & supplier, qty&unit).
    - Replace material.
    - Change color variant (choose color for that material).
    - Change source variant (choose supplier for that material).

**Materials**

- Similar to Products:
  - List/search.
  - New/edit forms with links to suppliers and colors.

**Suppliers & Colors**

- Simple list + create/edit pages.

**Type Manager**

- `/admin/types`:
  - For each entity_type, display and edit a tree of `entity_type_nodes`.
  - Allow add / rename / delete nodes while keeping a valid tree.
- `/admin/attributes`:
  - For each entity_type, table of attribute_definitions.
  - Add, edit, deactivate attributes.
  - These definitions should drive extra fields on forms and extra columns in tables.

---

## 5. Implementation Plan for the Agent

Keep steps small and focused:

1. **Project bootstrap**
   - Create Next.js App Router project in JS mode.
   - Set up Tailwind & shadcn/ui.
   - Implement global layout (top bar + left nav + main area).

2. **Supabase integration**
   - Add Supabase JS client (server & client helpers).
   - Create SQL schema for all tables described above.
   - Document needed env vars.

3. **Auth & admin user**
   - Implement email/password login (Supabase).
   - Protect app routes behind login.
   - Use `users.is_admin` to gate admin pages (for now assume single admin).

4. **CRUD pages**
   - Seasons, Products, Materials, Suppliers, Colors:
     - RSC-based list + create/edit pages.
     - Include `type_id` selection and dynamic attributes rendering.

5. **Type Manager**
   - Pages for editing `entity_type_nodes` (tree) and `attribute_definitions`.
   - Use these definitions to render extra fields/columns on entity forms & tables.

6. **BOM editor**
   - Implement `product_boms` and `bom_items` queries/mutations via RSC/server actions.
   - Build BOM tab for Product with add/replace/color-variant/source-variant actions.

The agent should keep code modular and documented so future approval workflow and RFA features can be added on top of this foundation.
