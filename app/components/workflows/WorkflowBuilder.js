'use client';

import { useCallback, useEffect, useMemo, useState } from 'react';
import ReactFlow, {
  ReactFlowProvider,
  addEdge,
  applyEdgeChanges,
  applyNodeChanges,
  Background,
  Controls,
  Handle,
  MarkerType,
  MiniMap,
  Position,
} from 'reactflow';
import 'reactflow/dist/style.css';
import {
  AdjustmentsHorizontalIcon,
  ArrowsRightLeftIcon,
  ClipboardDocumentListIcon,
  FlagIcon,
  PlayIcon,
  UserGroupIcon,
  UserIcon,
} from '@heroicons/react/24/solid';

const categoryStyles = {
  start: {
    label: 'Start',
    border: 'border-emerald-500',
    bg: 'bg-emerald-50',
    text: 'text-emerald-700',
    description: 'Entry node. Usually only one outgoing path.',
    icon: PlayIcon,
  },
  end: {
    label: 'End',
    border: 'border-rose-500',
    bg: 'bg-rose-50',
    text: 'text-rose-700',
    description: 'Terminal node. Typically only incoming paths.',
    icon: FlagIcon,
  },
  activity: {
    label: 'Activity',
    border: 'border-sky-500',
    bg: 'bg-sky-50',
    text: 'text-sky-700',
    description: 'Configure task content, instructions, and roles.',
    icon: ClipboardDocumentListIcon,
  },
  condition: {
    label: 'Condition',
    border: 'border-amber-500',
    bg: 'bg-amber-50',
    text: 'text-amber-700',
    description: 'Branch paths based on upstream node states.',
    icon: AdjustmentsHorizontalIcon,
  },
  state: {
    label: 'State Transition',
    border: 'border-indigo-500',
    bg: 'bg-indigo-50',
    text: 'text-indigo-700',
    description: 'Set the primary object status from its catalog.',
    icon: ArrowsRightLeftIcon,
  },
};

const palette = [
  { category: 'start', headline: 'Start', detail: 'Flow entry (outgoing paths only).' },
  { category: 'end', headline: 'End', detail: 'Flow terminal (incoming paths only).' },
  { category: 'activity', headline: 'Activity', detail: 'Task node with assignees and instructions.' },
  { category: 'condition', headline: 'Condition', detail: 'Route based on upstream outcomes.' },
  { category: 'state', headline: 'State Transition', detail: 'Update the primary object status.' },
];


const baseViewport = { x: 0, y: 0, zoom: 1 };

const WorkflowNode = ({ data }) => {
  const config = categoryStyles[data.category] || categoryStyles.activity;
  const Icon = config.icon || PlayIcon;
  const allowTarget = data.category !== 'start';
  const allowSource = data.category !== 'end';

  return (
    <div
      className={`min-w-[180px] rounded-xl border bg-white px-3 py-2 shadow-sm ${config.border}`}
    >
      {allowTarget && (
        <Handle type="target" position={Position.Top} className="!bg-slate-500" />
      )}
      <div className="flex items-center gap-2">
        {Icon && <Icon className="h-4 w-4 text-gray-500" />}
        <span
          className={`text-xs font-semibold uppercase tracking-wide ${config.text}`}
        >
          {data.label || config.label}
        </span>
        <span className="text-[10px] uppercase text-gray-400">
          {data.category}
        </span>
      </div>
      {data.description && (
        <p className="mt-1 text-xs text-gray-600">{data.description}</p>
      )}
      {data.assignedUsers && (
        <p className="mt-1 flex items-center gap-1 text-[11px] text-indigo-600">
          <UserIcon className="h-3.5 w-3.5" />
          <span>Users: {data.assignedUsers}</span>
        </p>
      )}
      {data.assignedGroups && (
        <p className="mt-1 flex items-center gap-1 text-[11px] text-fuchsia-600">
          <UserGroupIcon className="h-3.5 w-3.5" />
          <span>Groups: {data.assignedGroups}</span>
        </p>
      )}
      {data.conditions && (
        <p className="mt-1 text-[11px] text-amber-600">Conditions: {data.conditions}</p>
      )}
      {data.state && (
        <p className="mt-1 text-[11px] text-sky-600">State: {data.state}</p>
      )}
      {allowSource && (
        <Handle type="source" position={Position.Bottom} className="!bg-slate-500" />
      )}
    </div>
  );
};

const nodeTypes = { workflowNode: WorkflowNode };

function generateId(prefix) {
  if (typeof crypto !== 'undefined' && crypto.randomUUID) {
    return `${prefix}_${crypto.randomUUID()}`;
  }
  return `${prefix}_${Date.now()}_${Math.floor(Math.random() * 1000)}`;
}

function createNode(category, position = { x: 80, y: 120 }) {
  const style = categoryStyles[category] || categoryStyles.activity;
  return {
    id: generateId(category),
    type: 'workflowNode',
    position,
    data: {
      category,
      label: style.label,
      description: '',
      assignedUsers: '',
      assignedGroups: '',
      conditions: '',
      state: '',
    },
  };
}

function defaultNodes() {
  return [
    createNode('start', { x: 80, y: 160 }),
    createNode('end', { x: 420, y: 160 }),
  ];
}

function normalizeNodes(nodes) {
  if (!Array.isArray(nodes) || nodes.length === 0) {
    return defaultNodes();
  }

  return nodes.map((node, index) => ({
    ...node,
    id: node.id || `node_${index}`,
    type: 'workflowNode',
    data: {
      category: node?.data?.category || 'activity',
      label: node?.data?.label || 'Node',
      description: node?.data?.description || '',
      assignedUsers: node?.data?.assignedUsers || '',
      assignedGroups: node?.data?.assignedGroups || '',
      conditions: node?.data?.conditions || '',
      state: node?.data?.state || '',
    },
  }));
}

function normalizeEdges(edges) {
  if (!Array.isArray(edges)) {
    return [];
  }
  return edges.map((edge, index) => ({
    ...edge,
    id: edge.id || `edge_${index}`,
  }));
}

function WorkflowBuilderInner({ initialWorkflows = [] }) {
  const [workflowList, setWorkflowList] = useState(initialWorkflows);
  const [workflowId, setWorkflowId] = useState(null);
  const [workflowName, setWorkflowName] = useState('');
  const [workflowDescription, setWorkflowDescription] = useState('');
  const [nodes, setNodes] = useState(() => defaultNodes());
  const [edges, setEdges] = useState([]);
  const [selectedNodeId, setSelectedNodeId] = useState(null);
  const [reactFlowInstance, setReactFlowInstance] = useState(null);
  const [statusMessage, setStatusMessage] = useState('');
  const [isSaving, setIsSaving] = useState(false);
  const [isLoadingWorkflow, setIsLoadingWorkflow] = useState(false);
  const [contextEditActive, setContextEditActive] = useState(false);

  const selectedNode = useMemo(
    () => nodes.find((node) => node.id === selectedNodeId),
    [nodes, selectedNodeId]
  );

  const setViewport = useCallback(
    (viewport) => {
      if (reactFlowInstance && viewport) {
        reactFlowInstance.setViewport(viewport, { duration: 300 });
      } else if (reactFlowInstance) {
        reactFlowInstance.setViewport(baseViewport, { duration: 300 });
        reactFlowInstance.fitView({ padding: 0.2, duration: 300 });
      }
    },
    [reactFlowInstance]
  );

  const refreshWorkflows = useCallback(async () => {
    try {
      const response = await fetch('/api/workflows');
      if (!response.ok) {
        throw new Error('Failed to refresh workflow list');
      }
      const data = await response.json();
      setWorkflowList(data.workflows || []);
    } catch (error) {
      setStatusMessage(error.message);
    }
  }, []);

  const resetWorkflow = useCallback(() => {
    setWorkflowId(null);
    setWorkflowName('');
    setWorkflowDescription('');
    setNodes(defaultNodes());
    setEdges([]);
    setSelectedNodeId(null);
    setContextEditActive(false);
    setViewport(baseViewport);
  }, [setViewport]);

  const loadWorkflow = useCallback(
    async (id) => {
      if (!id) {
        resetWorkflow();
        return;
      }

      setIsLoadingWorkflow(true);
      setStatusMessage('');

    try {
      const response = await fetch(`/api/workflows?id=${id}`);
      if (!response.ok) {
        throw new Error('Failed to load workflow details');
      }
        const { workflow } = await response.json();
        setWorkflowId(workflow.id);
        setWorkflowName(workflow.name || '');
        setWorkflowDescription(workflow.description || '');
        const definition = workflow.definition || {};
        setNodes(normalizeNodes(definition.nodes));
        setEdges(normalizeEdges(definition.edges));
        setSelectedNodeId(null);
        setViewport(definition.viewport || baseViewport);
        setContextEditActive(false);
        setStatusMessage('Workflow loaded');
    } catch (error) {
      setStatusMessage(error.message);
    } finally {
      setIsLoadingWorkflow(false);
    }
  },
  [resetWorkflow, setViewport]
);

  useEffect(() => {
    const handleKeyDown = (event) => {
      if (
        (event.key === 'Delete' || event.key === 'Backspace') &&
        selectedNodeId
      ) {
        setNodes((currentNodes) => {
          const target = currentNodes.find((node) => node.id === selectedNodeId);
          if (!target) {
            return currentNodes;
          }
          if (target.data?.category === 'start' || target.data?.category === 'end') {
            return currentNodes;
          }
          return currentNodes.filter((node) => node.id !== selectedNodeId);
        });
        setEdges((currentEdges) =>
          currentEdges.filter(
            (edge) => edge.source !== selectedNodeId && edge.target !== selectedNodeId
          )
        );
        setSelectedNodeId(null);
        setContextEditActive(false);
        setStatusMessage('Node removed');
      }
    };

    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, [selectedNodeId]);

  useEffect(() => {
    setWorkflowList(initialWorkflows);
  }, [initialWorkflows]);

  const handleNodesChange = useCallback(
    (changes) => setNodes((nds) => applyNodeChanges(changes, nds)),
    []
  );

  const handleEdgesChange = useCallback(
    (changes) => setEdges((eds) => applyEdgeChanges(changes, eds)),
    []
  );

  const handleConnect = useCallback(
    (connection) =>
      setEdges((eds) =>
        addEdge(
          {
            ...connection,
            markerEnd: {
              type: MarkerType.ArrowClosed,
              width: 12,
              height: 12,
            },
          },
          eds
        )
      ),
    []
  );

  const handleSelectionChange = useCallback(({ nodes }) => {
    setSelectedNodeId(nodes?.[0]?.id || null);
    setContextEditActive(false);
  }, []);

  const handleNodeContextMenu = useCallback(
    (event, node) => {
      if (!node) return;
      if (node?.data?.category === 'start' || node?.data?.category === 'end') {
        return;
      }
      event.preventDefault();
      setSelectedNodeId(node.id);
      setContextEditActive(true);
    },
    []
  );

  const addNode = useCallback((category) => {
    setNodes((current) => [
      ...current,
      createNode(category, {
        x: 100 + Math.random() * 500,
        y: 80 + Math.random() * 320,
      }),
    ]);
  }, []);

  const updateSelectedNode = useCallback(
    (field, value) => {
      if (!selectedNodeId) return;
      setNodes((current) =>
        current.map((node) =>
          node.id === selectedNodeId
            ? {
                ...node,
                data: {
                  ...node.data,
                  [field]: value,
                },
              }
            : node
        )
      );
    },
    [selectedNodeId]
  );

  const handleSave = useCallback(async () => {
    if (!workflowName.trim()) {
      setStatusMessage('Please enter a workflow name');
      return;
    }

    setIsSaving(true);
    setStatusMessage('');

    try {
      const payload = {
        id: workflowId,
        name: workflowName.trim(),
        description: workflowDescription,
        definition: {
          nodes,
          edges,
          viewport: reactFlowInstance?.getViewport() || baseViewport,
        },
      };

      const response = await fetch('/api/workflows', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload),
      });

      const data = await response.json();

      if (!response.ok) {
        throw new Error(data.error || 'Save failed');
      }

      setWorkflowId(data.workflow.id);
      setStatusMessage('Workflow saved');
      setWorkflowList((list) => {
        const remaining = list.filter((item) => item.id !== data.workflow.id);
        return [data.workflow, ...remaining];
      });
    } catch (error) {
      setStatusMessage(error.message);
    } finally {
      setIsSaving(false);
    }
  }, [
    edges,
    nodes,
    reactFlowInstance,
    workflowDescription,
    workflowId,
    workflowName,
  ]);

  return (
    <div className="space-y-6">
      <div className="rounded-xl border border-gray-200 bg-white p-6 shadow-sm">
        <div className="grid gap-4 lg:grid-cols-3">
          <div>
            <label className="text-sm font-medium text-gray-700">Saved Workflows</label>
            <select
              className="mt-1 w-full rounded-md border-gray-300 text-sm shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
              value={workflowId || ''}
              onChange={(event) => loadWorkflow(event.target.value)}
            >
              <option value="">Create New Workflow</option>
              {workflowList.map((workflow) => (
                <option key={workflow.id} value={workflow.id}>
                  {workflow.name}
                </option>
              ))}
            </select>
          </div>
          <div className="flex items-end gap-3">
            <button
              type="button"
              onClick={refreshWorkflows}
              className="inline-flex flex-1 items-center justify-center rounded-md border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
            >
              Refresh List
            </button>
            <button
              type="button"
              onClick={resetWorkflow}
              className="inline-flex flex-1 items-center justify-center rounded-md border border-gray-300 px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50"
            >
              New Blank Workflow
            </button>
          </div>
          <div className="text-right text-sm text-gray-500">
            {isLoadingWorkflow ? 'Loading…' : statusMessage}
          </div>
        </div>

        <div className="mt-6 grid gap-4 lg:grid-cols-2">
          <div>
            <label className="text-sm font-medium text-gray-700">Workflow Name</label>
            <input
              type="text"
              value={workflowName}
              onChange={(event) => setWorkflowName(event.target.value)}
              placeholder="e.g. Material Development Approval Flow"
              className="mt-1 w-full rounded-md border-gray-300 text-sm shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
            />
          </div>
          <div>
            <label className="text-sm font-medium text-gray-700">Workflow Description</label>
            <input
              type="text"
              value={workflowDescription}
              onChange={(event) => setWorkflowDescription(event.target.value)}
              placeholder="Briefly describe what the workflow does"
              className="mt-1 w-full rounded-md border-gray-300 text-sm shadow-sm focus:border-indigo-500 focus:ring-indigo-500"
            />
          </div>
        </div>

        <div className="mt-4 flex justify-end gap-3">
          <button
            type="button"
            onClick={handleSave}
            disabled={isSaving}
            className="inline-flex items-center rounded-md bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-700 disabled:cursor-not-allowed disabled:opacity-70"
          >
            {isSaving ? 'Saving…' : 'Save Workflow'}
          </button>
        </div>
      </div>

      <div className="grid gap-6 lg:grid-cols-[260px_minmax(0,1fr)_320px] pb-10">
        <div className="space-y-3">
          {palette.map((item) => {
            const Icon = categoryStyles[item.category]?.icon;
            return (
              <button
                key={item.category}
                type="button"
                onClick={() => addNode(item.category)}
                className="w-full rounded-xl border border-gray-200 bg-white px-4 py-3 text-left shadow-sm transition hover:border-indigo-400 hover:shadow"
              >
                <div className="flex items-start gap-3">
                  {Icon && <Icon className="h-5 w-5 text-gray-500" />}
                  <div>
                    <p className="text-sm font-semibold text-gray-900">
                      {item.headline}
                    </p>
                    <p className="text-xs text-gray-500">{item.detail}</p>
                  </div>
                </div>
              </button>
            );
          })}
          <p className="text-xs text-gray-500">
            Add components to the canvas, drag them into position, connect nodes with arrows, and press Delete to remove selected nodes.
          </p>
        </div>

        <div className="rounded-xl border border-gray-200 bg-white shadow-sm">
          <ReactFlow
            nodes={nodes}
            edges={edges}
            onNodesChange={handleNodesChange}
            onEdgesChange={handleEdgesChange}
            onConnect={handleConnect}
            nodeTypes={nodeTypes}
            onInit={setReactFlowInstance}
            onSelectionChange={handleSelectionChange}
            onNodeContextMenu={handleNodeContextMenu}
            fitView
            className="h-[720px] min-h-[720px]"
          >
            <MiniMap />
            <Controls />
            <Background gap={16} />
          </ReactFlow>
        </div>

        <div className="rounded-xl border border-gray-200 bg-white p-4 shadow-sm">
          <div className="flex items-center justify-between">
            <h3 className="text-sm font-semibold text-gray-900">Properties</h3>
            {contextEditActive && selectedNode && (
              <span className="rounded-full bg-indigo-100 px-3 py-1 text-[10px] font-semibold uppercase tracking-wide text-indigo-600">
                Context edit
              </span>
            )}
          </div>
          {!selectedNode && (
            <p className="mt-3 text-sm text-gray-500">Select a node to configure it.</p>
          )}

          {selectedNode && (
            <div className="mt-4 space-y-4">
              <div>
                <label className="text-xs font-medium text-gray-600">Name</label>
                <input
                  type="text"
                  value={selectedNode.data.label}
                  onChange={(event) => updateSelectedNode('label', event.target.value)}
                  className="mt-1 w-full rounded-md border-gray-300 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                />
              </div>

              <div>
                <label className="text-xs font-medium text-gray-600">Task Description</label>
                <textarea
                  value={selectedNode.data.description}
                  onChange={(event) => updateSelectedNode('description', event.target.value)}
                  rows={3}
                  placeholder="Describe the required work or decision."
                  className="mt-1 w-full rounded-md border-gray-300 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                />
              </div>

              {selectedNode.data.category !== 'start' && selectedNode.data.category !== 'end' && (
                <>
                  <div>
                    <label className="text-xs font-medium text-gray-600">Assigned Users</label>
                    <input
                      type="text"
                      value={selectedNode.data.assignedUsers}
                      onChange={(event) => updateSelectedNode('assignedUsers', event.target.value)}
                      placeholder="e.g. Material Engineer, Purchasing"
                      className="mt-1 w-full rounded-md border-gray-300 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                    />
                  </div>
                  <div>
                    <label className="text-xs font-medium text-gray-600">Assigned Groups</label>
                    <input
                      type="text"
                      value={selectedNode.data.assignedGroups}
                      onChange={(event) => updateSelectedNode('assignedGroups', event.target.value)}
                      placeholder="Enter group names or codes"
                      className="mt-1 w-full rounded-md border-gray-300 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                    />
                  </div>
                </>
              )}

              {selectedNode.data.category === 'condition' && (
                <div>
                  <label className="text-xs font-medium text-gray-600">Condition Logic</label>
                  <textarea
                    value={selectedNode.data.conditions}
                    onChange={(event) =>
                      updateSelectedNode('conditions', event.target.value)
                    }
                    rows={3}
                    placeholder="e.g. A=Approved AND B=Rejected"
                    className="mt-1 w-full rounded-md border-gray-300 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                  />
                </div>
              )}

              {selectedNode.data.category === 'state' && (
                <div>
                  <label className="text-xs font-medium text-gray-600">Target Status</label>
                  <input
                    type="text"
                    value={selectedNode.data.state}
                    onChange={(event) =>
                      updateSelectedNode('state', event.target.value)
                    }
                    placeholder="e.g. Released / Archived"
                    className="mt-1 w-full rounded-md border-gray-300 text-sm focus:border-indigo-500 focus:ring-indigo-500"
                  />
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default function WorkflowBuilder(props) {
  return (
    <ReactFlowProvider>
      <WorkflowBuilderInner {...props} />
    </ReactFlowProvider>
  );
}
