import { createClient } from '@/lib/supabase/server';
import TypeTreeView from '@/components/TypeTreeView';

export default async function TypeManagerPage() {
  const supabase = await createClient();

  const { data: typeNodes, error } = await supabase
    .from('entity_type_nodes')
    .select('*')
    .order('entity_type', { ascending: true })
    .order('display_order', { ascending: true });

  // Group by entity type
  const groupedTypes = typeNodes?.reduce((acc, node) => {
    if (!acc[node.entity_type]) {
      acc[node.entity_type] = [];
    }
    acc[node.entity_type].push(node);
    return acc;
  }, {}) || {};

  const entityTypes = ['product', 'material', 'supplier', 'color', 'season'];

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-3xl font-bold text-gray-900">Type Manager</h1>
        <p className="mt-2 text-sm text-gray-600">
          Manage entity type hierarchies and classifications. Right-click on nodes to add children, edit, or delete.
        </p>
      </div>

      {error && (
        <div className="text-red-600 mb-4">Error loading types: {error.message}</div>
      )}

      <div className="space-y-6">
        {entityTypes.map((entityType) => (
          <div key={entityType} className="bg-white shadow rounded-lg">
            <div className="px-4 py-5 sm:p-6">
              <h2 className="text-lg font-medium text-gray-900 capitalize mb-4">
                {entityType} Type Hierarchy
              </h2>
              <TypeTreeView
                entityType={entityType}
                nodes={groupedTypes[entityType] || []}
              />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
