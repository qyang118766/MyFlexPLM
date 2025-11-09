'use client';

import { useState, useRef, useEffect } from 'react';
import { createTypeNode, updateTypeNode, deleteTypeNode } from '@/lib/actions/typeNodes';

export default function TypeTreeView({ entityType, nodes }) {
  const [expandedNodes, setExpandedNodes] = useState(new Set());
  const [contextMenu, setContextMenu] = useState(null);
  const [editingNode, setEditingNode] = useState(null);
  const [showAddDialog, setShowAddDialog] = useState(null);
  const contextMenuRef = useRef(null);

  // Build tree structure from flat list
  const buildTree = (nodes, parentId = null) => {
    return nodes
      .filter((node) => node.parent_id === parentId)
      .sort((a, b) => a.display_order - b.display_order)
      .map((node) => ({
        ...node,
        children: buildTree(nodes, node.id),
      }));
  };

  const tree = buildTree(nodes);

  // Toggle node expansion
  const toggleNode = (nodeId) => {
    const newExpanded = new Set(expandedNodes);
    if (newExpanded.has(nodeId)) {
      newExpanded.delete(nodeId);
    } else {
      newExpanded.add(nodeId);
    }
    setExpandedNodes(newExpanded);
  };

  // Handle right-click context menu
  const handleContextMenu = (e, node) => {
    e.preventDefault();
    setContextMenu({
      x: e.clientX,
      y: e.clientY,
      node,
    });
  };

  // Close context menu when clicking outside
  useEffect(() => {
    const handleClickOutside = (e) => {
      if (contextMenuRef.current && !contextMenuRef.current.contains(e.target)) {
        setContextMenu(null);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Handle add child action
  const handleAddChild = (parentNode) => {
    if (!parentNode.can_have_children) {
      alert('This node cannot have children.');
      return;
    }
    setShowAddDialog({ parentId: parentNode.id, parentName: parentNode.name });
    setContextMenu(null);
  };

  // Handle edit action
  const handleEdit = (node) => {
    setEditingNode(node);
    setContextMenu(null);
  };

  // Handle delete action
  const handleDelete = async (node) => {
    if (!confirm(`Are you sure you want to delete "${node.name}"?`)) {
      return;
    }

    const formData = new FormData();
    formData.append('id', node.id);

    const result = await deleteTypeNode(formData);
    if (!result.success) {
      alert(`Error: ${result.error}`);
    }
    setContextMenu(null);
  };

  // Render a single tree node
  const renderNode = (node, level = 0) => {
    const hasChildren = node.children && node.children.length > 0;
    const isExpanded = expandedNodes.has(node.id);

    return (
      <div key={node.id}>
        <div
          className="flex items-center py-2 px-3 hover:bg-gray-50 cursor-pointer group"
          style={{ paddingLeft: `${level * 24 + 12}px` }}
          onContextMenu={(e) => handleContextMenu(e, node)}
        >
          {/* Expand/Collapse Icon */}
          <button
            onClick={() => toggleNode(node.id)}
            className="w-5 h-5 flex items-center justify-center mr-2"
          >
            {hasChildren ? (
              isExpanded ? (
                <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clipRule="evenodd" />
                </svg>
              ) : (
                <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clipRule="evenodd" />
                </svg>
              )
            ) : (
              <span className="w-4 h-4"></span>
            )}
          </button>

          {/* Node Icon */}
          <svg className="w-5 h-5 mr-2 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
            <path d="M2 6a2 2 0 012-2h5l2 2h5a2 2 0 012 2v6a2 2 0 01-2 2H4a2 2 0 01-2-2V6z" />
          </svg>

          {/* Node Name */}
          <span className="text-sm font-medium text-gray-900 flex-1">
            {node.name}
          </span>

          {/* Code Badge */}
          {node.code && (
            <span className="ml-2 px-2 py-1 text-xs font-semibold bg-gray-100 text-gray-600 rounded">
              {node.code}
            </span>
          )}

          {/* Can't have children indicator */}
          {!node.can_have_children && (
            <span className="ml-2 px-2 py-1 text-xs font-semibold bg-yellow-100 text-yellow-800 rounded">
              Leaf
            </span>
          )}
        </div>

        {/* Render children if expanded */}
        {hasChildren && isExpanded && (
          <div>
            {node.children.map((child) => renderNode(child, level + 1))}
          </div>
        )}
      </div>
    );
  };

  return (
    <div className="relative">
      {/* Tree View */}
      <div className="border border-gray-200 rounded-lg bg-white">
        {tree.length > 0 ? (
          <div className="divide-y divide-gray-100">
            {tree.map((node) => renderNode(node))}
          </div>
        ) : (
          <div className="p-8 text-center text-gray-500">
            No type nodes defined. Right-click to add a root node.
          </div>
        )}
      </div>

      {/* Context Menu */}
      {contextMenu && (
        <div
          ref={contextMenuRef}
          className="fixed z-50 bg-white border border-gray-200 rounded-lg shadow-lg py-1 min-w-[160px]"
          style={{ left: contextMenu.x, top: contextMenu.y }}
        >
          {contextMenu.node.can_have_children && (
            <button
              onClick={() => handleAddChild(contextMenu.node)}
              className="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
            >
              Add Child
            </button>
          )}
          <button
            onClick={() => handleEdit(contextMenu.node)}
            className="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
          >
            Edit
          </button>
          <button
            onClick={() => handleDelete(contextMenu.node)}
            className="w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-gray-100"
          >
            Delete
          </button>
        </div>
      )}

      {/* Add Root Node Button (when right-clicking empty space) */}
      <button
        onClick={() => setShowAddDialog({ parentId: null, parentName: 'Root' })}
        className="mt-4 bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700"
      >
        Add Root Type
      </button>

      {/* Add/Edit Dialog */}
      {(showAddDialog || editingNode) && (
        <NodeDialog
          entityType={entityType}
          parentId={showAddDialog?.parentId}
          parentName={showAddDialog?.parentName}
          editNode={editingNode}
          onClose={() => {
            setShowAddDialog(null);
            setEditingNode(null);
          }}
        />
      )}
    </div>
  );
}

// Dialog for adding/editing nodes
function NodeDialog({ entityType, parentId, parentName, editNode, onClose }) {
  const [formData, setFormData] = useState({
    name: editNode?.name || '',
    code: editNode?.code || '',
    can_have_children: editNode?.can_have_children ?? true,
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState(null);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    setError(null);

    try {
      const data = new FormData();

      if (editNode) {
        // Update existing node
        data.append('id', editNode.id);
        data.append('name', formData.name);
        data.append('code', formData.code);
        data.append('can_have_children', formData.can_have_children.toString());

        const result = await updateTypeNode(data);
        if (!result.success) {
          throw new Error(result.error);
        }
      } else {
        // Create new node
        data.append('entity_type', entityType);
        data.append('name', formData.name);
        data.append('code', formData.code);
        if (parentId) {
          data.append('parent_id', parentId);
        }
        data.append('can_have_children', formData.can_have_children.toString());

        const result = await createTypeNode(data);
        if (!result.success) {
          throw new Error(result.error);
        }
      }

      onClose();
    } catch (err) {
      setError(err.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6">
        <h3 className="text-lg font-semibold mb-4">
          {editNode ? 'Edit Type Node' : `Add Child to ${parentName}`}
        </h3>

        {error && (
          <div className="mb-4 p-3 bg-red-50 text-red-700 rounded-md text-sm">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit}>
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Name <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                required
                value={formData.name}
                onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                placeholder="e.g., Womens Apparel"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Code (Optional)
              </label>
              <input
                type="text"
                value={formData.code}
                onChange={(e) => setFormData({ ...formData, code: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                placeholder="e.g., WOMENS_APP"
              />
            </div>

            <div className="flex items-center">
              <input
                type="checkbox"
                id="can_have_children"
                checked={formData.can_have_children}
                onChange={(e) => setFormData({ ...formData, can_have_children: e.target.checked })}
                className="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
              />
              <label htmlFor="can_have_children" className="ml-2 text-sm text-gray-700">
                Can have children (uncheck to make this a leaf node)
              </label>
            </div>
          </div>

          <div className="mt-6 flex justify-end space-x-3">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
              disabled={isSubmitting}
            >
              Cancel
            </button>
            <button
              type="submit"
              className="px-4 py-2 text-sm font-medium text-white bg-indigo-600 rounded-md hover:bg-indigo-700 disabled:opacity-50"
              disabled={isSubmitting}
            >
              {isSubmitting ? 'Saving...' : (editNode ? 'Update' : 'Create')}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
