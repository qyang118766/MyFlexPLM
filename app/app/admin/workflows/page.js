import { createClient } from '@/lib/supabase/server';
import { requireAdminUser } from '@/lib/auth/guards';
import WorkflowBuilder from '@/components/workflows/WorkflowBuilder';

export default async function WorkflowManagementPage() {
  const supabase = await createClient();

  await requireAdminUser(supabase);

  const { data: workflows, error } = await supabase
    .from('workflows')
    .select('*')
    .order('updated_at', { ascending: false });

  return (
    <div className="space-y-8">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Workflow Management</h1>
        <p className="mt-2 text-sm text-gray-600">
          Build approval flows using a drag-and-drop canvas, configure activity/condition/state nodes,
          and save the definition directly to the database.
        </p>
      </div>

      {error && (
        <div className="rounded-md border border-red-200 bg-red-50 px-4 py-3 text-sm text-red-700">
          {error.message}
        </div>
      )}

      <WorkflowBuilder initialWorkflows={workflows || []} />
    </div>
  );
}
