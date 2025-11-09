'use server';

import { deleteMaterial } from '@/lib/actions/materials';

export async function removeMaterial(formData) {
  await deleteMaterial(formData);
}
