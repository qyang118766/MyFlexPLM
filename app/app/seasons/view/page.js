import Link from 'next/link';
import { notFound } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { buildTypePath, formatTypePath } from '@/lib/data/typeNodes';
import { getAttributesWithPermissions } from '@/lib/services/attributePermissions';

function formatDate(value) {
  if (!value) return 'N/A';
  return new Date(value).toLocaleString();
}

function renderValue(value) {
  if (value === null || value === undefined || value === '') {
    return 'N/A';
  }
  if (typeof value === 'object') {
    return JSON.stringify(value, null, 2);
  }
  return value.toString();
}

export default async function SeasonViewPage({ searchParams }) {
  const params = await searchParams;
  const id = params?.id;

  if (!id) {
    return (
      <div className="space-y-4 bg-white shadow rounded-lg p-8">
        <p className="text-sm text-gray-600">Select a season from the list to view its information.</p>
        <Link href="/seasons" className="text-indigo-600 hover:text-indigo-800 text-sm font-medium">
          &larr; Back to Seasons
        </Link>
      </div>
    );
  }

  const supabase = await createClient();
  const { data: season, error } = await supabase.from('seasons').select('*').eq('id', id).single();

  if (error || !season) {
    notFound();
  }

  const typePath = season.type_id ? await buildTypePath(supabase, season.type_id) : [];
  const typePathString = season.type_id ? formatTypePath(typePath) : 'Not assigned';

  const attributeDefs = await getAttributesWithPermissions(supabase, 'season', season.type_id || null);
  const attributeDefsMap = attributeDefs.reduce((acc, attr) => {
    acc[attr.key] = attr;
    return acc;
  }, {});

  const seasonAttributes = season.attributes || {};
  const visibleAttributeEntries = Object.entries(seasonAttributes).filter(
    ([key]) => attributeDefsMap[key]
  );

  return (
    <div className="space-y-8">
      <div>
        <Link href="/seasons" className="text-sm text-indigo-600 hover:text-indigo-800">
          &larr; Back to Seasons
        </Link>
        <h1 className="mt-2 text-3xl font-bold text-gray-900">{season.name}</h1>
        <p className="text-sm text-gray-600">Code: {season.code}</p>
      </div>

      <div className="bg-white shadow rounded-lg">
        <div className="border-b px-6 py-4">
          <p className="text-sm font-semibold text-gray-900">Season Overview</p>
        </div>
        <div className="px-6 py-6 space-y-6">
          <div className="grid gap-4 md:grid-cols-2">
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Type</p>
              <p className="mt-1 text-sm text-gray-900">{typePathString}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Year</p>
              <p className="mt-1 text-sm text-gray-900">{season.year ?? 'N/A'}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Status</p>
              <p className="mt-1 text-sm text-gray-900 capitalize">{season.status || 'N/A'}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Created At</p>
              <p className="mt-1 text-sm text-gray-900">{formatDate(season.created_at)}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Updated At</p>
              <p className="mt-1 text-sm text-gray-900">{formatDate(season.updated_at)}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Created By</p>
              <p className="mt-1 text-sm text-gray-900">{season.create_by || 'N/A'}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Updated By</p>
              <p className="mt-1 text-sm text-gray-900">{season.update_by || 'N/A'}</p>
            </div>
          </div>

          <div>
            <p className="text-sm font-semibold text-gray-900 mb-3">Custom Attributes</p>
            {visibleAttributeEntries.length === 0 ? (
              <p className="text-sm text-gray-500">No custom attributes visible.</p>
            ) : (
              <div className="grid gap-4 md:grid-cols-2">
                {visibleAttributeEntries.map(([key, value]) => {
                  const attrDef = attributeDefsMap[key];
                  return (
                    <div key={key} className="border rounded-lg p-4 bg-gray-50">
                      <p className="text-xs uppercase tracking-wider text-gray-500">
                        {attrDef?.label || key}
                      </p>
                      <p className="text-sm text-gray-900 whitespace-pre-wrap mt-1">{renderValue(value)}</p>
                    </div>
                  );
                })}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
