import { defineConfig } from 'drizzle-kit';

export default defineConfig({
  schema: './src/schema.ts',
  out: './drizzle',
  dialect: 'postgresql',
  dbCredentials: {
    host: 'localhost',
    port: 5435,
    user: 'precision',
    password: 'precision_pass',
    database: 'precision_manufacturing',
  },
});
