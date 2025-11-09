-- 创建触发器函数：当 auth.users 中创建新用户时，自动在 public.users 中创建记录
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, display_name, is_admin, created_at, updated_at)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'display_name', NEW.email),
    FALSE,
    NOW(),
    NOW()
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 创建触发器：在 auth.users 插入新记录后自动执行
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- 同步现有的 auth.users 到 public.users（如果有的话）
INSERT INTO public.users (id, email, display_name, is_admin, created_at, updated_at)
SELECT
  id,
  email,
  COALESCE(raw_user_meta_data->>'display_name', email) as display_name,
  FALSE as is_admin,
  created_at,
  updated_at
FROM auth.users
WHERE id NOT IN (SELECT id FROM public.users)
ON CONFLICT (id) DO NOTHING;
