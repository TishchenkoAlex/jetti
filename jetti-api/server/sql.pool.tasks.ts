import { sqlConfigTask } from './env/environment';
import { SqlPool } from './mssql';

export const TASKS_POOL = new SqlPool(sqlConfigTask);
