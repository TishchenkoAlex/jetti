import * as moment from 'moment';
import { RefValue } from './models/common-types';
import { configSchema } from './models/config';
import { DocumentBase, Ref } from './models/document';
import { createDocument, IFlatDocument, INoSqlDocument } from './models/documents.factory';
import { createDocumentServer, DocumentBaseServer } from './models/documents.factory.server';
import { DocTypes } from './models/documents.types';
import { RegisterAccumulationTypes } from './models/Registers/Accumulation/factory';
import { RegisterAccumulation } from './models/Registers/Accumulation/RegisterAccumulation';
import { RegistersInfo } from './models/Registers/Info/factory';
import { RegisterInfo } from './models/Registers/Info/RegisterInfo';
import { adminModeForPost, postDocument, unpostDocument, updateDocument, setPostedSate } from './routes/utils/post';
import { MSSQL } from './mssql';
import { v1 } from 'uuid';

export interface BatchRow { SKU: Ref; Storehouse: Ref; Qty: number; Cost: number; batch: Ref; rate: number; }

export interface JTL {
  account: {
    balance: (account: Ref, date: Date, company: Ref, tx: MSSQL) => Promise<number | null>,
    debit: (account: Ref, date: Date, company: Ref, tx: MSSQL) => Promise<number | null>,
    kredit: (account: Ref, date: Date, company: Ref, tx: MSSQL) => Promise<number | null>,
    byCode: (code: string, tx: MSSQL) => Promise<string | null>
  };
  register: {
    movementsByDoc: <T extends RegisterAccumulation>(type: RegisterAccumulationTypes, doc: Ref, tx: MSSQL) => Promise<T[]>,
    balance: (type: RegisterAccumulationTypes, date: Date, resource: string[],
      analytics: { [key: string]: Ref }, tx: MSSQL) => Promise<{ [x: string]: number } | null>,
  };
  doc: {
    byCode: (type: DocTypes, code: string, tx: MSSQL) => Promise<string | null>;
    byId: (id: Ref, tx: MSSQL) => Promise<IFlatDocument | null>;
    byIdT: <T extends DocumentBase>(id: Ref, tx: MSSQL) => Promise<T | null>;
    formControlRef: (id: Ref, tx: MSSQL) => Promise<RefValue | null>;
    postById: (id: Ref, tx: MSSQL) => Promise<DocumentBaseServer>;
    unPostById: (id: Ref, tx: MSSQL) => Promise<DocumentBaseServer>;
    noSqlDocument: (flatDoc: IFlatDocument) => INoSqlDocument | null;
    flatDocument: (noSqldoc: INoSqlDocument) => IFlatDocument | null;
    docPrefix: (type: DocTypes, tx: MSSQL) => Promise<string>
  };
  info: {
    sliceLast: <T extends RegistersInfo>(type: string, date: Date, company: Ref,
      analytics: { [key: string]: any }, tx: MSSQL) => Promise<T | null>,
    exchangeRate: (date: Date, company: Ref, currency: Ref, tx: MSSQL) => Promise<number>
  };
  util: {
    postMode: (mode: boolean, tx: MSSQL) => Promise<boolean>,
    closeMonth: (company: Ref, date: Date, tx: MSSQL) => Promise<void>,
    closeMonthErrors: (company: Ref, date: Date, tx: MSSQL) => Promise<{ Storehouse: Ref; SKU: Ref; Cost: number }[] | null>
    GUID: () => Promise<string>
  };
}

export const lib: JTL = {
  account: {
    balance,
    debit,
    kredit,
    byCode: accountByCode
  },
  register: {
    balance: registerBalance,
    movementsByDoc
  },
  doc: {
    byCode: byCode,
    byId: byId,
    byIdT: byIdT,
    formControlRef,
    postById,
    unPostById,
    noSqlDocument,
    flatDocument,
    docPrefix
  },
  info: {
    sliceLast,
    exchangeRate
  },
  util: {
    postMode: adminModeForPost,
    closeMonth: closeMonth,
    GUID,
    closeMonthErrors,

  }
};

async function GUID(): Promise<string> {
  return v1();
}

async function accountByCode(code: string, tx: MSSQL): Promise<string | null> {
  const result = await tx.oneOrNone<any>(`
    SELECT id result FROM [Catalog.Account.v]  WITH (NOEXPAND) WHERE code = @p1`, [code]);
  return result ? result.result as string : null;
}

async function byCode(type: string, code: string, tx: MSSQL): Promise<string | null> {
  const result = await tx.oneOrNone<any>(`SELECT id result FROM [${type}.v]  WITH (NOEXPAND) WHERE code = @p1`, [code]);
  return result ? result.result as string : null;
}

async function byId(id: string, tx: MSSQL): Promise<IFlatDocument | null> {
  if (!id) return null;
  const result = await tx.oneOrNone<INoSqlDocument | null>(`
  SELECT * FROM "Documents" WHERE id = @p1`, [id]);
  if (result) return flatDocument(result); else return null;
}

async function byIdT<T extends DocumentBase>(id: string, tx: MSSQL): Promise<T | null> {
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

async function docPrefix(type: DocTypes, tx: MSSQL): Promise<string> {
  const metadata = configSchema.get(type);
  if (metadata && metadata.prefix) {
    const prefix = metadata.prefix;
    const queryText = `SELECT '${prefix}' + FORMAT((NEXT VALUE FOR "Sq.${type}"), '0000000000') result `;
    const result = await tx.oneOrNone<{ result: string }>(queryText);
    return result ? result.result : '';
  }
  return '';
}

async function formControlRef(id: Ref, tx: MSSQL): Promise<RefValue | null> {
  const result = await tx.oneOrNone<RefValue>(`
    SELECT "id", "code", "description" as "value", "type" FROM "Documents" WHERE id = @p1`, [id]);
  return result;
}

async function debit(account: Ref, date = new Date(), company: Ref, tx: MSSQL): Promise<number> {
  const result = await tx.oneOrNone<{ result: number }>(`
    SELECT SUM(sum) result FROM "Register.Account"
    WHERE dt = @p1 AND datetime <= @p2 AND company = @p3
  `, [account, date, company]);
  return result ? result.result : 0;
}

async function kredit(account: Ref, date = new Date(), company: Ref, tx: MSSQL): Promise<number> {
  const result = await tx.oneOrNone<{ result: number }>(`
    SELECT SUM(sum) result FROM "Register.Account"
    WHERE kt = @p1 AND datetime <= @p2 AND company = @p3
  `, [account, date, company]);
  return result ? result.result : 0;
}

async function balance(account: Ref, date = new Date(), company: Ref, tx: MSSQL): Promise<number> {
  const result = await tx.oneOrNone<{ result: number }>(`
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
  resource: string[], analytics: { [key: string]: Ref }, tx: MSSQL): Promise<{ [x: string]: number }> {

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

  const result = await tx.oneOrNone<any>(queryText, [date]);
  return (result ? result : {});
}

async function exchangeRate(date = new Date(), company: Ref, currency: Ref, tx: MSSQL): Promise<number> {

  const queryText = `
    SELECT TOP 1 CAST([Rate] AS FLOAT) / CASE WHEN [Mutiplicity] > 0 THEN [Mutiplicity] ELSE 1 END result
    FROM [Register.Info.ExchangeRates]
    WHERE (1=1)
      AND date <= @p1
      AND company = @p2
      AND [currency] = @p3
    ORDER BY date DESC`;
  const result = await tx.oneOrNone<{ result: number }>(queryText, [date, company, currency]);
  return result ? result.result : 1;
}

async function sliceLast<T extends RegisterInfo>(type: string, date = new Date(), company: Ref,
  analytics: { [key: string]: any }, tx: MSSQL) {

  const addWhere = (key: string) => `AND "${key}" = '${analytics[key]}' \n`;
  let where = ''; for (const el of Object.keys(analytics)) { where += addWhere(el); }

  const queryText = `
    SELECT TOP 1 * FROM [Register.Info.${type}]
    WHERE (1=1)
      AND date <= @p1
      AND company = @p2
      ${where}
    ORDER BY date DESC`;
  const result = await tx.oneOrNone<T>(queryText, [date, company]);
  return result;
}

export async function postById(id: Ref, tx: MSSQL) {
  try {
    await lib.util.postMode(true, tx);
    const serverDoc = await setPostedSate(id, tx);
    await unpostDocument(serverDoc, tx);
    await postDocument(serverDoc, tx);
    return serverDoc;
  } catch (err) { throw new Error(`Error on post by document by id = '${id}', ${err}`); }
  finally { await lib.util.postMode(false, tx); }
}

export async function unPostById(id: Ref, tx: MSSQL) {
  try {
    await lib.util.postMode(true, tx);
    const doc = (await lib.doc.byId(id, tx))!;
    const serverDoc = await createDocumentServer(doc.type as DocTypes, doc, tx);
    if (!doc.posted) return serverDoc;
    serverDoc.posted = false;
    await unpostDocument(serverDoc, tx);
    await updateDocument(serverDoc, tx);
    return serverDoc;
  } catch (err) { throw err; }
  finally { await lib.util.postMode(false, tx); }
}

export async function movementsByDoc<T extends RegisterAccumulation>(type: RegisterAccumulationTypes, doc: Ref, tx: MSSQL) {
  const queryText = `
  SELECT * FROM [Accumulation] WHERE type = @p1 AND document = @p2`;
  return await tx.manyOrNone<T>(queryText, [type, doc]);
}

async function closeMonth(company: Ref, date: Date, tx: MSSQL): Promise<void> {
  // const sdb = new MSSQL({ email: '', isAdmin: true, env: {}, description: '', roles: []}, TASKS_POOL);
  await tx.none(`
    EXEC [Invetory.Close.Month-MEM] @company = '${company}', @date = '${date.toJSON()}'`);
}

async function closeMonthErrors(company: Ref, date: Date, tx: MSSQL) {
  const result = await tx.manyOrNone<{ Storehouse: Ref, SKU: Ref, Cost: number }>(`
    SELECT q.*, JSON_VALUE(d.doc, N'$."Department"') Department FROM (
      SELECT Storehouse, SKU, SUM([Cost]) [Cost]
      FROM [dbo].[Register.Accumulation.Inventory] r
      WHERE date <= EOMONTH(@p1) AND company = @p2
      GROUP BY Storehouse, SKU
      HAVING SUM([Qty]) = 0 AND SUM([Cost]) <> 0) q
    LEFT JOIN Documents d ON d.id = q.Storehouse`, [date, company]);
  return result;
}

global['lib'] = lib;
global['DOC'] = lib.doc;
global['byCode'] = lib.doc.byCode;
global['moment'] = moment;
