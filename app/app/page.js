import Link from 'next/link';
import { createClient } from '@/lib/supabase/server';

export default async function Dashboard() {
  const supabase = await createClient();

  // 获取统计数据
  const [
    { count: seasonsCount },
    { count: productsCount },
    { count: materialsCount },
    { count: suppliersCount },
    { count: colorsCount },
  ] = await Promise.all([
    supabase.from('seasons').select('*', { count: 'exact', head: true }),
    supabase.from('products').select('*', { count: 'exact', head: true }),
    supabase.from('materials').select('*', { count: 'exact', head: true }),
    supabase.from('suppliers').select('*', { count: 'exact', head: true }),
    supabase.from('colors').select('*', { count: 'exact', head: true }),
  ]);

  const stats = [
    { name: 'Seasons', value: seasonsCount || 0, href: '/seasons' },
    { name: 'Products', value: productsCount || 0, href: '/products' },
    { name: 'Materials', value: materialsCount || 0, href: '/materials' },
    { name: 'Suppliers', value: suppliersCount || 0, href: '/suppliers' },
    { name: 'Colors', value: colorsCount || 0, href: '/colors' },
  ];

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
        <p className="mt-2 text-sm text-gray-600">
          Welcome to FlexLite PLM - Product Lifecycle Management
        </p>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-5 mb-8">
        {stats.map((stat) => (
          <Link
            key={stat.name}
            href={stat.href}
            className="bg-white overflow-hidden shadow rounded-lg hover:shadow-md transition-shadow"
          >
            <div className="p-5">
              <div className="flex items-center">
                <div className="flex-1">
                  <dt className="text-sm font-medium text-gray-500 truncate">
                    {stat.name}
                  </dt>
                  <dd className="mt-1 text-3xl font-semibold text-gray-900">
                    {stat.value}
                  </dd>
                </div>
              </div>
            </div>
          </Link>
        ))}
      </div>

      {/* Welcome Card */}
      <div className="bg-white shadow rounded-lg p-6 mb-6">
        <h2 className="text-lg font-medium text-gray-900 mb-4">Welcome to FlexLite PLM</h2>
        <div className="text-sm text-gray-600 space-y-2">
          <p>A lightweight Product Lifecycle Management system inspired by FlexPLM.</p>
          <p className="font-medium mt-4">Core Features:</p>
          <ul className="list-disc list-inside space-y-1 ml-4">
            <li>Seasons Management</li>
            <li>Products Management with BOM Editor</li>
            <li>Materials Library Management</li>
            <li>Suppliers Management</li>
            <li>Colors Library Management</li>
            <li>Type Manager and Attribute Manager (Dynamic Types and Attributes)</li>
          </ul>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="bg-white shadow rounded-lg p-6">
        <h2 className="text-lg font-medium text-gray-900 mb-4">Quick Actions</h2>
        <div className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3">
          <Link
            href="/seasons"
            className="border border-gray-300 rounded-lg p-4 hover:border-indigo-500 hover:shadow-sm transition-all"
          >
            <h3 className="font-medium text-gray-900">Manage Seasons</h3>
            <p className="text-sm text-gray-500 mt-1">Create and manage product seasons</p>
          </Link>
          <Link
            href="/products"
            className="border border-gray-300 rounded-lg p-4 hover:border-indigo-500 hover:shadow-sm transition-all"
          >
            <h3 className="font-medium text-gray-900">Manage Products</h3>
            <p className="text-sm text-gray-500 mt-1">Create products and edit BOMs</p>
          </Link>
          <Link
            href="/materials"
            className="border border-gray-300 rounded-lg p-4 hover:border-indigo-500 hover:shadow-sm transition-all"
          >
            <h3 className="font-medium text-gray-900">Manage Materials</h3>
            <p className="text-sm text-gray-500 mt-1">Maintain materials library and supplier relationships</p>
          </Link>
        </div>
      </div>
    </div>
  );
}
