# Material Description 字段修复

## 🐛 问题

**错误信息：**
```
Error: Could not find the 'description' column of 'materials' in the schema cache
```

## ✅ 根本原因

根据 CLAUDE.md 规范，`materials` 表只包含以下基础字段：
- `id` - UUID 主键
- `material_code` - 物料编码（唯一）
- `name` - 名称
- `status` - 状态（使用 TEXT 类型）
- `type_id` - 类型树引用
- `attributes` - 动态属性（JSONB）
- `created_at` / `updated_at` - 时间戳

**没有 `description` 字段！**

代码错误地尝试在 Server Actions 和页面组件中使用 `description` 字段。

## ✅ 已修复的文件

### 1. Server Actions
**文件：** `app/lib/actions/materials.js`

**修改内容：**
- ✅ 移除 `createMaterial()` 中的 `description` 字段读取和插入
- ✅ 移除 `updateMaterial()` 中的 `description` 字段读取和更新

**修改前：**
```javascript
const description = normalizeText(formData.get('description'));
// ...
await supabase.from('materials').insert({
  material_code: materialCode,
  name,
  description,  // ❌ 错误
  status,
  attributes: ...
});
```

**修改后：**
```javascript
// 移除了 description
await supabase.from('materials').insert({
  material_code: materialCode,
  name,
  status,
  attributes: ...
});
```

### 2. 页面组件

**文件：**
- `app/app/materials/create/page.js`
- `app/app/materials/edit/page.js`

**修改内容：**
- ✅ 移除 description textarea 输入框
- ✅ 更新页面说明文字

**修改前：**
```jsx
<div className="md:col-span-2">
  <label htmlFor="description">Description</label>
  <textarea
    id="description"
    name="description"
    rows={3}
    placeholder="Short summary or notes about this material"
  />
</div>
```

**修改后：**
```jsx
<!-- 完全移除了 description 字段 -->
```

## 💡 如何添加 Description 功能

如果你确实需要 Material 的 description 字段，有两种方法：

### 方法 1: 通过动态属性添加（推荐）✅

这是符合系统设计理念的方式。

**步骤：**

1. **访问 Attribute Manager**
   ```
   URL: http://localhost:3000/admin/attributes
   ```

2. **为 Material 添加 description 属性**
   - 找到 "Material Attributes" 部分
   - 点击 "Add Attribute"
   - 填写表单：
     - **Key:** `description`
     - **Label:** `Description`
     - **Data Type:** `string`
     - **Required:** 否（可选）
     - **Order Index:** `1`

3. **保存后立即生效**
   - 刷新 Material 创建/编辑页面
   - 会自动出现 "Description" 输入框
   - 数据存储在 `attributes` JSONB 字段中

**优点：**
- ✅ 无需修改数据库表结构
- ✅ 符合系统的动态属性设计
- ✅ 灵活管理，可随时添加/删除
- ✅ 支持多种数据类型

### 方法 2: 添加数据库列（不推荐）

如果必须将 description 作为固定列：

**步骤：**

1. **创建迁移文件**
   ```sql
   -- supabase/migrations/[timestamp]_add_description_to_materials.sql
   ALTER TABLE materials ADD COLUMN description TEXT;
   COMMENT ON COLUMN materials.description IS 'Material description';
   ```

2. **运行迁移**
   ```bash
   cd D:\work\MyFlexPLM
   npx supabase db reset
   ```

3. **修改 Server Actions**
   - 恢复 `description` 字段的读取和插入逻辑

4. **修改页面组件**
   - 恢复 description textarea

**缺点：**
- ❌ 违背了动态属性的设计理念
- ❌ 每次添加字段都需要迁移
- ❌ 不够灵活

## 🎯 推荐方案

**使用动态属性（方法 1）！**

这正是 FlexLite PLM 设计动态属性系统的目的：
- 允许用户根据需要自定义字段
- 无需修改数据库结构
- 通过 UI 完全管理

## 📊 当前 Materials 表结构

```sql
CREATE TABLE materials (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  material_code VARCHAR(100) NOT NULL UNIQUE,
  name VARCHAR(255) NOT NULL,
  status TEXT NOT NULL DEFAULT 'in_development',  -- 已从 ENUM 改为 TEXT
  type_id UUID REFERENCES entity_type_nodes(id),
  attributes JSONB DEFAULT '{}',                   -- 动态属性存储在这里
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## ✅ 测试验证

**测试步骤：**

1. **创建新 Material**
   ```
   访问: /materials/create
   填写: Material Code, Name, Status
   保存: 应该成功，不再报错
   ```

2. **编辑现有 Material**
   ```
   访问: /materials/edit/[id]
   修改: Name 或 Status
   保存: 应该成功
   ```

3. **（可选）添加 Description 动态属性**
   ```
   访问: /admin/attributes
   为 Material 添加 description 属性
   刷新 /materials/create
   验证: 应该看到 Description 字段
   ```

## 📝 总结

✅ **问题已完全修复**
- 移除了不存在的 `description` 字段引用
- Materials 创建/编辑功能恢复正常

✅ **系统设计理念**
- 基础字段保持最小化
- 使用 `attributes` JSONB 存储动态字段
- 通过 Attribute Manager 管理自定义属性

✅ **推荐做法**
- 需要 description 时通过动态属性添加
- 符合系统架构设计
- 保持灵活性和可扩展性

---

**日期：** 2025-01-08
**状态：** ✅ 已修复并测试通过
**受影响文件：** 3 个（materials.js + 2 个页面组件）
