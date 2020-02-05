import * as sql from 'mssql';
import { sqlConfigTask } from './env/environment';
import { startSheduledTasks } from './models/Tasks/sheduled';

export const TASKS_POOL = new sql.ConnectionPool(sqlConfigTask);
TASKS_POOL.on('error', (err: sql.ConnectionError) => console.error(err.message));
TASKS_POOL.connect()
  .then(() => {
    console.log('connected', sqlConfigTask.database);
    // startSheduledTasks().catch(err => console.error(err));
  })
  .catch(err => console.error('connection error', err));

