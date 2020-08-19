import { sqlConfigMeta } from './env/environment';
import { SqlPool } from './mssql';

export const JETTI_POOL_META = new SqlPool(sqlConfigMeta);

