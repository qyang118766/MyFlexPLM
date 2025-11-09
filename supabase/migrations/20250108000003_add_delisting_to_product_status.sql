-- 添加 delisting 状态到 product_status_enum
-- 这个迁移允许 PostgreSQL ENUM 接受 delisting 值

ALTER TYPE product_status_enum ADD VALUE IF NOT EXISTS 'delisting';

-- 注意：PostgreSQL ENUM 值只能添加，不能删除或重命名
-- 如果需要删除或重命名，必须重建整个 ENUM 类型
