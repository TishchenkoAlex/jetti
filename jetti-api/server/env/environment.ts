import { config as dotenv } from 'dotenv';
import { config } from 'mssql';

dotenv();

export const DB_NAME = process.env.DB_NAME!;
export const REDIS_DB_HOST = process.env.REDIS_DB_HOST!;
export const JTW_KEY = process.env.JTW_KEY!;

const DB_PORT = parseInt(process.env.DB_PORT as string, undefined);

export const sqlConfig: config = {
  server: process.env.DB_HOST!,
  port: DB_PORT,
  database: DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  requestTimeout: 1000 * 120,
  pool: { min: 50, max: 10000 },
  options: { encrypt: false }
};

export const sqlConfigTask: config = {
  server: process.env.DB_HOST!,
  port: DB_PORT,
  database: DB_NAME,
  user: process.env.DB_TASK_USER,
  password: process.env.DB_TASK_PASSWORD,
  requestTimeout: 1000 * 1200000,
  pool: { min: 100, max: 1000000 },
  options: { encrypt: false }
};


export const sqlConfigAccounts: config = {
  server: process.env.DB_ACCOUNTS_HOST!,
  port: DB_PORT,
  database: process.env.DB_ACCOUNTS_NAME!,
  user: process.env.DB_ACCOUNTS_USER,
  password: process.env.DB_ACCOUNTS_PASSWORD ,
  requestTimeout: 1000 * 120,
  pool: { min: 25, max: 10000 },
  options: { encrypt: false }
};
