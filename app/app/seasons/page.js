import Link from 'next/link';
import { createClient } from '@/lib/supabase/server';
import ConfirmDeleteButton from '@/components/ConfirmDeleteButton';
import { removeSeason } from './remove/action';

export default async function SeasonsPage() {
  const supabase = await createClient();

  const { data: seasons, error } = await supabase
    .from('seasons')
    .select('*')
    .order('created_at', { ascending: false });

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Seasons</h1>
        <p className="mt-2 text-sm text-gray-600">
          Manage product seasons and collections
        </p>
      </div>

      <div className="bg-white shadow rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <div className="flex justify-between items-center mb-4">
            <h2 className="text-lg font-medium text-gray-900">All Seasons</h2>
            <Link
              href="/seasons/create"
              className="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700"
            >
              Create Season
            </Link>
          </div>

          {error && (
            <div className="text-red-600 mb-4">Error loading seasons: {error.message}</div>
          )}

          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Code
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Name
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Year
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
                {seasons && seasons.length > 0 ? (
                  seasons.map((season) => (
                    <tr key={season.id}>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        {season.code}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        <Link
                          href={`/seasons/view?id=${season.id}`}
                          className="text-indigo-600 hover:text-indigo-800 font-medium"
                        >
                          {season.name}
                        </Link>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {season.year}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${
                          season.status === 'active' ? 'bg-green-100 text-green-800' :
                          season.status === 'planned' ? 'bg-blue-100 text-blue-800' :
                          'bg-gray-100 text-gray-800'
                        }`}>
                          {season.status}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 space-x-4">
                        <Link
                          href={`/seasons/edit?seasonId=${season.id}`}
                          className="text-indigo-600 hover:text-indigo-900"
                        >
                          Edit
                        </Link>
                        <form action={removeSeason} className="inline-block">
                          <input type="hidden" name="season_id" value={season.id} />
                          <ConfirmDeleteButton label="Delete" entityName="this season" />
                        </form>
                      </td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan="5" className="px-6 py-4 text-center text-sm text-gray-500">
                      No seasons found
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
