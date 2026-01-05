import { drizzle } from 'drizzle-orm/postgres-js';
import postgres from 'postgres';
import * as schema from './schema.js';

// Connection configuration
const connectionString = 'postgres://precision:precision_pass@localhost:5435/precision_manufacturing';

// Create the connection
const queryClient = postgres(connectionString);

// Create the Drizzle database instance with schema
export const db = drizzle(queryClient, { schema });

// Export the query client for manual queries if needed
export { queryClient };

// Graceful shutdown helper
export async function closeConnection() {
  await queryClient.end();
}
