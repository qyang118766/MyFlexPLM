import Link from 'next/link';
import { notFound } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { updateProduct } from '@/lib/actions/products';
import { getEnumValues, ENUM_TYPES } from '@/lib/services/enums';
import { getVisibleAttributes } from '@/lib/services/attributeFiltering';

function getSearchParam(searchParams, key) {
  if (!searchParams) return null;
  if (typeof searchParams.get === 'function') {
    const valueFromGetter = searchParams.get(key);
    return valueFromGetter ?? null;
  }
  const value = searchParams[key];
  if (!value) return null;
  if (Array.isArray(value)) {
    return value[0];
  }
  return typeof value === 'string' ? value : null;
}

function formatSeason(season) {
  if (!season) return '';
  const code = season.code ? season.code : '';
  const name = season.name ? season.name : '';
  return [code, name].filter(Boolean).join(' • ');
}

function parseOptions(rawOptions) {
  if (!rawOptions) return [];
  if (Array.isArray(rawOptions)) {
    return rawOptions;
  }
  if (typeof rawOptions === 'object') {
    if (Array.isArray(rawOptions.values)) {
      return rawOptions.values;
    }
    return Object.values(rawOptions);
  }
  if (typeof rawOptions === 'string') {
    try {
      const parsed = JSON.parse(rawOptions);
      if (Array.isArray(parsed)) return parsed;
      if (parsed && Array.isArray(parsed.values)) {
        return parsed.values;
      }
      return Object.values(parsed ?? {});
    } catch {
      return [];
    }
  }
  return [];
}

function AttributeField({ attribute, value }) {
  const inputName = `attribute_${attribute.key}`;
  const commonProps = {
    name: inputName,
    id: inputName,
    className:
      'mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500',
    required: attribute.required || false,
  };

  switch (attribute.data_type) {
    case 'number':
      return (
        <input
          type="number"
          step="0.01"
          placeholder={`Enter ${attribute.label}`}
          defaultValue={value ?? ''}
          {...commonProps}
        />
      );
    case 'boolean':
      return (
        <select {...commonProps} defaultValue={value === true ? 'true' : value === false ? 'false' : ''}>
          <option value="">Select value</option>
          <option value="true">Yes</option>
          <option value="false">No</option>
        </select>
      );
    case 'date':
      return <input type="date" defaultValue={value ?? ''} {...commonProps} />;
    case 'enum': {
      const options = parseOptions(attribute.options);
      return (
        <select {...commonProps} defaultValue={value ?? ''}>
          <option value="">Select value</option>
          {options.map((option) => (
            <option key={option} value={option}>
              {option}
            </option>
          ))}
        </select>
      );
    }
    default:
      return (
        <input
          type="text"
          placeholder={`Enter ${attribute.label}`}
          defaultValue={value ?? ''}
          {...commonProps}
        />
      );
  }
}

export default async function EditProductPage({ searchParams }) {
  // Next.js 15+: searchParams 是一个 Promise，需要 await
  const params = await searchParams;
  const productId = getSearchParam(params, 'productId');

  if (!productId) {
    return (
      <div className="bg-white shadow rounded-lg p-10 space-y-4">
        <div>
          <h1 className="text-2xl font-semibold text-gray-900 mb-2">Edit Product</h1>
          <p className="text-gray-600">Select a product from the list to edit its details.</p>
        </div>
        <Link
          href="/products"
          className="inline-flex items-center text-sm font-medium text-indigo-600 hover:text-indigo-800"
        >
          &larr; Back to Products
        </Link>
      </div>
    );
  }

  // Fetch enum values from database
  const statusOptions = await getEnumValues(ENUM_TYPES.PRODUCT_STATUS);
  const genderOptions = await getEnumValues(ENUM_TYPES.PRODUCT_GENDER);

  const supabase = await createClient();

  const [{ data: product, error: productError }, { data: seasons, error: seasonsError }] =
    await Promise.all([
      supabase
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
        .eq('id', productId)
        .single(),
      supabase
        .from('seasons')
        .select('id, code, name')
        .order('created_at', { ascending: false }),
    ]);

  if (productError || !product) {
    notFound();
  }

  if (seasonsError) {
    throw new Error(seasonsError.message);
  }

  // Get attributes visible to this product's type node (respects scope)
  const attributeDefs = await getVisibleAttributes(supabase, 'product', product.type_id);

  const productAttributes = product.attributes || {};

  return (
    <div className="space-y-8">
      <div>
        <Link href="/products" className="text-sm text-indigo-600 hover:text-indigo-800">
          &larr; Back to Products
        </Link>
      </div>

      <div className="flex flex-col gap-2">
        <h1 className="text-3xl font-bold text-gray-900">Edit Product</h1>
        <p className="text-sm text-gray-600">
          Update base data, season links, and dynamic attributes. Changes apply immediately after saving.
        </p>
      </div>

      <form action={updateProduct} className="bg-white shadow rounded-lg p-8 space-y-8">
        <input type="hidden" name="product_id" value={product.id} />
        <input type="hidden" name="type_id" value={product.type_id || ''} />

        <section className="grid grid-cols-1 gap-6 md:grid-cols-2">
          <div>
            <label htmlFor="style_code" className="block text-sm font-medium text-gray-700">
              Style Code *
            </label>
            <input
              id="style_code"
              name="style_code"
              type="text"
              required
              defaultValue={product.style_code || ''}
              className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
            />
          </div>

          <div>
            <label htmlFor="name" className="block text-sm font-medium text-gray-700">
              Product Name *
            </label>
            <input
              id="name"
              name="name"
              type="text"
              required
              defaultValue={product.name || ''}
              className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
            />
          </div>

          <div>
            <label htmlFor="gender" className="block text-sm font-medium text-gray-700">
              Gender
            </label>
            <select
              id="gender"
              name="gender"
              className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
              defaultValue={product.gender || 'unisex'}
            >
              {genderOptions.map((option) => (
                <option key={option.value} value={option.value}>
                  {option.label}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label htmlFor="status" className="block text-sm font-medium text-gray-700">
              Product Status
            </label>
            <select
              id="status"
              name="status"
              className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
              defaultValue={product.status || 'development'}
            >
              {statusOptions.map((option) => (
                <option key={option.value} value={option.value}>
                  {option.label}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label htmlFor="season_id" className="block text-sm font-medium text-gray-700">
              Season (optional)
            </label>
            <select
              id="season_id"
              name="season_id"
              className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
              defaultValue={product.season_id || ''}
            >
              <option value="">No season</option>
              {seasons?.map((season) => (
                <option key={season.id} value={season.id}>
                  {formatSeason(season)}
                </option>
              ))}
            </select>
          </div>
        </section>

        {attributeDefs && attributeDefs.length > 0 && (
          <section className="space-y-4">
            <h2 className="text-lg font-semibold text-gray-900">Dynamic Attributes</h2>
            <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
              {attributeDefs.map((attribute) => (
                <div key={attribute.id}>
                  <label
                    htmlFor={`attribute_${attribute.key}`}
                    className="block text-sm font-medium text-gray-700"
                  >
                    {attribute.label}
                    {attribute.required ? <span className="text-red-500 ml-1">*</span> : null}
                  </label>
                  <AttributeField attribute={attribute} value={productAttributes[attribute.key]} />
                </div>
              ))}
            </div>
          </section>
        )}

        <div className="flex flex-col gap-3 sm:flex-row sm:justify-end">
          <Link
            href="/products"
            className="inline-flex items-center justify-center rounded-md border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
          >
            Cancel
          </Link>
          <button
            type="submit"
            className="inline-flex items-center justify-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-sm font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
          >
            Save Changes
          </button>
        </div>
      </form>
    </div>
  );
}
