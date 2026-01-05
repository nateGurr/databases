import { closeConnection } from './db.js';
import * as queries from './queries.js';

// Color helpers for console output
const green = (text: string) => `\x1b[32m${text}\x1b[0m`;
const red = (text: string) => `\x1b[31m${text}\x1b[0m`;
const yellow = (text: string) => `\x1b[33m${text}\x1b[0m`;

interface TestResult {
  name: string;
  passed: boolean;
  error?: string;
}

const results: TestResult[] = [];

async function runTest(name: string, testFn: () => Promise<void>) {
  try {
    await testFn();
    results.push({ name, passed: true });
    console.log(`  ${green('✓')} ${name}`);
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    results.push({ name, passed: false, error: message });
    console.log(`  ${red('✗')} ${name}`);
    console.log(`    ${red(message)}`);
  }
}

async function runAllTests() {
  console.log('\n' + '='.repeat(60));
  console.log('PrecisionParts Drizzle ORM Test Suite');
  console.log('='.repeat(60));

  // 5.1 CRUD Tests
  console.log('\n📦 Problem 5.1: CRUD Operations\n');
  
  await runTest('getActiveMaterials returns array', async () => {
    const materials = await queries.getActiveMaterials();
    if (!Array.isArray(materials)) throw new Error('Expected array');
    if (materials.length === 0) throw new Error('Expected materials, got empty array');
  });

  await runTest('getMaterialBySku finds existing material', async () => {
    const material = await queries.getMaterialBySku('RAW-AL6061-SHT');
    if (!material) throw new Error('Expected to find material');
    if (material.name !== 'Aluminum 6061-T6 Sheet') throw new Error('Wrong material returned');
  });

  await runTest('getMaterialBySku returns null for non-existent', async () => {
    const material = await queries.getMaterialBySku('NOT-EXISTS');
    if (material !== null) throw new Error('Expected null for non-existent SKU');
  });

  // 5.2 Filter Tests
  console.log('\n🔍 Problem 5.2: Filters\n');

  await runTest('getMaterialsBelowReorder finds low stock items', async () => {
    const materials = await queries.getMaterialsBelowReorder();
    if (!Array.isArray(materials)) throw new Error('Expected array');
  });

  await runTest('getPartsByCategory filters correctly', async () => {
    const parts = await queries.getPartsByCategory('aerospace');
    if (!Array.isArray(parts)) throw new Error('Expected array');
    if (parts.length === 0) throw new Error('Expected aerospace parts');
  });

  await runTest('searchParts finds matching parts', async () => {
    const parts = await queries.searchParts('brake');
    if (!Array.isArray(parts)) throw new Error('Expected array');
  });

  // 5.3 Join Tests
  console.log('\n🔗 Problem 5.3: Joins\n');

  await runTest('getOrderWithItems returns order with items', async () => {
    const result = await queries.getOrderWithItems('PO-2024-001');
    if (!result) throw new Error('Expected order to be found');
    if (!result.order || !result.items) throw new Error('Expected order and items properties');
  });

  await runTest('getPartWithMaterials returns BOM', async () => {
    const result = await queries.getPartWithMaterials('AERO-BRK-001');
    if (!result) throw new Error('Expected part to be found');
    if (!result.materials) throw new Error('Expected materials array');
    if (typeof result.totalMaterialCost !== 'number') throw new Error('Expected totalMaterialCost');
  });

  await runTest('getMachineProductionHistory returns runs', async () => {
    const result = await queries.getMachineProductionHistory(1);
    if (!result) throw new Error('Expected machine to be found');
    if (!result.runs) throw new Error('Expected runs array');
  });

  // 5.4 Aggregation Tests
  console.log('\n📊 Problem 5.4: Aggregations\n');

  await runTest('getInventorySummary groups by type', async () => {
    const summary = await queries.getInventorySummary();
    if (!Array.isArray(summary)) throw new Error('Expected array');
    if (summary.length === 0) throw new Error('Expected summary data');
  });

  await runTest('getProductionStats returns statistics', async () => {
    const stats = await queries.getProductionStats();
    if (!stats) throw new Error('Expected stats object');
    if (typeof stats.totalRuns !== 'number') throw new Error('Expected totalRuns');
  });

  await runTest('getQualityMetricsByPart returns metrics', async () => {
    const metrics = await queries.getQualityMetricsByPart();
    if (!Array.isArray(metrics)) throw new Error('Expected array');
  });

  // 5.5 Transaction Tests
  console.log('\n💾 Problem 5.5: Transactions\n');

  await runTest('createOrderWithItems creates atomically', async () => {
    const result = await queries.createOrderWithItems(
      {
        orderNumber: `TEST-${Date.now()}`,
        customerName: 'Test Customer',
        status: 'pending',
      },
      [
        { partId: 1, quantity: 10, unitPrice: 100 },
        { partId: 2, quantity: 5, unitPrice: 200 },
      ]
    );
    if (!result.order) throw new Error('Expected order');
    if (!result.items || result.items.length !== 2) throw new Error('Expected 2 items');
  });

  // Summary
  console.log('\n' + '='.repeat(60));
  const passed = results.filter(r => r.passed).length;
  const failed = results.filter(r => !r.passed).length;
  
  if (failed === 0) {
    console.log(green(`\n✅ All ${passed} tests passed!\n`));
  } else {
    console.log(yellow(`\n⚠️  ${passed} passed, ${red(`${failed} failed`)}\n`));
  }

  console.log('='.repeat(60) + '\n');

  await closeConnection();
  process.exit(failed > 0 ? 1 : 0);
}

runAllTests().catch(async (error) => {
  console.error('Test suite failed:', error);
  await closeConnection();
  process.exit(1);
});
