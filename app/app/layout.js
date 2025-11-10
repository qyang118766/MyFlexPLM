import './globals.css';
import AppLayout from '@/components/AppLayout';
import { createClient } from '@/lib/supabase/server';

export const metadata = {
  title: 'FlexLite PLM',
  description: 'Lightweight Product Lifecycle Management System',
};

export default async function RootLayout({ children }) {
  let user = null;
  let isSuperAdmin = false;

  try {
    const supabase = await createClient();
    const {
      data: { user: supabaseUser },
      error,
    } = await supabase.auth.getUser();

    if (!error && supabaseUser) {
      user = supabaseUser;

      // Get user's superadmin status from database
      const { data: userData } = await supabase
        .from('users')
        .select('is_superadmin')
        .eq('id', supabaseUser.id)
        .single();

      isSuperAdmin = userData?.is_superadmin || false;
    }
  } catch (error) {
    console.error('Unable to determine auth state, rendering logged-out layout.', error);
  }

  // 如果是登录页面，不使用 AppLayout
  return (
    <html lang="en">
      <body>
        {user ? <AppLayout user={user} isSuperAdmin={isSuperAdmin}>{children}</AppLayout> : children}
      </body>
    </html>
  );
}
