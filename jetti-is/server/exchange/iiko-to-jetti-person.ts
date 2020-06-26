import { SQLClient } from '../sql/sql-client';
import { v1 as uuidv1 } from 'uuid';
import { ColumnValue, Request } from 'tedious';

import { SQLPool } from '../sql/sql-pool';
import { ISyncParams, GetSqlConfig, GetExchangeCatalogID, saveLogProtocol } from './iiko-to-jetti-connection';
import { GetCatalog, InsertCatalog, UpdateCatalog } from './iiko-to-jetti-utils';

const syncStage = 'Catalog.Person';
///////////////////////////////////////////////////////////
interface IiikoPerson {
  project: string,
  id: string,
  baseid: string,
  type: string,
  code: string,
  name: string,
  deleted: boolean
}
///////////////////////////////////////////////////////////
const transformPerson = (syncParams: ISyncParams, source: any): IiikoPerson => {
  return {
    project: syncParams.project.id,
    id: source.id,
    baseid: syncParams.source.id,
    type: 'Person',
    code: source.code,
    name: source.name,
    deleted: source.deleted
  }
}  
///////////////////////////////////////////////////////////
const newPerson = (syncParams: ISyncParams, iikoProduct: IiikoPerson): any => {
  return {
    id: uuidv1().toUpperCase(),
    type: 'Catalog.Person',
    code: syncParams.source.code + '-' + iikoProduct.code,
    description: iikoProduct.name,
    posted: !iikoProduct.deleted,
    deleted: !!iikoProduct.deleted,
    doc: {
      Code1: null,
      Code2: null
    },
    parent: null,
    isfolder: false,
    company: syncParams.source.company,
    user: null,
    info: null
  }
}
///////////////////////////////////////////////////////////
const newManager = (syncParams: ISyncParams, iikoProduct: IiikoPerson): any => {
  return {
    id: uuidv1().toUpperCase(),
    type: 'Catalog.Manager',
    code: syncParams.source.code + '-' + iikoProduct.code,
    description: iikoProduct.name,
    posted: !iikoProduct.deleted,
    deleted: !!iikoProduct.deleted,
    doc: {
      FullName: iikoProduct.name
    },
    parent: null,
    isfolder: false,
    company: syncParams.source.company,
    user: null,
    info: null
  }
}
///////////////////////////////////////////////////////////
async function syncPerson (syncParams: ISyncParams, iikoPerson: IiikoPerson, destSQL: SQLClient ): Promise<any> {
  let response: any = await GetCatalog(iikoPerson.project, iikoPerson.id, iikoPerson.baseid, 'Person', destSQL);
  if (!response) {
    if (syncParams.logLevel>1) await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `insert Pperson ${iikoPerson.name}`);
    const NoSqlDocument: any = newPerson(syncParams, iikoPerson);
    const jsonDoc = JSON.stringify(NoSqlDocument);
    response = await InsertCatalog(jsonDoc, NoSqlDocument.id, iikoPerson, destSQL);
  }
  else {
    if (syncParams.forcedUpdate) {
      if (syncParams.logLevel>1) await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `update Pperson ${iikoPerson.name}`);
      response.type = 'Catalog.Person';
      //response.code = syncParams.source.code + '-'+iikoPerson.code;
      response.description = iikoPerson.name;
      response.posted = !iikoPerson.deleted;
      response.deleted = !!iikoPerson.deleted;
      response.isfolder = false;
      response.company = syncParams.source.company;
      response.parent = null;
      response.user = null;
      response.info = null;

      const jsonDoc = JSON.stringify(response);
      response = await UpdateCatalog(jsonDoc, response.id, iikoPerson, destSQL);
    }
  }
  return response;
}
///////////////////////////////////////////////////////////
async function syncManager (syncParams: ISyncParams, iikoPerson: IiikoPerson, destSQL: SQLClient ): Promise<any> {
  let response: any = await GetCatalog(iikoPerson.project, iikoPerson.id, iikoPerson.baseid, 'Manager', destSQL);
  if (response === null) {
    if (syncParams.logLevel>1) await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `insert Manager ${iikoPerson.name}`);
    const NoSqlDocument: any = newManager(syncParams, iikoPerson);
    const jsonDoc = JSON.stringify(NoSqlDocument);
    response = await InsertCatalog(jsonDoc, NoSqlDocument.id, iikoPerson, destSQL);
  }
  else {
    if (syncParams.forcedUpdate) {
      if (syncParams.logLevel>1) await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `update Manager ${iikoPerson.name}`);
      response.type = 'Catalog.Manager';
      //response.code = syncParams.source.code + '-'+iikoPerson.code;
      response.description = iikoPerson.name;
      response.posted = !iikoPerson.deleted;
      response.deleted = !!iikoPerson.deleted;
      response.isfolder = false;
      response.company = syncParams.source.company;
      response.parent = null;
      response.user = null;
      response.info = null;
      //response.doc.FullName = iikoPerson.name;

      const jsonDoc = JSON.stringify(response);
      response = await UpdateCatalog(jsonDoc, response.id, iikoPerson, destSQL);
    }
  }
  return response;
}


///////////////////////////////////////////////////////////
export async function ImportPersonToJetti(syncParams: ISyncParams) {
  await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `Start sync Persons and Managers`);
  if (syncParams.baseType=='sql') {
    await ImportPersonSQLToJetti(syncParams).catch(() => { });
  }
}
///////////////////////////////////////////////////////////
//const dSQLAdmin = new SQLPool(DestSqlConfig);
//const eSQLAdmin = new SQLPool(SourceSqlConfig);
///////////////////////////////////////////////////////////

export async function ImportPersonSQLToJetti(syncParams: ISyncParams) {

    const ssqlcfg = await GetSqlConfig(syncParams.source.id);
    const ssql = new SQLClient(new SQLPool(ssqlcfg));
    const dsql = new SQLClient(new SQLPool(await GetSqlConfig(syncParams.destination)));

    let i = 0;
    let batch: any[] = [];
    await ssql.manyOrNoneStream(`
        SELECT top 5
          cast(spr.id as nvarchar(50)) as id,
          coalesce(spr.deleted,0) as deleted,
          coalesce(cast(spr.[xml] as xml).value('(/r/name/customValue)[1]' ,'nvarchar(255)'),
          cast(spr.[xml] as xml).value('(/r/name)[1]' ,'nvarchar(255)'), null) as name,
          cast(spr.[xml] as xml).value('(/r/code)[1]' ,'nvarchar(255)') as code
        FROM dbo.entity spr
        where spr.type = 'User'
          and cast(spr.[xml] as xml).value('(/r/employee)[1]' ,'bit') = 1
          and cast(spr.[xml] as xml).value('(/r/code)[1]' ,'nvarchar(255)')<>''
          and cast(CONVERT(datetime2(0), cast(spr.[xml] as xml).value('(/r/modified)[1]' ,'nvarchar(255)'), 126) as date)>=@p1
    `, [syncParams.lastSyncDate],
    async (row: ColumnValue[], req: Request) => {
      // читаем содержимое справочника порциями по ssqlcfg.batch.max
      i++;
      const rawDoc: any = {};
      row.forEach(col => rawDoc[col.metadata.colName] = col.value);
      const iikoPerson: IiikoPerson = transformPerson(syncParams, rawDoc);
      batch.push(iikoPerson);

      if (batch.length === ssqlcfg.batch.max) {
        req.pause();
        if (syncParams.logLevel>0) saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `inserting to batch ${i} person`);
        for (const doc of batch) {
          await syncPerson(syncParams, doc, dsql);
          doc.type = 'Manager';
          await syncManager(syncParams, doc, dsql);
        }
        batch = [];
        req.resume();
      }
    },
    async (rowCount: number, more: boolean) => {
        if (rowCount && !more && batch.length > 0) {
          if (syncParams.logLevel>0) saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `inserting tail ${batch.length} person`);
          for (const doc of batch) {
            await syncPerson(syncParams, doc, dsql);
            doc.type = 'Manager';
            await syncManager(syncParams, doc, dsql);
          } 
        }
        await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `Finish sync Persons and Managers`);
    });    
}
