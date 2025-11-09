import Link from 'next/link';
import { createClient } from '@/lib/supabase/server';
import ConfirmDeleteButton from '@/components/ConfirmDeleteButton';
import { removeSupplier } from './remove/action';

export default async function SuppliersPage() {
  const supabase = await createClient();

  // Use the suppliers_latest view which JOINs supplier_master with latest suppliers
  const { data: suppliers, error } = await supabase
    .from('suppliers_latest')
    .select('*')
    .order('created_at', { ascending: false });

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Suppliers</h1>
        <p className="mt-2 text-sm text-gray-600">
          Manage supplier information and relationships
        </p>
      </div>

      <div className="bg-white shadow rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-lg font-medium text-gray-900">All Suppliers</h2>
            <Link
              href="/suppliers/create"
              className="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700"
            >
              Create Supplier
            </Link>
          </div>

          {error && (
            <div className="text-red-600 mb-4">Error loading suppliers: {error.message}</div>
          )}

          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Supplier Code
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Name
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Region
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Status
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {suppliers && suppliers.length > 0 ? (
                  suppliers.map((supplier) => (
                    <tr key={supplier.id}>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        {supplier.supplier_code}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        <Link
                          href={`/suppliers/view?id=${supplier.id}`}
                          className="text-indigo-600 hover:text-indigo-800 font-medium"
                        >
                          {supplier.name}
                        </Link>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {supplier.region}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${
                          supplier.status === 'active' ? 'bg-green-100 text-green-800' :
                          'bg-gray-100 text-gray-800'
                        }`}>
                          {supplier.status}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 space-x-4">
                        <Link
                          href={`/suppliers/edit?supplierId=${supplier.id}`}
                          className="text-indigo-600 hover:text-indigo-900"
                        >
                          Edit
                        </Link>
                        <form action={removeSupplier} className="inline-block">
                          <input type="hidden" name="supplier_id" value={supplier.id} />
                          <ConfirmDeleteButton label="Delete" entityName="this supplier" />
                        </form>
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan="5" className="px-6 py-4 text-center text-sm text-gray-500">
                      No suppliers found
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
