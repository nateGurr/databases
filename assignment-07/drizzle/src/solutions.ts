import { db } from './db.js';
import {
  materials,
  parts,
  partMaterials,
  productionOrders,
  orderItems,
  productionRuns,
  machines,
  qualityChecks,
  type NewMaterial,
  type NewProductionOrder,
} from './schema.js';
import { eq, isNull, lt, ilike, sql, desc, asc, and } from 'drizzle-orm';

// =============================================================================
// PROBLEM 5.1: Basic CRUD Operations - SOLUTIONS
// =============================================================================

/**
 * 5.1a: Get all active materials
 */
export async function getActiveMaterials() {
  return await db
    .select()
    .from(materials)
    .where(isNull(materials.deletedAt))
    .orderBy(asc(materials.name));
}

/**
 * 5.1b: Get material by SKU
 */
export async function getMaterialBySku(sku: string) {
  const result = await db
    .select()
    .from(materials)
    .where(eq(materials.sku, sku))
    .limit(1);
  
  return result[0] ?? null;
}

/**
 * 5.1c: Create a new material
 */
export async function createMaterial(material: NewMaterial) {
  const result = await db
    .insert(materials)
    .values(material)
    .returning();
  
  return result[0];
}

/**
 * 5.1d: Update material stock
 */
export async function updateMaterialStock(materialId: number, newQuantity: number) {
  const result = await db
    .update(materials)
    .set({ 
      quantityInStock: newQuantity.toString(),
      updatedAt: new Date()
    })
    .where(eq(materials.materialId, materialId))
    .returning();
  
  return result[0];
}

// =============================================================================
// PROBLEM 5.2: Query with Filters - SOLUTIONS
// =============================================================================

/**
 * 5.2a: Get materials below reorder level
 */
export async function getMaterialsBelowReorder() {
  return await db
    .select({
      materialId: materials.materialId,
      sku: materials.sku,
      name: materials.name,
      quantityInStock: materials.quantityInStock,
      reorderLevel: materials.reorderLevel,
      shortage: sql<number>`${materials.reorderLevel} - ${materials.quantityInStock}`.as('shortage'),
    })
    .from(materials)
    .where(
      and(
        isNull(materials.deletedAt),
        sql`${materials.quantityInStock} < ${materials.reorderLevel}`
      )
    )
    .orderBy(desc(sql`${materials.reorderLevel} - ${materials.quantityInStock}`));
}

/**
 * 5.2b: Get parts by category
 */
export async function getPartsByCategory(category: string) {
  return await db
    .select({
      partNumber: parts.partNumber,
      name: parts.name,
      basePrice: parts.basePrice,
    })
    .from(parts)
    .where(
      and(
        eq(parts.category, category),
        isNull(parts.deletedAt)
      )
    )
    .orderBy(desc(parts.basePrice));
}

/**
 * 5.2c: Search parts by name
 */
export async function searchParts(searchTerm: string) {
  return await db
    .select()
    .from(parts)
    .where(
      and(
        ilike(parts.name, `%${searchTerm}%`),
        isNull(parts.deletedAt)
      )
    );
}

// =============================================================================
// PROBLEM 5.3: Joins and Relations - SOLUTIONS
// =============================================================================

/**
 * 5.3a: Get production order with items
 */
export async function getOrderWithItems(orderNumber: string) {
  const result = await db.query.productionOrders.findFirst({
    where: eq(productionOrders.orderNumber, orderNumber),
    with: {
      items: {
        with: {
          part: true,
        },
      },
    },
  });
  
  if (!result) return null;
  
  return {
    order: {
      orderId: result.orderId,
      orderNumber: result.orderNumber,
      customerName: result.customerName,
      status: result.status,
      dueDate: result.dueDate,
    },
    items: result.items.map(item => ({
      itemId: item.itemId,
      partNumber: item.part.partNumber,
      partName: item.part.name,
      quantityOrdered: item.quantityOrdered,
      quantityProduced: item.quantityProduced,
      unitPrice: item.unitPrice,
    })),
  };
}

/**
 * 5.3b: Get part with bill of materials
 */
export async function getPartWithMaterials(partNumber: string) {
  const result = await db.query.parts.findFirst({
    where: eq(parts.partNumber, partNumber),
    with: {
      materials: {
        with: {
          material: true,
        },
      },
    },
  });
  
  if (!result) return null;
  
  const materialsWithCost = result.materials.map(pm => ({
    sku: pm.material.sku,
    name: pm.material.name,
    quantityRequired: pm.quantityRequired,
    unitCost: pm.material.unitCost,
    lineCost: Number(pm.quantityRequired) * Number(pm.material.unitCost),
  }));
  
  const totalMaterialCost = materialsWithCost.reduce(
    (sum, m) => sum + m.lineCost,
    0
  );
  
  return {
    part: {
      partId: result.partId,
      partNumber: result.partNumber,
      name: result.name,
      category: result.category,
      basePrice: result.basePrice,
    },
    materials: materialsWithCost,
    totalMaterialCost,
  };
}

/**
 * 5.3c: Get machine production history
 */
export async function getMachineProductionHistory(machineId: number) {
  const result = await db.query.machines.findFirst({
    where: eq(machines.machineId, machineId),
    with: {
      productionRuns: {
        with: {
          part: true,
        },
        orderBy: (runs, { desc }) => [desc(runs.startTime)],
      },
    },
  });
  
  if (!result) return null;
  
  return {
    machine: {
      machineId: result.machineId,
      machineCode: result.machineCode,
      name: result.name,
      status: result.status,
    },
    runs: result.productionRuns.map(run => ({
      runNumber: run.runNumber,
      partNumber: run.part.partNumber,
      partName: run.part.name,
      quantityPlanned: run.quantityPlanned,
      quantityProduced: run.quantityProduced,
      status: run.status,
      startTime: run.startTime,
      endTime: run.endTime,
    })),
  };
}

// =============================================================================
// PROBLEM 5.4: Aggregation Queries - SOLUTIONS
// =============================================================================

/**
 * 5.4a: Get inventory summary
 */
export async function getInventorySummary() {
  return await db
    .select({
      materialType: materials.materialType,
      count: sql<number>`count(*)`.as('count'),
      totalQuantity: sql<number>`sum(${materials.quantityInStock})`.as('total_quantity'),
      totalValue: sql<number>`sum(${materials.quantityInStock} * ${materials.unitCost})`.as('total_value'),
    })
    .from(materials)
    .where(isNull(materials.deletedAt))
    .groupBy(materials.materialType)
    .orderBy(desc(sql`sum(${materials.quantityInStock} * ${materials.unitCost})`));
}

/**
 * 5.4b: Get production statistics
 */
export async function getProductionStats() {
  const result = await db
    .select({
      totalRuns: sql<number>`count(*)`.as('total_runs'),
      completedRuns: sql<number>`count(*) filter (where ${productionRuns.status} = 'completed')`.as('completed_runs'),
      runningRuns: sql<number>`count(*) filter (where ${productionRuns.status} = 'running')`.as('running_runs'),
      totalQuantityProduced: sql<number>`sum(${productionRuns.quantityProduced})`.as('total_quantity_produced'),
      avgRunQuantity: sql<number>`avg(${productionRuns.quantityPlanned})`.as('avg_run_quantity'),
    })
    .from(productionRuns);
  
  return result[0];
}

/**
 * 5.4c: Get quality metrics by part
 */
export async function getQualityMetricsByPart() {
  return await db
    .select({
      partNumber: parts.partNumber,
      totalChecks: sql<number>`count(${qualityChecks.checkId})`.as('total_checks'),
      passRate: sql<number>`
        round(
          100.0 * count(*) filter (where ${qualityChecks.result} in ('pass', 'conditional')) 
          / nullif(count(*), 0),
          2
        )
      `.as('pass_rate'),
      failRate: sql<number>`
        round(
          100.0 * count(*) filter (where ${qualityChecks.result} = 'fail') 
          / nullif(count(*), 0),
          2
        )
      `.as('fail_rate'),
    })
    .from(qualityChecks)
    .innerJoin(productionRuns, eq(qualityChecks.runId, productionRuns.runId))
    .innerJoin(parts, eq(productionRuns.partId, parts.partId))
    .groupBy(parts.partNumber)
    .orderBy(asc(sql`
      round(
        100.0 * count(*) filter (where ${qualityChecks.result} in ('pass', 'conditional')) 
        / nullif(count(*), 0),
        2
      )
    `));
}

// =============================================================================
// PROBLEM 5.5: Transactions - SOLUTIONS
// =============================================================================

/**
 * 5.5a: Create order with items
 */
export async function createOrderWithItems(
  order: NewProductionOrder,
  items: Array<{ partId: number; quantity: number; unitPrice: number }>
) {
  return await db.transaction(async (tx) => {
    // Insert the order
    const [newOrder] = await tx
      .insert(productionOrders)
      .values(order)
      .returning();
    
    // Insert order items
    const insertedItems = await tx
      .insert(orderItems)
      .values(
        items.map(item => ({
          orderId: newOrder.orderId,
          partId: item.partId,
          quantityOrdered: item.quantity,
          unitPrice: item.unitPrice.toString(),
        }))
      )
      .returning();
    
    return {
      order: newOrder,
      items: insertedItems,
    };
  });
}
