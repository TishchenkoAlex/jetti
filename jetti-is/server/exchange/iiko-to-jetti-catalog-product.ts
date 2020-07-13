import { SQLClient } from '../sql/sql-client';
import { v1 as uuidv1 } from 'uuid';
import { ColumnValue, Request } from 'tedious';
import { config as dotenv } from 'dotenv';

import { SQLPool } from '../sql/sql-pool';
import { ISyncParams, GetSqlConfig, GetExchangeCatalogID, saveLogProtocol } from './iiko-to-jetti-connection';
import { GetCatalog, InsertCatalog, UpdateCatalog } from './iiko-to-jetti-utils';

const syncStage = 'Catalog.Product';
///////////////////////////////////////////////////////////
interface IiikoProduct {
  project: string;
  id: string;
  baseid: string;
  type: string;
  parent: string;
  mainparent: string;
  code: string;
  name: string;
  deleted: boolean;
  unit: string;
  unitname: string;
  prodtype: string;
}
///////////////////////////////////////////////////////////
const transformProduct = (syncParams: ISyncParams, source: any): IiikoProduct => {
  return {
    project: syncParams.project.id,
    id: source.id,
    baseid: syncParams.source.id,
    type: 'Product',
    parent: source.parent,
    mainparent: source.mainparent,
    code: source.code,
    name: source.name,
    deleted: source.deleted,
    unit: source.unit,
    unitname: source.unitname,
    prodtype: source.prodtype
  };
};
///////////////////////////////////////////////////////////
const newProduct = (syncParams: ISyncParams, iikoProduct: IiikoProduct): any => {
  return {
    id: uuidv1().toUpperCase(),
    type: 'Catalog.Product',
    code: syncParams.source.code + '-' + iikoProduct.code,
    description: iikoProduct.name,
    posted: !iikoProduct.deleted,
    deleted: !!iikoProduct.deleted,
    doc: {
      ProductKind: null,
      Unit: null
    },
    parent: syncParams.source.ProductFolder,
    isfolder: false,
    company: syncParams.source.company,
    user: null,
    info: null
  };
};
///////////////////////////////////////////////////////////
async function syncProduct(syncParams: ISyncParams, iikoProduct: IiikoProduct, destSQL: SQLClient): Promise<any> {
  let response: any = await GetCatalog(iikoProduct.project, iikoProduct.id, iikoProduct.baseid, 'Product', destSQL);
  const ProductKind: any = await destSQL.oneOrNone(`
    SELECT id FROM [dbo].[Catalog.ProductKind.v] WITH (NOEXPAND) where [code]=@p1`, [iikoProduct.prodtype]);
  if (!response) {
    if (syncParams.logLevel > 1) saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `insert Product ${iikoProduct.name} products`);
    const NoSqlDocument: any = newProduct(syncParams, iikoProduct);
    if (ProductKind) NoSqlDocument.doc.ProductKind = ProductKind.id;
    NoSqlDocument.doc.Unit = await GetExchangeCatalogID(iikoProduct.project, iikoProduct.unit, iikoProduct.baseid, 'Unit');
    const jsonDoc = JSON.stringify(NoSqlDocument);
    response = await InsertCatalog(jsonDoc, NoSqlDocument.id, iikoProduct, destSQL);
  } else {
    if (syncParams.forcedUpdate) {
      if (syncParams.logLevel > 1) saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `update Product ${iikoProduct.name} products`);
      response.type = 'Catalog.Product';
      response.code = syncParams.source.code + '-' + iikoProduct.code;
      response.description = iikoProduct.name;
      response.posted = !iikoProduct.deleted;
      response.deleted = !!iikoProduct.deleted;
      response.doc.ProductKind = ProductKind.id;
      response.doc.Unit = await GetExchangeCatalogID(iikoProduct.project, iikoProduct.unit, iikoProduct.baseid, 'Unit');
      response.isfolder = false;
      response.company = syncParams.source.company;
      response.parent = syncParams.source.ProductFolder;
      response.user = null;
      response.info = null;

      const jsonDoc = JSON.stringify(response);
      response = await UpdateCatalog(jsonDoc, response.id, iikoProduct, destSQL);
    }
  }
  return response;
}
///////////////////////////////////////////////////////////
////
///////////////////////////////////////////////////////////
export async function ImportProductToJetti(syncParams: ISyncParams) {
  await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `Start sync Products`);
  if (syncParams.baseType === 'sql') await ImportProductSQLToJetti(syncParams);
}
///////////////////////////////////////////////////////////
export async function ImportProductSQLToJetti(syncParams: ISyncParams) {

  const ssqlcfg = await GetSqlConfig(syncParams.source.id);
  const ssql = new SQLClient(new SQLPool(ssqlcfg));
  const dsql = new SQLClient(new SQLPool(await GetSqlConfig(syncParams.destination)));

  let countRows = 0;
  let batch: any[] = [];
  await ssql.manyOrNoneStream(`
    SELECT
      cast(spr.id as nvarchar(50)) as id,
      coalesce(spr.deleted,0) as deleted,
      coalesce(cast(spr.[xml] as xml).value('(/r/name/customValue)[1]' ,'nvarchar(255)'),
      cast(spr.[xml] as xml).value('(/r/name)[1]' ,'nvarchar(255)'), null) as name,
      cast(spr.[xml] as xml).value('(/r/mainUnit)[1]' ,'nvarchar(255)') as unit,
      coalesce(cast(izm.[xml] as xml).value('(/r/name/customValue)[1]' ,'nvarchar(255)'),
      cast(izm.[xml] as xml).value('(/r/name)[1]' ,'nvarchar(255)'), null) as unitname,
      cast(spr.[xml] as xml).value('(/r/parent)[1]' ,'nvarchar(255)') as parentid,
      cast(spr.[xml] as xml).value('(/r/code)[1]' ,'nvarchar(255)') as code,
      cast(spr.[xml] as xml).value('(/r/type)[1]' ,'nvarchar(255)') as prodtype
    FROM dbo.entity spr
      left join dbo.entity izm on izm.id = cast(spr.[xml] as xml).value('(/r/mainUnit)[1]' , 'nvarchar(255)')
    WHERE (1 = 1)
      AND spr.type = 'Product'
      AND cast(CONVERT(datetime2(0), cast(spr.[xml] as xml).value('(/r/modified)[1]' ,'nvarchar(255)'), 126) as date)>=@p1
      -- and cast(spr.[xml] as xml).value('(/r/parent)[1]' ,'nvarchar(255)') = 'A22A2352-5768-4831-83A4-32F8928CE866'
      -- and cast(spr.[xml] as xml).value('(/r/parent)[1]' ,'nvarchar(255)')='E5DE4E02-1981-42AF-B32D-D94282D699DF'
    `, [syncParams.lastSyncDate],

    async (row: ColumnValue[], req: Request) => {
      // читаем содержимое справочника порциями по ssqlcfg.batch.max
      countRows = countRows + 1;
      const rawDoc: any = {};
      row.forEach(col => rawDoc[col.metadata.colName] = col.value);
      const iikoProduct: IiikoProduct = transformProduct(syncParams, rawDoc);
      batch.push(iikoProduct);

      if (batch.length === ssqlcfg.batch.max) {
        req.pause();
        if (syncParams.logLevel > 0) await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `inserting to batch ${countRows} products`);
        for (const doc of batch) await syncProduct(syncParams, doc, dsql);
        batch = [];
        req.resume();
      }
    },

    async (rowCount: number, more: boolean) => {
      if (rowCount && !more && batch.length > 0) {
        if (syncParams.logLevel > 0)
          await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `inserting to batch ${batch.length} products`);
        for (const doc of batch) await syncProduct(syncParams, doc, dsql);
      }
      await saveLogProtocol(syncParams.syncid, 0, 0, syncStage, `Finish sync Product.`);
    });

}
///////////////////////////////////////////////////////////
