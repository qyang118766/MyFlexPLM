/**
 * Version Control Service
 *
 * Centralized module for managing versioning across versioned entities:
 * - Products
 * - Materials
 * - Suppliers
 *
 * Versioning Strategy:
 * - Create: Initialize with version A.1, isLatest=true
 * - Update: Insert new row with incremented iteration, mark as latest, mark old as not latest
 * - Each item (identified by code) can have multiple versions, but only one is marked as latest
 *
 * Version Format: {MajorVersion}.{Iteration}
 * - MajorVersion: Single letter A-Z (currently only 'A' is used)
 * - Iteration: Number starting from 1, increments with each update
 * - Examples: A.1, A.2, A.3, etc.
 */

import { createClient } from '@/lib/supabase/server';

/**
 * Entity configuration for versioned entities
 */
const VERSIONED_ENTITIES = {
  products: {
    table: 'products',
    masterTable: 'product_master',
    codeField: 'style_code',
    displayName: 'Product',
  },
  materials: {
    table: 'materials',
    masterTable: 'material_master',
    codeField: 'material_code',
    displayName: 'Material',
  },
  suppliers: {
    table: 'suppliers',
    masterTable: 'supplier_master',
    codeField: 'supplier_code',
    displayName: 'Supplier',
  },
};

/**
 * Create or verify master record exists
 * Master record contains unique code and creation metadata
 *
 * @param {string} entityType - Type of entity (products, materials, suppliers)
 * @param {string} code - The unique code value
 * @param {string} userId - User identifier for created_by
 * @returns {Promise<Object>} Result with success status and master record
 */
export async function ensureMasterRecord(entityType, code, userId) {
  const config = VERSIONED_ENTITIES[entityType];
  if (!config) {
    throw new Error(`Invalid entity type: ${entityType}`);
  }

  const supabase = await createClient();

  // Check if master record exists
  const { data: existing, error: checkError } = await supabase
    .from(config.masterTable)
    .select('*')
    .eq(config.codeField, code)
    .single();

  if (existing) {
    return {
      success: true,
      data: existing,
      isNew: false,
    };
  }

  // Create new master record
  const masterPayload = {
    [config.codeField]: code,
    created_by: userId,
  };

  const { data: newMaster, error: insertError } = await supabase
    .from(config.masterTable)
    .insert(masterPayload)
    .select()
    .single();

  if (insertError) {
    return {
      success: false,
      error: `Failed to create master record: ${insertError.message}`,
    };
  }

  return {
    success: true,
    data: newMaster,
    isNew: true,
  };
}

/**
 * Check if master record exists
 *
 * @param {string} entityType - Type of entity (products, materials, suppliers)
 * @param {string} code - The unique code value
 * @returns {Promise<boolean>} True if master record exists
 */
export async function masterRecordExists(entityType, code) {
  const config = VERSIONED_ENTITIES[entityType];
  if (!config) {
    throw new Error(`Invalid entity type: ${entityType}`);
  }

  const supabase = await createClient();

  const { data, error } = await supabase
    .from(config.masterTable)
    .select(config.codeField)
    .eq(config.codeField, code)
    .single();

  return !error && data !== null;
}

/**
 * Initialize version for a new entity
 * Sets version to 'A', iteration to 1, and isLatest to true
 *
 * @returns {Object} Version fields to include in INSERT payload
 */
export function initializeVersion() {
  return {
    version: 'A',
    iteration: 1,
    is_latest: true,
  };
}

/**
 * Get the latest version of an entity by its code
 *
 * @param {string} entityType - Type of entity (products, materials, suppliers)
 * @param {string} code - The code value to search for
 * @returns {Promise<Object|null>} Latest version record or null if not found
 */
export async function getLatestVersion(entityType, code) {
  const config = VERSIONED_ENTITIES[entityType];
  if (!config) {
    throw new Error(`Invalid entity type: ${entityType}. Must be one of: ${Object.keys(VERSIONED_ENTITIES).join(', ')}`);
  }

  const supabase = await createClient();

  const { data, error } = await supabase
    .from(config.table)
    .select('*')
    .eq(config.codeField, code)
    .eq('is_latest', true)
    .single();

  if (error) {
    console.error(`Error fetching latest version for ${config.displayName} ${code}:`, error);
    return null;
  }

  return data;
}

/**
 * Get all versions of an entity by its code, ordered by version/iteration
 *
 * @param {string} entityType - Type of entity (products, materials, suppliers)
 * @param {string} code - The code value to search for
 * @returns {Promise<Array>} Array of all versions, ordered newest to oldest
 */
export async function getVersionHistory(entityType, code) {
  const config = VERSIONED_ENTITIES[entityType];
  if (!config) {
    throw new Error(`Invalid entity type: ${entityType}`);
  }

  const supabase = await createClient();

  const { data, error } = await supabase
    .from(config.table)
    .select('*')
    .eq(config.codeField, code)
    .order('version', { ascending: false })
    .order('iteration', { ascending: false });

  if (error) {
    console.error(`Error fetching version history for ${config.displayName} ${code}:`, error);
    return [];
  }

  return data || [];
}

/**
 * Prepare next version payload for an update operation
 *
 * This function:
 * 1. Fetches the current latest version
 * 2. Increments the iteration number
 * 3. Returns payload with new version info and fields to preserve
 *
 * @param {string} entityType - Type of entity (products, materials, suppliers)
 * @param {string} code - The code value being updated
 * @param {Object} newData - New data for the updated version
 * @returns {Promise<Object>} Payload for the new version including version fields and preserved data
 */
export async function prepareNextVersion(entityType, code, newData = {}) {
  const config = VERSIONED_ENTITIES[entityType];
  if (!config) {
    throw new Error(`Invalid entity type: ${entityType}`);
  }

  // Get the current latest version
  const currentVersion = await getLatestVersion(entityType, code);

  if (!currentVersion) {
    throw new Error(`No existing version found for ${config.displayName} code: ${code}`);
  }

  // Calculate next iteration
  const nextIteration = (currentVersion.iteration || 0) + 1;

  // Return payload with version fields and preserved data
  return {
    version: currentVersion.version || 'A',
    iteration: nextIteration,
    is_latest: true,
    // Preserve fields that should carry over
    preservedFields: {
      [config.codeField]: currentVersion[config.codeField],
      type_id: currentVersion.type_id,
      create_by: currentVersion.create_by,
    },
  };
}

/**
 * Mark a specific version as the latest version
 * This will:
 * 1. Set is_latest=false for all other versions with the same code
 * 2. Set is_latest=true for the specified version
 *
 * @param {string} entityType - Type of entity (products, materials, suppliers)
 * @param {string} code - The code value
 * @param {string} versionId - The UUID of the version to mark as latest
 * @returns {Promise<boolean>} Success status
 */
export async function markAsLatestVersion(entityType, code, versionId) {
  const config = VERSIONED_ENTITIES[entityType];
  if (!config) {
    throw new Error(`Invalid entity type: ${entityType}`);
  }

  const supabase = await createClient();

  // Start a transaction-like operation
  // Step 1: Mark all versions of this code as not latest
  const { error: updateError } = await supabase
    .from(config.table)
    .update({ is_latest: false })
    .eq(config.codeField, code);

  if (updateError) {
    console.error(`Error unmarking old versions for ${config.displayName} ${code}:`, updateError);
    return false;
  }

  // Step 2: Mark the specified version as latest
  const { error: markError } = await supabase
    .from(config.table)
    .update({ is_latest: true })
    .eq('id', versionId);

  if (markError) {
    console.error(`Error marking version ${versionId} as latest:`, markError);
    return false;
  }

  return true;
}

/**
 * Execute versioned update
 *
 * This is the main function for updating versioned entities.
 * It handles the complete update workflow:
 * 1. Fetch current version details
 * 2. Mark current version as not latest
 * 3. Insert new version with incremented iteration
 *
 * @param {string} entityType - Type of entity (products, materials, suppliers)
 * @param {string} code - The code value being updated
 * @param {Object} payload - Complete payload for the new version (excluding version fields)
 * @param {string} userId - User performing the update
 * @returns {Promise<Object>} Result object with success status and new version data
 */
export async function executeVersionedUpdate(entityType, code, payload, userId) {
  const config = VERSIONED_ENTITIES[entityType];
  if (!config) {
    throw new Error(`Invalid entity type: ${entityType}`);
  }

  const supabase = await createClient();

  // Get current version
  const currentVersion = await getLatestVersion(entityType, code);
  if (!currentVersion) {
    return {
      success: false,
      error: `No existing version found for ${config.displayName} code: ${code}`,
    };
  }

  // Calculate next version
  const nextIteration = (currentVersion.iteration || 0) + 1;

  // Step 1: Mark current version as not latest
  const { error: updateError } = await supabase
    .from(config.table)
    .update({ is_latest: false })
    .eq('id', currentVersion.id);

  if (updateError) {
    return {
      success: false,
      error: `Failed to update previous version: ${updateError.message}`,
    };
  }

  // Step 2: Insert new version
  const newVersionPayload = {
    ...payload,
    [config.codeField]: code,
    version: currentVersion.version || 'A',
    iteration: nextIteration,
    is_latest: true,
    create_by: currentVersion.create_by, // Preserve original creator
    update_by: userId, // Set current user as updater
  };

  const { data, error: insertError } = await supabase
    .from(config.table)
    .insert(newVersionPayload)
    .select()
    .single();

  if (insertError) {
    // Rollback: restore previous version as latest
    await supabase
      .from(config.table)
      .update({ is_latest: true })
      .eq('id', currentVersion.id);

    return {
      success: false,
      error: `Failed to insert new version: ${insertError.message}`,
    };
  }

  return {
    success: true,
    data,
    previousVersion: currentVersion,
  };
}

/**
 * Format version for display
 *
 * @param {string} version - Version letter (A-Z)
 * @param {number} iteration - Iteration number
 * @returns {string} Formatted version string (e.g., "A.1", "A.23")
 */
export function formatVersion(version, iteration) {
  return `${version || 'A'}.${iteration || 1}`;
}

/**
 * Get entity configuration
 *
 * @param {string} entityType - Type of entity
 * @returns {Object} Entity configuration
 */
export function getEntityConfig(entityType) {
  return VERSIONED_ENTITIES[entityType];
}

/**
 * Check if an entity type is version-controlled
 *
 * @param {string} entityType - Type of entity
 * @returns {boolean} True if entity is version-controlled
 */
export function isVersionControlled(entityType) {
  return entityType in VERSIONED_ENTITIES;
}

/**
 * Create new item with master record and first version
 *
 * This is the main function for creating new versioned entities.
 * It handles the complete creation workflow:
 * 1. Create master record (or verify it doesn't already exist)
 * 2. Create first version (A.1) with is_latest = true
 *
 * @param {string} entityType - Type of entity (products, materials, suppliers)
 * @param {string} code - The unique code value
 * @param {Object} payload - Complete payload for the first version (excluding version fields and code)
 * @param {string} userId - User performing the creation
 * @returns {Promise<Object>} Result object with success status and created data
 */
export async function createVersionedItem(entityType, code, payload, userId) {
  const config = VERSIONED_ENTITIES[entityType];
  if (!config) {
    throw new Error(`Invalid entity type: ${entityType}`);
  }

  const supabase = await createClient();

  // Step 1: Check if master record already exists
  const masterExists = await masterRecordExists(entityType, code);
  if (masterExists) {
    return {
      success: false,
      error: `${config.displayName} with code "${code}" already exists. Use a different code or update the existing item.`,
    };
  }

  // Step 2: Create master record
  const masterResult = await ensureMasterRecord(entityType, code, userId);
  if (!masterResult.success) {
    return {
      success: false,
      error: masterResult.error,
    };
  }

  // Step 3: Initialize version fields
  const versionFields = initializeVersion();

  // Step 4: Create first version
  const firstVersionPayload = {
    ...payload,
    [config.codeField]: code,
    ...versionFields,
    create_by: userId,
    update_by: userId,
  };

  const { data, error: insertError } = await supabase
    .from(config.table)
    .insert(firstVersionPayload)
    .select()
    .single();

  if (insertError) {
    // Rollback: Delete master record if version creation failed
    await supabase
      .from(config.masterTable)
      .delete()
      .eq(config.codeField, code);

    return {
      success: false,
      error: `Failed to create first version: ${insertError.message}`,
    };
  }

  return {
    success: true,
    data,
    masterRecord: masterResult.data,
  };
}
