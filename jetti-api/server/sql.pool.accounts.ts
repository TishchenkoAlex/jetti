import * as sql from 'mssql';
import { sqlConfigAccounts } from './env/environment';

export const ACCOUNTS_POOL = new sql.ConnectionPool(sqlConfigAccounts);
ACCOUNTS_POOL.connect()
  .then(() => console.log('connected', sqlConfigAccounts.database))
  .catch(err => console.log('connection error', err));

ACCOUNTS_POOL.on('error', (err: sql.ConnectionError) => console.log(err));
