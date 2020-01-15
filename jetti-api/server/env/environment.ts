import { config as dotenv } from 'dotenv';
import { config } from 'mssql';

dotenv();

export const DB_NAME = process.env.DB_NAME!;
export const REDIS_DB_HOST = process.env.REDIS_DB_HOST!;
export const REDIS_DB_AUTH = process.env.REDIS_DB_AUTH;
export const JTW_KEY = process.env.JTW_KEY!;
export const bpApiHost = 'https://bp.x100-group.com/JettiProcesses/hs';

const DB_PORT = parseInt(process.env.DB_PORT as string, undefined);

export const sqlConfig: config = {
  server: process.env.DB_HOST!,
  port: DB_PORT,
  database: DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  requestTimeout: 1000 * 60 * 2,
  pool: { min: 1000, max: 1000 * 10, autostart: true },
  options: { encrypt: true }
};

export const sqlConfigTask: config = {
  server: process.env.DB_HOST!,
  port: DB_PORT,
  database: DB_NAME,
  user: process.env.DB_TASK_USER,
  password: process.env.DB_TASK_PASSWORD,
  requestTimeout: 1000 * 60 * 60 * 24,
  pool: { min: 1000, max: 1000 * 100 },
  options: { encrypt: true }
};

export const sqlConfigAccounts: config = {
  server: process.env.DB_ACCOUNTS_HOST!,
  port: DB_PORT,
  database: process.env.DB_ACCOUNTS_NAME!,
  user: process.env.DB_ACCOUNTS_USER,
  password: process.env.DB_ACCOUNTS_PASSWORD ,
  requestTimeout: 1000 * 120,
  pool: { min: 25, max: 1000 },
  options: { encrypt: true }
};
