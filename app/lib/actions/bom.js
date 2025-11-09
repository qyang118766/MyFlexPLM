'use server';

import { revalidatePath } from 'next/cache';
import { createClient } from '@/lib/supabase/server';

const BOM_STATUS_VALUES = new Set(['draft', 'active', 'archived']);

function normalizeNumber(value, fallback = null) {
  if (value === null || value === undefined) return fallback;
  const parsed = parseFloat(value);
  return Number.isFinite(parsed) ? parsed : fallback;
}

function normalizeText(value, fallback = null) {
  if (!value) return fallback;
  return value.toString().trim() || fallback;
}

function normalizeStatus(value) {
  if (!value) return 'draft';
  const normalized = value.toString().trim().toLowerCase();
  return BOM_STATUS_VALUES.has(normalized) ? normalized : 'draft';
}

function revalidateBomPage() {
  revalidatePath('/bom');
}

async function nextLineNumber(supabase, bomId) {
  const { data, error } = await supabase
    .from('bom_items')
    .select('line_number')
    .eq('bom_id', bomId)
    .order('line_number', { ascending: false })
    .limit(1)
    .maybeSingle();

  if (error) {
    throw new Error(error.message);
  }

  return data?.line_number ? data.line_number + 1 : 1;
}

export async function addBomItem(formData) {
  const supabase = await createClient();

  const bomId = normalizeText(formData.get('bom_id'));
  const productId = normalizeText(formData.get('product_id'));
  const materialId = normalizeText(formData.get('material_id'));
  const colorId = normalizeText(formData.get('color_id'));
  const supplierId = normalizeText(formData.get('supplier_id'));
  const quantity = normalizeNumber(formData.get('quantity'), 1);
  const unit = normalizeText(formData.get('unit'), 'pcs');

  if (!bomId || !productId || !materialId) {
    return { error: 'Missing required fields for BOM item.' };
  }

  let lineNumber = 1;

  try {
    lineNumber = await nextLineNumber(supabase, bomId);
  } catch (error) {
    return { error: error.message };
  }

  const { error } = await supabase.from('bom_items').insert({
    bom_id: bomId,
    line_number: lineNumber,
    material_id: materialId,
    color_id: colorId || null,
    supplier_id: supplierId || null,
    quantity,
    unit,
  });

  if (error) {
    return { error: error.message };
  }

  revalidateBomPage();
  return { success: true };
}

export async function updateBomItem(formData) {
  const supabase = await createClient();

  const itemId = normalizeText(formData.get('bom_item_id'));
  const productId = normalizeText(formData.get('product_id'));
  const colorId = normalizeText(formData.get('color_id'));
  const supplierId = normalizeText(formData.get('supplier_id'));
  const quantityValue = normalizeNumber(formData.get('quantity'));
  const unitValue = normalizeText(formData.get('unit'), 'pcs');

  if (!itemId || !productId) {
    return { error: 'Missing required identifiers for update.' };
  }

  const updates = {
    color_id: colorId || null,
    supplier_id: supplierId || null,
    unit: unitValue,
  };

  if (quantityValue !== null) {
    updates.quantity = quantityValue;
  }

  const { error } = await supabase.from('bom_items').update(updates).eq('id', itemId);

  if (error) {
    return { error: error.message };
  }

  revalidateBomPage();
  return { success: true };
}

export async function deleteBomItem(formData) {
  const supabase = await createClient();

  const itemId = normalizeText(formData.get('bom_item_id'));
  const productId = normalizeText(formData.get('product_id'));

  if (!itemId || !productId) {
    return { error: 'Missing identifiers for delete.' };
  }

  const { error } = await supabase.from('bom_items').delete().eq('id', itemId);

  if (error) {
    return { error: error.message };
  }

  revalidateBomPage();
  return { success: true };
}

export async function createBomStructure(formData) {
  const supabase = await createClient();

  const productId = normalizeText(formData.get('product_id'));
  const name = normalizeText(formData.get('name'), 'Default BOM');
  const status = normalizeStatus(formData.get('status'));

  if (!productId) {
    return { error: 'Product id is required to create a BOM.' };
  }

  const { error } = await supabase.from('product_boms').insert({
    product_id: productId,
    name,
    status,
  });

  if (error) {
    return { error: error.message };
  }

  revalidateBomPage();
  return { success: true };
}
