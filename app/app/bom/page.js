import Link from 'next/link';
import { createClient } from '@/lib/supabase/server';
import {
  addBomItem,
  updateBomItem,
  deleteBomItem,
  createBomStructure,
} from '@/lib/actions/bom';

const UNIT_OPTIONS = ['pcs', 'set', 'm', 'cm', 'yd', 'kg'];
const BOM_STATUS_OPTIONS = ['draft', 'active', 'archived'];

function escapeIlike(term) {
  return term.replace(/[%_]/g, (char) => `\\${char}`);
}

function buildOptionMap(rows, key) {
  if (!rows) return {};
  return rows.reduce((acc, row) => {
    if (!row?.material_id || !row[key]) {
      return acc;
    }
    if (!acc[row.material_id]) {
      acc[row.material_id] = [];
    }
    acc[row.material_id].push(row[key]);
    return acc;
  }, {});
}

function buildQuery(params) {
  const query = new URLSearchParams();
  Object.entries(params).forEach(([key, value]) => {
    if (value) {
      query.set(key, value);
    }
  });
  const qs = query.toString();
  return qs ? `?${qs}` : '';
}

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
  if (typeof value === 'string') {
    return value;
  }
  return null;
}

async function fetchMaterialSearchResults(supabase, searchTerm) {
  let query = supabase
    .from('materials')
    .select('id, material_code, name, status')
    .order('updated_at', { ascending: false })
    .limit(20);

  if (searchTerm) {
    const escaped = escapeIlike(searchTerm);
    const pattern = `%${escaped}%`;
    query = query.or(`material_code.ilike.${pattern},name.ilike.${pattern}`);
  }

  const { data, error } = await query;
  if (error) {
    throw new Error(error.message);
  }
  return data ?? [];
}

export default async function BomPage(props) {
  const searchParams = await props.searchParams;
  const productIdRaw = getSearchParam(searchParams, 'productId');
  const productId = productIdRaw?.trim() ? productIdRaw.trim() : null;
  const requestedBomIdRaw = getSearchParam(searchParams, 'bomId');
  const requestedBomId = requestedBomIdRaw?.trim() ? requestedBomIdRaw.trim() : null;
  const materialSearchRaw = getSearchParam(searchParams, 'materialSearch');
  const materialSearch = materialSearchRaw?.trim() || '';

  if (!productId) {
    return (
      <div className="bg-white shadow rounded-lg p-10">
        <h1 className="text-2xl font-semibold text-gray-900 mb-2">BOM Editor</h1>
        <p className="text-gray-600">
          Select a product from the Products list to load its Bill of Materials.
        </p>
      </div>
    );
  }

  const supabase = await createClient();

  const { data: product, error: productError } = await supabase
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
    .single();

  if (productError || !product) {
    return (
      <div className="bg-white shadow rounded-lg p-10 space-y-4">
        <div>
          <h1 className="text-2xl font-semibold text-gray-900 mb-2">BOM Editor</h1>
          <p className="text-gray-600">
            The requested product could not be found or you no longer have access to it.
          </p>
        </div>
        <Link
          href="/products"
          className="inline-flex items-center text-sm font-medium text-indigo-600 hover:text-indigo-800"
        >
          &larr; Return to Products
        </Link>
      </div>
    );
  }

  const { data: bomsData, error: bomsError } = await supabase
    .from('product_boms')
    .select('*')
    .eq('product_id', productId)
    .order('created_at', { ascending: true });

  if (bomsError) {
    throw new Error(bomsError.message);
  }

  const boms = bomsData ?? [];
  const activeBom =
    requestedBomId && boms.length > 0
      ? boms.find((bom) => bom.id === requestedBomId) ?? boms[0]
      : boms[0] ?? null;

  let bomItems = [];
  let materialSearchResults = [];
  let colorOptions = {};
  let supplierOptions = {};

  if (activeBom) {
    const [{ data: bomItemsData, error: bomItemsError }, materialResults] =
      await Promise.all([
        supabase
          .from('bom_items')
          .select(
            `
              *,
              materials (
                id,
                material_code,
                name,
                status
              ),
              colors (
                id,
                color_code,
                name
              ),
              suppliers (
                id,
                supplier_code,
                name
              )
            `
          )
          .eq('bom_id', activeBom.id)
          .order('line_number', { ascending: true }),
        fetchMaterialSearchResults(supabase, materialSearch),
      ]);

    if (bomItemsError) {
      throw new Error(bomItemsError.message);
    }

    bomItems = bomItemsData ?? [];
    materialSearchResults = materialResults;

    const materialIds = Array.from(
      new Set([
        ...bomItems.map((item) => item.material_id).filter(Boolean),
        ...materialSearchResults.map((mat) => mat.id).filter(Boolean),
      ])
    );

    if (materialIds.length > 0) {
      const { data: colorRows, error: colorError } = await supabase
        .from('material_colors')
        .select(
          `
            material_id,
            colors (
              id,
              name,
              color_code
            )
          `
        )
        .in('material_id', materialIds);

      if (colorError) {
        throw new Error(colorError.message);
      }

      const { data: supplierRows, error: supplierError } = await supabase
        .from('material_suppliers')
        .select(
          `
            material_id,
            suppliers (
              id,
              name,
              supplier_code
            )
          `
        )
        .in('material_id', materialIds);

      if (supplierError) {
        throw new Error(supplierError.message);
      }

      colorOptions = buildOptionMap(colorRows, 'colors');
      supplierOptions = buildOptionMap(supplierRows, 'suppliers');
    }
  }

  return (
    <div className="space-y-8">
      <div>
        <Link href="/products" className="text-sm text-indigo-600 hover:text-indigo-800">
          &larr; Back to Products
        </Link>
      </div>

      <div className="bg-white shadow rounded-lg p-6 space-y-2">
        <p className="text-sm text-gray-500">Product</p>
        <h1 className="text-2xl font-bold text-gray-900">{product.name}</h1>
        <div className="text-sm text-gray-600">
          Style Code: <span className="font-medium">{product.style_code || 'N/A'}</span>
          {product.seasons ? (
            <span className="ml-4">
              Season:{' '}
              <span className="font-medium">
                {product.seasons.code} &middot; {product.seasons.name}
              </span>
            </span>
          ) : null}
        </div>
      </div>

      <div className="grid gap-6 lg:grid-cols-4">
        <section className="bg-white shadow rounded-lg p-6 lg:col-span-1 space-y-4">
          <div>
            <h2 className="text-lg font-medium text-gray-900">Product BOMs</h2>
            <p className="text-sm text-gray-500">Select or create a BOM structure.</p>
          </div>

          {boms.length === 0 ? (
            <div className="text-sm text-gray-500 border border-dashed rounded-md p-4">
              This product does not have any BOM structures yet.
            </div>
          ) : (
            <div className="space-y-2">
              {boms.map((bom) => {
                const isActive = activeBom?.id === bom.id;
                const href = `/bom${buildQuery({
                  productId: product.id,
                  bomId: bom.id,
                  materialSearch: materialSearch || undefined,
                })}`;

                return (
                  <Link
                    key={bom.id}
                    href={href}
                    className={`block rounded-md border px-3 py-2 text-sm ${
                      isActive
                        ? 'border-indigo-500 bg-indigo-50 text-indigo-800'
                        : 'border-gray-200 hover:border-gray-300 text-gray-700'
                    }`}
                  >
                    <div className="font-semibold">{bom.name}</div>
                    <div className="text-xs uppercase text-gray-500">Status: {bom.status}</div>
                  </Link>
                );
              })}
            </div>
          )}

          <div className="border-t pt-4">
            <p className="text-sm font-medium text-gray-900 mb-2">Create BOM</p>
            <form action={createBomStructure} className="space-y-3">
              <input type="hidden" name="product_id" value={product.id} />
              <div>
                <label className="block text-xs font-medium text-gray-500 mb-1">
                  Name
                </label>
                <input
                  type="text"
                  name="name"
                  placeholder="e.g. Default BOM"
                  className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                />
              </div>
              <div>
                <label className="block text-xs font-medium text-gray-500 mb-1">
                  Status
                </label>
                <select
                  name="status"
                  defaultValue="draft"
                  className="w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                >
                  {BOM_STATUS_OPTIONS.map((status) => (
                    <option key={status} value={status}>
                      {status}
                    </option>
                  ))}
                </select>
              </div>

              <button
                type="submit"
                className="w-full inline-flex justify-center rounded-md border border-transparent bg-indigo-600 px-3 py-2 text-sm font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
              >
                Add BOM
              </button>
            </form>
          </div>
        </section>

        <div className="lg:col-span-3 space-y-6">
          {!activeBom ? (
            <div className="bg-white shadow rounded-lg p-10 text-center text-gray-500">
              Create a BOM structure to start managing materials for this product.
            </div>
          ) : (
            <>
              <section className="bg-white shadow rounded-lg">
                <div className="px-4 py-5 sm:p-6">
                  <div className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between mb-4">
                    <div>
                      <h2 className="text-lg font-medium text-gray-900">{activeBom.name}</h2>
                      <p className="text-sm text-gray-500">
                        BOM status:{' '}
                        <span className="font-semibold capitalize">{activeBom.status}</span>
                      </p>
                    </div>
                  </div>

                  {bomItems.length === 0 ? (
                    <div className="text-center py-12 text-gray-500 border border-dashed rounded-lg">
                      No BOM items yet. Use the Material Library to add components.
                    </div>
                  ) : (
                    <div className="overflow-x-auto">
                      <table className="min-w-full divide-y divide-gray-200">
                        <thead className="bg-gray-50">
                          <tr>
                            <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Line
                            </th>
                            <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Material
                            </th>
                            <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Details
                            </th>
                            <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Quantity
                            </th>
                            <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Actions
                            </th>
                          </tr>
                        </thead>
                        <tbody className="bg-white divide-y divide-gray-200">
                          {bomItems.map((item) => {
                            const material = item.materials;
                            const availableColors = colorOptions[item.material_id] ?? [];
                            const availableSuppliers = supplierOptions[item.material_id] ?? [];

                            return (
                              <tr key={item.id}>
                                <td className="px-4 py-4 text-sm text-gray-900 font-medium">
                                  {item.line_number}
                                </td>
                                <td className="px-4 py-4">
                                  <div className="text-sm font-semibold text-gray-900">
                                    {material?.name || 'Unknown Material'}
                                  </div>
                                  <div className="text-xs text-gray-500">
                                    {material?.material_code ? `Code: ${material.material_code}` : 'No code'}
                                  </div>
                                  <div className="text-xs text-gray-500 capitalize">
                                    Status: {material?.status || 'n/a'}
                                  </div>
                                </td>
                                <td className="px-4 py-4">
                                  <form action={updateBomItem} className="space-y-3">
                                    <input type="hidden" name="bom_item_id" value={item.id} />
                                    <input type="hidden" name="product_id" value={product.id} />
                                    <input type="hidden" name="bom_id" value={activeBom.id} />

                                    <div>
                                      <label className="block text-xs font-medium text-gray-500 mb-1">
                                        Color Variant
                                      </label>
                                      <select
                                        name="color_id"
                                        defaultValue={item.color_id || ''}
                                        className="w-full rounded-md border-gray-300 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                                      >
                                        <option value="">No color</option>
                                        {availableColors.map((color) => (
                                          <option key={color.id} value={color.id}>
                                            {color.name}
                                            {color.color_code ? ` (${color.color_code})` : ''}
                                          </option>
                                        ))}
                                      </select>
                                    </div>

                                    <div>
                                      <label className="block text-xs font-medium text-gray-500 mb-1">
                                        Supplier Variant
                                      </label>
                                      <select
                                        name="supplier_id"
                                        defaultValue={item.supplier_id || ''}
                                        className="w-full rounded-md border-gray-300 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                                      >
                                        <option value="">No supplier</option>
                                        {availableSuppliers.map((supplier) => (
                                          <option key={supplier.id} value={supplier.id}>
                                            {supplier.name}
                                            {supplier.supplier_code ? ` (${supplier.supplier_code})` : ''}
                                          </option>
                                        ))}
                                      </select>
                                    </div>

                                    <div className="flex gap-2">
                                      <div className="flex-1">
                                        <label className="block text-xs font-medium text-gray-500 mb-1">
                                          Quantity
                                        </label>
                                        <input
                                          type="number"
                                          name="quantity"
                                          step="0.01"
                                          defaultValue={item.quantity || 1}
                                          className="w-full rounded-md border-gray-300 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                                        />
                                      </div>
                                      <div>
                                        <label className="block text-xs font-medium text-gray-500 mb-1">
                                          Unit
                                        </label>
                                        <select
                                          name="unit"
                                          defaultValue={item.unit || 'pcs'}
                                          className="rounded-md border-gray-300 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                                        >
                                          {UNIT_OPTIONS.map((unit) => (
                                            <option key={unit} value={unit}>
                                              {unit}
                                            </option>
                                          ))}
                                        </select>
                                      </div>
                                    </div>

                                    <button
                                      type="submit"
                                      className="w-full inline-flex justify-center rounded-md border border-transparent bg-indigo-600 px-3 py-1.5 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                                    >
                                      Save Line
                                    </button>
                                  </form>
                                </td>
                                <td className="px-4 py-4 text-sm text-gray-900">
                                  <div className="font-semibold">{item.quantity || '-'}</div>
                                  <div className="uppercase text-xs text-gray-500">{item.unit || 'pcs'}</div>
                                </td>
                                <td className="px-4 py-4">
                                  <form action={deleteBomItem}>
                                    <input type="hidden" name="bom_item_id" value={item.id} />
                                    <input type="hidden" name="product_id" value={product.id} />
                                    <input type="hidden" name="bom_id" value={activeBom.id} />
                                    <button
                                      type="submit"
                                      className="text-sm text-red-600 hover:text-red-800"
                                      aria-label="Delete BOM item"
                                    >
                                      Delete
                                    </button>
                                  </form>
                                </td>
                              </tr>
                            );
                          })}
                        </tbody>
                      </table>
                    </div>
                  )}
                </div>
              </section>

              <section className="bg-white shadow rounded-lg">
                <div className="px-4 py-5 sm:p-6 space-y-4">
                  <div>
                    <h2 className="text-lg font-medium text-gray-900">Material Library</h2>
                    <p className="text-sm text-gray-500">
                      Search the material library and add entries to this BOM.
                    </p>
                  </div>

                  <form className="flex flex-col gap-2 sm:flex-row" method="GET">
                    <input type="hidden" name="productId" value={product.id} />
                    <input type="hidden" name="bomId" value={activeBom.id} />
                    <input
                      type="text"
                      name="materialSearch"
                      placeholder="Search by code or name"
                      defaultValue={materialSearch}
                      className="flex-1 rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                    />
                    <div className="flex gap-2">
                      <button
                        type="submit"
                        className="rounded-md bg-gray-900 px-4 py-2 text-sm font-medium text-white hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2"
                      >
                        Search
                      </button>
                      {materialSearch && (
                        <Link
                          href={`/bom${buildQuery({ productId: product.id, bomId: activeBom.id })}`}
                          className="rounded-md border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
                        >
                          Clear
                        </Link>
                      )}
                    </div>
                  </form>

                  <div className="space-y-4 max-h-[600px] overflow-y-auto pr-1">
                    {materialSearchResults.length === 0 ? (
                      <div className="text-sm text-gray-500">
                        {materialSearch
                          ? 'No materials found for this search.'
                          : 'Use the search above to browse materials.'}
                      </div>
                    ) : (
                      materialSearchResults.map((material) => {
                        const availableColors = colorOptions[material.id] ?? [];
                        const availableSuppliers = supplierOptions[material.id] ?? [];

                        return (
                          <div key={material.id} className="border rounded-lg p-4 space-y-3">
                            <div>
                              <p className="text-sm font-semibold text-gray-900">{material.name}</p>
                              <p className="text-xs text-gray-500">
                                Code: {material.material_code || 'N/A'} &middot; Status:{' '}
                                <span className="capitalize">{material.status || 'n/a'}</span>
                              </p>
                            </div>

                            <form action={addBomItem} className="space-y-3">
                              <input type="hidden" name="bom_id" value={activeBom.id} />
                              <input type="hidden" name="product_id" value={product.id} />
                              <input type="hidden" name="material_id" value={material.id} />

                              <div className="flex gap-2">
                                <div className="flex-1">
                                  <label className="block text-xs font-medium text-gray-500 mb-1">
                                    Quantity
                                  </label>
                                  <input
                                    type="number"
                                    name="quantity"
                                    step="0.01"
                                    defaultValue="1"
                                    className="w-full rounded-md border-gray-300 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                                  />
                                </div>
                                <div>
                                  <label className="block text-xs font-medium text-gray-500 mb-1">
                                    Unit
                                  </label>
                                  <select
                                    name="unit"
                                    defaultValue="pcs"
                                    className="rounded-md border-gray-300 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                                  >
                                    {UNIT_OPTIONS.map((unit) => (
                                      <option key={unit} value={unit}>
                                        {unit}
                                      </option>
                                    ))}
                                  </select>
                                </div>
                              </div>

                              <div>
                                <label className="block text-xs font-medium text-gray-500 mb-1">
                                  Color Variant
                                </label>
                                <select
                                  name="color_id"
                                  defaultValue=""
                                  className="w-full rounded-md border-gray-300 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                                >
                                  <option value="">No color</option>
                                  {availableColors.map((color) => (
                                    <option key={color.id} value={color.id}>
                                      {color.name}
                                      {color.color_code ? ` (${color.color_code})` : ''}
                                    </option>
                                  ))}
                                </select>
                              </div>

                              <div>
                                <label className="block text-xs font-medium text-gray-500 mb-1">
                                  Supplier Variant
                                </label>
                                <select
                                  name="supplier_id"
                                  defaultValue=""
                                  className="w-full rounded-md border-gray-300 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                                >
                                  <option value="">No supplier</option>
                                  {availableSuppliers.map((supplier) => (
                                    <option key={supplier.id} value={supplier.id}>
                                      {supplier.name}
                                      {supplier.supplier_code ? ` (${supplier.supplier_code})` : ''}
                                    </option>
                                  ))}
                                </select>
                              </div>

                              <button
                                type="submit"
                                className="w-full inline-flex justify-center rounded-md border border-transparent bg-indigo-600 px-3 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
                              >
                                Add to BOM
                              </button>
                            </form>
                          </div>
                        );
                      })
                    )}
                  </div>
                </div>
              </section>
            </>
          )}
        </div>
      </div>
    </div>
  );
}
