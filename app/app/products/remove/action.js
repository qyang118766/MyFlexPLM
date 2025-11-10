'use server';

import { revalidatePath } from 'next/cache';
import { createClient } from '@/lib/supabase/server';
import { assertPermission } from '@/lib/permissions';

export async function removeProduct(formData) {
  const supabase = await createClient();

  const productId = formData.get('product_id');

  if (!productId) {
    throw new Error('Missing product id.');
  }

  // Get product's type_id before deleting
  const { data: product, error: fetchError } = await supabase
    .from('products')
    .select('type_id')
    .eq('id', productId)
    .single();

  if (fetchError || !product) {
    throw new Error('Product not found.');
  }

  // Check permission - user must have 'delete' or 'full' permission for this type node
  await assertPermission(product.type_id, 'delete', 'You do not have permission to delete this product.');

  const { error } = await supabase.from('products').delete().eq('id', productId);

  if (error) {
    throw new Error(error.message);
  }

  revalidatePath('/products');
}
