'use client';

import { useState } from 'react';

export default function HierarchicalGroupSelector({ groups, selectedGroupIds, onSelectionChange }) {
  const [expandedNodes, setExpandedNodes] = useState(new Set());

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

  const handleToggle = (groupId) => {
    const newSelection = selectedGroupIds.includes(groupId)
      ? selectedGroupIds.filter(id => id !== groupId)
      : [...selectedGroupIds, groupId];
    onSelectionChange(newSelection);
  };

  const renderNode = (node, level = 0) => {
    const hasChildren = node.children && node.children.length > 0;
    const isExpanded = expandedNodes.has(node.id);
    const isSelected = selectedGroupIds.includes(node.id);

    return (
      <div key={node.id}>
        <div
          className="flex items-center py-1"
          style={{ paddingLeft: `${level * 20}px` }}
        >
          {/* Expand/Collapse Button */}
          <button
            type="button"
            onClick={() => hasChildren && toggleNode(node.id)}
            className="w-4 h-4 flex items-center justify-center mr-1"
          >
            {hasChildren ? (
              isExpanded ? (
                <svg className="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clipRule="evenodd" />
                </svg>
              ) : (
                <svg className="w-3 h-3" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clipRule="evenodd" />
                </svg>
              )
            ) : (
              <span className="w-3 h-3"></span>
            )}
          </button>

          {/* Checkbox */}
          <input
            type="checkbox"
            id={`group-${node.id}`}
            checked={isSelected}
            onChange={() => handleToggle(node.id)}
            className="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
          />

          {/* Label */}
          <label
            htmlFor={`group-${node.id}`}
            className="ml-2 text-sm text-gray-700 cursor-pointer"
          >
            {node.name}
            {node.code && (
              <span className="ml-1 text-gray-500 text-xs">({node.code})</span>
            )}
          </label>
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
    <div className="border border-gray-300 rounded-md p-3 max-h-60 overflow-y-auto">
      {tree.length > 0 ? (
        tree.map((node) => renderNode(node))
      ) : (
        <p className="text-sm text-gray-500">No groups available</p>
      )}
    </div>
  );
}
