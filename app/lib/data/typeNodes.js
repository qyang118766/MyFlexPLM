export async function buildTypePath(supabase, typeId) {
  if (!typeId) {
    return [];
  }

  const path = [];
  let currentId = typeId;

  while (currentId) {
    const { data: node, error } = await supabase
      .from('entity_type_nodes')
      .select('id, name, code, parent_id')
      .eq('id', currentId)
      .single();

    if (error || !node) {
      break;
    }

    path.unshift(node);
    currentId = node.parent_id;
  }

  return path;
}

export function formatTypePath(path) {
  if (!path || path.length === 0) {
    return 'Unassigned Type';
  }
  return path.map((node) => node.name).join(' > ');
}
