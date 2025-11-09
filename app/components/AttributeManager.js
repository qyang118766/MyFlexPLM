'use client';

import { useState } from 'react';
import { createAttribute, updateAttribute, toggleAttributeStatus, deleteAttribute } from '@/lib/actions/attributes';

export default function AttributeManager({ entityType, attributes, typeNodes }) {
  const [showDialog, setShowDialog] = useState(false);
  const [editingAttribute, setEditingAttribute] = useState(null);

  const handleEdit = (attr) => {
    setEditingAttribute(attr);
    setShowDialog(true);
  };

  const handleAdd = () => {
    setEditingAttribute(null);
    setShowDialog(true);
  };

  const handleToggleStatus = async (attr) => {
    const formData = new FormData();
    formData.append('id', attr.id);
    formData.append('is_active', (!attr.is_active).toString());

    const result = await toggleAttributeStatus(formData);
    if (!result.success) {
      alert(`Error: ${result.error}`);
    }
  };

  const handleDelete = async (attr) => {
    if (!confirm(`Are you sure you want to delete the attribute "${attr.label}"?`)) {
      return;
    }

    const formData = new FormData();
    formData.append('id', attr.id);

    const result = await deleteAttribute(formData);
    if (!result.success) {
      alert(`Error: ${result.error}`);
    }
  };

  // Get type node name from ID
  const getTypeNodeName = (typeNodeId) => {
    if (!typeNodeId) return 'All';
    const node = typeNodes.find(n => n.id === typeNodeId);
    if (!node) return 'Unknown';

    // Build path
    const path = [];
    let current = node;
    while (current) {
      path.unshift(current.name);
      current = typeNodes.find(n => n.id === current.parent_id);
    }
    return path.join(' > ');
  };

  return (
    <div>
      <div className="flex justify-between items-center mb-4">
        <div className="text-sm text-gray-600">
          {attributes.length} attribute{attributes.length !== 1 ? 's' : ''} defined
        </div>
        <button
          onClick={handleAdd}
          className="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700"
        >
          Add Attribute
        </button>
      </div>

      <div className="overflow-x-auto">
        <table className="min-w-full divide-y divide-gray-200">
          <thead className="bg-gray-50">
            <tr>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Key
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Label
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Data Type
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Scope
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Flags
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Status
              </th>
              <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody className="bg-white divide-y divide-gray-200">
            {attributes.length > 0 ? (
              attributes.map((attr) => (
                <tr key={attr.id} className={attr.is_active ? '' : 'bg-gray-50 opacity-60'}>
                  <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                    {attr.key}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    {attr.label}
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    <span className="px-2 py-1 text-xs font-semibold bg-blue-100 text-blue-800 rounded">
                      {attr.data_type}
                    </span>
                    {attr.max_length && (
                      <span className="ml-1 text-xs text-gray-400">
                        ({attr.max_length})
                      </span>
                    )}
                  </td>
                  <td className="px-6 py-4 text-sm text-gray-500">
                    <div className="max-w-xs truncate" title={getTypeNodeName(attr.type_node_id)}>
                      {getTypeNodeName(attr.type_node_id)}
                    </div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                    <div className="flex gap-1">
                      {attr.required && (
                        <span className="px-2 py-1 text-xs font-semibold bg-red-100 text-red-800 rounded">
                          Required
                        </span>
                      )}
                      {attr.is_unique && (
                        <span className="px-2 py-1 text-xs font-semibold bg-purple-100 text-purple-800 rounded">
                          Unique
                        </span>
                      )}
                    </div>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap">
                    <button
                      onClick={() => handleToggleStatus(attr)}
                      className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full cursor-pointer ${
                        attr.is_active
                          ? 'bg-green-100 text-green-800 hover:bg-green-200'
                          : 'bg-gray-100 text-gray-800 hover:bg-gray-200'
                      }`}
                    >
                      {attr.is_active ? 'Active' : 'Inactive'}
                    </button>
                  </td>
                  <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 space-x-3">
                    <button
                      onClick={() => handleEdit(attr)}
                      className="text-indigo-600 hover:text-indigo-900"
                    >
                      Edit
                    </button>
                    <button
                      onClick={() => handleDelete(attr)}
                      className="text-red-600 hover:text-red-900"
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))
            ) : (
              <tr>
                <td colSpan="7" className="px-6 py-4 text-center text-sm text-gray-500">
                  No attributes defined for this entity type
                </td>
              </tr>
            )}
          </tbody>
        </table>
      </div>

      {showDialog && (
        <AttributeDialog
          entityType={entityType}
          typeNodes={typeNodes}
          editAttribute={editingAttribute}
          onClose={() => {
            setShowDialog(false);
            setEditingAttribute(null);
          }}
        />
      )}
    </div>
  );
}

// Dialog for adding/editing attributes
function AttributeDialog({ entityType, typeNodes, editAttribute, onClose }) {
  const [formData, setFormData] = useState({
    key: editAttribute?.key || '',
    label: editAttribute?.label || '',
    data_type: editAttribute?.data_type || 'string',
    required: editAttribute?.required || false,
    is_unique: editAttribute?.is_unique || false,
    max_length: editAttribute?.max_length || '',
    type_node_id: editAttribute?.type_node_id || '',
    options: editAttribute?.options ? JSON.stringify(editAttribute.options, null, 2) : '',
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState(null);
  const [showTypePicker, setShowTypePicker] = useState(false);

  const dataTypes = [
    { value: 'string', label: 'Text (String)' },
    { value: 'number', label: 'Number' },
    { value: 'boolean', label: 'Boolean (Yes/No)' },
    { value: 'date', label: 'Date' },
    { value: 'enum', label: 'Enum (Select from options)' },
  ];

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    setError(null);

    try {
      const data = new FormData();

      if (editAttribute) {
        data.append('id', editAttribute.id);
      } else {
        data.append('entity_type', entityType);
      }

      data.append('key', formData.key);
      data.append('label', formData.label);
      data.append('data_type', formData.data_type);
      data.append('required', formData.required.toString());
      data.append('is_unique', formData.is_unique.toString());

      if (formData.max_length) {
        data.append('max_length', formData.max_length);
      }

      if (formData.type_node_id) {
        data.append('type_node_id', formData.type_node_id);
      }

      if (formData.options) {
        data.append('options', formData.options);
      }

      const result = editAttribute
        ? await updateAttribute(data)
        : await createAttribute(data);

      if (!result.success) {
        throw new Error(result.error);
      }

      onClose();
    } catch (err) {
      setError(err.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  // Get selected type node name
  const getSelectedTypeName = () => {
    if (!formData.type_node_id) return 'All (Global)';
    const node = typeNodes.find(n => n.id === formData.type_node_id);
    if (!node) return 'All (Global)';

    const path = [];
    let current = node;
    while (current) {
      path.unshift(current.name);
      current = typeNodes.find(n => n.id === current.parent_id);
    }
    return path.join(' > ');
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 overflow-y-auto">
      <div className="bg-white rounded-lg shadow-xl max-w-2xl w-full p-6 m-4">
        <h3 className="text-lg font-semibold mb-4">
          {editAttribute ? 'Edit Attribute' : 'Add New Attribute'}
        </h3>

        {error && (
          <div className="mb-4 p-3 bg-red-50 text-red-700 rounded-md text-sm">
            {error}
          </div>
        )}

        <form onSubmit={handleSubmit}>
          <div className="space-y-4 max-h-[70vh] overflow-y-auto pr-2">
            {/* Key */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Key (Internal Name) <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                required
                value={formData.key}
                onChange={(e) => setFormData({ ...formData, key: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                placeholder="e.g., sale_number"
                pattern="[a-z_][a-z0-9_]*"
                title="Must start with lowercase letter or underscore, can contain lowercase letters, numbers, and underscores"
              />
              <p className="mt-1 text-xs text-gray-500">
                Lowercase letters, numbers, and underscores only
              </p>
            </div>

            {/* Label */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Display Label <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                required
                value={formData.label}
                onChange={(e) => setFormData({ ...formData, label: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                placeholder="e.g., Sale Number"
              />
            </div>

            {/* Data Type */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Data Type <span className="text-red-500">*</span>
              </label>
              <select
                required
                value={formData.data_type}
                onChange={(e) => setFormData({ ...formData, data_type: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
              >
                {dataTypes.map((dt) => (
                  <option key={dt.value} value={dt.value}>
                    {dt.label}
                  </option>
                ))}
              </select>
            </div>

            {/* Max Length (for string type) */}
            {formData.data_type === 'string' && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Max Length (Optional)
                </label>
                <input
                  type="number"
                  min="1"
                  value={formData.max_length}
                  onChange={(e) => setFormData({ ...formData, max_length: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                  placeholder="e.g., 255"
                />
              </div>
            )}

            {/* Options (for enum type) */}
            {formData.data_type === 'enum' && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Options (JSON Array) <span className="text-red-500">*</span>
                </label>
                <textarea
                  required={formData.data_type === 'enum'}
                  value={formData.options}
                  onChange={(e) => setFormData({ ...formData, options: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 font-mono text-sm"
                  rows={4}
                  placeholder='["Option 1", "Option 2", "Option 3"]'
                />
                <p className="mt-1 text-xs text-gray-500">
                  Enter a JSON array of string values
                </p>
              </div>
            )}

            {/* Type Scope */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Scope to Type (Optional)
              </label>
              <div className="flex gap-2">
                <input
                  type="text"
                  readOnly
                  value={getSelectedTypeName()}
                  className="flex-1 px-3 py-2 border border-gray-300 rounded-md bg-gray-50 cursor-pointer"
                  onClick={() => setShowTypePicker(true)}
                />
                <button
                  type="button"
                  onClick={() => setFormData({ ...formData, type_node_id: '' })}
                  className="px-3 py-2 border border-gray-300 rounded-md hover:bg-gray-50"
                >
                  Clear
                </button>
              </div>
              <p className="mt-1 text-xs text-gray-500">
                If set, this attribute only applies to the selected type and its descendants
              </p>
            </div>

            {/* Flags */}
            <div className="space-y-2">
              <div className="flex items-center">
                <input
                  type="checkbox"
                  id="required"
                  checked={formData.required}
                  onChange={(e) => setFormData({ ...formData, required: e.target.checked })}
                  className="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
                />
                <label htmlFor="required" className="ml-2 text-sm text-gray-700">
                  Required field
                </label>
              </div>

              <div className="flex items-center">
                <input
                  type="checkbox"
                  id="is_unique"
                  checked={formData.is_unique}
                  onChange={(e) => setFormData({ ...formData, is_unique: e.target.checked })}
                  className="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
                />
                <label htmlFor="is_unique" className="ml-2 text-sm text-gray-700">
                  Unique (no duplicates allowed)
                </label>
              </div>
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
              {isSubmitting ? 'Saving...' : (editAttribute ? 'Update' : 'Create')}
            </button>
          </div>
        </form>

        {/* Type Node Picker Modal */}
        {showTypePicker && (
          <TypeNodePicker
            typeNodes={typeNodes}
            selectedId={formData.type_node_id}
            onSelect={(nodeId) => {
              setFormData({ ...formData, type_node_id: nodeId });
              setShowTypePicker(false);
            }}
            onClose={() => setShowTypePicker(false)}
          />
        )}
      </div>
    </div>
  );
}

// Type node picker component
function TypeNodePicker({ typeNodes, selectedId, onSelect, onClose }) {
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

  const tree = buildTree(typeNodes);

  const toggleNode = (nodeId) => {
    const newExpanded = new Set(expandedNodes);
    if (newExpanded.has(nodeId)) {
      newExpanded.delete(nodeId);
    } else {
      newExpanded.add(nodeId);
    }
    setExpandedNodes(newExpanded);
  };

  const renderNode = (node, level = 0) => {
    const hasChildren = node.children && node.children.length > 0;
    const isExpanded = expandedNodes.has(node.id);
    const isSelected = node.id === selectedId;

    return (
      <div key={node.id}>
        <div
          className={`flex items-center py-2 px-3 cursor-pointer hover:bg-gray-50 ${
            isSelected ? 'bg-indigo-50 border-l-2 border-indigo-600' : ''
          }`}
          style={{ paddingLeft: `${level * 24 + 12}px` }}
          onClick={() => onSelect(node.id)}
        >
          <button
            onClick={(e) => {
              e.stopPropagation();
              if (hasChildren) toggleNode(node.id);
            }}
            className="w-5 h-5 flex items-center justify-center mr-2"
          >
            {hasChildren ? (
              isExpanded ? '▼' : '▶'
            ) : (
              <span className="w-4 h-4"></span>
            )}
          </button>
          <span className={`text-sm ${isSelected ? 'font-semibold text-indigo-900' : 'text-gray-900'}`}>
            {node.name}
          </span>
        </div>
        {hasChildren && isExpanded && (
          <div>
            {node.children.map((child) => renderNode(child, level + 1))}
          </div>
        )}
      </div>
    );
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-[60]">
      <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6 m-4">
        <h4 className="text-md font-semibold mb-4">Select Type Scope</h4>
        <div className="border border-gray-200 rounded-lg max-h-96 overflow-y-auto">
          {tree.map((node) => renderNode(node))}
        </div>
        <div className="mt-4 flex justify-end">
          <button
            onClick={onClose}
            className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50"
          >
            Close
          </button>
        </div>
      </div>
    </div>
  );
}
