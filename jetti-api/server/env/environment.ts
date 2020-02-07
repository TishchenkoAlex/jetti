import { config as dotenv } from 'dotenv';
import { ConnectionConfig } from 'tedious';

dotenv();
export type ConnectionConfigAndPool = ConnectionConfig & { pool: { min: number, max: number } };

export const DB_NAME = process.env.DB_NAME!;
export const REDIS_DB_HOST = process.env.REDIS_DB_HOST!;
export const REDIS_DB_AUTH = process.env.REDIS_DB_AUTH;
export const JTW_KEY = process.env.JTW_KEY!;
export const bpApiHost = 'https://bp.x100-group.com/JettiProcesses/hs';

const DB_PORT = parseInt(process.env.DB_PORT as string, undefined);

export const sqlConfig: ConnectionConfig & { pool: { min: number, max: number } } = {
  server: process.env.DB_HOST!,
  authentication: {
    type: 'default',
    options: {
      userName: process.env.DB_USER,
      password: process.env.DB_PASSWORD
    }
  },
  options: {
    encrypt: false,
    database: DB_NAME,
    port: DB_PORT,
    requestTimeout: 1000 * 60 * 2,
    rowCollectionOnRequestCompletion: true,
  },
  pool: {
    min: 10,
    max: 1000
  }
};

export const sqlConfigTask: ConnectionConfig & { pool: { min: number, max: number } } = {
  server: process.env.DB_HOST!,
  authentication: {
    type: 'default',
    options: {
      userName: process.env.DB_TASK_USER,
      password: process.env.DB_TASK_PASSWORD
    }
  },
  options: {
    encrypt: false,
    database: DB_NAME,
    port: DB_PORT,
    requestTimeout: 1000 * 60 * 10,
    rowCollectionOnRequestCompletion: true,
  },
  pool: {
    min: 20,
    max: 1000
  }
};
