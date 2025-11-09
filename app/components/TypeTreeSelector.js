'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';

export default function TypeTreeSelector({
  typeNodes = [],
  entityLabel = 'Item',
  selectPath = '/',
  description = '',
}) {
  const router = useRouter();
  const [expandedNodes, setExpandedNodes] = useState(new Set());

  const buildTree = (nodes) => {
    const nodeMap = new Map();
    const rootNodes = [];

    nodes.forEach((node) => {
      nodeMap.set(node.id, { ...node, children: [] });
    });

    nodes.forEach((node) => {
      if (node.parent_id) {
        const parent = nodeMap.get(node.parent_id);
        if (parent) {
          parent.children.push(nodeMap.get(node.id));
        }
      } else {
        rootNodes.push(nodeMap.get(node.id));
      }
    });

    return rootNodes;
  };

  const toggleExpand = (nodeId) => {
    const newExpanded = new Set(expandedNodes);
    if (newExpanded.has(nodeId)) {
      newExpanded.delete(nodeId);
    } else {
      newExpanded.add(nodeId);
    }
    setExpandedNodes(newExpanded);
  };

  const selectType = (typeId) => {
    const url = `${selectPath}?typeId=${typeId}`;
    router.push(url);
  };

  const TreeNode = ({ node, level = 0 }) => {
    const hasChildren = node.children && node.children.length > 0;
    const isExpanded = expandedNodes.has(node.id);

    return (
      <div className="select-none">
        <div
          className="flex items-center py-2 px-3 hover:bg-gray-50 rounded-md cursor-pointer group"
          style={{ paddingLeft: `${level * 1.5 + 0.75}rem` }}
          onClick={() => selectType(node.id)}
        >
          {hasChildren && (
            <button
              type="button"
              onClick={(e) => {
                e.stopPropagation();
                toggleExpand(node.id);
              }}
              className="mr-2 text-gray-400 hover:text-gray-600"
            >
              <svg
                className={`w-4 h-4 transition-transform ${isExpanded ? 'rotate-90' : ''}`}
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
              </svg>
            </button>
          )}

          <div className="mr-2 text-gray-400">
            {hasChildren ? (
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z"
                />
              </svg>
            ) : (
              <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                  strokeLinecap="round"
                  strokeLinejoin="round"
                  strokeWidth={2}
                  d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                />
              </svg>
            )}
          </div>

          <div className="flex-1 flex items-center justify-between">
            <div className="flex items-center gap-2">
              <span className="text-sm font-medium text-gray-900">{node.name}</span>
              {node.code && (
                <span className="text-xs text-gray-500 font-mono bg-gray-100 px-2 py-0.5 rounded">
                  {node.code}
                </span>
              )}
            </div>
            <button
              type="button"
              onClick={(e) => {
                e.stopPropagation();
                selectType(node.id);
              }}
              className="opacity-0 group-hover:opacity-100 transition-opacity px-3 py-1 text-xs bg-indigo-600 text-white rounded hover:bg-indigo-700"
            >
              Select
            </button>
          </div>
        </div>
        {hasChildren && isExpanded && (
          <div>
            {node.children.map((child) => (
              <TreeNode key={child.id} node={child} level={level + 1} />
            ))}
          </div>
        )}
      </div>
    );
  };

  const treeData = buildTree(typeNodes);
  const resolvedDescription =
    description ||
    `Choose a ${entityLabel.toLowerCase()} type from the hierarchy below to continue creating your ${entityLabel.toLowerCase()}.`;

  return (
    <div className="bg-white shadow rounded-lg p-6">
      <div className="mb-6">
        <h2 className="text-xl font-semibold text-gray-900 mb-2">Select {entityLabel} Type</h2>
        <p className="text-sm text-gray-600">{resolvedDescription}</p>
      </div>

      <div className="border border-gray-200 rounded-lg p-4 max-h-96 overflow-y-auto">
        {treeData.length === 0 ? (
          <div className="text-center py-8 text-gray-500">
            <p>No {entityLabel.toLowerCase()} types available.</p>
            <p className="text-sm mt-2">
              Please create types in the{' '}
              <a href="/admin/types" className="text-indigo-600 hover:text-indigo-800">
                Type Manager
              </a>
              .
            </p>
          </div>
        ) : (
          treeData.map((node) => <TreeNode key={node.id} node={node} />)
        )}
      </div>

      <div className="mt-4 text-xs text-gray-500">
        💡 Tip: Click the arrow to expand/collapse, or click &quot;Select&quot; to choose a type.
      </div>
    </div>
  );
}
