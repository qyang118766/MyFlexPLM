'use server';

import { revalidatePath } from 'next/cache';
import { createClient } from '@/lib/supabase/server';

export async function removeProduct(formData) {
  const supabase = await createClient();

  const productId = formData.get('product_id');

  if (!productId) {
    throw new Error('Missing product id.');
  }

  const { error } = await supabase.from('products').delete().eq('id', productId);

  if (error) {
    throw new Error(error.message);
  }

  revalidatePath('/products');
}
