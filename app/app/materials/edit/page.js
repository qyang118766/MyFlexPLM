import Link from 'next/link';
import { notFound } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { updateMaterial } from '@/lib/actions/materials';
import { getEnumValues, ENUM_TYPES } from '@/lib/services/enums';
import { getAttributesWithPermissions } from '@/lib/services/attributePermissions';
import { getUserPermissionSummary, checkUserPermission } from '@/lib/permissions';

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
  const isReadOnly = attribute.permission_level === 'read-only';
  const commonProps = {
    name: inputName,
    id: inputName,
    className:
      `mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500 ${isReadOnly ? 'bg-gray-100 cursor-not-allowed' : ''}`,
    required: attribute.required || false,
    disabled: isReadOnly,
  };

  switch (attribute.data_type) {
    case 'number':
      return (
        <input
          type="number"
          step="0.01"
          defaultValue={value ?? ''}
          placeholder={`Enter ${attribute.label}`}
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

export default async function EditMaterialPage({ searchParams }) {
  // Next.js 15+: searchParams 是一个 Promise，需要 await
  const params = await searchParams;
  const materialId = getSearchParam(params, 'materialId');

  if (!materialId) {
    return (
      <div className="bg-white shadow rounded-lg p-10 space-y-4">
        <div>
          <h1 className="text-2xl font-semibold text-gray-900 mb-2">Edit Material</h1>
          <p className="text-gray-600">Select a material from the list to edit its details.</p>
        </div>
        <Link
          href="/materials"
          className="inline-flex items-center text-sm font-medium text-indigo-600 hover:text-indigo-800"
        >
          &larr; Back to Materials
        </Link>
      </div>
    );
  }

  // Fetch enum values from database
  const statusOptions = await getEnumValues(ENUM_TYPES.MATERIAL_STATUS);

  const supabase = await createClient();

  const { data: material, error: materialError } = await supabase
    .from('materials')
    .select('*')
    .eq('id', materialId)
    .single();

  if (materialError || !material) {
    notFound();
  }

  // Check user permissions for editing this material
  const permissionResult = await getUserPermissionSummary();
  const userPermissions = permissionResult.data;

  if (!userPermissions?.isAdmin) {
    const hasPermission = await checkUserPermission(material.type_id, 'edit');
    if (!hasPermission) {
      return (
        <div className="min-h-screen flex items-center justify-center">
          <div className="text-center">
            <h1 className="text-2xl font-bold text-gray-900 mb-2">Access Denied</h1>
            <p className="text-gray-600 mb-4">You do not have permission to edit this material.</p>
            <Link
              href="/"
              className="inline-flex items-center justify-center rounded-md bg-indigo-600 px-4 py-2 text-sm font-medium text-white hover:bg-indigo-700"
            >
              Go to Home
            </Link>
          </div>
        </div>
      );
    }
  }

  // Get attributes with permission levels (hidden attributes are filtered out)
  const attributeDefs = await getAttributesWithPermissions(supabase, 'material', material.type_id);

  const materialAttributes = material.attributes || {};

  return (
    <div className="space-y-8">
      <div>
        <Link href="/materials" className="text-sm text-indigo-600 hover:text-indigo-800">
          &larr; Back to Materials
        </Link>
      </div>

      <div className="flex flex-col gap-2">
        <h1 className="text-3xl font-bold text-gray-900">Edit Material</h1>
        <p className="text-sm text-gray-600">
          Update the material metadata, status, and custom attributes. Changes apply immediately.
        </p>
      </div>

      <form action={updateMaterial} className="bg-white shadow rounded-lg p-8 space-y-8">
        <input type="hidden" name="material_id" value={material.id} />
        <input type="hidden" name="type_id" value={material.type_id || ''} />

        <section className="grid grid-cols-1 gap-6 md:grid-cols-2">
          <div>
            <label htmlFor="material_code" className="block text-sm font-medium text-gray-700">
              Material Code *
            </label>
            <input
              id="material_code"
              name="material_code"
              type="text"
              required
              defaultValue={material.material_code || ''}
              className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
            />
          </div>

          <div>
            <label htmlFor="name" className="block text-sm font-medium text-gray-700">
              Material Name *
            </label>
            <input
              id="name"
              name="name"
              type="text"
              required
              defaultValue={material.name || ''}
              className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
            />
          </div>

          <div>
            <label htmlFor="status" className="block text-sm font-medium text-gray-700">
              Status
            </label>
            <select
              id="status"
              name="status"
              className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
              defaultValue={material.status || 'in_development'}
            >
              {statusOptions.map((option) => (
                <option key={option.value} value={option.value}>
                  {option.label}
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
                  <AttributeField attribute={attribute} value={materialAttributes[attribute.key]} />
                </div>
              ))}
            </div>
          </section>
        )}

        <div className="flex flex-col gap-3 sm:flex-row sm:justify-end">
          <Link
            href="/materials"
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
