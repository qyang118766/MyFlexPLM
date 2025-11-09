import { createClient } from '@/lib/supabase/server';
import EnumManager from './EnumManager';

export default async function EnumsPage() {
  const supabase = await createClient();

  // 获取所有枚举值
  const { data: enums, error } = await supabase
    .from('enums')
    .select('*')
    .order('enum_type', { ascending: true })
    .order('order_index', { ascending: true })
    .order('enum_value', { ascending: true });

  if (error) {
    console.error('Error fetching enums:', error);
  }

  // 按枚举类型分组
  const groupedEnums = (enums || []).reduce((acc, item) => {
    if (!acc[item.enum_type]) {
      acc[item.enum_type] = [];
    }
    acc[item.enum_type].push(item);
    return acc;
  }, {});

  // 获取所有唯一的枚举类型
  const enumTypes = Object.keys(groupedEnums).sort();

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Enum Manager</h1>
        <p className="mt-2 text-sm text-gray-600">
          Manage system enumeration values for statuses, types, and other options
        </p>
      </div>

      {error && (
        <div className="rounded-md bg-red-50 p-4 mb-6">
          <div className="flex">
            <div className="ml-3">
              <h3 className="text-sm font-medium text-red-800">Error loading enums</h3>
              <div className="mt-2 text-sm text-red-700">
                <p>{error.message}</p>
              </div>
            </div>
          </div>
        </div>
      )}

      <EnumManager initialEnums={groupedEnums} enumTypes={enumTypes} />
    </div>
  );
}
