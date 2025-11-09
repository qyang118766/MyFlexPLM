# Master Table Refactoring

## 概述

本次重构将项目标识（item identity）和版本数据（version data）分离到不同的表中，实现更清晰的数据架构和更好的版本控制。

## 架构设计

### 两层架构

```
┌─────────────────────┐         ┌──────────────────────┐
│  Master Table       │         │  Detail Table        │
│  (项目唯一性)       │ 1 ──┬──▶ N │  (版本数据)          │
├─────────────────────┤      │   ├──────────────────────┤
│ code (PK)           │      │   │ id (PK)              │
│ created_at          │      │   │ code (FK)            │
│ created_by          │      │   │ name                 │
│ updated_at          │      │   │ ...other fields      │
└─────────────────────┘      │   │ version              │
                             │   │ iteration            │
                             │   │ is_latest            │
                             │   │ create_by            │
                             │   │ update_by            │
                             └─  └──────────────────────┘
```

### Master 表

**作用：**
- 保证 code 的唯一性
- 记录项目的创建元数据
- 作为所有版本的"锚点"

**字段：**
- `code` - 主键，唯一标识符（style_code/material_code/supplier_code）
- `created_at` - 创建时间
- `created_by` - 创建者
- `updated_at` - 最后更新时间

**三张 Master 表：**
1. `product_master` - style_code 唯一
2. `material_master` - material_code 唯一
3. `supplier_master` - supplier_code 唯一

### Detail 表（原表）

**作用：**
- 存储版本数据
- 记录完整的版本历史
- 通过 `is_latest` 标记当前版本

**字段改变：**
- `code` - 不再唯一，外键引用 master 表
- `version` - 大版本号（A-Z）
- `iteration` - 小版本号（1,2,3...）
- `is_latest` - 标记是否为最新版本

**约束：**
- `FOREIGN KEY (code) REFERENCES master_table(code)` - 必须关联 master
- `UNIQUE (code, version, iteration)` - 版本唯一性
- `UNIQUE INDEX ON (code) WHERE is_latest = TRUE` - 每个 code 只能有一个最新版本

## 数据库迁移

### Migration: 20250109000002_create_master_tables.sql

**主要操作：**

1. **创建 Master 表**
   ```sql
   CREATE TABLE product_master (
     style_code VARCHAR PRIMARY KEY,
     created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
     created_by TEXT NOT NULL,
     updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
   );
   ```

2. **添加外键约束**
   ```sql
   ALTER TABLE products
     ADD CONSTRAINT fk_products_master
     FOREIGN KEY (style_code)
     REFERENCES product_master(style_code)
     ON DELETE CASCADE;
   ```

3. **迁移现有数据**
   ```sql
   -- 将现有的 distinct code 迁移到 master 表
   INSERT INTO product_master (style_code, created_at, created_by)
   SELECT DISTINCT ON (style_code)
     style_code,
     created_at,
     COALESCE(create_by, 'system') as created_by
   FROM products
   WHERE style_code IS NOT NULL
   ORDER BY style_code, created_at ASC;
   ```

4. **创建便捷视图**
   ```sql
   CREATE OR REPLACE VIEW products_latest AS
   SELECT
     pm.style_code,
     pm.created_at as master_created_at,
     pm.created_by as master_created_by,
     p.*
   FROM product_master pm
   INNER JOIN products p ON pm.style_code = p.style_code
   WHERE p.is_latest = TRUE;
   ```

5. **性能索引**
   ```sql
   CREATE INDEX idx_products_style_code_latest
     ON products(style_code, is_latest) WHERE is_latest = TRUE;
   ```

## 代码重构

### 版本控制服务更新

**文件：** `app/lib/services/versionControl.js`

**新增函数：**

#### `ensureMasterRecord(entityType, code, userId)`

创建或验证 master 记录存在。

**返回：**
```javascript
{
  success: boolean,
  data: object,      // Master record
  isNew: boolean,    // 是否新创建
  error: string      // 错误信息（如果失败）
}
```

#### `masterRecordExists(entityType, code)`

检查 master 记录是否存在。

**返回：** `boolean`

#### `createVersionedItem(entityType, code, payload, userId)`

创建新项目（master + 第一个版本）。

**流程：**
1. 检查 master 是否已存在
2. 创建 master 记录
3. 创建第一个版本（A.1）
4. 如果失败，回滚 master

**返回：**
```javascript
{
  success: boolean,
  data: object,          // 版本记录
  masterRecord: object,  // Master 记录
  error: string          // 错误信息（如果失败）
}
```

### Server Actions 更新

**更新文件：**
- `app/lib/actions/products.js`
- `app/lib/actions/materials.js`
- `app/lib/actions/suppliers.js`

**创建操作变化：**

```javascript
// 旧代码
const payload = {
  style_code: styleCode,
  ...fields,
  version: 'A',
  iteration: 1,
  create_by: userId,
  update_by: userId,
};
await supabase.from('products').insert(payload);

// 新代码
const payload = {
  ...fields,  // 不包含 code 和 version
};
const result = await createVersionedItem('products', styleCode, payload, userId);
```

**更新操作保持不变：**
```javascript
const result = await executeVersionedUpdate('products', styleCode, payload, userId);
```

### 查询逻辑更新

**列表页更新：**
- `app/app/products/page.js`
- `app/app/materials/page.js`
- `app/app/suppliers/page.js`

**旧查询：**
```javascript
const { data } = await supabase
  .from('products')
  .select('*')
  .eq('is_latest', true);
```

**新查询（使用视图）：**
```javascript
const { data } = await supabase
  .from('products_latest')
  .select('*');
```

**视图优势：**
- 自动 JOIN master 和 detail 表
- 自动过滤 `is_latest = true`
- 包含 master 表的元数据
- 查询更简洁

## 工作流程

### 创建新项目

```
用户操作: 创建 Product (FLEX-001)
    ↓
Step 1: 检查 product_master 中 FLEX-001 是否存在
    ↓ (不存在)
Step 2: 在 product_master 创建记录
    ├─ style_code = 'FLEX-001'
    ├─ created_at = NOW()
    └─ created_by = 'user@example.com'
    ↓
Step 3: 在 products 创建第一个版本
    ├─ style_code = 'FLEX-001' (FK)
    ├─ version = 'A'
    ├─ iteration = 1
    ├─ is_latest = true
    ├─ name, status, ... (业务数据)
    ├─ create_by = 'user@example.com'
    └─ update_by = 'user@example.com'
    ↓
成功 ✓
```

### 更新现有项目

```
用户操作: 更新 Product (FLEX-001)
    ↓
Step 1: 在 products 查找 is_latest = true 的版本
    ↓ (找到 A.2)
Step 2: 将当前版本标记为非最新
    ├─ UPDATE products
    ├─ SET is_latest = false
    └─ WHERE id = (A.2 的 id)
    ↓
Step 3: 插入新版本
    ├─ style_code = 'FLEX-001' (不变)
    ├─ version = 'A' (不变)
    ├─ iteration = 3 (递增)
    ├─ is_latest = true
    ├─ name, status, ... (新数据)
    ├─ create_by = (保留原始创建者)
    └─ update_by = 'user@example.com'
    ↓
成功 ✓

数据库状态:
  FLEX-001 → A.1 (is_latest = false)
  FLEX-001 → A.2 (is_latest = false)
  FLEX-001 → A.3 (is_latest = true) ← 当前版本
```

### 查询最新版本

```
用户操作: 访问产品列表
    ↓
SQL 查询: SELECT * FROM products_latest
    ↓
视图展开为:
  SELECT
    pm.style_code,
    pm.created_at as master_created_at,
    pm.created_by as master_created_by,
    p.*
  FROM product_master pm
  INNER JOIN products p ON pm.style_code = p.style_code
  WHERE p.is_latest = TRUE
    ↓
返回结果: 每个 style_code 一条记录（最新版本）
```

## 数据完整性

### 外键级联

**ON DELETE CASCADE:**
```sql
ALTER TABLE products
  ADD CONSTRAINT fk_products_master
  FOREIGN KEY (style_code)
  REFERENCES product_master(style_code)
  ON DELETE CASCADE;
```

**效果：**
- 删除 master 记录 → 自动删除所有版本
- 保证数据一致性
- 避免孤儿记录

### 唯一性约束

**Master 表：**
- `code PRIMARY KEY` - 绝对唯一

**Detail 表：**
- `(code, version, iteration) UNIQUE` - 版本唯一
- `(code) UNIQUE WHERE is_latest = TRUE` - 只能有一个最新版本

### 触发器

**自动更新 updated_at：**
```sql
CREATE TRIGGER set_product_master_updated_at
  BEFORE UPDATE ON product_master
  FOR EACH ROW
  EXECUTE FUNCTION update_master_updated_at();
```

## 对比：重构前后

### 创建操作

| 方面 | 重构前 | 重构后 |
|------|--------|--------|
| 表操作 | 1 次 INSERT (products) | 2 次 INSERT (master + products) |
| 唯一性检查 | 数据库约束（UNIQUE） | 应用层 + 数据库约束 |
| 代码重复 | 分散在各 action | 集中在 versionControl.js |
| 错误处理 | 简单 | 带回滚机制 |

### 查询操作

| 方面 | 重构前 | 重构后 |
|------|--------|--------|
| 最新版本查询 | `WHERE is_latest = true` | `FROM products_latest` (视图) |
| 表数量 | 1 个 | 2 个（通过视图简化） |
| 查询复杂度 | 简单 | 简单（视图封装） |
| 性能 | 全表扫描 + 索引 | JOIN + 索引（相当） |

### 更新操作

| 方面 | 重构前 | 重构后 |
|------|--------|--------|
| 操作流程 | 相同 | 相同 |
| master 更新 | 无 | 无需更新（master 不变） |
| 代码复杂度 | 中等 | 低（模块化） |

### 数据完整性

| 方面 | 重构前 | 重构后 |
|------|--------|--------|
| code 唯一性 | Detail 表 UNIQUE | Master 表 PRIMARY KEY |
| 版本唯一性 | `(code, v, i)` UNIQUE | `(code, v, i)` UNIQUE |
| 最新版本唯一 | 索引约束 | 索引约束 |
| 级联删除 | 无 | Master → Detail CASCADE |
| 孤儿记录风险 | 无 | 无（外键保护） |

## 优势总结

### 1. 清晰的数据架构

✅ **职责分离**
- Master 表：管理项目标识和唯一性
- Detail 表：管理版本数据和历史

✅ **易于理解**
- 一目了然的两层结构
- 清晰的关系映射（1:N）

### 2. 更强的数据完整性

✅ **唯一性保证**
- Master PRIMARY KEY 保证 code 绝对唯一
- 外键约束防止孤儿记录

✅ **级联操作**
- 删除 master 自动清理所有版本
- 避免数据不一致

### 3. 代码可维护性

✅ **模块化**
- 版本控制逻辑集中在一个模块
- 创建/更新流程标准化

✅ **可扩展性**
- 易于添加新的版本控制实体
- 统一的接口和错误处理

✅ **测试友好**
- 单一职责，易于测试
- 模拟和回滚更容易

### 4. 业务逻辑清晰

✅ **创建流程**
- 先建立身份（master）
- 再创建首个版本
- 逻辑直观

✅ **查询简化**
- 使用视图封装 JOIN
- 应用代码更简洁

## 潜在注意事项

### 1. 性能考虑

⚠️ **JOIN 开销**
- 每次查询需要 JOIN 两个表
- **缓解：** 使用视图 + 索引优化

⚠️ **INSERT 次数增加**
- 创建时需要两次 INSERT
- **缓解：** 影响微小，可接受

### 2. 迁移复杂度

⚠️ **现有数据迁移**
- 需要从 detail 表提取 distinct codes
- **缓解：** 迁移脚本自动处理

⚠️ **应用代码更新**
- 创建逻辑需要调整
- **缓解：** 集中在少数文件

### 3. 开发注意事项

⚠️ **必须先创建 master**
- 不能直接 INSERT detail 表
- **缓解：** 使用 `createVersionedItem()` 强制流程

⚠️ **外键约束**
- 删除 master 会级联删除所有版本
- **缓解：** 这正是期望的行为

## 迁移检查清单

### 数据库层

- [ ] 运行迁移 `20250109000001_refactor_version_control.sql`
- [ ] 运行迁移 `20250109000002_create_master_tables.sql`
- [ ] 验证 master 表已创建
- [ ] 验证外键约束已添加
- [ ] 验证视图已创建
- [ ] 验证现有数据已迁移
- [ ] 验证索引已创建

### 代码层

- [ ] 更新 `versionControl.js` 服务
- [ ] 更新 `products.js` actions
- [ ] 更新 `materials.js` actions
- [ ] 更新 `suppliers.js` actions
- [ ] 更新 products 列表页
- [ ] 更新 materials 列表页
- [ ] 更新 suppliers 列表页

### 测试

- [ ] 测试创建新产品
- [ ] 测试更新现有产品
- [ ] 测试列表查询
- [ ] 测试重复 code 创建（应失败）
- [ ] 测试版本历史查询
- [ ] 测试级联删除

## 示例代码

### 创建新产品

```javascript
import { createVersionedItem } from '@/lib/services/versionControl';

const result = await createVersionedItem(
  'products',
  'FLEX-001',
  {
    name: 'FlexLite Jacket',
    gender: 'unisex',
    status: 'development',
    type_id: 'uuid...',
    season_id: 'uuid...',
  },
  'user@example.com'
);

if (result.success) {
  console.log('Created:', result.data);
  console.log('Master:', result.masterRecord);
}
```

### 更新产品

```javascript
import { executeVersionedUpdate } from '@/lib/services/versionControl';

const result = await executeVersionedUpdate(
  'products',
  'FLEX-001',
  {
    name: 'FlexLite Jacket v2',
    status: 'production',
  },
  'user@example.com'
);

if (result.success) {
  console.log('New version:', result.data);
  console.log('Previous version:', result.previousVersion);
}
```

### 查询最新版本

```javascript
// 使用视图 - 推荐
const { data } = await supabase
  .from('products_latest')
  .select('*');

// 或手动 JOIN
const { data } = await supabase
  .from('product_master')
  .select(`
    *,
    products!inner(*)
  `)
  .eq('products.is_latest', true);
```

### 查询版本历史

```javascript
import { getVersionHistory } from '@/lib/services/versionControl';

const history = await getVersionHistory('products', 'FLEX-001');
history.forEach(version => {
  console.log(`Version ${version.version}.${version.iteration}`);
  console.log(`  Name: ${version.name}`);
  console.log(`  Status: ${version.status}`);
  console.log(`  Updated: ${version.updated_at}`);
});
```

---

**日期：** 2025-01-09
**状态：** ✅ 实现完成
**涉及实体：** Products, Materials, Suppliers
**迁移：** 20250109000002_create_master_tables.sql
**前置迁移：** 20250109000001_refactor_version_control.sql
