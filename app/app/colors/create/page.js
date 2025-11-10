import Link from 'next/link';
import TypeTreeSelector from '@/components/TypeTreeSelector';
import { createClient } from '@/lib/supabase/server';
import { createColor } from '@/lib/actions/colors';
import { getEnumValues, ENUM_TYPES } from '@/lib/services/enums';
import { buildTypePath, formatTypePath } from '@/lib/data/typeNodes';
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

function AttributeField({ attribute }) {
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

export default async function CreateColorPage({ searchParams }) {
  const params = await searchParams;
  const typeId = params?.typeId;

  const supabase = await createClient();

  // Check user permissions
  const permissionResult = await getUserPermissionSummary();
  const userPermissions = permissionResult.data;
  const colorPermission = userPermissions?.entityPermissions?.color || 'none';

  // If user doesn't have at least create permission, deny access
  if (!userPermissions?.isAdmin && !['create', 'delete', 'full'].includes(colorPermission)) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-gray-900 mb-2">Access Denied</h1>
          <p className="text-gray-600 mb-4">You do not have permission to create colors.</p>
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

  const { data: typeNodes, error: typeNodesError } = await supabase
    .from('entity_type_nodes')
    .select('*')
    .eq('entity_type', 'color')
    .order('name', { ascending: true });

  if (typeNodesError) {
    throw new Error(typeNodesError.message);
  }

  if (!typeId) {
    return (
      <div className="space-y-8">
        <div>
          <Link href="/colors" className="text-sm text-indigo-600 hover:text-indigo-800">
            &larr; Back to Colors
          </Link>
        </div>

        <div className="flex flex-col gap-2">
          <h1 className="text-3xl font-bold text-gray-900">Create Color</h1>
          <p className="text-sm text-gray-600">
            Select a color type (palette, finish, etc.) from the hierarchy below.
          </p>
        </div>

        <TypeTreeSelector
          typeNodes={typeNodes || []}
          entityLabel="Color"
          selectPath="/colors/create"
          description="Choose the color category before entering the color details."
        />
      </div>
    );
  }

  // If typeId is selected, also check permission for this specific node
  if (!userPermissions?.isAdmin) {
    const hasPermission = await checkUserPermission(typeId, 'create');
    if (!hasPermission) {
      return (
        <div className="min-h-screen flex items-center justify-center">
          <div className="text-center">
            <h1 className="text-2xl font-bold text-gray-900 mb-2">Access Denied</h1>
            <p className="text-gray-600 mb-4">You do not have permission to create colors of this type.</p>
            <Link
              href="/colors"
              className="inline-flex items-center justify-center rounded-md bg-indigo-600 px-4 py-2 text-sm font-medium text-white hover:bg-indigo-700"
            >
              Back to Colors
            </Link>
          </div>
        </div>
      );
    }
  }

  const typePath = await buildTypePath(supabase, typeId);
  const typePathString = formatTypePath(typePath);

  const statusOptions = await getEnumValues(ENUM_TYPES.COLOR_STATUS);

  // Get attributes with permissions
  const attributeDefs = await getAttributesWithPermissions(supabase, 'color', typeId);

  return (
    <div className="space-y-8">
      <div>
        <Link href="/colors" className="text-sm text-indigo-600 hover:text-indigo-800">
          &larr; Back to Colors
        </Link>
      </div>

      <div className="flex flex-col gap-2">
        <h1 className="text-3xl font-bold text-gray-900">Create Color</h1>
        <p className="text-sm text-gray-600">
          Define color basics and optional attributes for consistent usage across the PLM.
        </p>
      </div>

      <div className="bg-indigo-50 border border-indigo-200 rounded-lg p-4">
        <p className="text-sm text-indigo-800">
          <span className="font-semibold">Selected Color Type:</span> {typePathString}
        </p>
      </div>

      <form action={createColor} className="bg-white shadow rounded-lg p-8 space-y-8">
        <input type="hidden" name="type_id" value={typeId} />

        <section className="grid grid-cols-1 gap-6 md:grid-cols-2">
          <div>
            <label htmlFor="color_code" className="block text-sm font-medium text-gray-700">
              Color Code *
            </label>
            <input
              id="color_code"
              name="color_code"
              type="text"
              required
              placeholder="e.g. COL-001"
              className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
            />
          </div>

          <div>
            <label htmlFor="name" className="block text-sm font-medium text-gray-700">
              Color Name *
            </label>
            <input
              id="name"
              name="name"
              type="text"
              required
              placeholder="e.g. Glacier Blue"
              className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
            />
          </div>

          <div>
            <label htmlFor="rgb_hex" className="block text-sm font-medium text-gray-700">
              RGB Hex
            </label>
            <input
              id="rgb_hex"
              name="rgb_hex"
              type="text"
              placeholder="#AABBCC"
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
              defaultValue="active"
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
                  <AttributeField attribute={attribute} />
                </div>
              ))}
            </div>
          </section>
        )}

        <div className="flex flex-col gap-3 sm:flex-row sm:justify-end">
          <Link
            href="/colors"
            className="inline-flex items-center justify-center rounded-md border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
          >
            Cancel
          </Link>
          <button
            type="submit"
            className="inline-flex items-center justify-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-sm font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
          >
            Save Color
          </button>
        </div>
      </form>
    </div>
  );
}
