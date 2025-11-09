import Link from 'next/link';
import { createClient } from '@/lib/supabase/server';
import { createProduct } from '@/lib/actions/products';
import { getEnumValues, ENUM_TYPES } from '@/lib/services/enums';
import TypeTreeSelector from '@/components/TypeTreeSelector';
import { getVisibleAttributes } from '@/lib/services/attributeFiltering';

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

function AttributeField({ attribute }) {
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
          {...commonProps}
        />
      );
    case 'boolean':
      return (
        <select {...commonProps} defaultValue="">
          <option value="">Select value</option>
          <option value="true">Yes</option>
          <option value="false">No</option>
        </select>
      );
    case 'date':
      return <input type="date" {...commonProps} />;
    case 'enum': {
      const options = parseOptions(attribute.options);
      return (
        <select {...commonProps} defaultValue="">
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
          {...commonProps}
        />
      );
  }
}

// 构建类型路径（从当前节点到根节点）
async function buildTypePath(supabase, typeId) {
  const path = [];
  let currentId = typeId;

  while (currentId) {
    const { data: node, error } = await supabase
      .from('entity_type_nodes')
      .select('id, name, code, parent_id')
      .eq('id', currentId)
      .single();

    if (error || !node) break;

    path.unshift(node); // 添加到开头，构建从根到叶的路径
    currentId = node.parent_id;
  }

  return path;
}

export default async function CreateProductPage({ searchParams }) {
  // Next.js 15+: searchParams 是一个 Promise
  const params = await searchParams;
  const typeId = params?.typeId;

  const supabase = await createClient();

  // 获取所有 product 类型节点
  const { data: typeNodes, error: typeNodesError } = await supabase
    .from('entity_type_nodes')
    .select('*')
    .eq('entity_type', 'product')
    .order('name', { ascending: true });

  if (typeNodesError) {
    throw new Error(typeNodesError.message);
  }

  // 如果没有选择类型，显示类型选择器
  if (!typeId) {
    return (
      <div className="space-y-8">
        <div>
          <Link href="/products" className="text-sm text-indigo-600 hover:text-indigo-800">
            &larr; Back to Products
          </Link>
        </div>

        <div className="flex flex-col gap-2">
          <h1 className="text-3xl font-bold text-gray-900">Create Product</h1>
          <p className="text-sm text-gray-600">
            First, select the product type from the hierarchy below.
          </p>
        </div>

        <TypeTreeSelector
          typeNodes={typeNodes || []}
          entityLabel="Product"
          selectPath="/products/create"
        />
      </div>
    );
  }

  // 如果选择了类型，显示创建表单
  // 构建类型路径
  const typePath = await buildTypePath(supabase, typeId);

  // 获取枚举值和其他数据
  const statusOptions = await getEnumValues(ENUM_TYPES.PRODUCT_STATUS);
  const genderOptions = await getEnumValues(ENUM_TYPES.PRODUCT_GENDER);

  const { data: seasons, error: seasonsError } = await supabase
    .from('seasons')
    .select('id, code, name')
    .order('created_at', { ascending: false });

  if (seasonsError) {
    throw new Error(seasonsError.message);
  }

  // Get attributes visible to this type node (respects scope)
  const attributeDefs = await getVisibleAttributes(supabase, 'product', typeId);

  // 格式化类型路径为字符串
  const typePathString = typePath.map(node => node.name).join(' > ');

  return (
    <div className="space-y-8">
      <div>
        <Link href="/products" className="text-sm text-indigo-600 hover:text-indigo-800">
          &larr; Back to Products
        </Link>
      </div>

      <div className="flex flex-col gap-2">
        <h1 className="text-3xl font-bold text-gray-900">Create Product</h1>
        <p className="text-sm text-gray-600">
          Provide the base product data and optional season or custom attributes.
        </p>
      </div>

      {/* 类型路径显示 */}
      <div className="bg-indigo-50 border border-indigo-200 rounded-lg p-4">
        <div className="flex items-center justify-between">
          <div>
            <label className="block text-xs font-medium text-indigo-900 mb-1">
              Product Type
            </label>
            <div className="flex items-center gap-2">
              <svg className="w-5 h-5 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" />
              </svg>
              <span className="text-sm font-semibold text-indigo-900">{typePathString}</span>
            </div>
          </div>
          <Link
            href="/products/create"
            className="text-sm text-indigo-600 hover:text-indigo-800 font-medium"
          >
            Change Type
          </Link>
        </div>
      </div>

      <form action={createProduct} className="bg-white shadow rounded-lg p-8 space-y-8">
        {/* 隐藏字段：type_id */}
        <input type="hidden" name="type_id" value={typeId} />

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
              placeholder="e.g. FLX-2025-001"
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
              placeholder="e.g. FlexLite Trail Jacket"
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
              defaultValue="unisex"
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
              defaultValue="development"
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
              defaultValue=""
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
                  <label htmlFor={`attribute_${attribute.key}`} className="block text-sm font-medium text-gray-700">
                    {attribute.label}
                    {attribute.required ? <span className="text-red-500 ml-1">*</span> : null}
                  </label>
                  <AttributeField attribute={attribute} />
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
            Save Product
          </button>
        </div>
      </form>
    </div>
  );
}
