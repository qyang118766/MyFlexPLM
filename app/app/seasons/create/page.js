import Link from 'next/link';
import { createClient } from '@/lib/supabase/server';
import { createSeason } from '@/lib/actions/seasons';
import { getEnumValues, ENUM_TYPES } from '@/lib/services/enums';
import { getAttributesWithPermissions } from '@/lib/services/attributePermissions';
import { getUserPermissionSummary } from '@/lib/permissions';

// 季节类型定义（暂时保留为常量，未来可迁移到数据库）
const SEASON_TYPES = [
  { value: 'spring', label: 'Spring', code: 'SP' },
  { value: 'summer', label: 'Summer', code: 'SU' },
  { value: 'fall', label: 'Fall', code: 'FA' },
  { value: 'winter', label: 'Winter', code: 'WI' },
  { value: 'spring_summer', label: 'Spring / Summer', code: 'SS' },
  { value: 'fall_winter', label: 'Fall / Winter', code: 'FW' },
];

function getUpcomingYears() {
  const currentYear = new Date().getFullYear();
  return Array.from({ length: 6 }, (_, index) => currentYear + index);
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

export default async function CreateSeasonPage() {
  const supabase = await createClient();

  // Check user permissions
  const permissionResult = await getUserPermissionSummary();
  const userPermissions = permissionResult.data;
  const seasonPermission = userPermissions?.entityPermissions?.season || 'none';

  // If user doesn't have at least create permission, deny access
  if (!userPermissions?.isAdmin && !['create', 'delete', 'full'].includes(seasonPermission)) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center">
          <h1 className="text-2xl font-bold text-gray-900 mb-2">Access Denied</h1>
          <p className="text-gray-600 mb-4">You do not have permission to create seasons.</p>
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

  // 从数据库获取状态枚举值
  const statusOptions = await getEnumValues(ENUM_TYPES.SEASON_STATUS);

  // Get attributes with permissions (season doesn't have type_id, so pass null)
  const attributeDefs = await getAttributesWithPermissions(supabase, 'season', null);

  const upcomingYears = getUpcomingYears();

  return (
    <div className="space-y-8">
      <div>
        <Link href="/seasons" className="text-sm text-indigo-600 hover:text-indigo-800">
          &larr; Back to Seasons
        </Link>
      </div>

      <div className="flex flex-col gap-2">
        <h1 className="text-3xl font-bold text-gray-900">Create Season</h1>
        <p className="text-sm text-gray-600">
          Choose a season template and year; the system will derive the season code and name for you.
        </p>
      </div>

      <form action={createSeason} className="bg-white shadow rounded-lg p-8 space-y-8">
        <section className="grid grid-cols-1 gap-6 md:grid-cols-2">
          <div>
            <label htmlFor="season_type" className="block text-sm font-medium text-gray-700">
              Season Template *
            </label>
            <select
              id="season_type"
              name="season_type"
              required
              className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
              defaultValue=""
            >
              <option value="" disabled>
                Select template
              </option>
              {SEASON_TYPES.map((type) => (
                <option key={type.value} value={type.value}>
                  {type.label}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label htmlFor="year" className="block text-sm font-medium text-gray-700">
              Year *
            </label>
            <input
              id="year"
              name="year"
              list="season-year-options"
              placeholder="e.g. 2025"
              required
              className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
              inputMode="numeric"
            />
            <datalist id="season-year-options">
              {upcomingYears.map((year) => (
                <option key={year} value={year} />
              ))}
            </datalist>
            <p className="mt-1 text-xs text-gray-500">
              Choose from the suggestions (current year + next 5) or type a custom year.
            </p>
          </div>

          <div>
            <label htmlFor="status" className="block text-sm font-medium text-gray-700">
              Status
            </label>
            <select
              id="status"
              name="status"
              className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
              defaultValue="planned"
            >
              {statusOptions.map((option) => (
                <option key={option.value} value={option.value}>
                  {option.label}
                </option>
              ))}
            </select>
          </div>

          <div className="rounded-md border border-indigo-100 bg-indigo-50 p-4 text-sm text-indigo-700 md:col-span-2">
            <p className="font-medium">Derived Naming</p>
            <p>
              When you save, the season code becomes <strong>CODE + YEAR</strong> (e.g. <code>SS2025</code>)
              and the name becomes <strong>YEAR + LABEL</strong> (e.g. <code>2025 Spring / Summer</code>).
            </p>
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
            href="/seasons"
            className="inline-flex items-center justify-center rounded-md border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
          >
            Cancel
          </Link>
          <button
            type="submit"
            className="inline-flex items-center justify-center rounded-md border border-transparent bg-indigo-600 px-4 py-2 text-sm font-medium text-white hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
          >
            Save Season
          </button>
        </div>
      </form>
    </div>
  );
}
