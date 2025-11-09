import Link from 'next/link';
import { notFound } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { buildTypePath, formatTypePath } from '@/lib/data/typeNodes';

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

export default async function ProductViewPage({ searchParams }) {
  const params = await searchParams;
  const id = params?.id;

  if (!id) {
    return (
      <div className="space-y-4 bg-white shadow rounded-lg p-8">
        <p className="text-sm text-gray-600">Select a product from the list to view its information.</p>
        <Link href="/products" className="text-indigo-600 hover:text-indigo-800 text-sm font-medium">
          &larr; Back to Products
        </Link>
      </div>
    );
  }

  const supabase = await createClient();

  const { data: product, error } = await supabase
    .from('products')
    .select(
      `
        *,
        seasons (
          id,
          code,
          name
        )
      `
    )
    .eq('id', id)
    .single();

  if (error || !product) {
    notFound();
  }

  const typePath = await buildTypePath(supabase, product.type_id);
  const typePathString = formatTypePath(typePath);
  const attributeEntries = Object.entries(product.attributes || {});
  const seasonLabel = product.seasons
    ? [product.seasons.code ?? 'N/A', product.seasons.name ?? '']
        .filter((value) => value && value !== 'N/A')
        .join(' ')
        .trim() || 'No season'
    : 'No season';

  return (
    <div className="space-y-8">
      <div>
        <Link href="/products" className="text-sm text-indigo-600 hover:text-indigo-800">
          &larr; Back to Products
        </Link>
        <h1 className="mt-2 text-3xl font-bold text-gray-900">{product.name}</h1>
        <p className="text-sm text-gray-600">Style Code: {product.style_code}</p>
      </div>

      <div className="bg-white shadow rounded-lg">
        <div className="border-b px-6 py-4">
          <p className="text-sm font-semibold text-gray-900">Product Overview</p>
        </div>
        <div className="px-6 py-6 space-y-6">
          <div className="grid gap-4 md:grid-cols-2">
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Type</p>
              <p className="mt-1 text-sm text-gray-900">{typePathString}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Status</p>
              <p className="mt-1 text-sm text-gray-900 capitalize">{product.status || 'N/A'}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Gender</p>
              <p className="mt-1 text-sm text-gray-900 capitalize">{product.gender || 'N/A'}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Season</p>
              <p className="mt-1 text-sm text-gray-900">{seasonLabel}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Created At</p>
              <p className="mt-1 text-sm text-gray-900">{formatDate(product.created_at)}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Updated At</p>
              <p className="mt-1 text-sm text-gray-900">{formatDate(product.updated_at)}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Version</p>
              <p className="mt-1 text-sm text-gray-900">
                {product.version || 'N/A'}.{product.iteration ?? 'N/A'}
              </p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Created By</p>
              <p className="mt-1 text-sm text-gray-900">{product.create_by || 'N/A'}</p>
            </div>
            <div>
              <p className="text-xs uppercase tracking-wider text-gray-500">Updated By</p>
              <p className="mt-1 text-sm text-gray-900">{product.update_by || 'N/A'}</p>
            </div>
          </div>

          <div>
            <p className="text-sm font-semibold text-gray-900 mb-3">Custom Attributes</p>
            {attributeEntries.length === 0 ? (
              <p className="text-sm text-gray-500">No custom attributes.</p>
            ) : (
              <div className="grid gap-4 md:grid-cols-2">
                {attributeEntries.map(([key, value]) => (
                  <div key={key} className="border rounded-lg p-4 bg-gray-50">
                    <p className="text-xs uppercase tracking-wider text-gray-500">{key}</p>
                    <p className="text-sm text-gray-900 whitespace-pre-wrap mt-1">{renderValue(value)}</p>
                  </div>
                ))}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
