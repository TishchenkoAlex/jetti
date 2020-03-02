import { sqlConfigExchange } from './env/environment';
import { SqlPool } from './mssql';

export const EXCHANGE_POOL = new SqlPool(sqlConfigExchange);
