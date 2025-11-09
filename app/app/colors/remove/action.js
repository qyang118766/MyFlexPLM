'use server';

import { deleteColor } from '@/lib/actions/colors';

export async function removeColor(formData) {
  await deleteColor(formData);
}
