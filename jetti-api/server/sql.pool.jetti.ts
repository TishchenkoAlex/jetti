import { sqlConfig } from './env/environment';
import { SqlPool } from './mssql';

export const JETTI_POOL = new SqlPool(sqlConfig);

