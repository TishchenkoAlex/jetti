import * as sql from 'mssql';
import { sqlConfig, sqlConfigTask } from './env/environment';

export const TASKS_POOL = new sql.ConnectionPool({...sqlConfigTask, requestTimeout: 1000 * 60 * 20});
TASKS_POOL.connect()
  .then(() => console.log('connected', sqlConfig.database))
  .catch(err => console.log('connection error', err));

TASKS_POOL.on('error', (err: sql.ConnectionError) => console.log(err));
