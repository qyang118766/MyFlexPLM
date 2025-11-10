import { NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';
import { requireAdminUser } from '@/lib/auth/guards';

function normalizeDefinition(definition) {
  if (!definition) {
    return { nodes: [], edges: [], viewport: null };
  }

  if (typeof definition === 'string') {
    try {
      return normalizeDefinition(JSON.parse(definition));
    } catch {
      return { nodes: [], edges: [], viewport: null };
    }
  }

  const base = { nodes: [], edges: [], viewport: null };
  return {
    ...base,
    ...definition,
    nodes: Array.isArray(definition.nodes) ? definition.nodes : [],
    edges: Array.isArray(definition.edges) ? definition.edges : [],
    viewport:
      definition.viewport && typeof definition.viewport === 'object'
        ? definition.viewport
        : null,
  };
}

function jsonError(message, status = 400) {
  return NextResponse.json({ error: message }, { status });
}

export async function GET(request) {
  const supabase = await createClient();

  try {
    await requireAdminUser(supabase);
  } catch (error) {
    return jsonError(error.message, error.statusCode || 401);
  }

  const { searchParams } = new URL(request.url);
  const workflowId = searchParams.get('id');

  if (workflowId) {
    const { data, error } = await supabase
      .from('workflows')
      .select('*')
      .eq('id', workflowId)
      .single();

    if (error) {
      return jsonError(error.message, 404);
    }

    return NextResponse.json({ workflow: data });
  }

  const { data, error } = await supabase
    .from('workflows')
    .select('*')
    .order('updated_at', { ascending: false });

  if (error) {
    return jsonError(error.message, 500);
  }

  return NextResponse.json({ workflows: data ?? [] });
}

export async function POST(request) {
  const supabase = await createClient();
  let guard;

  try {
    guard = await requireAdminUser(supabase);
  } catch (error) {
    return jsonError(error.message, error.statusCode || 401);
  }

  let payload;
  try {
    payload = await request.json();
  } catch {
    return jsonError('Invalid JSON payload');
  }

  const { id, name, description, definition } = payload || {};

  if (!name || typeof name !== 'string') {
    return jsonError('Workflow name is required');
  }

  const definitionObject = normalizeDefinition(definition);
  const timestamp = new Date().toISOString();

  const basePayload = {
    name: name.trim(),
    description: description?.toString().trim() || null,
    definition: definitionObject,
    update_by: guard.identifier,
    updated_at: timestamp,
  };

  let result;
  let error;

  if (id) {
    ({ data: result, error } = await supabase
      .from('workflows')
      .update(basePayload)
      .eq('id', id)
      .select()
      .single());
  } else {
    ({ data: result, error } = await supabase
      .from('workflows')
      .insert({
        ...basePayload,
        create_by: guard.identifier,
      })
      .select()
      .single());
  }

  if (error) {
    return jsonError(error.message, 500);
  }

  return NextResponse.json({ workflow: result }, { status: id ? 200 : 201 });
}

