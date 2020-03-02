import { sqlConfigX100DATA } from './env/environment';
import { SqlPool } from './mssql';

export const x100DATA_POOL = new SqlPool(sqlConfigX100DATA);
