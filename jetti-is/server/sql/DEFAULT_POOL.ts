import { config as dotenv } from 'dotenv';
dotenv();

import { SQLConnectionConfig } from './interfaces';
import { SQLPool } from './sql-pool';

const sqlConfigDefault: SQLConnectionConfig = {
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
    database: process.env.DB_NAME,
    port: parseInt(process.env.DB_PORT as string, undefined),
    requestTimeout: 2 * 60 * 1000,
    // rowCollectionOnRequestCompletion: true,
  },
  pool: {
    min: 0,
    max: 1000,
    idleTimeoutMillis: 20 * 60 * 1000
  }
};

export const DEFAULT_POOL = new SQLPool(sqlConfigDefault);
