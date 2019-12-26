import * as sql from 'mssql';
import { sqlConfig } from './env/environment';

export const JETTI_POOL = new sql.ConnectionPool(sqlConfig);
JETTI_POOL.connect()
  .then(() => console.log('connected', sqlConfig.database))
  .catch(err => console.log('connection error', err));


JETTI_POOL.on('error', (err: sql.ConnectionError) => console.error(err));
