'use client';

import { useState } from 'react';
import { createEnumValue, updateEnumValue, deleteEnumValue, toggleEnumValue } from '@/lib/actions/enums';

export default function EnumManager({ initialEnums, enumTypes }) {
  const [enums] = useState(initialEnums);
  const [isAddDialogOpen, setIsAddDialogOpen] = useState(false);
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false);
  const [selectedEnum, setSelectedEnum] = useState(null);
  const [selectedType, setSelectedType] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  // 刷新枚举列表
  const refreshEnums = () => {
    window.location.reload();
  };

  // 处理添加新枚举
  const handleAdd = async (formData) => {
    setLoading(true);
    setError(null);

    const result = await createEnumValue(formData);

    setLoading(false);

    if (result.success) {
      setIsAddDialogOpen(false);
      refreshEnums();
    } else {
      setError(result.error);
    }
  };

  // 处理编辑枚举
  const handleEdit = async (formData) => {
    if (!selectedEnum) return;

    setLoading(true);
    setError(null);

    const result = await updateEnumValue(selectedEnum.id, formData);

    setLoading(false);

    if (result.success) {
      setIsEditDialogOpen(false);
      setSelectedEnum(null);
      refreshEnums();
    } else {
      setError(result.error);
    }
  };

  // 处理切换启用/停用
  const handleToggle = async (enumItem) => {
    const result = await toggleEnumValue(enumItem.id, !enumItem.is_active);

    if (result.success) {
      refreshEnums();
    } else {
      alert('Error toggling enum: ' + result.error);
    }
  };

  // 处理删除
  const handleDelete = async (enumItem) => {
    if (!confirm(`Are you sure you want to delete "${enumItem.label}"? This may cause data inconsistencies.`)) {
      return;
    }

    const result = await deleteEnumValue(enumItem.id);

    if (result.success) {
      refreshEnums();
    } else {
      alert('Error deleting enum: ' + result.error);
    }
  };

  // 打开添加对话框
  const openAddDialog = (enumType) => {
    setSelectedType(enumType);
    setError(null);
    setIsAddDialogOpen(true);
  };

  // 打开编辑对话框
  const openEditDialog = (enumItem) => {
    setSelectedEnum(enumItem);
    setError(null);
    setIsEditDialogOpen(true);
  };

  return (
    <div className="space-y-6">
      {/* 添加新枚举类型的按钮 */}
      <div className="bg-white shadow rounded-lg p-6">
        <h2 className="text-lg font-medium text-gray-900 mb-4">Quick Add</h2>
        <div className="flex flex-wrap gap-2">
          {enumTypes.map((type) => (
            <button
              key={type}
              onClick={() => openAddDialog(type)}
              className="px-3 py-2 bg-indigo-100 text-indigo-700 rounded-md hover:bg-indigo-200 text-sm font-medium"
            >
              + Add to {type.replace('_', ' ')}
            </button>
          ))}
        </div>
      </div>

      {/* 按类型显示枚举列表 */}
      {enumTypes.map((enumType) => (
        <div key={enumType} className="bg-white shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-lg font-medium text-gray-900">
                {enumType.replace('_', ' ').toUpperCase()}
              </h2>
              <button
                onClick={() => openAddDialog(enumType)}
                className="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700 text-sm"
              >
                Add Value
              </button>
            </div>

            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Value
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Label
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Order
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
                  {enums[enumType]?.map((enumItem) => (
                    <tr key={enumItem.id}>
                      <td className="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                        <code className="bg-gray-100 px-2 py-1 rounded">{enumItem.enum_value}</code>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {enumItem.label}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {enumItem.order_index}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span
                          className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${
                            enumItem.is_active
                              ? 'bg-green-100 text-green-800'
                              : 'bg-gray-100 text-gray-800'
                          }`}
                        >
                          {enumItem.is_active ? 'Active' : 'Inactive'}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm space-x-3">
                        <button
                          onClick={() => openEditDialog(enumItem)}
                          className="text-indigo-600 hover:text-indigo-900"
                        >
                          Edit
                        </button>
                        <button
                          onClick={() => handleToggle(enumItem)}
                          className="text-blue-600 hover:text-blue-900"
                        >
                          {enumItem.is_active ? 'Disable' : 'Enable'}
                        </button>
                        <button
                          onClick={() => handleDelete(enumItem)}
                          className="text-red-600 hover:text-red-900"
                        >
                          Delete
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      ))}

      {/* 添加对话框 */}
      {isAddDialogOpen && (
        <Dialog
          title="Add New Enum Value"
          onClose={() => setIsAddDialogOpen(false)}
        >
          <form
            onSubmit={(e) => {
              e.preventDefault();
              const formData = new FormData(e.target);
              handleAdd(formData);
            }}
            className="space-y-4"
          >
            {error && (
              <div className="rounded-md bg-red-50 p-4">
                <p className="text-sm text-red-700">{error}</p>
              </div>
            )}

            <input type="hidden" name="enum_type" value={selectedType} />

            <div>
              <label htmlFor="enum_value" className="block text-sm font-medium text-gray-700">
                Value *
              </label>
              <input
                type="text"
                id="enum_value"
                name="enum_value"
                required
                placeholder="e.g., active, in_development"
                className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
              <p className="mt-1 text-xs text-gray-500">
                Use lowercase with underscores (e.g., &quot;in_development&quot;)
              </p>
            </div>

            <div>
              <label htmlFor="label" className="block text-sm font-medium text-gray-700">
                Label *
              </label>
              <input
                type="text"
                id="label"
                name="label"
                required
                placeholder="e.g., Active, In Development"
                className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>

            <div>
              <label htmlFor="order_index" className="block text-sm font-medium text-gray-700">
                Order Index
              </label>
              <input
                type="number"
                id="order_index"
                name="order_index"
                defaultValue="0"
                className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>

            <div>
              <label className="flex items-center">
                <input
                  type="checkbox"
                  name="is_active"
                  value="true"
                  defaultChecked
                  className="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
                />
                <span className="ml-2 text-sm text-gray-700">Active</span>
              </label>
            </div>

            <div className="flex justify-end space-x-3 pt-4">
              <button
                type="button"
                onClick={() => setIsAddDialogOpen(false)}
                className="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50"
              >
                Cancel
              </button>
              <button
                type="submit"
                disabled={loading}
                className="px-4 py-2 bg-indigo-600 text-white rounded-md text-sm font-medium hover:bg-indigo-700 disabled:opacity-50"
              >
                {loading ? 'Adding...' : 'Add Enum Value'}
              </button>
            </div>
          </form>
        </Dialog>
      )}

      {/* 编辑对话框 */}
      {isEditDialogOpen && selectedEnum && (
        <Dialog
          title="Edit Enum Value"
          onClose={() => {
            setIsEditDialogOpen(false);
            setSelectedEnum(null);
          }}
        >
          <form
            onSubmit={(e) => {
              e.preventDefault();
              const formData = new FormData(e.target);
              handleEdit(formData);
            }}
            className="space-y-4"
          >
            {error && (
              <div className="rounded-md bg-red-50 p-4">
                <p className="text-sm text-red-700">{error}</p>
              </div>
            )}

            <div>
              <label className="block text-sm font-medium text-gray-700">Type</label>
              <p className="mt-1 text-sm text-gray-900">{selectedEnum.enum_type}</p>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700">Value</label>
              <p className="mt-1 text-sm text-gray-900">
                <code className="bg-gray-100 px-2 py-1 rounded">{selectedEnum.enum_value}</code>
              </p>
              <p className="mt-1 text-xs text-gray-500">Value cannot be changed</p>
            </div>

            <div>
              <label htmlFor="edit_label" className="block text-sm font-medium text-gray-700">
                Label *
              </label>
              <input
                type="text"
                id="edit_label"
                name="label"
                required
                defaultValue={selectedEnum.label}
                className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>

            <div>
              <label htmlFor="edit_order_index" className="block text-sm font-medium text-gray-700">
                Order Index
              </label>
              <input
                type="number"
                id="edit_order_index"
                name="order_index"
                defaultValue={selectedEnum.order_index}
                className="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 text-sm focus:border-indigo-500 focus:ring-indigo-500"
              />
            </div>

            <div>
              <label className="flex items-center">
                <input
                  type="checkbox"
                  name="is_active"
                  value="true"
                  defaultChecked={selectedEnum.is_active}
                  className="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500"
                />
                <span className="ml-2 text-sm text-gray-700">Active</span>
              </label>
            </div>

            <div className="flex justify-end space-x-3 pt-4">
              <button
                type="button"
                onClick={() => {
                  setIsEditDialogOpen(false);
                  setSelectedEnum(null);
                }}
                className="px-4 py-2 border border-gray-300 rounded-md text-sm font-medium text-gray-700 hover:bg-gray-50"
              >
                Cancel
              </button>
              <button
                type="submit"
                disabled={loading}
                className="px-4 py-2 bg-indigo-600 text-white rounded-md text-sm font-medium hover:bg-indigo-700 disabled:opacity-50"
              >
                {loading ? 'Saving...' : 'Save Changes'}
              </button>
            </div>
          </form>
        </Dialog>
      )}
    </div>
  );
}

// 简单的对话框组件
function Dialog({ title, children, onClose }) {
  return (
    <div className="fixed inset-0 z-50 overflow-y-auto">
      <div className="flex min-h-screen items-center justify-center p-4">
        {/* 背景遮罩 */}
        <div
          className="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity"
          onClick={onClose}
        />

        {/* 对话框内容 */}
        <div className="relative bg-white rounded-lg shadow-xl max-w-md w-full p-6">
          <h3 className="text-lg font-medium text-gray-900 mb-4">{title}</h3>
          {children}
        </div>
      </div>
    </div>
  );
}
