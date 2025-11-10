'use client';

import { useState, useEffect } from 'react';
import { getDefaultAttributePermissionForGroup } from '@/lib/services/attributePermissions';

const ATTRIBUTE_PERMISSION_LEVELS = [
  { value: 'default', label: 'Default (Inherited from type)', color: 'bg-gray-100 text-gray-800', description: 'Use type node permission' },
  { value: 'hidden', label: 'Hidden', color: 'bg-red-100 text-red-800', description: 'Completely hidden from this group' },
  { value: 'read-only', label: 'Read Only', color: 'bg-blue-100 text-blue-800', description: 'Visible but not editable' },
  { value: 'editable', label: 'Editable', color: 'bg-green-100 text-green-800', description: 'Fully editable' },
];

/**
 * AttributePermissionMatrix Component
 *
 * Displays a matrix of groups and their permission levels for an attribute
 * Shows default permissions inherited from type node permissions
 *
 * @param {Array} groups - All available user groups
 * @param {Array} permissions - Current permissions [{groupId, permission_level}]
 * @param {Function} onChange - Callback when permissions change
 * @param {string} attributeId - Attribute ID for calculating default permissions
 * @param {string} scopeTypeNodeId - Type node ID where attribute is scoped
 */
export default function AttributePermissionMatrix({ groups, permissions = [], onChange, attributeId, typeNodeId }) {
  const [expandedNodes, setExpandedNodes] = useState(new Set());
  const [defaultPermissions, setDefaultPermissions] = useState({});
  const [isLoadingDefaults, setIsLoadingDefaults] = useState(false);

  // Build permission map for quick lookup
  const permissionMap = permissions.reduce((acc, p) => {
    acc[p.group_id] = p.permission_level;
    return acc;
  }, {});

  // Load default permissions for all groups
  useEffect(() => {
    async function loadDefaults() {
      if (!attributeId || !typeNodeId) return;

      setIsLoadingDefaults(true);
      const defaults = {};

      for (const group of groups) {
        const result = await getDefaultAttributePermissionForGroup(attributeId, group.id);
        if (result.success) {
          defaults[group.id] = result.data;
        }
      }

      setDefaultPermissions(defaults);
      setIsLoadingDefaults(false);
    }

    loadDefaults();
  }, [attributeId, typeNodeId, groups]);

  // Build tree structure
  const buildTree = (nodes, parentId = null) => {
    return nodes
      .filter((node) => node.parent_id === parentId)
      .sort((a, b) => (a.display_order || 0) - (b.display_order || 0))
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
    let newPermissions = permissions.filter(p => p.group_id !== groupId);

    // If level is 'default' or empty, remove the override
    if (level && level !== 'default') {
      newPermissions.push({
        group_id: groupId,
        permission_level: level,
      });
    }

    onChange(newPermissions);
  };

  const renderPermissionCell = (node) => {
    const currentPermission = permissionMap[node.id];
    const defaultPermission = defaultPermissions[node.id] || 'hidden';
    const effectivePermission = currentPermission || defaultPermission;

    return (
      <div className="flex items-center gap-2">
        <select
          value={currentPermission || 'default'}
          onChange={(e) => handlePermissionChange(node.id, e.target.value)}
          className="text-xs border border-gray-300 rounded px-2 py-1 focus:outline-none focus:ring-2 focus:ring-indigo-500 min-w-[180px]"
        >
          {ATTRIBUTE_PERMISSION_LEVELS.map((level) => (
            <option key={level.value} value={level.value}>
              {level.label}
            </option>
          ))}
        </select>

        {(!currentPermission || currentPermission === 'default') && (
          <span className="text-xs text-gray-500 italic">
            (inherited: {defaultPermission})
          </span>
        )}
      </div>
    );
  };

  const renderNode = (node, level = 0) => {
    const hasChildren = node.children && node.children.length > 0;
    const isExpanded = expandedNodes.has(node.id);

    return (
      <div key={node.id}>
        <div
          className="flex items-center py-2 hover:bg-gray-50 border-b border-gray-100"
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

          {/* Permission Selector */}
          {renderPermissionCell(node)}
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
      {/* Explanation */}
      <div className="bg-blue-50 border border-blue-200 rounded-lg p-3">
        <div className="text-sm font-medium text-blue-900 mb-1">
          Attribute Permission Inheritance
        </div>
        <div className="text-xs text-blue-700">
          By default, attribute permissions are inherited from type node permissions:
          <ul className="mt-1 ml-4 list-disc">
            <li><strong>Type: Read</strong> → Attribute: Read-Only</li>
            <li><strong>Type: Edit/Create/Delete/Full</strong> → Attribute: Editable</li>
            <li><strong>Type: None</strong> → Attribute: Hidden</li>
          </ul>
          You can override these defaults by selecting a specific permission level below.
        </div>
      </div>

      {/* Permission Matrix */}
      <div>
        <div className="text-sm font-medium text-gray-700 mb-2">
          Group-Specific Permissions
        </div>

        {isLoadingDefaults ? (
          <div className="text-sm text-gray-500 py-4 text-center">
            Loading default permissions...
          </div>
        ) : (
          <div className="border border-gray-200 rounded-lg max-h-96 overflow-y-auto">
            {tree.length > 0 ? (
              tree.map((node) => renderNode(node))
            ) : (
              <div className="p-4 text-center text-sm text-gray-500">
                No groups available
              </div>
            )}
          </div>
        )}

        <div className="mt-2 text-xs text-gray-500">
          Select "Default (Inherited from type)" to remove override and use type-based permission.
        </div>
      </div>

      {/* Permission Legend */}
      <div className="bg-gray-50 border border-gray-200 rounded-lg p-3">
        <div className="text-xs font-medium text-gray-700 mb-2">
          Permission Levels
        </div>
        <div className="grid grid-cols-2 gap-2">
          {ATTRIBUTE_PERMISSION_LEVELS.filter(l => l.value !== 'default').map((level) => (
            <div key={level.value} className="flex items-start gap-2">
              <span className={`px-2 py-1 text-xs font-semibold rounded ${level.color}`}>
                {level.label}
              </span>
              <span className="text-xs text-gray-600">{level.description}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
