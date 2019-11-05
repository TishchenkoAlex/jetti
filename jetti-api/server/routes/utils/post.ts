import { DocumentBase } from '../../models/document';
import { INoSqlDocument } from '../../models/documents.factory';
import { RegisterAccumulation } from '../../models/Registers/Accumulation/RegisterAccumulation';
import { lib } from '../../std.lib';
import { InsertRegistersIntoDB } from './InsertRegistersIntoDB';
import { MSSQL } from '../../mssql';
import { DocumentBaseServer } from '../../models/documents.factory.server';


export async function postDocument(serverDoc: DocumentBaseServer, tx: MSSQL) {

  const beforePost: (tx: MSSQL) => Promise<DocumentBase> = serverDoc['serverModule']['beforePost'];
  if (typeof beforePost === 'function') await beforePost(tx);
  if (serverDoc.beforePost) await serverDoc.beforePost(tx);

  if (serverDoc.isDoc && serverDoc.onPost) {
    const Registers = await serverDoc.onPost(tx);
    await InsertRegistersIntoDB(serverDoc, Registers, tx);
  }

  const afterPost: (tx: MSSQL) => Promise<void> = serverDoc['serverModule']['afterPost'];
  if (typeof afterPost === 'function') await afterPost(tx);
  if (serverDoc.afterPost) await serverDoc.afterPost(tx);

}

export async function unpostDocument(serverDoc: DocumentBaseServer, tx: MSSQL) {
  await tx.none(`
    DELETE FROM "Register.Account" WHERE document = '${serverDoc.id}';
    DELETE FROM "Register.Info" WHERE document = '${serverDoc.id}';
    DELETE FROM "Accumulation" WHERE document = '${serverDoc.id}';
  `);
}

export async function insertDocument(serverDoc: DocumentBaseServer, tx: MSSQL) {
  const id = serverDoc.id;

  const beforeSave: (tx: MSSQL) => Promise<void> = serverDoc['serverModule']['beforeSave'];
  if (typeof beforeSave === 'function') await beforeSave(tx);
  if (serverDoc.beforeSave) await serverDoc.beforeSave(tx);

  serverDoc.timestamp = new Date();

  const noSqlDocument = lib.doc.noSqlDocument(serverDoc);
  const jsonDoc = JSON.stringify(noSqlDocument);
  let response: INoSqlDocument;

  response = <INoSqlDocument>await tx.oneOrNone<INoSqlDocument>(`
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

  const afterSave: (tx: MSSQL) => Promise<void> = serverDoc['serverModule']['afterSave'];
  if (typeof afterSave === 'function') await afterSave(tx);
  if (serverDoc.afterSave) await serverDoc.afterSave(tx);

  serverDoc.map(response);
  return serverDoc;
}

export async function updateDocument(serverDoc: DocumentBaseServer, tx: MSSQL) {
  const id = serverDoc.id;

  const beforeSave: (tx: MSSQL) => Promise<void> = serverDoc['serverModule']['beforeSave'];
  if (typeof beforeSave === 'function') await beforeSave(tx);
  if (serverDoc.beforeSave) await serverDoc.beforeSave(tx);

  serverDoc.timestamp = new Date();

  const noSqlDocument = lib.doc.noSqlDocument(serverDoc);
  const jsonDoc = JSON.stringify(noSqlDocument);

  let response: INoSqlDocument;
  response = <INoSqlDocument>await tx.oneOrNone<INoSqlDocument>(`
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

  const afterSave: (tx: MSSQL) => Promise<void> = serverDoc['serverModule']['afterSave'];
  if (typeof afterSave === 'function') await afterSave(tx);
  if (serverDoc.afterSave) await serverDoc.afterSave(tx);

  serverDoc.map(response);
  return serverDoc;
}

export async function adminModeForPost(mode: boolean, tx: MSSQL): Promise<boolean> {
  await tx.none(`EXEC sys.sp_set_session_context N'postMode', N'${mode}';`);
  return mode;
}
