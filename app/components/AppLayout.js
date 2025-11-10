'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { logout } from '@/lib/actions/auth';

const navigation = [
  { name: 'Dashboard', href: '/' },
  { name: 'Seasons', href: '/seasons' },
  { name: 'Products', href: '/products' },
  { name: 'Materials', href: '/materials' },
  { name: 'Suppliers', href: '/suppliers' },
  { name: 'Colors', href: '/colors' },
];

const adminNavigation = [
  { name: 'Users & Groups', href: '/admin/users' },
  { name: 'Type Manager', href: '/admin/types' },
  { name: 'Attribute Manager', href: '/admin/attributes' },
  { name: 'Enum Manager', href: '/admin/enums' },
  { name: 'Workflow Management', href: '/admin/workflows' },
];

export default function AppLayout({ children, user, isSuperAdmin }) {
  const pathname = usePathname();

  return (
    <div className="min-h-screen bg-gray-100">
      {/* Top Navigation Bar */}
      <nav className="bg-white shadow-sm border-b border-gray-200">
        <div className="mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex">
              <div className="flex-shrink-0 flex items-center">
                <h1 className="text-xl font-bold text-indigo-600">FlexLite PLM</h1>
              </div>
            </div>

            <div className="flex items-center">
              <div className="flex items-center space-x-4">
                <span className="text-sm text-gray-700">{user?.email}</span>
                <form action={logout}>
                  <button
                    type="submit"
                    className="text-sm text-gray-700 hover:text-gray-900"
                  >
                    Logout
                  </button>
                </form>
              </div>
            </div>
          </div>
        </div>
      </nav>

      <div className="flex">
        {/* Left Sidebar Navigation */}
        <aside className="w-64 bg-white shadow-sm min-h-[calc(100vh-4rem)]">
          <nav className="px-3 py-4">
            <div className="space-y-1">
              {navigation.map((item) => {
                const isActive = pathname === item.href;
                return (
                  <Link
                    key={item.name}
                    href={item.href}
                    className={`
                      block px-3 py-2 rounded-md text-sm font-medium
                      ${
                        isActive
                          ? 'bg-indigo-100 text-indigo-700'
                          : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'
                      }
                    `}
                  >
                    {item.name}
                  </Link>
                );
              })}
            </div>

            {/* Only show Admin menu for superadmin users */}
            {isSuperAdmin && (
              <div className="mt-8">
                <h3 className="px-3 text-xs font-semibold text-gray-500 uppercase tracking-wider">
                  Admin
                </h3>
                <div className="mt-2 space-y-1">
                  {adminNavigation.map((item) => {
                    const isActive = pathname === item.href;
                    return (
                      <Link
                        key={item.name}
                        href={item.href}
                        className={`
                          block px-3 py-2 rounded-md text-sm font-medium
                          ${
                            isActive
                              ? 'bg-indigo-100 text-indigo-700'
                              : 'text-gray-700 hover:bg-gray-100 hover:text-gray-900'
                          }
                        `}
                      >
                        {item.name}
                      </Link>
                    );
                  })}
                </div>
              </div>
            )}
          </nav>
        </aside>

        {/* Main Content Area */}
        <main className="flex-1 p-8">
          {children}
        </main>
      </div>
    </div>
  );
}
