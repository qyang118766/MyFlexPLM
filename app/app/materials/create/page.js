import Link from 'next/link';
import TypeTreeSelector from '@/components/TypeTreeSelector';
import { createClient } from '@/lib/supabase/server';
import { createMaterial } from '@/lib/actions/materials';
import { getEnumValues, ENUM_TYPES } from '@/lib/services/enums';
import { buildTypePath, formatTypePath } from '@/lib/data/typeNodes';
import { getVisibleAttributes } from '@/lib/services/attributeFiltering';

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

export default async function CreateMaterialPage({ searchParams }) {
  const params = await searchParams;
  const typeId = params?.typeId;

  const supabase = await createClient();

  const { data: typeNodes, error: typeNodesError } = await supabase
    .from('entity_type_nodes')
    .select('*')
    .eq('entity_type', 'material')
    .order('name', { ascending: true });

  if (typeNodesError) {
    throw new Error(typeNodesError.message);
  }

  if (!typeId) {
    return (
      <div className="space-y-8">
        <div>
          <Link href="/materials" className="text-sm text-indigo-600 hover:text-indigo-800">
            &larr; Back to Materials
          </Link>
        </div>

        <div className="flex flex-col gap-2">
          <h1 className="text-3xl font-bold text-gray-900">Create Material</h1>
          <p className="text-sm text-gray-600">
            First, select the material type from the hierarchy below.
          </p>
        </div>

        <TypeTreeSelector
          typeNodes={typeNodes || []}
          entityLabel="Material"
          selectPath="/materials/create"
          description="Choose a material type before entering the material details."
        />
      </div>
    );
  }

  const typePath = await buildTypePath(supabase, typeId);
  const typePathString = formatTypePath(typePath);

  const statusOptions = await getEnumValues(ENUM_TYPES.MATERIAL_STATUS);

  // Get attributes visible to this type node (respects scope)
  const attributeDefs = await getVisibleAttributes(supabase, 'material', typeId);

  return (
    <div className="space-y-8">
      <div>
        <Link href="/materials" className="text-sm text-indigo-600 hover:text-indigo-800">
          &larr; Back to Materials
        </Link>
      </div>

      <div className="flex flex-col gap-2">
        <h1 className="text-3xl font-bold text-gray-900">Create Material</h1>
        <p className="text-sm text-gray-600">
          Capture new materials for the library including code, name, status and dynamic attributes.
        </p>
      </div>

      <div className="bg-indigo-50 border border-indigo-200 rounded-lg p-4">
        <p className="text-sm text-indigo-800">
          <span className="font-semibold">Selected Material Type:</span> {typePathString}
        </p>
      </div>

      <form action={createMaterial} className="bg-white shadow rounded-lg p-8 space-y-8">
        <input type="hidden" name="type_id" value={typeId} />

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
              placeholder="e.g. MAT-001"
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
              placeholder="e.g. Recycled Nylon"
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
              defaultValue="in_development"
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
            href="/materials"
            className="inline-flex items-center justify-center rounded-md border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
          >
            Cancel
          </Link>
          <button
            type="submit"
            className="inline-flex items-center justify-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-sm font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
          >
            Save Material
          </button>
        </div>
      </form>
    </div>
  );
}
