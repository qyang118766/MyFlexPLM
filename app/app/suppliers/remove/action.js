'use server';

import { deleteSupplier } from '@/lib/actions/suppliers';

export async function removeSupplier(formData) {
  await deleteSupplier(formData);
}
