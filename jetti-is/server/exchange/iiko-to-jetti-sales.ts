import { SQLClient } from '../sql/sql-client';
import { v1 as uuidv1 } from 'uuid';
import { ColumnValue, Request } from 'tedious';

import { SQLPool } from '../sql/sql-pool';
import { ISyncParams, GetSqlConfig, GetExchangeCatalogID } from './iiko-to-jetti-connection';
import { GetCatalog, InsertCatalog, UpdateCatalog } from './iiko-to-jetti-utils';


export async function ImportSalesToJetti(syncParams: ISyncParams) {
/*    
    if (syncParams.baseType=='sql') {
      ImportPersonSQLToJetti(syncParams).catch(() => { });
    } */
}
  