import { db, closeConnection } from './db.js';
import { sql } from 'drizzle-orm';

async function testConnection() {
  try {
    // Test the connection
    const result = await db.execute(sql`SELECT current_database(), current_user, version()`);
    console.log('✅ Database connection successful!');
    console.log('');
    console.log('Connection details:');
    console.log(`  Database: ${result[0].current_database}`);
    console.log(`  User: ${result[0].current_user}`);
    console.log(`  PostgreSQL: ${result[0].version}`);
    console.log('');
    
    // Test that schema exists
    const schemaCheck = await db.execute(sql`
      SELECT schema_name 
      FROM information_schema.schemata 
      WHERE schema_name = 'manufacturing'
    `);
    
    if (schemaCheck.length > 0) {
      console.log('✅ Manufacturing schema found!');
    } else {
      console.log('❌ Manufacturing schema not found. Make sure the database is initialized.');
    }
    
    // Count tables
    const tableCount = await db.execute(sql`
      SELECT count(*) as table_count
      FROM information_schema.tables 
      WHERE table_schema = 'manufacturing'
    `);
    console.log(`   Tables in schema: ${tableCount[0].table_count}`);
    
  } catch (error) {
    console.error('❌ Database connection failed!');
    console.error('');
    console.error('Make sure Docker containers are running:');
    console.error('  cd .. && docker compose up -d');
    console.error('');
    console.error('Error:', error);
    process.exit(1);
  } finally {
    await closeConnection();
  }
}

testConnection();
