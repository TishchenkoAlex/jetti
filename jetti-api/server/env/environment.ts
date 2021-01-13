import { config as dotenv } from 'dotenv';
import { ConnectionConfig } from 'tedious';

dotenv();
export type ConnectionConfigAndPool = ConnectionConfig & { pool: { min: number, max: number, idleTimeoutMillis: number } };

export const DB_NAME = process.env.DB_NAME!;
export const REDIS_DB_HOST = process.env.REDIS_DB_HOST!;
export const REDIS_DB_AUTH = process.env.REDIS_DB_AUTH;
export const JETTI_IS_HOST = process.env.JETTI_IS_HOST || 'http://localhost:3500';
export const JTW_KEY = process.env.JTW_KEY!;
export const bpApiHost = 'https://bp.x100-group.com/JettiProcesses/hs';
export const LOGIC_USECASHREQUESTAPPROVING = process.env.LOGIC_USECASHREQUESTAPPROVING || '0';
export const REGISTER_ACCUMULATION_SOURCE = process.env.REGISTER_ACCUMULATION_SOURCE || '';
export const TRANSFORMED_REGISTER_MOVEMENTS_TABLE = '[dbo].[Register.Accumulation.Balance.RC]';

const DB_PORT = parseInt(process.env.DB_PORT as string, undefined);

export const portal1CApiConfig = {
  baseURL: process.env.PORTAL1C_API_HOST,
  auth: {
    username: process.env.PORTAL1C_API_USER,
    password: process.env.PORTAL1C_API_PASSWORD
  }
};

export const sqlConfig: ConnectionConfigAndPool = {
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
    requestTimeout: 5 * 60 * 1000,
    rowCollectionOnRequestCompletion: true,
  },
  pool: {
    min: 0,
    max: 1000,
    idleTimeoutMillis: 20 * 60 * 1000
  }
};

export const sqlConfigMeta: ConnectionConfigAndPool = {
  server: process.env.DB_HOST!,
  authentication: {
    type: 'default',
    options: {
      userName: process.env.DB_USER_META,
      password: process.env.DB_PASSWORD_META
    }
  },
  options: {
    encrypt: false,
    database: DB_NAME,
    port: DB_PORT,
    requestTimeout: 5 * 60 * 1000,
    rowCollectionOnRequestCompletion: true,
  },
  pool: {
    min: 0,
    max: 1000,
    idleTimeoutMillis: 20 * 60 * 1000
  }
};

export const sqlConfigX100DATA: ConnectionConfigAndPool = {
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
    database: 'x100-DATA',
    port: DB_PORT,
    requestTimeout: 5 * 60 * 1000,
    rowCollectionOnRequestCompletion: true,
  },
  pool: {
    min: 0,
    max: 1000,
    idleTimeoutMillis: 20 * 60 * 1000
  }
};

export const sqlConfigTask: ConnectionConfigAndPool = {
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
    requestTimeout: 3 * 60 * 60 * 1000,
    rowCollectionOnRequestCompletion: true,
  },
  pool: {
    min: 0,
    max: 1000,
    idleTimeoutMillis: 20 * 60 * 1000
  }
};

export const sqlConfigExchange: ConnectionConfigAndPool = {
  server: '34.91.140.192',
  authentication: {
    type: 'default',
    options: {
      userName: process.env.DB_USER,
      password: process.env.DB_PASSWORD
    }
  },
  options: {
    encrypt: false,
    database: 'Exchange',
    port: DB_PORT,
    requestTimeout: 20 * 60 * 1000,
    rowCollectionOnRequestCompletion: true,
  },
  pool: {
    min: 0,
    max: 1000,
    idleTimeoutMillis: 20 * 60 * 1000
  }
};

