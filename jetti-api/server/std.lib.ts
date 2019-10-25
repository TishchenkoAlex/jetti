import * as moment from 'moment';
import { RefValue } from './models/api';
import { configSchema } from './models/config';
import { DocumentBase, Ref } from './models/document';
import { createDocument } from './models/documents.factory';
import { createDocumentServer } from './models/documents.factory.server';
import { DocTypes } from './models/documents.types';
import { RegisterAccumulationTypes } from './models/Registers/Accumulation/factory';
import { RegisterAccumulation } from './models/Registers/Accumulation/RegisterAccumulation';
import { DocumentBaseServer, IFlatDocument, INoSqlDocument } from './models/ServerDocument';
import { MSSQL, sdb } from './mssql';
import { InsertRegisterstoDB } from './routes/utils/execute-script';

export interface BatchRow {
  SKU: Ref; Storehouse: Ref; Qty: number; batch: Ref; Cost: number;
  res1: number; res2: number; res3: number; res4: number; res5: number;
}

export interface JTL {
  db: MSSQL;
  account: {
    balance: (account: Ref, date: Date, company: Ref) => Promise<number | null>,
    debit: (account: Ref, date: Date, company: Ref) => Promise<number | null>,
    kredit: (account: Ref, date: Date, company: Ref) => Promise<number | null>,
    byCode: (code: string, tx?: MSSQL) => Promise<string | null>
  };
  register: {
    movementsByDoc: <T extends RegisterAccumulation>(type: RegisterAccumulationTypes, doc: Ref, tx?: MSSQL) => Promise<T[]>,
    balance: (type: RegisterAccumulationTypes, date: Date, resource: string[],
      analytics: { [key: string]: Ref }, tx?: MSSQL) => Promise<{ [x: string]: number } | null>,
    avgCost: (date: Date, analytics: { [key: string]: Ref }, tx?: MSSQL) => Promise<number | null>,
    inventoryBalance: (date: Date, analytics: { [key: string]: Ref }, tx?: MSSQL) => Promise<{ Cost: number, Qty: number } | null>,
  };
  doc: {
    byCode: (type: DocTypes, code: string, tx?: MSSQL) => Promise<string | null>;
    byId: (id: Ref, tx?: MSSQL) => Promise<IFlatDocument | null>;
    byIdT: <T extends DocumentBase>(id: string, tx?: MSSQL) => Promise<T | null>;
    formControlRef: (id: string, tx?: MSSQL) => Promise<RefValue | null>;
    postById: (id: string, posted: boolean, tx?: MSSQL) => Promise<void>;
    repostById: (id: Ref, tx?: MSSQL) => Promise<void>;
    noSqlDocument: (flatDoc: IFlatDocument) => INoSqlDocument | null;
    flatDocument: (noSqldoc: INoSqlDocument) => IFlatDocument | null;
    docPrefix: (type: DocTypes, tx?: MSSQL) => Promise<string>
  };
  info: {
    sliceLast: (type: string, date: Date, company: Ref, resource: string,
      analytics: { [key: string]: any }, tx?: MSSQL) => Promise<any>,
    sliceLastJSON: (type: string, date: Date, company: Ref,
      analytics: { [key: string]: any }, tx?: MSSQL) => Promise<any>,
    exchangeRate: (date: Date, company: Ref, currency: Ref, tx?: MSSQL) => Promise<number>
  };
  inventory: {
    batchRows: (date: Date, company: Ref, Storehouse: Ref, SKU: Ref, Qty: number,
      Inventory: any[], tx?: MSSQL) => Promise<any[]>,
    batchReturn(retDoc: string, rows: BatchRow[], tx?: MSSQL)
  };
}

export const lib: JTL = {
  db: sdb,
  account: {
    balance,
    debit,
    kredit,
    byCode: accountByCode
  },
  register: {
    balance: registerBalance,
    inventoryBalance,
    avgCost,
    movementsByDoc,
  },
  doc: {
    byCode: byCode,
    byId: byId,
    byIdT: byIdT,
    formControlRef,
    postById,
    repostById,
    noSqlDocument,
    flatDocument,
    docPrefix
  },
  info: {
    sliceLast,
    sliceLastJSON,
    exchangeRate
  },
  inventory: {
    batchRows,
    batchReturn
  }
};

async function accountByCode(code: string, tx = sdb): Promise<string | null> {
  const result = await tx.oneOrNone<any>(`
    SELECT id result FROM "Documents" WHERE type = 'Catalog.Account' AND code = @p1`, [code]);
  return result ? result.result as string : null;
}

async function byCode(type: string, code: string, tx = sdb): Promise<string | null> {
  const result = await tx.oneOrNone<any>(`SELECT id result FROM "Documents" WHERE type = @p1 AND code = @p2`, [type, code]);
  return result ? result.result as string : null;
}

async function byId(id: string, tx = sdb): Promise<IFlatDocument | null> {
  if (!id) return null;
  const result = await tx.oneOrNone<INoSqlDocument | null>(`
  SELECT * FROM "Documents" WHERE id = '${id}'`);
  if (result) return flatDocument(result); else return null;
}

async function byIdT<T extends DocumentBase>(id: string, tx = sdb): Promise<T | null> {
  const result = await byId(id, tx);
  if (result) return createDocument<T>(result.type, result); else return null;
}

function noSqlDocument(flatDoc: INoSqlDocument | DocumentBaseServer): INoSqlDocument | null {
  if (!flatDoc) throw new Error(`lib.noSqlDocument: source is null!`);
  const { id, date, type, code, description, company, user, posted, deleted, isfolder, parent, info, timestamp, ...doc } = flatDoc;
  return <INoSqlDocument>
    { id, date, type, code, description, company, user, posted, deleted, isfolder, parent, info, timestamp, doc };
}

function flatDocument(noSqldoc: INoSqlDocument): IFlatDocument {
  if (!noSqldoc) throw new Error(`lib.flatDocument: source is null!`);
  const { doc, ...header } = noSqldoc;
  const flatDoc = { ...header, ...doc };
  return flatDoc;
}

async function docPrefix(type: DocTypes, tx: MSSQL = sdb): Promise<string> {
  const metadata = configSchema.get(type);
  if (metadata && metadata.prefix) {
    const prefix = metadata.prefix;
    const queryText = `SELECT '${prefix}' + FORMAT((NEXT VALUE FOR "Sq.${type}"), '0000000000') result `;
    const result = await tx.oneOrNone<{ result: string }>(queryText);
    return result ? result.result : '';
  }
  return '';
}

async function formControlRef(id: string, tx: MSSQL = sdb): Promise<RefValue | null> {
  const result = await tx.oneOrNone<RefValue>(`
    SELECT "id", "code", "description" as "value", "type" FROM "Documents" WHERE id = '${id}'`);
  return result;
}

async function debit(account: Ref, date = new Date(), company: Ref): Promise<number> {
  const result = await sdb.oneOrNone<{ result: number }>(`
    SELECT SUM(sum) result FROM "Register.Account"
    WHERE dt = @p1 AND datetime <= @p2 AND company = @p3
  `, [account, date, company]);
  return result ? result.result : 0;
}

async function kredit(account: Ref, date = new Date(), company: Ref): Promise<number> {
  const result = await sdb.oneOrNone<{ result: number }>(`
    SELECT SUM(sum) result FROM "Register.Account"
    WHERE kt = @p1 AND datetime <= @p2 AND company = @p3
  `, [account, date, company]);
  return result ? result.result : 0;
}

async function balance(account: Ref, date = new Date(), company: Ref): Promise<number> {
  const result = await sdb.oneOrNone<{ result: number }>(`
  SELECT (SUM(u.dt) - SUM(u.kt)) result FROM (
      SELECT SUM(sum) dt, 0 kt
      FROM "Register.Account"
      WHERE dt = @p1 AND datetime <= @p2 AND company = @p3

      UNION ALL

      SELECT 0 dt, SUM(sum) kt
      FROM "Register.Account"
      WHERE kt = @p1 AND datetime <= @p2 AND company = @p3
  ) u`, [account, date, company]);
  return result ? result.result : 0;
}

async function registerBalance(type: RegisterAccumulationTypes, date = new Date(),
  resource: string[], analytics: { [key: string]: Ref }, tx = sdb): Promise<{ [x: string]: number }> {

  const addFields = (key) => `SUM("${key}") "${key}",\n`;
  let fields = ''; for (const el of resource) { fields += addFields(el); } fields = fields.slice(0, -2);

  const addWhere = (key) => `AND "${key}" = '${analytics[key]}'\n`;
  let where = ''; for (const el of resource) { where += addWhere(el); } where = where.slice(0, -2);

  const queryText = `
  SELECT ${fields}
  FROM "${type}"
  WHERE (1=1)
    AND date <= @p1
    ${where}
  `;

  const result = await sdb.oneOrNone<any>(queryText, [date]);
  return (result ? result : {});
}

async function avgCost(date: Date, analytics: { [key: string]: Ref }, tx = sdb): Promise<number | null> {
  const queryText = `
  SELECT
    SUM("Cost.In") / ISNULL(SUM("Qty.In"), 1) result
  FROM "Register.Accumulation.Inventory"
  WHERE (1=1)
    AND kind = 1
    AND date <= @p1
    AND company = @p2
    AND "SKU" = @p3
    AND "Storehouse" = @p4`;
  const result = await tx.oneOrNone<{ result: number }>(queryText, [date, analytics.company, analytics.SKU, analytics.Storehouse]);
  return result ? result.result : null;
}

async function inventoryBalance(date: Date, analytics: { [key: string]: Ref }, tx = sdb): Promise<{ Cost: number, Qty: number } | null> {
  const queryText = `
  SELECT
    SUM("Cost") "Cost", SUM("Qty") "Qty"
    FROM "Register.Accumulation.Inventory"
    WHERE (1=1)
      AND date <= @p1
      AND company = @p2
      AND "SKU" = @p3
      AND "Storehouse" = @p4`;
  const result = await tx.oneOrNone<{ Cost: number, Qty: number, }>
    (queryText, [date, analytics.company, analytics.SKU, analytics.Storehouse]);
  return result ? { Cost: result.Cost, Qty: result.Qty } : null;
}

async function sliceLast(type: string, date = new Date(), company: Ref,
  resource: string, analytics: { [key: string]: any }, tx = sdb): Promise<number | null> {

  const addWhere = (key: string) => `AND CAST(JSON_VALUE(data, N'$."${key}"') AS UNIQUEIDENTIFIER) = '${analytics[key]}' \n`;
  let where = ''; for (const el of Object.keys(analytics)) where += addWhere(el);

  const queryText = `
    SELECT TOP 1 JSON_VALUE(data, N'$."${resource}"') result FROM "Register.Info"
    WHERE (1=1)
      AND date <= @p1
      AND type = 'Register.Info.${type}'
      AND company = '${company}'
      ${where}
    ORDER BY date DESC`;
  const result = await tx.oneOrNone<{ result: any }>(queryText, [date]);
  return result ? result.result : null;
}

async function exchangeRate(date = new Date(), company: Ref, currency: Ref, tx = sdb): Promise<number> {

  const queryText = `
    SELECT TOP 1 CAST(JSON_VALUE(data, N'$."Rate"') AS money) /
      CASE
        WHEN CAST(JSON_VALUE(data, N'$."Mutiplicity"') AS money) > 0 THEN
          JSON_VALUE(data, N'$."Mutiplicity"')
        ELSE
          1
      END result
    FROM "Register.Info"
    WHERE (1=1)
      AND date <= @p1
      AND type = 'Register.Info.ExchangeRates'
      AND company = '${company}'
      AND CAST(JSON_VALUE(data, N'$."currency"') AS UNIQUEIDENTIFIER) = '${currency}'
    ORDER BY date DESC`;
  const result = await tx.oneOrNone<{ result: number }>(queryText, [date]);
  return result ? result.result : 1;
}

async function sliceLastJSON(type: string, date = new Date(), company: Ref,
  analytics: { [key: string]: any }, tx = sdb): Promise<number | null> {

  const addWhere = (key) => `AND CAST(JSON_VALUE(data, N'$."${key}"') AS UNIQUEIDENTIFIER) = '${analytics[key]}' \n`;
  let where = ''; for (const el of Object.keys(analytics)) { where += addWhere(el); }

  const queryText = `
    SELECT TOP 1 JSON_QUERY(data) result FROM "Register.Info"
    WHERE (1=1)
      AND date <= @p1
      AND type = 'Register.Info.${type}'
      AND company = '${company}'
      ${where}
    ORDER BY date DESC`;
  const result = await tx.oneOrNone<{ result: any }>(queryText, [date]);
  return result ? result.result : null;
}

export async function postById(id: string, posted: boolean, tx: MSSQL = sdb): Promise<void> {
  return tx.tx<any>(async subtx => {
    const doc = (await lib.doc.byId(id, subtx))!;
    if (doc.deleted) return; // throw new Error('cant POST deleted document');
    const serverDoc = await createDocumentServer<DocumentBaseServer>(doc.type as DocTypes, doc!, tx);
    serverDoc.posted = posted;

    const deleted = await subtx.manyOrNone(`
      SELECT * FROM "Accumulation" WHERE document = '${id}';
      DELETE FROM "Register.Account" WHERE document = '${id}';
      DELETE FROM "Register.Info" WHERE document = '${id}';
      DELETE FROM "Accumulation" WHERE document = '${id}';
      UPDATE "Documents" SET posted = @p1, deleted = 0, description = @p2 WHERE id = '${id}' AND posted <> @p1`,
      [serverDoc.posted, serverDoc.description]);
    serverDoc['deletedRegisterAccumulation'] = () => deleted;

    if (serverDoc.isDoc && serverDoc.onPost) {
      const Registers = await serverDoc.onPost(subtx);
      if (posted && !doc.deleted) await InsertRegisterstoDB(serverDoc, Registers, subtx);
    }
  });
}

export async function repostById(id: Ref, tx: MSSQL = sdb): Promise<void> {
  return tx.tx<any>(async subtx => {

    const doc = (await lib.doc.byId(id, subtx))!;

    if (doc) {
      if (doc.deleted) return;

      const serverDoc = await createDocumentServer<DocumentBaseServer>(doc.type, doc, tx);

      const deleted = await subtx.manyOrNone(`
        SELECT * FROM "Accumulation" WHERE document = '${id}';
        DELETE FROM "Register.Account" WHERE document = '${id}';
        DELETE FROM "Register.Info" WHERE document = '${id}';
        DELETE FROM "Accumulation" WHERE document = '${id}';
        UPDATE "Documents" SET posted = 1, deleted = 0, description = @p1 WHERE id = '${id}' AND posted = 0;`,
        [serverDoc.description]);
      serverDoc['deletedRegisterAccumulation'] = () => deleted;

      if (serverDoc.isDoc && serverDoc.onPost) {
        const Registers = await serverDoc.onPost(subtx);
        await InsertRegisterstoDB(serverDoc, Registers, subtx);
      }
    }
  });
}

export async function movementsByDoc<T extends RegisterAccumulation>(type: RegisterAccumulationTypes, doc: Ref, tx: MSSQL = sdb) {
  const queryText = `
  SELECT * FROM Accumulation where type = '${type}' AND document = '${doc}'`;
  return await tx.manyOrNone<T>(queryText);
}

export async function batchRows(date: Date, company: Ref, Storehouse: Ref, SKU: Ref, Qty: number, BatchRows: any[], tx: MSSQL = sdb) {

  const ResultBatchRows: any[] = [];

  const queryText = `
    SELECT batch, Qty, Cost, b.date FROM (
      SELECT
        batch,
        SUM("Qty") Qty,
        SUM("Cost.In") / ISNULL(SUM("Qty.In"), 1) Cost
      FROM (
        SELECT
        [batch],
        [Cost.In],
        [Qty],
        [Qty.In]
      FROM [Register.Accumulation.Inventory] r
      WHERE (1=1)
        AND [date] <= @p1
        AND [company] = @p2
        AND [SKU] = @p3
        AND [Storehouse] = @p4

      UNION ALL

      SELECT
        [batch],
        -[Cost][Cost.In],
        -[Qty] [Qty],
        -[Qty] [Qty.In]
      FROM OPENJSON(@p5) WITH (
        [batch] UNIQUEIDENTIFIER,
        [Storehouse] UNIQUEIDENTIFIER,
        [SKU] UNIQUEIDENTIFIER,
        [Qty] MONEY,
        [Cost] MONEY
      )
      WHERE (1=1)
        AND [SKU] = @p3
        AND [Storehouse] = @p4
      ) r
    GROUP BY batch
    HAVING SUM("Qty") > 0 ) s
    LEFT JOIN Documents b ON b.id = s.batch
    ORDER BY b.date, s.batch
  `;
  const queryResult = await tx.manyOrNone<{ batch: string, Qty: number, Cost: number }>
    (queryText, [date, company, SKU, Storehouse, JSON.stringify(BatchRows)]);
  let total = Qty;
  for (const a of queryResult) {
    if (total <= 0) break;
    const q = Math.min(total, a.Qty);
    const rate = q / Qty;
    BatchRows.push({ batch: a.batch, Qty: q, Cost: a.Cost * q, Storehouse, SKU, rate });
    ResultBatchRows.push({ batch: a.batch, Qty: q, Cost: a.Cost * q, Storehouse, SKU, rate });
    total = total - q;
  }
  if (total > 0) {
    BatchRows.push({ batch: null, Qty, Cost: 0, Storehouse, SKU, rate: 1 });
    ResultBatchRows.push({ batch: null, Qty, Cost: 0, Storehouse, SKU, rate: 1 });
  }

  return ResultBatchRows;
}

export async function batchReturn(retDoc: string, rows: BatchRow[], tx: MSSQL = sdb) {
  const rowsKeys = rows.map(r => (r.Storehouse as string) + (r.SKU as string));
  const uniquerowsKeys = rowsKeys.filter((v, i, a) => a.indexOf(v) === i);
  const grouped = uniquerowsKeys.map(r => {
    const filter = rows.filter(f => (f.Storehouse as string) + (f.SKU as string) === r);
    const Qty = filter.reduce((a, b) => a + b.Qty, 0);
    const res1 = filter.reduce((a, b) => a + b.res1, 0);
    const res2 = filter.reduce((a, b) => a + b.res2, 0);
    const res3 = filter.reduce((a, b) => a + b.res3, 0);
    const res4 = filter.reduce((a, b) => a + b.res4, 0);
    const res5 = filter.reduce((a, b) => a + b.res5, 0);
    return <BatchRow>({ SKU: filter[0].SKU, Storehouse: filter[0].Storehouse, Qty, Cost: 0, batch: null, res1, res2, res3 });
  });
  const result: BatchRow[] = [];
  for (const row of grouped) {
    const queryText = `
      SELECT batch, Qty, Cost, b.date FROM (
      SELECT
        batch,
        -SUM("Qty") Qty,
        SUM("Cost.Out") / ISNULL(SUM("Qty.Out"), -1) Cost
      FROM "Register.Accumulation.Inventory" r
      WHERE (1=1)
        AND "document" = @p1
      GROUP BY batch
      HAVING -SUM("Qty") > 0 ) s
      LEFT JOIN Documents b ON b.id = s.batch
      ORDER BY b.date, s.batch`;
    const queryResult = await tx.manyOrNone<{ batch: string, Qty: number, Cost: number }>
      (queryText, [retDoc]);
    let total = row.Qty;
    for (const a of queryResult) {
      if (total <= 0) break;
      const q = Math.min(total, a.Qty);
      const rate = q / row.Qty;
      result.push({
        batch: a.batch, Qty: q, Cost: a.Cost * q, Storehouse: row.Storehouse, SKU: row.SKU,
        res1: row.res1 * rate, res2: row.res2 * rate, res3: row.res3 * rate, res4: row.res3 * rate, res5: row.res3 * rate
      });
      total = total - q;
    }
    if (total > 0) {
      const SKU = await lib.doc.byId(row.SKU as string, tx);
      console.log(`Не достаточно ${total} единиц ${SKU!.description}`);
      // throw new Error(`Не достаточно ${total} единиц ${SKU!.description}`);
    }
  }
  return result;
}

global['lib'] = lib;
global['DOC'] = lib.doc;
global['byCode'] = lib.doc.byCode;
global['moment'] = moment;
