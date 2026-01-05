import {
  pgTable,
  pgSchema,
  serial,
  varchar,
  text,
  integer,
  numeric,
  boolean,
  timestamp,
  jsonb,
  primaryKey,
  index,
} from 'drizzle-orm/pg-core';
import { relations } from 'drizzle-orm';

// Define the manufacturing schema
export const manufacturing = pgSchema('manufacturing');

// =============================================================================
// EMPLOYEES TABLE
// =============================================================================
export const employees = manufacturing.table('employees', {
  id: serial('id').primaryKey(),
  employeeId: varchar('employee_id', { length: 20 }).notNull().unique(),
  firstName: varchar('first_name', { length: 50 }).notNull(),
  lastName: varchar('last_name', { length: 50 }).notNull(),
  email: varchar('email', { length: 100 }).notNull().unique(),
  phone: varchar('phone', { length: 20 }),
  department: varchar('department', { length: 50 }).notNull(),
  role: varchar('role', { length: 50 }).notNull(),
  hireDate: timestamp('hire_date').notNull(),
  hourlyRate: numeric('hourly_rate', { precision: 8, scale: 2 }),
  isActive: boolean('is_active').default(true),
  deletedAt: timestamp('deleted_at'),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

// =============================================================================
// MATERIALS TABLE
// =============================================================================
export const materials = manufacturing.table('materials', {
  materialId: serial('material_id').primaryKey(),
  sku: varchar('sku', { length: 50 }).notNull().unique(),
  name: varchar('name', { length: 100 }).notNull(),
  description: text('description'),
  materialType: varchar('material_type', { length: 50 }).notNull(),
  unitOfMeasure: varchar('unit_of_measure', { length: 20 }).notNull(),
  quantityInStock: numeric('quantity_in_stock', { precision: 12, scale: 3 }).default('0'),
  reorderLevel: numeric('reorder_level', { precision: 12, scale: 3 }).default('0'),
  unitCost: numeric('unit_cost', { precision: 10, scale: 2 }).notNull(),
  supplier: varchar('supplier', { length: 100 }),
  leadTimeDays: integer('lead_time_days'),
  storageLocation: varchar('storage_location', { length: 50 }),
  deletedAt: timestamp('deleted_at'),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
}, (table) => ({
  skuIdx: index('materials_sku_idx').on(table.sku),
  typeIdx: index('materials_type_idx').on(table.materialType),
}));

// =============================================================================
// PARTS TABLE
// =============================================================================
export const parts = manufacturing.table('parts', {
  partId: serial('part_id').primaryKey(),
  partNumber: varchar('part_number', { length: 50 }).notNull().unique(),
  name: varchar('name', { length: 100 }).notNull(),
  description: text('description'),
  category: varchar('category', { length: 50 }).notNull(),
  specifications: jsonb('specifications'),
  currentVersion: integer('current_version').default(1),
  basePrice: numeric('base_price', { precision: 10, scale: 2 }).notNull(),
  standardLeadDays: integer('standard_lead_days').default(14),
  isActive: boolean('is_active').default(true),
  deletedAt: timestamp('deleted_at'),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
}, (table) => ({
  partNumberIdx: index('parts_part_number_idx').on(table.partNumber),
  categoryIdx: index('parts_category_idx').on(table.category),
}));

// =============================================================================
// PART VERSIONS TABLE
// =============================================================================
export const partVersions = manufacturing.table('part_versions', {
  versionId: serial('version_id').primaryKey(),
  partId: integer('part_id').notNull().references(() => parts.partId),
  versionNumber: integer('version_number').notNull(),
  changeDescription: text('change_description'),
  specifications: jsonb('specifications'),
  createdBy: integer('created_by').references(() => employees.id),
  approvedBy: integer('approved_by').references(() => employees.id),
  approvedAt: timestamp('approved_at'),
  createdAt: timestamp('created_at').defaultNow(),
});

// =============================================================================
// PART MATERIALS (BILL OF MATERIALS)
// =============================================================================
export const partMaterials = manufacturing.table('part_materials', {
  id: serial('id').primaryKey(),
  partId: integer('part_id').notNull().references(() => parts.partId),
  materialId: integer('material_id').notNull().references(() => materials.materialId),
  quantityRequired: numeric('quantity_required', { precision: 10, scale: 4 }).notNull(),
  notes: text('notes'),
});

// =============================================================================
// MACHINES TABLE
// =============================================================================
export const machines = manufacturing.table('machines', {
  machineId: serial('machine_id').primaryKey(),
  machineCode: varchar('machine_code', { length: 20 }).notNull().unique(),
  name: varchar('name', { length: 100 }).notNull(),
  machineType: varchar('machine_type', { length: 50 }).notNull(),
  manufacturer: varchar('manufacturer', { length: 100 }),
  model: varchar('model', { length: 50 }),
  serialNumber: varchar('serial_number', { length: 50 }),
  location: varchar('location', { length: 50 }),
  status: varchar('status', { length: 20 }).default('operational'),
  lastMaintenance: timestamp('last_maintenance'),
  nextMaintenance: timestamp('next_maintenance'),
  hourlyRate: numeric('hourly_rate', { precision: 8, scale: 2 }),
  deletedAt: timestamp('deleted_at'),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

// =============================================================================
// PRODUCTION ORDERS TABLE
// =============================================================================
export const productionOrders = manufacturing.table('production_orders', {
  orderId: serial('order_id').primaryKey(),
  orderNumber: varchar('order_number', { length: 30 }).notNull().unique(),
  customerName: varchar('customer_name', { length: 100 }).notNull(),
  customerContact: varchar('customer_contact', { length: 100 }),
  priority: varchar('priority', { length: 20 }).default('normal'),
  status: varchar('status', { length: 20 }).default('pending'),
  orderDate: timestamp('order_date').defaultNow(),
  dueDate: timestamp('due_date'),
  shippedDate: timestamp('shipped_date'),
  notes: text('notes'),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

// =============================================================================
// ORDER ITEMS TABLE
// =============================================================================
export const orderItems = manufacturing.table('order_items', {
  itemId: serial('item_id').primaryKey(),
  orderId: integer('order_id').notNull().references(() => productionOrders.orderId),
  partId: integer('part_id').notNull().references(() => parts.partId),
  quantityOrdered: integer('quantity_ordered').notNull(),
  quantityProduced: integer('quantity_produced').default(0),
  unitPrice: numeric('unit_price', { precision: 10, scale: 2 }).notNull(),
});

// =============================================================================
// PRODUCTION RUNS TABLE
// =============================================================================
export const productionRuns = manufacturing.table('production_runs', {
  runId: serial('run_id').primaryKey(),
  runNumber: varchar('run_number', { length: 30 }).notNull().unique(),
  orderId: integer('order_id').references(() => productionOrders.orderId),
  partId: integer('part_id').notNull().references(() => parts.partId),
  machineId: integer('machine_id').references(() => machines.machineId),
  operatorId: integer('operator_id').references(() => employees.id),
  quantityPlanned: integer('quantity_planned').notNull(),
  quantityProduced: integer('quantity_produced').default(0),
  quantityRejected: integer('quantity_rejected').default(0),
  status: varchar('status', { length: 20 }).default('scheduled'),
  startTime: timestamp('start_time'),
  endTime: timestamp('end_time'),
  notes: text('notes'),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

// =============================================================================
// QUALITY CHECKS TABLE
// =============================================================================
export const qualityChecks = manufacturing.table('quality_checks', {
  checkId: serial('check_id').primaryKey(),
  runId: integer('run_id').notNull().references(() => productionRuns.runId),
  checkType: varchar('check_type', { length: 30 }).notNull(),
  result: varchar('result', { length: 20 }).notNull(),
  inspectorId: integer('inspector_id').references(() => employees.id),
  checkedAt: timestamp('checked_at').defaultNow(),
  defectTypes: jsonb('defect_types'),
  measurements: jsonb('measurements'),
  notes: text('notes'),
  createdAt: timestamp('created_at').defaultNow(),
});

// =============================================================================
// AUDIT LOG TABLE
// =============================================================================
export const auditLog = manufacturing.table('audit_log', {
  logId: serial('log_id').primaryKey(),
  tableName: varchar('table_name', { length: 50 }).notNull(),
  recordId: integer('record_id').notNull(),
  action: varchar('action', { length: 20 }).notNull(),
  oldData: jsonb('old_data'),
  newData: jsonb('new_data'),
  changedFields: text('changed_fields').array(),
  performedBy: integer('performed_by'),
  performedAt: timestamp('performed_at').defaultNow(),
});

// =============================================================================
// INVENTORY LOG TABLE
// =============================================================================
export const inventoryLog = manufacturing.table('inventory_log', {
  logId: serial('log_id').primaryKey(),
  materialId: integer('material_id').notNull().references(() => materials.materialId),
  changeType: varchar('change_type', { length: 20 }).notNull(),
  quantityChange: numeric('quantity_change', { precision: 12, scale: 3 }).notNull(),
  quantityBefore: numeric('quantity_before', { precision: 12, scale: 3 }),
  quantityAfter: numeric('quantity_after', { precision: 12, scale: 3 }),
  unitCost: numeric('unit_cost', { precision: 10, scale: 2 }),
  referenceType: varchar('reference_type', { length: 50 }),
  referenceId: integer('reference_id'),
  reason: text('reason'),
  performedBy: integer('performed_by'),
  createdAt: timestamp('created_at').defaultNow(),
});

// =============================================================================
// ORDER STATUS HISTORY TABLE
// =============================================================================
export const orderStatusHistory = manufacturing.table('order_status_history', {
  historyId: serial('history_id').primaryKey(),
  orderId: integer('order_id').notNull().references(() => productionOrders.orderId),
  oldStatus: varchar('old_status', { length: 20 }),
  newStatus: varchar('new_status', { length: 20 }).notNull(),
  changedBy: integer('changed_by'),
  changeReason: text('change_reason'),
  changedAt: timestamp('changed_at').defaultNow(),
});

// =============================================================================
// MAINTENANCE LOG TABLE
// =============================================================================
export const maintenanceLog = manufacturing.table('maintenance_log', {
  logId: serial('log_id').primaryKey(),
  machineId: integer('machine_id').notNull().references(() => machines.machineId),
  maintenanceType: varchar('maintenance_type', { length: 30 }).notNull(),
  description: text('description'),
  partsReplaced: jsonb('parts_replaced'),
  laborHours: numeric('labor_hours', { precision: 6, scale: 2 }),
  cost: numeric('cost', { precision: 10, scale: 2 }),
  performedBy: integer('performed_by').references(() => employees.id),
  completedAt: timestamp('completed_at'),
  nextDueAt: timestamp('next_due_at'),
  createdAt: timestamp('created_at').defaultNow(),
});

// =============================================================================
// RELATIONS
// =============================================================================

export const partsRelations = relations(parts, ({ many }) => ({
  versions: many(partVersions),
  materials: many(partMaterials),
  orderItems: many(orderItems),
  productionRuns: many(productionRuns),
}));

export const partVersionsRelations = relations(partVersions, ({ one }) => ({
  part: one(parts, {
    fields: [partVersions.partId],
    references: [parts.partId],
  }),
  createdByEmployee: one(employees, {
    fields: [partVersions.createdBy],
    references: [employees.id],
  }),
}));

export const partMaterialsRelations = relations(partMaterials, ({ one }) => ({
  part: one(parts, {
    fields: [partMaterials.partId],
    references: [parts.partId],
  }),
  material: one(materials, {
    fields: [partMaterials.materialId],
    references: [materials.materialId],
  }),
}));

export const productionOrdersRelations = relations(productionOrders, ({ many }) => ({
  items: many(orderItems),
  runs: many(productionRuns),
  statusHistory: many(orderStatusHistory),
}));

export const orderItemsRelations = relations(orderItems, ({ one }) => ({
  order: one(productionOrders, {
    fields: [orderItems.orderId],
    references: [productionOrders.orderId],
  }),
  part: one(parts, {
    fields: [orderItems.partId],
    references: [parts.partId],
  }),
}));

export const productionRunsRelations = relations(productionRuns, ({ one, many }) => ({
  order: one(productionOrders, {
    fields: [productionRuns.orderId],
    references: [productionOrders.orderId],
  }),
  part: one(parts, {
    fields: [productionRuns.partId],
    references: [parts.partId],
  }),
  machine: one(machines, {
    fields: [productionRuns.machineId],
    references: [machines.machineId],
  }),
  operator: one(employees, {
    fields: [productionRuns.operatorId],
    references: [employees.id],
  }),
  qualityChecks: many(qualityChecks),
}));

export const qualityChecksRelations = relations(qualityChecks, ({ one }) => ({
  run: one(productionRuns, {
    fields: [qualityChecks.runId],
    references: [productionRuns.runId],
  }),
  inspector: one(employees, {
    fields: [qualityChecks.inspectorId],
    references: [employees.id],
  }),
}));

export const machinesRelations = relations(machines, ({ many }) => ({
  productionRuns: many(productionRuns),
  maintenanceLogs: many(maintenanceLog),
}));

export const materialsRelations = relations(materials, ({ many }) => ({
  partMaterials: many(partMaterials),
  inventoryLogs: many(inventoryLog),
}));

// =============================================================================
// TYPE EXPORTS
// =============================================================================

export type Employee = typeof employees.$inferSelect;
export type NewEmployee = typeof employees.$inferInsert;

export type Material = typeof materials.$inferSelect;
export type NewMaterial = typeof materials.$inferInsert;

export type Part = typeof parts.$inferSelect;
export type NewPart = typeof parts.$inferInsert;

export type PartVersion = typeof partVersions.$inferSelect;
export type NewPartVersion = typeof partVersions.$inferInsert;

export type Machine = typeof machines.$inferSelect;
export type NewMachine = typeof machines.$inferInsert;

export type ProductionOrder = typeof productionOrders.$inferSelect;
export type NewProductionOrder = typeof productionOrders.$inferInsert;

export type OrderItem = typeof orderItems.$inferSelect;
export type NewOrderItem = typeof orderItems.$inferInsert;

export type ProductionRun = typeof productionRuns.$inferSelect;
export type NewProductionRun = typeof productionRuns.$inferInsert;

export type QualityCheck = typeof qualityChecks.$inferSelect;
export type NewQualityCheck = typeof qualityChecks.$inferInsert;
