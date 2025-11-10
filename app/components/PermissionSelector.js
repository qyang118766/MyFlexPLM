'use client';

import { useState } from 'react';

const PERMISSION_LEVELS = [
  { value: 'none', label: 'None (Hidden)', color: 'bg-gray-100 text-gray-800' },
  { value: 'read', label: 'Read Only', color: 'bg-blue-100 text-blue-800' },
  { value: 'write', label: 'Full Control', color: 'bg-green-100 text-green-800' },
];

/**
 * PermissionSelector Component
 *
 * Allows selecting permission levels for different groups
 *
 * @param {Array} groups - All available groups
 * @param {Array} permissions - Current permissions [{groupId, permissionLevel}]
 * @param {Function} onChange - Callback when permissions change
 */
export default function PermissionSelector({ groups, permissions = [], onChange }) {
  const [expandedNodes, setExpandedNodes] = useState(new Set());

  // Build permission map for quick lookup
  const permissionMap = permissions.reduce((acc, p) => {
    acc[p.groupId || 'default'] = p.permissionLevel;
    return acc;
  }, {});

  // Get default permission (for users not in any group)
  const defaultPermission = permissionMap['default'] || 'write';

  // Build tree structure
  const buildTree = (nodes, parentId = null) => {
    return nodes
      .filter((node) => node.parent_id === parentId)
      .sort((a, b) => a.display_order - b.display_order)
      .map((node) => ({
        ...node,
        children: buildTree(nodes, node.id),
      }));
  };

  const tree = buildTree(groups);

  const toggleNode = (nodeId) => {
    const newExpanded = new Set(expandedNodes);
    if (newExpanded.has(nodeId)) {
      newExpanded.delete(nodeId);
    } else {
      newExpanded.add(nodeId);
    }
    setExpandedNodes(newExpanded);
  };

  const handlePermissionChange = (groupId, level) => {
    const newPermissions = permissions.filter(p => p.groupId !== groupId);

    if (level !== null) {
      newPermissions.push({
        groupId,
        permissionLevel: level,
      });
    }

    onChange(newPermissions);
  };

  const handleDefaultPermissionChange = (level) => {
    const newPermissions = permissions.filter(p => p.groupId !== null);

    newPermissions.push({
      groupId: null,
      permissionLevel: level,
    });

    onChange(newPermissions);
  };

  const renderNode = (node, level = 0) => {
    const hasChildren = node.children && node.children.length > 0;
    const isExpanded = expandedNodes.has(node.id);
    const currentPermission = permissionMap[node.id];

    return (
      <div key={node.id}>
        <div
          className="flex items-center py-2 hover:bg-gray-50"
          style={{ paddingLeft: `${level * 20 + 8}px` }}
        >
          {/* Expand/Collapse Button */}
          <button
            type="button"
            onClick={() => hasChildren && toggleNode(node.id)}
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

          {/* Group Icon */}
          <svg className="w-4 h-4 mr-2 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
            <path d="M13 6a3 3 0 11-6 0 3 3 0 016 0zM18 8a2 2 0 11-4 0 2 2 0 014 0zM14 15a4 4 0 00-8 0v3h8v-3zM6 8a2 2 0 11-4 0 2 2 0 014 0zM16 18v-3a5.972 5.972 0 00-.75-2.906A3.005 3.005 0 0119 15v3h-3zM4.75 12.094A5.973 5.973 0 004 15v3H1v-3a3 3 0 013.75-2.906z" />
          </svg>

          {/* Group Name */}
          <span className="text-sm text-gray-900 flex-1">
            {node.name}
            {node.code && (
              <span className="ml-1 text-xs text-gray-500">({node.code})</span>
            )}
          </span>

          {/* Permission Dropdown */}
          <select
            value={currentPermission || ''}
            onChange={(e) => handlePermissionChange(node.id, e.target.value || null)}
            className="text-xs border border-gray-300 rounded px-2 py-1 focus:outline-none focus:ring-2 focus:ring-indigo-500"
          >
            <option value="">Not Set</option>
            {PERMISSION_LEVELS.map((level) => (
              <option key={level.value} value={level.value}>
                {level.label}
              </option>
            ))}
          </select>
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
    <div className="space-y-4">
      {/* Default Permission for All Users */}
      <div className="bg-blue-50 border border-blue-200 rounded-lg p-3">
        <div className="flex items-center justify-between">
          <div className="flex items-center">
            <svg className="w-5 h-5 mr-2 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
              <path d="M9 6a3 3 0 11-6 0 3 3 0 016 0zM17 6a3 3 0 11-6 0 3 3 0 016 0zM12.93 17c.046-.327.07-.66.07-1a6.97 6.97 0 00-1.5-4.33A5 5 0 0119 16v1h-6.07zM6 11a5 5 0 015 5v1H1v-1a5 5 0 015-5z" />
            </svg>
            <div>
              <div className="text-sm font-medium text-gray-900">All Users (Default)</div>
              <div className="text-xs text-gray-600">
                Applies to users not in any specific group
              </div>
            </div>
          </div>

          <select
            value={defaultPermission}
            onChange={(e) => handleDefaultPermissionChange(e.target.value)}
            className="text-sm border border-gray-300 rounded px-3 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-500 bg-white"
          >
            {PERMISSION_LEVELS.map((level) => (
              <option key={level.value} value={level.value}>
                {level.label}
              </option>
            ))}
          </select>
        </div>
      </div>

      {/* Group-specific Permissions */}
      <div>
        <div className="text-sm font-medium text-gray-700 mb-2">
          Group-Specific Permissions
        </div>
        <div className="border border-gray-200 rounded-lg max-h-80 overflow-y-auto">
          {tree.length > 0 ? (
            tree.map((node) => renderNode(node))
          ) : (
            <div className="p-4 text-center text-sm text-gray-500">
              No groups available
            </div>
          )}
        </div>
        <div className="mt-2 text-xs text-gray-500">
          Group-specific permissions override the default permission. Leave &quot;Not Set&quot; to use default.
        </div>
      </div>

      {/* Permission Summary */}
      {permissions.length > 0 && (
        <div className="bg-gray-50 border border-gray-200 rounded-lg p-3">
          <div className="text-xs font-medium text-gray-700 mb-2">
            Permission Summary
          </div>
          <div className="flex flex-wrap gap-2">
            {permissions.map((p) => {
              const group = p.groupId ? groups.find(g => g.id === p.groupId) : null;
              const levelInfo = PERMISSION_LEVELS.find(l => l.value === p.permissionLevel);

              return (
                <div
                  key={p.groupId || 'default'}
                  className={`px-2 py-1 text-xs font-semibold rounded ${levelInfo?.color || 'bg-gray-100 text-gray-800'}`}
                >
                  {group ? group.name : 'All Users'}: {levelInfo?.label || p.permissionLevel}
                </div>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
}
