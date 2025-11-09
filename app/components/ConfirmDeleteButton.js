'use client';

export default function ConfirmDeleteButton({ label = 'Delete', entityName = 'this item' }) {
  const handleClick = (event) => {
    event.preventDefault();

    const firstConfirmation = window.confirm(
      `Are you sure you want to delete ${entityName}? This action cannot be undone.`
    );
    if (!firstConfirmation) {
      return;
    }

    const secondConfirmation = window.confirm(
      `Please confirm once more: deleting ${entityName} will permanently remove all related data.`
    );
    if (!secondConfirmation) {
      return;
    }

    const form = event.currentTarget.closest('form');
    if (form) {
      form.requestSubmit();
    }
  };

  return (
    <button
      type="button"
      onClick={handleClick}
      className="text-red-600 hover:text-red-800"
    >
      {label}
    </button>
  );
}
