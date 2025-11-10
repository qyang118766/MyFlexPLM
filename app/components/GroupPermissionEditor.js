'use client';

import { useState, useEffect } from 'react';
import { ChevronRight, ChevronDown, Check } from 'lucide-react';

/**
 * GroupPermissionEditor Component
 *
 * Allows editing permissions for a group across different entity types
 * Features:
 * - Multi-select type tree nodes
 * - Set permission levels (none, read, edit, create, delete, full)
 * - Shows inheritance from parent groups
 * - Shows cascading effect to child nodes
 */
export default function GroupPermissionEditor({
  group,
  parentGroup = null,
  entityType = 'product',
  typeNodes = [],
  existingPermissions = [],
  onPermissionsChange
}) {
  const [selectedNodes, setSelectedNodes] = useState([]);
  const [permissions, setPermissions] = useState({});
  const [expandedNodes, setExpandedNodes] = useState(new Set());
  const [selectedPermissionLevel, setSelectedPermissionLevel] = useState('read');

  // Permission levels with labels and descriptions
  const permissionLevels = [
    { value: 'none', label: 'None', description: 'No access', color: 'bg-gray-100 text-gray-700' },
    { value: 'read', label: 'Read Only', description: 'View only', color: 'bg-blue-100 text-blue-700' },
    { value: 'edit', label: 'Edit', description: 'View and modify', color: 'bg-green-100 text-green-700' },
    { value: 'create', label: 'Create', description: 'View, modify, and create', color: 'bg-yellow-100 text-yellow-700' },
    { value: 'delete', label: 'Delete', description: 'View, modify, create, and delete', color: 'bg-orange-100 text-orange-700' },
    { value: 'full', label: 'Full Access', description: 'All operations', color: 'bg-purple-100 text-purple-700' },
  ];

  // Initialize permissions from existing data
  useEffect(() => {
    const permMap = {};
    existingPermissions.forEach(perm => {
      permMap[perm.type_node_id] = perm.permission_level;
    });
    setPermissions(permMap);
  }, [existingPermissions]);

  // Build tree structure
  const buildTree = (nodes, parentId = null) => {
    return nodes
      .filter(node => node.parent_id === parentId)
      .map(node => ({
        ...node,
        children: buildTree(nodes, node.id)
      }));
  };

  const tree = buildTree(typeNodes);

  // Toggle node expansion
  const toggleExpand = (nodeId) => {
    const newExpanded = new Set(expandedNodes);
    if (newExpanded.has(nodeId)) {
      newExpanded.delete(nodeId);
    } else {
      newExpanded.add(nodeId);
    }
    setExpandedNodes(newExpanded);
  };

  // Toggle node selection
  const toggleSelect = (nodeId) => {
    setSelectedNodes(prev => {
      if (prev.includes(nodeId)) {
        return prev.filter(id => id !== nodeId);
      } else {
        return [...prev, nodeId];
      }
    });
  };

  // Apply permission to selected nodes
  const applyPermissionToSelected = () => {
    if (selectedNodes.length === 0) return;

    const newPermissions = { ...permissions };

    // Apply to selected nodes and their descendants
    selectedNodes.forEach(nodeId => {
      applyPermissionToNodeAndDescendants(nodeId, selectedPermissionLevel, newPermissions);
    });

    setPermissions(newPermissions);
    setSelectedNodes([]);

    // Notify parent component
    if (onPermissionsChange) {
      onPermissionsChange(newPermissions);
    }
  };

  // Apply permission to node and all descendants (向下覆盖)
  const applyPermissionToNodeAndDescendants = (nodeId, permLevel, permMap) => {
    permMap[nodeId] = permLevel;

    // Find node and apply to children
    const node = typeNodes.find(n => n.id === nodeId);
    if (node) {
      const children = typeNodes.filter(n => n.parent_id === nodeId);
      children.forEach(child => {
        applyPermissionToNodeAndDescendants(child.id, permLevel, permMap);
      });
    }
  };

  // Get effective permission (considering inheritance from parent nodes)
  const getEffectivePermission = (nodeId) => {
    // Check direct permission
    if (permissions[nodeId]) {
      return permissions[nodeId];
    }

    // Check parent nodes
    const node = typeNodes.find(n => n.id === nodeId);
    if (node && node.parent_id) {
      return getEffectivePermission(node.parent_id);
    }

    return 'full'; // Default
  };

  // Get parent group's permission for this node (for validation)
  const getParentGroupPermission = (nodeId) => {
    if (!parentGroup) return 'full';
    // This would be fetched from server in real implementation
    return 'full';
  };

  // Render tree node
  const renderNode = (node, level = 0) => {
    const isExpanded = expandedNodes.has(node.id);
    const isSelected = selectedNodes.includes(node.id);
    const hasChildren = node.children && node.children.length > 0;
    const effectivePermission = getEffectivePermission(node.id);
    const directPermission = permissions[node.id];
    const permissionInfo = permissionLevels.find(p => p.value === effectivePermission);

    return (
      <div key={node.id}>
        <div
          className={`flex items-center py-2 px-2 hover:bg-gray-50 rounded ${
            isSelected ? 'bg-blue-50 border border-blue-200' : ''
          }`}
          style={{ paddingLeft: `${level * 20 + 8}px` }}
        >
          {/* Expand/Collapse button */}
          <button
            onClick={() => toggleExpand(node.id)}
            className="mr-1 p-1 hover:bg-gray-200 rounded"
            disabled={!hasChildren}
          >
            {hasChildren ? (
              isExpanded ? <ChevronDown size={16} /> : <ChevronRight size={16} />
            ) : (
              <span className="inline-block w-4" />
            )}
          </button>

          {/* Checkbox for selection */}
          <button
            onClick={() => toggleSelect(node.id)}
            className={`mr-2 w-5 h-5 border rounded flex items-center justify-center ${
              isSelected
                ? 'bg-blue-500 border-blue-500'
                : 'border-gray-300 hover:border-blue-500'
            }`}
          >
            {isSelected && <Check size={14} className="text-white" />}
          </button>

          {/* Node name */}
          <span className="flex-1 font-medium text-sm">{node.name}</span>

          {/* Permission badge */}
          {permissionInfo && (
            <span
              className={`ml-2 px-2 py-1 text-xs rounded ${permissionInfo.color}`}
              title={directPermission ? 'Direct permission' : 'Inherited from parent'}
            >
              {permissionInfo.label}
              {!directPermission && <span className="ml-1 text-gray-500">↑</span>}
            </span>
          )}
        </div>

        {/* Render children */}
        {isExpanded && hasChildren && (
          <div>
            {node.children.map(child => renderNode(child, level + 1))}
          </div>
        )}
      </div>
    );
  };

  // Clear all permissions
  const clearPermissions = () => {
    setPermissions({});
    if (onPermissionsChange) {
      onPermissionsChange({});
    }
  };

  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h3 className="text-lg font-semibold">
          {group ? `Permissions for "${group.name}"` : 'Group Permissions'}
        </h3>
        {parentGroup && (
          <span className="text-sm text-gray-500">
            Inherits from: <span className="font-medium">{parentGroup.name}</span>
          </span>
        )}
      </div>

      {/* Permission control panel */}
      <div className="bg-gray-50 p-4 rounded-lg border border-gray-200">
        <div className="flex items-center gap-4">
          <div className="flex-1">
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Select Permission Level
            </label>
            <div className="flex gap-2 flex-wrap">
              {permissionLevels.map(level => (
                <button
                  key={level.value}
                  onClick={() => setSelectedPermissionLevel(level.value)}
                  className={`px-3 py-2 text-sm rounded border ${
                    selectedPermissionLevel === level.value
                      ? level.color + ' border-current font-semibold'
                      : 'bg-white border-gray-300 text-gray-700 hover:bg-gray-50'
                  }`}
                  title={level.description}
                >
                  {level.label}
                </button>
              ))}
            </div>
          </div>

          <div className="flex flex-col gap-2">
            <button
              onClick={applyPermissionToSelected}
              disabled={selectedNodes.length === 0}
              className="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:bg-gray-300 disabled:cursor-not-allowed text-sm font-medium"
            >
              Apply to Selected ({selectedNodes.length})
            </button>
            <button
              onClick={clearPermissions}
              className="px-4 py-2 bg-white border border-gray-300 text-gray-700 rounded hover:bg-gray-50 text-sm"
            >
              Clear All
            </button>
          </div>
        </div>

        {selectedNodes.length > 0 && (
          <div className="mt-3 text-sm text-blue-600">
            {selectedNodes.length} node(s) selected. Permission will cascade to all child nodes.
          </div>
        )}
      </div>

      {/* Type tree */}
      <div className="border border-gray-200 rounded-lg bg-white">
        <div className="p-3 border-b bg-gray-50 flex items-center justify-between">
          <span className="font-medium text-sm">
            {entityType.charAt(0).toUpperCase() + entityType.slice(1)} Type Tree
          </span>
          <button
            onClick={() => {
              // Expand all nodes
              const allNodeIds = new Set(typeNodes.map(n => n.id));
              setExpandedNodes(allNodeIds);
            }}
            className="text-xs text-blue-600 hover:underline"
          >
            Expand All
          </button>
        </div>

        <div className="p-2 max-h-96 overflow-y-auto">
          {tree.length > 0 ? (
            tree.map(node => renderNode(node))
          ) : (
            <div className="text-center py-8 text-gray-500 text-sm">
              No type nodes available
            </div>
          )}
        </div>
      </div>

      {/* Legend */}
      <div className="text-xs text-gray-500 space-y-1">
        <div className="flex items-center gap-2">
          <span className="font-semibold">Note:</span>
          <span>Permissions cascade down to all child nodes.</span>
        </div>
        <div className="flex items-center gap-2">
          <span className="inline-block w-3 h-3 bg-blue-50 border border-blue-200 rounded" />
          <span>= Selected node</span>
        </div>
        <div className="flex items-center gap-2">
          <span className="text-gray-500">↑</span>
          <span>= Inherited from parent node</span>
        </div>
      </div>
    </div>
  );
}
