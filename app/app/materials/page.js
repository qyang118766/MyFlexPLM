import Link from 'next/link';
import { createClient } from '@/lib/supabase/server';
import ConfirmDeleteButton from '@/components/ConfirmDeleteButton';
import { removeMaterial } from './remove/action';
import { getUserPermissionSummary, getUserAccessibleTypeNodes } from '@/lib/permissions';

export default async function MaterialsPage() {
  const supabase = await createClient();

  // Get user permissions
  const permissionResult = await getUserPermissionSummary();
  const userPermissions = permissionResult.data;
  const materialPermission = userPermissions?.entityPermissions?.material || 'none';

  // If user has no read permission, show access denied
  if (materialPermission === 'none') {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-gray-900 mb-2">Access Denied</h1>
          <p className="text-gray-600">You do not have permission to view materials.</p>
        </div>
      </div>
    );
  }

  // Get accessible type nodes for filtering
  const accessibleNodesResult = await getUserAccessibleTypeNodes('material');
  const accessibleNodeIds = accessibleNodesResult.data?.map(n => n.id) || [];

  // Use the materials_latest view which JOINs material_master with latest materials
  let query = supabase
    .from('materials_latest')
    .select('*')
    .order('created_at', { ascending: false });

  // Filter by accessible type nodes if not admin
  if (!userPermissions?.isAdmin && accessibleNodeIds.length > 0) {
    query = query.in('type_id', accessibleNodeIds);
  }

  const { data: materials, error } = await query;

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Materials</h1>
        <p className="mt-2 text-sm text-gray-600">
          Manage materials library and supplier relationships
        </p>
      </div>

      <div className="bg-white shadow rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-lg font-medium text-gray-900">
              All Materials
              {!userPermissions?.isAdmin && (
                <span className="ml-2 text-xs text-gray-500">
                  (Permission: {materialPermission})
                </span>
              )}
            </h2>
            {(['create', 'delete', 'full'].includes(materialPermission) || userPermissions?.isAdmin) && (
              <Link
                href="/materials/create"
                className="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700"
              >
                Create Material
              </Link>
            )}
          </div>

          {error && (
            <div className="text-red-600 mb-4">Error loading materials: {error.message}</div>
          )}

          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Material Code
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Name
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
                {materials && materials.length > 0 ? (
                  materials.map((material) => (
                    <tr key={material.id}>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        {material.material_code}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        <Link
                          href={`/materials/view?id=${material.id}`}
                          className="text-indigo-600 hover:text-indigo-800 font-medium"
                        >
                          {material.name}
                        </Link>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${
                          material.status === 'active' ? 'bg-green-100 text-green-800' :
                          material.status === 'in_development' ? 'bg-blue-100 text-blue-800' :
                          material.status === 'rfq' ? 'bg-yellow-100 text-yellow-800' :
                          'bg-gray-100 text-gray-800'
                        }`}>
                          {material.status}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 space-x-4">
                        {/* View is always available if user can see the list */}
                        <Link
                          href={`/materials/view?id=${material.id}`}
                          className="text-indigo-600 hover:text-indigo-900"
                        >
                          View
                        </Link>

                        {/* Edit requires 'edit' or higher permission */}
                        {(['edit', 'create', 'delete', 'full'].includes(materialPermission) || userPermissions?.isAdmin) && (
                          <Link
                            href={`/materials/edit?materialId=${material.id}`}
                            className="text-indigo-600 hover:text-indigo-900"
                          >
                            Edit
                          </Link>
                        )}

                        {/* Delete requires 'delete' or 'full' permission */}
                        {(['delete', 'full'].includes(materialPermission) || userPermissions?.isAdmin) && (
                          <form action={removeMaterial} className="inline-block">
                            <input type="hidden" name="material_id" value={material.id} />
                            <ConfirmDeleteButton label="Delete" entityName="this material" />
                          </form>
                        )}

                        {/* Show message if user only has read permission */}
                        {materialPermission === 'read' && !userPermissions?.isAdmin && (
                          <span className="text-gray-400 text-xs italic">(Read-only)</span>
                        )}
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan="4" className="px-6 py-4 text-center text-sm text-gray-500">
                      No materials found
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
