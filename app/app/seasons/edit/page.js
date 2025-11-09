import Link from 'next/link';
import { notFound } from 'next/navigation';
import { createClient } from '@/lib/supabase/server';
import { updateSeason } from '@/lib/actions/seasons';
import { getEnumValues, ENUM_TYPES } from '@/lib/services/enums';

// SEASON_TYPES remains as a local constant for template selection
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

function inferSeasonType(code) {
  if (!code) return '';
  const upperCode = code.toUpperCase();
  const match = SEASON_TYPES.find((type) => upperCode.startsWith(type.code));
  return match ? match.value : '';
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

export default async function EditSeasonPage({ searchParams }) {
  // Next.js 15+: searchParams 是一个 Promise，需要 await
  const params = await searchParams;
  const seasonId = getSearchParam(params, 'seasonId');

  if (!seasonId) {
    return (
      <div className="bg-white shadow rounded-lg p-10 space-y-4">
        <div>
          <h1 className="text-2xl font-semibold text-gray-900 mb-2">Edit Season</h1>
          <p className="text-gray-600">Select a season from the list to edit its details.</p>
        </div>
        <Link
          href="/seasons"
          className="inline-flex items-center text-sm font-medium text-indigo-600 hover:text-indigo-800"
        >
          &larr; Back to Seasons
        </Link>
      </div>
    );
  }

  // Fetch enum values from database
  const statusOptions = await getEnumValues(ENUM_TYPES.SEASON_STATUS);

  const supabase = await createClient();

  const [{ data: season, error: seasonError }, { data: attributeDefs, error: attributesError }] =
    await Promise.all([
      supabase.from('seasons').select('*').eq('id', seasonId).single(),
      supabase
        .from('attribute_definitions')
        .select('*')
        .eq('entity_type', 'season')
        .eq('is_active', true)
        .order('order_index', { ascending: true })
        .order('created_at', { ascending: true }),
    ]);

  if (seasonError || !season) {
    notFound();
  }

  if (attributesError) {
    throw new Error(attributesError.message);
  }

  const inferredType = inferSeasonType(season.code);
  const upcomingYears = getUpcomingYears();
  const seasonAttributes = season.attributes || {};

  return (
    <div className="space-y-8">
      <div>
        <Link href="/seasons" className="text-sm text-indigo-600 hover:text-indigo-800">
          &larr; Back to Seasons
        </Link>
      </div>

      <div className="flex flex-col gap-2">
        <h1 className="text-3xl font-bold text-gray-900">Edit Season</h1>
        <p className="text-sm text-gray-600">
          Update the template, year, and attributes. Season code and name will be regenerated based on your
          selections.
        </p>
      </div>

      <form action={updateSeason} className="bg-white shadow rounded-lg p-8 space-y-8">
        <input type="hidden" name="season_id" value={season.id} />

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
              defaultValue={inferredType || ''}
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
              defaultValue={season.year ?? ''}
              className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
              inputMode="numeric"
            />
            <datalist id="season-year-options">
              {upcomingYears.map((year) => (
                <option key={year} value={year} />
              ))}
            </datalist>
          </div>

          <div>
            <label htmlFor="status" className="block text-sm font-medium text-gray-700">
              Status
            </label>
            <select
              id="status"
              name="status"
              className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
              defaultValue={season.status || 'planned'}
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
              Current Code: <strong>{season.code || 'N/A'}</strong> &middot; Current Name:{' '}
              <strong>{season.name || 'N/A'}</strong>
            </p>
            <p className="mt-1">
              After saving, the code becomes <strong>CODE + YEAR</strong> (e.g. <code>SS2025</code>) and the name
              becomes <strong>YEAR + LABEL</strong> (e.g. <code>2025 Spring / Summer</code>).
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
                  <AttributeField attribute={attribute} value={seasonAttributes[attribute.key]} />
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
            Save Changes
          </button>
        </div>
      </form>
    </div>
  );
}
