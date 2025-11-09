import Link from 'next/link';
import { createClient } from '@/lib/supabase/server';
import ConfirmDeleteButton from '@/components/ConfirmDeleteButton';
import { removeColor } from './remove/action';

export default async function ColorsPage() {
  const supabase = await createClient();

  const { data: colors, error } = await supabase
    .from('colors')
    .select('*')
    .order('created_at', { ascending: false });

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Colors</h1>
        <p className="mt-2 text-sm text-gray-600">
          Manage color library and specifications
        </p>
      </div>

      <div className="bg-white shadow rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-lg font-medium text-gray-900">All Colors</h2>
            <Link
              href="/colors/create"
              className="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700"
            >
              Create Color
            </Link>
          </div>

          {error && (
            <div className="text-red-600 mb-4">Error loading colors: {error.message}</div>
          )}

          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Color Code
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Name
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Color
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
                {colors && colors.length > 0 ? (
                  colors.map((color) => (
                    <tr key={color.id}>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        {color.color_code}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        <Link
                          href={`/colors/view?id=${color.id}`}
                          className="text-indigo-600 hover:text-indigo-800 font-medium"
                        >
                          {color.name}
                        </Link>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        <div className="flex items-center">
                          {color.rgb_hex && (
                            <div
                              className="w-8 h-8 rounded border border-gray-300 mr-2"
                              style={{ backgroundColor: color.rgb_hex }}
                            />
                          )}
                          <span>{color.rgb_hex || 'N/A'}</span>
                        </div>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${
                          color.status === 'active' ? 'bg-green-100 text-green-800' :
                          'bg-gray-100 text-gray-800'
                        }`}>
                          {color.status}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 space-x-4">
                        <Link
                          href={`/colors/edit?colorId=${color.id}`}
                          className="text-indigo-600 hover:text-indigo-900"
                        >
                          Edit
                        </Link>
                        <form action={removeColor} className="inline-block">
                          <input type="hidden" name="color_id" value={color.id} />
                          <ConfirmDeleteButton label="Delete" entityName="this color" />
                        </form>
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan="5" className="px-6 py-4 text-center text-sm text-gray-500">
                      No colors found
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
