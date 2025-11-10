import Link from 'next/link';
import { createClient } from '@/lib/supabase/server';
import ConfirmDeleteButton from '@/components/ConfirmDeleteButton';
import { removeProduct } from './remove/action';
import { getUserPermissionSummary, getUserAccessibleTypeNodes, checkUserPermission } from '@/lib/permissions';

export default async function ProductsPage() {
  const supabase = await createClient();

  // Get user permissions
  const permissionResult = await getUserPermissionSummary();
  const userPermissions = permissionResult.data;
  const productPermission = userPermissions?.entityPermissions?.product || 'none';

  // If user has no read permission, show access denied
  if (productPermission === 'none') {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-gray-900 mb-2">Access Denied</h1>
          <p className="text-gray-600">You do not have permission to view products.</p>
        </div>
      </div>
    );
  }

  // Get accessible type nodes for filtering
  const accessibleNodesResult = await getUserAccessibleTypeNodes('product');
  const accessibleNodeIds = accessibleNodesResult.data?.map(n => n.id) || [];

  // Use the products_latest view which JOINs product_master with latest products
  let query = supabase
    .from('products_latest')
    .select(`
      *,
      seasons (
        code,
        name
      )
    `)
    .order('created_at', { ascending: false });

  // Filter by accessible type nodes if not admin
  if (!userPermissions?.isAdmin && accessibleNodeIds.length > 0) {
    query = query.in('type_id', accessibleNodeIds);
  }

  const { data: products, error } = await query;

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Products</h1>
        <p className="mt-2 text-sm text-gray-600">
          Manage products and BOMs
        </p>
      </div>

      <div className="bg-white shadow rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-lg font-medium text-gray-900">
              All Products
              {!userPermissions?.isAdmin && (
                <span className="ml-2 text-xs text-gray-500">
                  (Permission: {productPermission})
                </span>
              )}
            </h2>
            {(['create', 'delete', 'full'].includes(productPermission) || userPermissions?.isAdmin) && (
              <Link
                href="/products/create"
                className="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700"
              >
                Create Product
              </Link>
            )}
          </div>

          {error && (
            <div className="text-red-600 mb-4">Error loading products: {error.message}</div>
          )}

          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Style Code
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Name
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Gender
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Season
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
                {products && products.length > 0 ? (
                  products.map((product) => (
                    <tr key={product.id}>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        {product.style_code}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        <Link
                          href={`/products/view?id=${product.id}`}
                          className="text-indigo-600 hover:text-indigo-800 font-medium"
                        >
                          {product.name}
                        </Link>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {product.gender}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {product.seasons?.code || 'N/A'}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${
                          product.status === 'production' ? 'bg-green-100 text-green-800' :
                          product.status === 'development' ? 'bg-blue-100 text-blue-800' :
                          product.status === 'pre-production' ? 'bg-yellow-100 text-yellow-800' :
                          'bg-gray-100 text-gray-800'
                        }`}>
                          {product.status}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 space-x-4">
                        {/* View is always available if user can see the list */}
                        <Link
                          href={`/products/view?id=${product.id}`}
                          className="text-indigo-600 hover:text-indigo-900"
                        >
                          View
                        </Link>

                        {/* Edit requires 'edit' or higher permission */}
                        {(['edit', 'create', 'delete', 'full'].includes(productPermission) || userPermissions?.isAdmin) && (
                          <Link
                            href={`/products/edit?productId=${product.id}`}
                            className="text-indigo-600 hover:text-indigo-900"
                          >
                            Edit
                          </Link>
                        )}

                        {/* BOM requires 'edit' or higher permission */}
                        {(['edit', 'create', 'delete', 'full'].includes(productPermission) || userPermissions?.isAdmin) && (
                          <Link
                            href={`/bom?productId=${product.id}`}
                            className="text-indigo-600 hover:text-indigo-900"
                          >
                            BOM
                          </Link>
                        )}

                        {/* Delete requires 'delete' or 'full' permission */}
                        {(['delete', 'full'].includes(productPermission) || userPermissions?.isAdmin) && (
                          <form action={removeProduct} className="inline-block">
                            <input type="hidden" name="product_id" value={product.id} />
                            <ConfirmDeleteButton label="Delete" entityName="this product" />
                          </form>
                        )}

                        {/* Show message if user only has read permission */}
                        {productPermission === 'read' && !userPermissions?.isAdmin && (
                          <span className="text-gray-400 text-xs italic">(Read-only)</span>
                        )}
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan="6" className="px-6 py-4 text-center text-sm text-gray-500">
                      No products found
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
