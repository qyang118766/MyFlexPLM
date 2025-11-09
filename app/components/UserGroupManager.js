'use client';

import { useState } from 'react';
import { createUser, updateUser, resetUserPassword, deleteUser } from '@/lib/actions/users';
import { createGroup, updateGroup, deleteGroup } from '@/lib/actions/groups';

export default function UserGroupManager({ users, groups, userGroups }) {
  const [activeTab, setActiveTab] = useState('users'); // 'users' or 'groups'
  const [showUserDialog, setShowUserDialog] = useState(false);
  const [showGroupDialog, setShowGroupDialog] = useState(false);
  const [showPasswordDialog, setShowPasswordDialog] = useState(false);
  const [editingUser, setEditingUser] = useState(null);
  const [editingGroup, setEditingGroup] = useState(null);
  const [selectedUser, setSelectedUser] = useState(null);

  // Build user-group map
  const userGroupMap = userGroups.reduce((acc, ug) => {
    if (!acc[ug.user_id]) acc[ug.user_id] = [];
    acc[ug.user_id].push(ug.group_id);
    return acc;
  }, {});

  const handleAddUser = () => {
    setEditingUser(null);
    setShowUserDialog(true);
  };

  const handleEditUser = (user) => {
    setEditingUser(user);
    setShowUserDialog(true);
  };

  const handleDeleteUser = async (user) => {
    if (!confirm(`Are you sure you want to delete user "${user.display_name}"?`)) {
      return;
    }

    const formData = new FormData();
    formData.append('user_id', user.id);

    const result = await deleteUser(formData);
    if (!result.success) {
      alert(`Error: ${result.error}`);
    }
  };

  const handleResetPassword = (user) => {
    setSelectedUser(user);
    setShowPasswordDialog(true);
  };

  const handleAddGroup = (parentId = null) => {
    setEditingGroup({ parent_id: parentId });
    setShowGroupDialog(true);
  };

  const handleEditGroup = (group) => {
    setEditingGroup(group);
    setShowGroupDialog(true);
  };

  const handleDeleteGroup = async (group) => {
    if (!confirm(`Are you sure you want to delete group "${group.name}"?`)) {
      return;
    }

    const formData = new FormData();
    formData.append('id', group.id);

    const result = await deleteGroup(formData);
    if (!result.success) {
      alert(`Error: ${result.error}`);
    }
  };

  // Get groups for a user
  const getUserGroups = (userId) => {
    const groupIds = userGroupMap[userId] || [];
    return groups.filter(g => groupIds.includes(g.id));
  };

  return (
    <div className="space-y-6">
      {/* Tabs */}
      <div className="border-b border-gray-200">
        <nav className="-mb-px flex space-x-8">
          <button
            onClick={() => setActiveTab('users')}
            className={`${
              activeTab === 'users'
                ? 'border-indigo-500 text-indigo-600'
                : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
            } whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm`}
          >
            Users
          </button>
          <button
            onClick={() => setActiveTab('groups')}
            className={`${
              activeTab === 'groups'
                ? 'border-indigo-500 text-indigo-600'
                : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300'
            } whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm`}
          >
            Groups
          </button>
        </nav>
      </div>

      {/* Users Tab */}
      {activeTab === 'users' && (
        <div className="bg-white shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-lg font-medium text-gray-900">Users</h2>
              <button
                onClick={handleAddUser}
                className="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700"
              >
                Add User
              </button>
            </div>

            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200">
                <thead className="bg-gray-50">
                  <tr>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Email
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Display Name
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Role
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Groups
                    </th>
                    <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                      Actions
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200">
                  {users.map((user) => {
                    const userGrps = getUserGroups(user.id);
                    return (
                      <tr key={user.id}>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                          {user.email}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                          {user.display_name}
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm">
                          <span className={`px-2 py-1 text-xs font-semibold rounded ${
                            user.role === 'admin'
                              ? 'bg-purple-100 text-purple-800'
                              : 'bg-blue-100 text-blue-800'
                          }`}>
                            {user.role === 'admin' ? 'Admin' : 'User'}
                          </span>
                        </td>
                        <td className="px-6 py-4 text-sm text-gray-500">
                          <div className="flex flex-wrap gap-1">
                            {userGrps.length > 0 ? (
                              userGrps.map(g => (
                                <span key={g.id} className="px-2 py-1 text-xs bg-gray-100 text-gray-700 rounded">
                                  {g.name}
                                </span>
                              ))
                            ) : (
                              <span className="text-gray-400">No groups</span>
                            )}
                          </div>
                        </td>
                        <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 space-x-3">
                          <button
                            onClick={() => handleEditUser(user)}
                            className="text-indigo-600 hover:text-indigo-900"
                          >
                            Edit
                          </button>
                          <button
                            onClick={() => handleResetPassword(user)}
                            className="text-orange-600 hover:text-orange-900"
                          >
                            Reset Password
                          </button>
                          <button
                            onClick={() => handleDeleteUser(user)}
                            className="text-red-600 hover:text-red-900"
                          >
                            Delete
                          </button>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          </div>
        </div>
      )}

      {/* Groups Tab */}
      {activeTab === 'groups' && (
        <div className="bg-white shadow rounded-lg">
          <div className="px-4 py-5 sm:p-6">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-lg font-medium text-gray-900">Groups</h2>
              <button
                onClick={() => handleAddGroup()}
                className="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700"
              >
                Add Root Group
              </button>
            </div>

            <GroupTree
              groups={groups}
              onAddChild={handleAddGroup}
              onEdit={handleEditGroup}
              onDelete={handleDeleteGroup}
            />
          </div>
        </div>
      )}

      {/* Dialogs */}
      {showUserDialog && (
        <UserDialog
          user={editingUser}
          groups={groups}
          userGroups={editingUser ? (userGroupMap[editingUser.id] || []) : []}
          onClose={() => setShowUserDialog(false)}
        />
      )}

      {showGroupDialog && (
        <GroupDialog
          group={editingGroup}
          groups={groups}
          onClose={() => setShowGroupDialog(false)}
        />
      )}

      {showPasswordDialog && selectedUser && (
        <PasswordDialog
          user={selectedUser}
          onClose={() => {
            setShowPasswordDialog(false);
            setSelectedUser(null);
          }}
        />
      )}
    </div>
  );
}

// Group Tree Component
function GroupTree({ groups, onAddChild, onEdit, onDelete }) {
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

  const renderNode = (node, level = 0) => {
    const hasChildren = node.children && node.children.length > 0;
    const isExpanded = expandedNodes.has(node.id);

    return (
      <div key={node.id}>
        <div
          className="flex items-center py-2 px-3 hover:bg-gray-50 group"
          style={{ paddingLeft: `${level * 24 + 12}px` }}
        >
          <button
            onClick={() => hasChildren && toggleNode(node.id)}
            className="w-5 h-5 flex items-center justify-center mr-2"
          >
            {hasChildren ? (
              isExpanded ? '▼' : '▶'
            ) : (
              <span className="w-4 h-4"></span>
            )}
          </button>

          <svg className="w-5 h-5 mr-2 text-gray-400" fill="currentColor" viewBox="0 0 20 20">
            <path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z" />
            <path fillRule="evenodd" d="M4 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v11a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm3 4a1 1 0 000 2h.01a1 1 0 100-2H7zm3 0a1 1 0 000 2h3a1 1 0 100-2h-3zm-3 4a1 1 0 100 2h.01a1 1 0 100-2H7zm3 0a1 1 0 100 2h3a1 1 0 100-2h-3z" clipRule="evenodd" />
          </svg>

          <span className="text-sm font-medium text-gray-900 flex-1">
            {node.name}
          </span>

          {node.code && (
            <span className="ml-2 px-2 py-1 text-xs font-semibold bg-gray-100 text-gray-600 rounded">
              {node.code}
            </span>
          )}

          <div className="ml-4 opacity-0 group-hover:opacity-100 flex gap-2">
            <button
              onClick={() => onAddChild(node.id)}
              className="text-xs text-indigo-600 hover:text-indigo-900"
            >
              Add Child
            </button>
            <button
              onClick={() => onEdit(node)}
              className="text-xs text-blue-600 hover:text-blue-900"
            >
              Edit
            </button>
            <button
              onClick={() => onDelete(node)}
              className="text-xs text-red-600 hover:text-red-900"
            >
              Delete
            </button>
          </div>
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
    <div className="border border-gray-200 rounded-lg">
      {tree.length > 0 ? (
        tree.map((node) => renderNode(node))
      ) : (
        <div className="p-8 text-center text-gray-500">
          No groups defined. Click "Add Root Group" to create one.
        </div>
      )}
    </div>
  );
}

// User Dialog Component
function UserDialog({ user, groups, userGroups, onClose }) {
  const [formData, setFormData] = useState({
    email: user?.email || '',
    display_name: user?.display_name || '',
    role: user?.role || 'user',
    initial_password: '',
    group_ids: userGroups || [],
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState(null);

  const handleGroupToggle = (groupId) => {
    const newGroups = formData.group_ids.includes(groupId)
      ? formData.group_ids.filter(id => id !== groupId)
      : [...formData.group_ids, groupId];
    setFormData({ ...formData, group_ids: newGroups });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    setError(null);

    try {
      const data = new FormData();

      if (user) {
        // Update existing user
        data.append('user_id', user.id);
        data.append('display_name', formData.display_name);
        data.append('role', formData.role);
        data.append('group_ids', JSON.stringify(formData.group_ids));

        const result = await updateUser(data);
        if (!result.success) {
          throw new Error(result.error);
        }
      } else {
        // Create new user
        data.append('email', formData.email);
        data.append('display_name', formData.display_name);
        data.append('role', formData.role);
        data.append('initial_password', formData.initial_password);
        data.append('group_ids', JSON.stringify(formData.group_ids));

        const result = await createUser(data);
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
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 overflow-y-auto">
      <div className="bg-white rounded-lg shadow-xl max-w-2xl w-full p-6 m-4">
        <h3 className="text-lg font-semibold mb-4">
          {user ? 'Edit User' : 'Add New User'}
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
                Email <span className="text-red-500">*</span>
              </label>
              <input
                type="email"
                required
                disabled={!!user}
                value={formData.email}
                onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 disabled:bg-gray-100"
                placeholder="user@example.com"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Display Name <span className="text-red-500">*</span>
              </label>
              <input
                type="text"
                required
                value={formData.display_name}
                onChange={(e) => setFormData({ ...formData, display_name: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                placeholder="John Doe"
              />
            </div>

            {!user && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Initial Password <span className="text-red-500">*</span>
                </label>
                <input
                  type="password"
                  required={!user}
                  value={formData.initial_password}
                  onChange={(e) => setFormData({ ...formData, initial_password: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                  placeholder="Minimum 6 characters"
                  minLength={6}
                />
              </div>
            )}

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Role
              </label>
              <select
                value={formData.role}
                onChange={(e) => setFormData({ ...formData, role: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
              >
                <option value="user">User</option>
                <option value="admin">Admin</option>
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Groups
              </label>
              <div className="border border-gray-300 rounded-md p-3 max-h-60 overflow-y-auto">
                {groups.length > 0 ? (
                  groups.map(group => (
                    <div key={group.id} className="flex items-center py-1">
                      <input
                        type="checkbox"
                        id={`group-${group.id}`}
                        checked={formData.group_ids.includes(group.id)}
                        onChange={() => handleGroupToggle(group.id)}
                        className="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
                      />
                      <label htmlFor={`group-${group.id}`} className="ml-2 text-sm text-gray-700">
                        {group.name}
                        {group.code && <span className="ml-2 text-gray-500">({group.code})</span>}
                      </label>
                    </div>
                  ))
                ) : (
                  <p className="text-sm text-gray-500">No groups available</p>
                )}
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
              {isSubmitting ? 'Saving...' : (user ? 'Update' : 'Create')}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

// Group Dialog Component
function GroupDialog({ group, groups, onClose }) {
  const isNew = !group?.id;
  const [formData, setFormData] = useState({
    name: group?.name || '',
    code: group?.code || '',
    description: group?.description || '',
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState(null);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    setError(null);

    try {
      const data = new FormData();

      if (isNew) {
        data.append('name', formData.name);
        data.append('code', formData.code);
        data.append('description', formData.description);
        if (group?.parent_id) {
          data.append('parent_id', group.parent_id);
        }

        const result = await createGroup(data);
        if (!result.success) {
          throw new Error(result.error);
        }
      } else {
        data.append('id', group.id);
        data.append('name', formData.name);
        data.append('code', formData.code);
        data.append('description', formData.description);

        const result = await updateGroup(data);
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

  // Get parent group name
  const getParentName = () => {
    if (!group?.parent_id) return 'Root';
    const parent = groups.find(g => g.id === group.parent_id);
    return parent ? parent.name : 'Unknown';
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6 m-4">
        <h3 className="text-lg font-semibold mb-4">
          {isNew ? `Add Child to ${getParentName()}` : 'Edit Group'}
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
                placeholder="e.g., Design Team"
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
                placeholder="e.g., DESIGN"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Description (Optional)
              </label>
              <textarea
                value={formData.description}
                onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                rows={3}
                placeholder="Brief description of this group"
              />
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
              {isSubmitting ? 'Saving...' : (isNew ? 'Create' : 'Update')}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

// Password Dialog Component
function PasswordDialog({ user, onClose }) {
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState(null);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    setError(null);

    if (newPassword !== confirmPassword) {
      setError('Passwords do not match');
      setIsSubmitting(false);
      return;
    }

    if (newPassword.length < 6) {
      setError('Password must be at least 6 characters');
      setIsSubmitting(false);
      return;
    }

    try {
      const formData = new FormData();
      formData.append('user_id', user.id);
      formData.append('new_password', newPassword);

      const result = await resetUserPassword(formData);
      if (!result.success) {
        throw new Error(result.error);
      }

      alert('Password reset successfully');
      onClose();
    } catch (err) {
      setError(err.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6 m-4">
        <h3 className="text-lg font-semibold mb-4">
          Reset Password for {user.display_name}
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
                New Password <span className="text-red-500">*</span>
              </label>
              <input
                type="password"
                required
                value={newPassword}
                onChange={(e) => setNewPassword(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                placeholder="Minimum 6 characters"
                minLength={6}
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">
                Confirm Password <span className="text-red-500">*</span>
              </label>
              <input
                type="password"
                required
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
                placeholder="Re-enter password"
                minLength={6}
              />
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
              {isSubmitting ? 'Resetting...' : 'Reset Password'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
