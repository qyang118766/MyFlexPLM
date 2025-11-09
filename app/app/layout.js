import './globals.css';
import AppLayout from '@/components/AppLayout';
import { createClient } from '@/lib/supabase/server';

export const metadata = {
  title: 'FlexLite PLM',
  description: 'Lightweight Product Lifecycle Management System',
};

export default async function RootLayout({ children }) {
  let user = null;

  try {
    const supabase = await createClient();
    const {
      data: { user: supabaseUser },
      error,
    } = await supabase.auth.getUser();

    if (!error) {
      user = supabaseUser;
    }
  } catch (error) {
    console.error('Unable to determine auth state, rendering logged-out layout.', error);
  }

  // 如果是登录页面，不使用 AppLayout
  return (
    <html lang="en">
      <body>
        {user ? <AppLayout user={user}>{children}</AppLayout> : children}
      </body>
    </html>
  );
}
