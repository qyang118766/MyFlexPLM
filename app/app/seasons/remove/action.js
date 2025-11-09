'use server';

import { deleteSeason } from '@/lib/actions/seasons';

export async function removeSeason(formData) {
  await deleteSeason(formData);
}
