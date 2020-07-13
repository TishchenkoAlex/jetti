import { SQLClient } from '../sql/sql-client';
import { config as dotenv } from 'dotenv';
import { GetExchangeCatalogID, GetExchangeDocumentID } from './iiko-to-jetti-connection';
import { SetExchangeCatalogID, SetExchangeDocumentID } from './iiko-to-jetti-connection';

dotenv();

export type Ref = string | null;

export interface INoSqlDocument {
  id: Ref;
  date: Date;
  type: string;
  code: string;
  description: string;
  company: Ref;
  user: Ref;
  posted: boolean;
  deleted: boolean;
  isfolder: boolean;
  parent: Ref;
  info: string | null;
  timestamp: Date;
  doc: { [x: string]: any };
}

export function nullOrID(d: any): Ref {
  if (!d) return null;
  return d.id;
}

export function DateToString(dt: Date): string {
  if (typeof dt === 'string') dt = new Date(dt);
  let res: string = dt.getFullYear().toString();
  if (dt.getMonth() < 9) res += `0${dt.getMonth() + 1}`;
  else res += `${dt.getMonth() + 1}`;
  if (dt.getDate() < 10) res += `0${dt.getDate()}`;
  else res += `${dt.getDate()}`;
  return res;
}

export async function GetCatalog(
  project: string,
  exchangeCode: string,
  exchangeBase: string,
  exchangeType: string,
  tx: SQLClient): Promise<INoSqlDocument | null> {
  // получить из базы элемент справочника
  const id: Ref = await GetExchangeCatalogID(project, exchangeCode, exchangeBase, exchangeType);
  const a: { [x: string]: any } = {};
  if (!id) return null;
  const response = await tx.oneOrNone<INoSqlDocument | null>(`SELECT * FROM Documents WHERE id = @p1`, [id]);
  return response;
}

export async function InsertCatalog(jsonDoc: string, id: string, source: any, tx: SQLClient) {
  // вставка элемента справочника в базу Jetti
  // ! добавить обработку ошибки и откат
  const response = await tx.oneOrNone<INoSqlDocument | null>(`
      INSERT INTO Documents(
        [id], [type], [date], [code], [description], [posted], [deleted],
        [parent], [isfolder], [company], [user], [info], [doc])
      SELECT
        [id], [type], getdate(), [code], [description], [posted], [deleted],
        [parent], [isfolder], [company], [user], [info], [doc]
      FROM OPENJSON(@p1) WITH (
        [id] UNIQUEIDENTIFIER,
        [date] DATETIME,
        [type] NVARCHAR(100),
        [code] NVARCHAR(36),
        [description] NVARCHAR(150),
        [posted] BIT,
        [deleted] BIT,
        [parent] UNIQUEIDENTIFIER,
        [isfolder] BIT,
        [company] UNIQUEIDENTIFIER,
        [user] UNIQUEIDENTIFIER,
        [info] NVARCHAR(max),
        [doc] NVARCHAR(max) N'$.doc' AS JSON
      );
      SELECT * FROM Documents WHERE id = @p2`, [jsonDoc, id]);
  await SetExchangeCatalogID(source, id);
  return response;
}

export async function UpdateCatalog(jsonDoc: string, id: Ref, source: any, tx: SQLClient) {
  // обновление элемента справочника в базу Jetti
  const response = await tx.oneOrNone<INoSqlDocument | null>(`
    UPDATE Documents
      SET
        type = i.type, parent = i.parent,
        date = i.date, code = i.code, description = i.description,
        posted = i.posted, deleted = i.deleted, isfolder = i.isfolder,
        "user" = i."user", company = i.company, info = i.info, timestamp = GETDATE(),
        doc = i.doc
      FROM (
        SELECT *
        FROM OPENJSON(@p1) WITH (
          [id] UNIQUEIDENTIFIER,
          [date] DATETIME,
          [type] NVARCHAR(100),
          [code] NVARCHAR(36),
          [description] NVARCHAR(150),
          [posted] BIT,
          [deleted] BIT,
          [isfolder] BIT,
          [company] UNIQUEIDENTIFIER,
          [user] UNIQUEIDENTIFIER,
          [info] NVARCHAR(max),
          [parent] UNIQUEIDENTIFIER,
          [doc] NVARCHAR(max) N'$.doc' AS JSON
        )
      ) i
      WHERE Documents.id = i.id;
    SELECT * FROM Documents WHERE id = @p2`, [jsonDoc, id]);
  await SetExchangeCatalogID(source, id);
  return response;
}

export async function GetDocument(project: string, exchangeCode: string, exchangeBase: string, exchangeType: string, tx: SQLClient) {
  // получить из базы документ
  const id: Ref = await GetExchangeDocumentID(project, exchangeCode, exchangeBase, exchangeType);
  if (!id) return null;
  const response = await tx.oneOrNone(`SELECT * FROM Documents WHERE id = @p1 `, [id]);
  return response;
}

export async function InsertDocument(jsonDoc: string, id: string, source: any, tx: SQLClient) {
  // вставка документа в базу Jetti
  // ! добавить обработку ошибки и откат
  const response = await tx.oneOrNone(`
    INSERT INTO Documents(
      [id], [type], [date], [code], [description], [posted], [deleted],
      [parent], [isfolder], [company], [user], [info], [doc])
    SELECT
      [id], [type], [date], [code], [description], [posted], [deleted],
      [parent], [isfolder], [company], [user], [info], [doc]
    FROM OPENJSON(@p1) WITH (
      [id] UNIQUEIDENTIFIER,
      [date] DATETIME,
      [type] NVARCHAR(100),
      [code] NVARCHAR(36),
      [description] NVARCHAR(150),
      [posted] BIT,
      [deleted] BIT,
      [parent] UNIQUEIDENTIFIER,
      [isfolder] BIT,
      [company] UNIQUEIDENTIFIER,
      [user] UNIQUEIDENTIFIER,
      [info] NVARCHAR(max),
      [doc] NVARCHAR(max) N'$.doc' AS JSON
    );
    SELECT * FROM Documents WHERE id = @p2`, [jsonDoc, id]);
  await SetExchangeDocumentID(source, id);
  return response;
}

/*
export async function InsertDocument(jsonDoc: string, exchangeCode: string, exchangeBase: string, tx: SQLClient) {
  const id = uuidv1().toUpperCase();
  const response = await tx.oneOrNone(`
      INSERT INTO Documents(
      [id], [type], [date], [code], [description], [posted], [deleted],
      [parent], [isfolder], [company], [user], [info], [doc], [ExchangeCode], [ExchangeBase])
      SELECT
      [type], getdate(), [code], [description], [posted], [deleted],
      [parent], [isfolder], [company], [user], [info], [doc], [ExchangeCode], [ExchangeBase]
      FROM OPENJSON(@p1) WITH (
      [id] UNIQUEIDENTIFIER,
      [date] DATETIME,
      [type] NVARCHAR(100),
      [code] NVARCHAR(36),
      [description] NVARCHAR(150),
      [posted] BIT,
      [deleted] BIT,
      [parent] UNIQUEIDENTIFIER,
      [isfolder] BIT,
      [company] UNIQUEIDENTIFIER,
      [user] UNIQUEIDENTIFIER,
      [info] NVARCHAR(max),
      [doc] NVARCHAR(max) N'$.doc' AS JSON,
      [ExchangeCode] NVARCHAR(50),
      [ExchangeBase] NVARCHAR(50)
      );
      SELECT * FROM Documents WHERE ExchangeCode = @p2 and ExchangeBase = @p3`, [jsonDoc, exchangeCode, exchangeBase]);
  return response;
}
*/

export async function UpdateDocument(jsonDoc: string, id: string, tx: SQLClient) {
  const response = await tx.oneOrNone(`
    UPDATE Documents
      SET
        type = i.type, parent = i.parent,
        date = i.date, code = i.code, description = i.description,
        posted = i.posted, deleted = i.deleted, isfolder = i.isfolder,
        "user" = i."user", company = i.company, info = i.info, timestamp = GETDATE(),
        doc = i.doc
      FROM (
        SELECT *
        FROM OPENJSON(@p1) WITH (
          [id] UNIQUEIDENTIFIER,
          [date] DATETIME,
          [type] NVARCHAR(100),
          [code] NVARCHAR(36),
          [description] NVARCHAR(150),
          [posted] BIT,
          [deleted] BIT,
          [isfolder] BIT,
          [company] UNIQUEIDENTIFIER,
          [user] UNIQUEIDENTIFIER,
          [info] NVARCHAR(max),
          [parent] UNIQUEIDENTIFIER,
          [doc] NVARCHAR(max) N'$.doc' AS JSON
        )
      ) i
    WHERE Documents.id = i.id;
    SELECT * FROM Documents WHERE id = @p2`, [jsonDoc, id]);
  return response;
}
///////////////////////////////////////////////////////////
// поставить документ в очередь на проведение
export async function setQueuePostDocument(id: string, company: string | null, flow: number, tx: SQLClient) {
  await tx.none(`insert into exc.QueuePost (id, company, flow) values(@p1, @p2, @p3)`, [id, company, flow]);
}///////////////////////////////////////////////////////////
