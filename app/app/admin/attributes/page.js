import { createClient } from '@/lib/supabase/server';
import AttributeManager from '@/components/AttributeManager';

export default async function AttributeManagerPage() {
  const supabase = await createClient();

  const { data: attributes, error: attrError } = await supabase
    .from('attribute_definitions')
    .select('*')
    .order('entity_type', { ascending: true })
    .order('order_index', { ascending: true });

  const { data: typeNodes, error: nodesError } = await supabase
    .from('entity_type_nodes')
    .select('*')
    .order('display_order', { ascending: true });

  // Group by entity type
  const groupedAttributes = attributes?.reduce((acc, attr) => {
    if (!acc[attr.entity_type]) {
      acc[attr.entity_type] = [];
    }
    acc[attr.entity_type].push(attr);
    return acc;
  }, {}) || {};

  // Group type nodes by entity type
  const groupedTypeNodes = typeNodes?.reduce((acc, node) => {
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
        <h1 className="text-3xl font-bold text-gray-900">Attribute Manager</h1>
        <p className="mt-2 text-sm text-gray-600">
          Define dynamic attributes for entity types. You can scope attributes to specific type hierarchy levels.
        </p>
      </div>

      {(attrError || nodesError) && (
        <div className="text-red-600 mb-4">
          Error loading data: {attrError?.message || nodesError?.message}
        </div>
      )}

      <div className="space-y-6">
        {entityTypes.map((entityType) => (
          <div key={entityType} className="bg-white shadow rounded-lg">
            <div className="px-4 py-5 sm:p-6">
              <h2 className="text-lg font-medium text-gray-900 capitalize mb-4">
                {entityType} Attributes
              </h2>
              <AttributeManager
                entityType={entityType}
                attributes={groupedAttributes[entityType] || []}
                typeNodes={groupedTypeNodes[entityType] || []}
              />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
