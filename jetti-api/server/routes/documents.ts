import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { DocumentBase, DocumentOptions } from '../../server/models/document';
import { dateReviverUTC } from '../fuctions/dateReviver';
import { SQLGenegator } from '../fuctions/SQLGenerator.MSSQL';
import { DocListRequestBody, IViewModel, PatchValue, RefValue } from '../models/api';
import { createDocument } from '../models/documents.factory';
import { createDocumentServer } from '../models/documents.factory.server';
import { DocTypes } from '../models/documents.types';
import { DocumentOperation } from '../models/Documents/Document.Operation';
import { RegisterAccumulation } from '../models/Registers/Accumulation/RegisterAccumulation';
import { MSSQL, sdb } from '../mssql';
import { DocumentBaseServer, IFlatDocument, INoSqlDocument } from './../models/ServerDocument';
import { FormListSettings } from './../models/user.settings';
import { buildColumnDef } from './../routes/utils/columns-def';
import { lib } from './../std.lib';
import { User } from './user.settings';
import { InsertRegistersIntoDB } from './utils/InsertRegistersIntoDB';
import { List } from './utils/list';

export const router = express.Router();

export async function buildViewModel(ServerDoc: DocumentBaseServer, tx: MSSQL) {
  const viewModelQuery = SQLGenegator.QueryObjectFromJSON(ServerDoc.Props());
  const NoSqlDocument = JSON.stringify(lib.doc.noSqlDocument(ServerDoc));
  return await tx.oneOrNone<{ [key: string]: any }>(viewModelQuery, [NoSqlDocument]);
}


// Select documents list for UI (grids/list etc)
router.post('/list', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => {
      const params = req.body as DocListRequestBody;
      res.json(await List(params, tx));
    }, User(req));
  } catch (err) { next(err); }
});

const viewAction = async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => {
      const params: { [key: string]: any } = req.body;
      const user = User(req);
      const id: string | undefined = params.id;
      const type: DocTypes = params.type;
      const Operation: string | undefined = req.query.Operation || undefined;
      const isFolder: boolean = req.query.isfolder === 'true';

      let doc: IFlatDocument | DocumentOperation | null = null;
      if (id) doc = await lib.doc.byId(id, tx);
      if (!doc) {
        doc = Operation ?
          { ...createDocument<DocumentBaseServer>(type), Operation } :
          createDocument<DocumentBaseServer>(type);
        doc!.isfolder = isFolder;
      }
      const ServerDoc = await createDocumentServer<DocumentBaseServer>(type, doc as IFlatDocument, tx);
      if (!ServerDoc) throw new Error(`wrong type ${type}`);
      if (id) ServerDoc.id = id;

      let model = {};
      const querySettings = await tx.oneOrNone<{ doc: FormListSettings }>(`
      SELECT JSON_QUERY(settings, '$."${type}"') doc FROM users where email = @p1`, [user]);
      const settings = querySettings && querySettings.doc || new FormListSettings();
      const userID = await lib.doc.byCode('Catalog.User', user, tx);

      if (id) {

        const addIncomeParamsIntoDoc = async (prm: { [x: string]: any }, d: DocumentBase) => {
          for (const k in prm) {
            if (k === 'type' || k === 'id' || k === 'new' || k === 'base' || k === 'copy') { continue; }
            if (typeof params[k] !== 'boolean') d[k] = params[k]; else d[k] = params[k];
          }
        };

        const command = req.query.new ? 'new' : req.query.copy ? 'copy' : req.query.base ? 'base' : '';
        switch (command) {
          case 'new':
            // init default values from metadata
            const schema = ServerDoc.Props();
            Object.keys(schema).filter(p => schema[p].value !== undefined).forEach(p => ServerDoc[p] = schema[p].value);
            addIncomeParamsIntoDoc(params, ServerDoc);
            if (userID) ServerDoc.user = userID;
            if (ServerDoc.onCreate) { await ServerDoc.onCreate(tx); }
            break;
          case 'copy':
            const copy = await lib.doc.byId(req.query.copy, tx);
            if (!copy) throw new Error(`base document ${req.query.copy} for copy is not found!`);
            const copyDoc = await createDocumentServer<DocumentBaseServer>(type, copy, tx);
            copyDoc.id = id; copyDoc.date = ServerDoc.date; copyDoc.code = '';
            copyDoc.posted = false; copyDoc.deleted = false; copyDoc.timestamp = null;
            copyDoc.parent = copyDoc.parent;
            if (userID) copyDoc.user = userID;
            ServerDoc.map(copyDoc);
            addIncomeParamsIntoDoc(params, ServerDoc);
            ServerDoc.description = 'Copy: ' + ServerDoc.description;
            break;
          case 'base':
            await ServerDoc.baseOn(req.query.base as string, tx);
            break;
          default:
            break;
        }
        model = (await buildViewModel(ServerDoc, tx))!;
      }

      const columnsDef = buildColumnDef(ServerDoc.Props(), settings);
      const result: IViewModel = { schema: ServerDoc.Props(), model, columnsDef, metadata: ServerDoc.Prop() as DocumentOptions, settings };
      res.json(result);
    }, User(req));
  } catch (err) { next(err); }
};
router.post('/view', viewAction);


// Delete or UnDelete document
router.delete('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => {
      const id: string = req.params.id;
      const doc = await lib.doc.byId(id, tx);
      if (!doc) throw new Error(`API - Delete: document with id '${id}' not found.`);

      const serverDoc = await createDocumentServer<DocumentBaseServer>(doc.type, doc, tx);

      const beforeDelete: (tx: MSSQL) => Promise<void> = serverDoc['serverModule']['beforeDelete'];
      if (typeof beforeDelete === 'function') await beforeDelete(tx);

      if (serverDoc.beforeDelete) await serverDoc.beforeDelete(tx);

      serverDoc.deleted = !!!serverDoc.deleted;
      serverDoc.posted = false;

      const deleted = await tx.manyOrNone<INoSqlDocument>(`
        SELECT * FROM "Accumulation" WHERE document = '${id}';
        DELETE FROM "Register.Account" WHERE document = '${id}';
        DELETE FROM "Register.Info" WHERE document = '${id}';
        DELETE FROM "Accumulation" WHERE document = '${id}';
        UPDATE "Documents" SET deleted = @p1, posted = 0 WHERE id = '${id}';`, [serverDoc.deleted]);
      serverDoc['deletedRegisterAccumulation'] = () => deleted;

      const afterDelete: (tx: MSSQL) => Promise<void> = serverDoc['serverModule']['afterDelete'];
      if (typeof afterDelete === 'function') await afterDelete(tx);

      if (serverDoc && serverDoc.afterDelete) await serverDoc.afterDelete(tx);

      if (serverDoc && serverDoc.onPost) await serverDoc.onPost(tx);

      const view = await buildViewModel(serverDoc, tx);
      res.json(view);
    }, User(req));
  } catch (err) { next(err); }
});

// Upsert document
async function post(serverDoc: DocumentBaseServer, mode: 'post' | 'save', tx: MSSQL) {
  const id = serverDoc.id;
  const isNew = (await tx.oneOrNone<{ id: string }>(`SELECT id FROM "Documents" WHERE id = '${id}'`) === null);

  const beforeSave: (tx: MSSQL) => Promise<void> = serverDoc['serverModule']['beforeSave'];
  if (typeof beforeSave === 'function') await beforeSave(tx);

  const beforePost: (tx: MSSQL) => Promise<void> = serverDoc['serverModule']['beforePost'];
  if (!!serverDoc.posted && (typeof beforePost === 'function')) await beforePost(tx);

  if (!!serverDoc.posted && serverDoc.beforePost) await serverDoc.beforePost(tx);

  if (serverDoc.isDoc) {
    const deleted = await tx.manyOrNone<RegisterAccumulation>(`
    SELECT * FROM "Accumulation" WHERE document = '${id}';
    DELETE FROM "Register.Account" WHERE document = '${id}';
    DELETE FROM "Register.Info" WHERE document = '${id}';
    DELETE FROM "Accumulation" WHERE document = '${id}';`);
    serverDoc['deletedRegisterAccumulation'] = () => deleted;
  }
  serverDoc.timestamp = new Date();

  const afterSave: (tx: MSSQL) => Promise<void> = serverDoc['serverModule']['afterSave'];
  if (typeof afterSave === 'function') await afterSave(tx);

  if (serverDoc.isDoc && serverDoc.onPost) {
    const Registers = await serverDoc.onPost(tx);
    if (serverDoc.posted && !serverDoc.deleted) await InsertRegistersIntoDB(serverDoc, Registers, tx);
  }

  const afterPost: (tx: MSSQL) => Promise<void> = serverDoc['serverModule']['afterPost'];
  if (!!serverDoc.posted && (typeof afterPost === 'function')) await afterPost(tx);

  const noSqlDocument = lib.doc.noSqlDocument(serverDoc);
  const jsonDoc = JSON.stringify(noSqlDocument);
  let response: INoSqlDocument;
  if (isNew) {
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
  } else {
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
  }
  serverDoc.map(response);
  return serverDoc;
}

// Upsert document
router.post('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => {
      const mode: 'post' | 'save' = req.query.mode || 'save';
      const doc: IFlatDocument = JSON.parse(JSON.stringify(req.body), dateReviverUTC);
      if (doc.deleted && mode === 'post') throw new Error('cant POST deleted document');
      if (mode === 'post') doc.posted = true;

      if (!doc.code) doc.code = await lib.doc.docPrefix(doc.type, tx);
      const serverDoc = await createDocumentServer<DocumentBaseServer>(doc.type as DocTypes, doc, tx);

      await post(serverDoc, mode, tx);
      const view = await buildViewModel(serverDoc, tx);
      res.json(view);
    }, User(req));
  } catch (err) { next(err); }
});

// unPost by id (without returns posted object to client, for post in cicle many docs)
router.get('/unpost/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => {
      const result = await lib.doc.postById(req.params.id, false, tx);
      res.json(result);
    }, User(req));
  } catch (err) { next(err); }
});

// Post by id (without returns posted object to client, for post in cicle many docs)
router.get('/post/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => {
      const result = await lib.doc.postById(req.params.id, true, tx);
      res.json(result);
    }, User(req));
  } catch (err) { next(err); }
});

// Get raw document by id
router.get('/byId/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => res.json(await lib.doc.byId(req.params.id, tx)), User(req));
  } catch (err) { next(err); }
});

router.post('/valueChanges/:type/:property', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => {
      const doc: IFlatDocument = JSON.parse(JSON.stringify(req.body.doc), dateReviverUTC);
      const value: RefValue = JSON.parse(JSON.stringify(req.body.value), dateReviverUTC);
      const property: string = req.params.property;
      const type: DocTypes = req.params.type as DocTypes;
      const serverDoc = await createDocumentServer<DocumentBaseServer>(type, doc, tx);

      let result: PatchValue = {};
      const OnChange: (value: RefValue) => Promise<PatchValue> = serverDoc['serverModule'][property + '_OnChange'];
      if (typeof OnChange === 'function') result = await OnChange(value) || {};

      if (Object.keys(result).length === 0 &&
        (serverDoc && serverDoc.onValueChanged) &&
        (typeof serverDoc.onValueChanged === 'function')) {
        result = await serverDoc.onValueChanged(property, value, tx);
      }
      res.json(result);
    }, User(req));
  } catch (err) { next(err); }
});

router.post('/command/:type/:command', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => {
      const doc: IFlatDocument = JSON.parse(JSON.stringify(req.body.doc), dateReviverUTC);
      const command: string = req.params.command;
      const type: DocTypes = req.params.type as DocTypes;
      const args: { [key: string]: any } = req.params.args as any;
      const serverDoc = await createDocumentServer<DocumentBaseServer>(type, doc, tx);

      const docModule: (args: { [key: string]: any }) => Promise<void> = serverDoc['serverModule'][command];
      if (typeof docModule === 'function') await docModule(args);

      const view = await buildViewModel(serverDoc, tx);
      res.json(view);
    }, User(req));
  } catch (err) { next(err); }
});

// Get tree for document list
router.get('/tree/:type', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => {
      const query = `select id, description, parent from "Documents" where isfolder = 1 and type = @p1 order by description, parent`;
      res.json(await tx.manyOrNone(query, [req.params.type]));
    }, User(req));
  } catch (err) { next(err); }
});

// Get formControlRef
router.get('/formControlRef/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => {
      res.json(await lib.doc.formControlRef(req.params.id, tx));
    }, User(req));
  } catch (err) { next(err); }
});
