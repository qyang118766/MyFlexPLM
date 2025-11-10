-- Create Initial Admin User for FlexLite PLM
-- Email: admin@flexlite.local
-- Password: 123456
--
-- Run this with: npx supabase db reset
-- Or execute manually in Supabase SQL Editor

-- Step 1: Create the user in Supabase Auth
-- Note: You need to run this in the Supabase SQL Editor with proper permissions
-- Or use Supabase Dashboard: Authentication > Users > Add User

-- For manual creation:
-- 1. Go to Supabase Dashboard: Authentication > Users > Add User
-- 2. Email: admin@flexlite.local
-- 3. Password: 123456
-- 4. Auto Confirm User: Yes
-- 5. Then run the UPDATE statement below

-- Step 2: Update user in public.users table to make them admin
-- Replace 'USER_ID_HERE' with the actual user ID from step 1

-- If you created the user manually, find their ID:
-- SELECT id FROM auth.users WHERE email = 'admin@flexlite.local';

-- Then update their role:
UPDATE public.users
SET
  role = 'admin',
  is_superadmin = true,
  display_name = 'System Administrator'
WHERE email = 'admin@flexlite.local';

-- Verify the admin user was created correctly:
SELECT
  id,
  email,
  display_name,
  role,
  is_superadmin,
  created_at
FROM public.users
WHERE email = 'admin@flexlite.local';
