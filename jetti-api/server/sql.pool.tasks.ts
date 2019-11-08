import * as sql from 'mssql';
import { sqlConfigTask } from './env/environment';
import { startSheduledTasks } from './models/Tasks/sheduled';

export const TASKS_POOL = new sql.ConnectionPool({...sqlConfigTask});
TASKS_POOL.connect()
  .then(() => {
    console.log('connected', sqlConfigTask.database);
    startSheduledTasks().catch(err => console.log(err));
  })
  .catch(err => console.log('connection error', err));

TASKS_POOL.on('error', (err: sql.ConnectionError) => console.log(err));
