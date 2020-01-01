import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { DocumentBase, DocumentOptions } from '../../server/models/document';
import { dateReviverUTC } from '../fuctions/dateReviver';
import { SQLGenegator } from '../fuctions/SQLGenerator.MSSQL';
import { DocListRequestBody, IViewModel, PatchValue, RefValue } from '../models/common-types';
import { createDocument, IFlatDocument, INoSqlDocument } from '../models/documents.factory';
import { createDocumentServer } from '../models/documents.factory.server';
import { DocTypes } from '../models/documents.types';
import { DocumentOperation } from '../models/Documents/Document.Operation';
import { FormListSettings } from './../models/user.settings';
import { buildColumnDef } from './../routes/utils/columns-def';
import { lib } from './../std.lib';
import { List } from './utils/list';
import { postDocument, insertDocument, updateDocument, unpostDocument } from './utils/post';
import { MSSQL } from '../mssql';
import { SDB } from './middleware/db-sessions';
import { User } from './user.settings';
import { DocumentWorkFlowServer } from '../models/Documents/Document.WorkFlow.server';

export const router = express.Router();

export async function buildViewModel<T>(ServerDoc: DocumentBase, tx: MSSQL) {
  const viewModelQuery = SQLGenegator.QueryObjectFromJSON(ServerDoc.Props());
  const NoSqlDocument = JSON.stringify(lib.doc.noSqlDocument(ServerDoc));
  return await tx.oneOrNone<T>(viewModelQuery, [NoSqlDocument]);
}

// Select documents list for UI (grids/list etc)
router.post('/list', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const params = req.body as DocListRequestBody;
    res.json(await List(params, sdb));
  } catch (err) { next(err); }
});

const viewAction = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const params: { [key: string]: any } = req.body;
    const email = User(req).email;
    const id: string | undefined = params.id;
    const type: DocTypes = params.type;
    const Operation: string | undefined = req.query.Operation || undefined;
    const isFolder: boolean = req.query.isfolder === 'true';

    let doc: IFlatDocument | DocumentOperation | null = null;
    if (id) doc = await lib.doc.byId(id, sdb);
    if (!doc) {
      doc = Operation ?
        { ...createDocument(type), Operation } :
        createDocument(type);
      doc!.isfolder = isFolder;
    }
    const ServerDoc = await createDocumentServer(type, doc as IFlatDocument, sdb);
    if (!ServerDoc) throw new Error(`wrong type ${type}`);
    if (id) ServerDoc.id = id;

    let model = {};
    const settings = new FormListSettings();
    const userID = await lib.doc.byCode('Catalog.User', email, sdb);

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
          if (ServerDoc.onCreate) { await ServerDoc.onCreate(sdb); }
          break;
        case 'copy':
          const copy = await lib.doc.byId(req.query.copy, sdb);
          if (!copy) throw new Error(`base document ${req.query.copy} for copy is not found!`);
          const copyDoc = await createDocumentServer(type, copy, sdb);
          copyDoc.id = id; copyDoc.date = ServerDoc.date; copyDoc.code = '';
          copyDoc.posted = false; copyDoc.deleted = false; copyDoc.timestamp = null;
          copyDoc.parent = copyDoc.parent;
          if (userID) copyDoc.user = userID;
          ServerDoc.map(copyDoc);
          addIncomeParamsIntoDoc(params, ServerDoc);
          ServerDoc.description = 'Copy: ' + ServerDoc.description;
          break;
        case 'base':
          if (ServerDoc.baseOn) await ServerDoc.baseOn(req.query.base as string, sdb);
          break;
        default:
          break;
      }
      model = (await buildViewModel<DocumentBase>(ServerDoc, sdb))!;
    }

    const columnsDef = buildColumnDef(ServerDoc.Props(), settings);
    const result: IViewModel = { schema: ServerDoc.Props(), model, columnsDef, metadata: ServerDoc.Prop() as DocumentOptions, settings };
    res.json(result);
  } catch (err) { next(err); }
};
router.post('/view', viewAction);

// Delete or UnDelete document
router.delete('/:id', async (req: Request, res: Response, next: NextFunction) => {
  const sdb = SDB(req);
  await sdb.tx(async tx => {
    try {
      await lib.util.postMode(true, tx);

      const id: string = req.params.id;
      const doc = await lib.doc.byId(id, tx);
      if (!doc) throw new Error(`API - Delete: document with id '${id}' not found.`);

      const serverDoc = await createDocumentServer(doc.type, doc, tx);

      if (!doc.deleted) {
        const beforeDelete: (tx: MSSQL) => Promise<void> = serverDoc['serverModule']['beforeDelete'];
        if (typeof beforeDelete === 'function') await beforeDelete(tx);
        if (serverDoc.beforeDelete) await serverDoc.beforeDelete(tx);
      }

      serverDoc.deleted = !!!serverDoc.deleted;
      serverDoc.posted = false;

      const deleted = await tx.none(`
        ELETE FROM "Register.Account" WHERE document = @p1 and date = @p2;
        DELETE FROM "Register.Info" WHERE document = @p1 and date = @p2;
        DELETE FROM "Accumulation" WHERE document = @p1 and date = @p2;
        UPDATE "Documents" SET deleted = @p3, posted = @p4 WHERE id = @p1;
      `, [id, serverDoc.date, serverDoc.deleted, 0]);

      if (!doc.deleted) {
        const afterDelete: (tx: MSSQL) => Promise<void> = serverDoc['serverModule']['afterDelete'];
        if (typeof afterDelete === 'function') await afterDelete(tx);
        if (serverDoc && serverDoc.afterDelete) await serverDoc.afterDelete(tx);
      }

      const view = await buildViewModel(serverDoc, tx);
      res.json(view);
    } catch (err) { next(err); }
    finally { await lib.util.postMode(false, tx); }
  });
});

router.post('/save', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      try {
        const doc: IFlatDocument = JSON.parse(JSON.stringify(req.body), dateReviverUTC);
        await lib.util.postMode(true, tx);
        if (!doc.code) doc.code = await lib.doc.docPrefix(doc.type, tx);
        const serverDoc = await createDocumentServer(doc.type as DocTypes, doc, tx);
        if (serverDoc.timestamp) {
          await updateDocument(serverDoc, tx);
        } else {
          await insertDocument(serverDoc, tx);
        }
        res.json((await buildViewModel(serverDoc, tx)));
      } catch (err) { throw err; }
      finally { await lib.util.postMode(false, tx); }
    });
  } catch (err) { next(err); }
});

router.post('/savepost', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      try {
        const doc: IFlatDocument = JSON.parse(JSON.stringify(req.body), dateReviverUTC);
        if (doc && doc.deleted) throw new Error('Cant POST deleted document');
        doc.posted = true;
        await lib.util.postMode(true, tx);
        if (!doc.code) doc.code = await lib.doc.docPrefix(doc.type, tx);
        const serverDoc = await createDocumentServer(doc.type as DocTypes, doc, tx);
        if (serverDoc.timestamp) {
          await unpostDocument(serverDoc, tx);
          await updateDocument(serverDoc, tx);
        } else {
          await insertDocument(serverDoc, tx);
        }
        await postDocument(serverDoc, tx);
        res.json((await buildViewModel(serverDoc, tx)));
      } catch (err) { throw err; }
      finally { await lib.util.postMode(false, tx); }
    });
  } catch (err) { next(err); }
});

router.post('/post', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      try {
        const doc: IFlatDocument = JSON.parse(JSON.stringify(req.body), dateReviverUTC);
        if (doc && doc.deleted) throw new Error('Cant POST deleted document');
        doc.posted = true;
        await lib.util.postMode(true, tx);
        const serverDoc = await createDocumentServer(doc.type as DocTypes, doc, tx);
        if (serverDoc.timestamp) {
          await unpostDocument(serverDoc, tx);
          await updateDocument(serverDoc, tx);
        } else {
          await insertDocument(serverDoc, tx);
        }
        await postDocument(serverDoc, tx);
        res.json((await buildViewModel(serverDoc, tx)));
      } catch (err) { throw err; }
      finally { await lib.util.postMode(false, tx); }
    });
  } catch (err) { next(err); }
});

// Post by id (without returns posted object to client, for post in cicle many docs)
router.get('/post/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      const { id, posted } = await lib.doc.postById(req.params.id, tx);
      res.json({ id, posted });
    });
  } catch (err) { next(err); }
});

// unPost by id (without returns posted object to client, for post in cicle many docs)
router.get('/unpost/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      const { id, posted } = await lib.doc.unPostById(req.params.id, tx);
      res.json({ id, posted });
    });
  } catch (err) { next(err); }
});

// Get raw document by id
router.get('/byId/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      const result = await lib.doc.byId(req.params.id, tx);
      res.json(result);
    });
  } catch (err) { next(err); }
});

router.post('/valueChanges/:type/:property', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      const doc: IFlatDocument = JSON.parse(JSON.stringify(req.body.doc), dateReviverUTC);
      const value: RefValue = JSON.parse(JSON.stringify(req.body.value), dateReviverUTC);
      const property: string = req.params.property;
      const type: DocTypes = req.params.type as DocTypes;
      const serverDoc = await createDocumentServer(type, doc, tx);

      let result: PatchValue = {};
      const OnChange: (value: RefValue) => Promise<PatchValue> = serverDoc['serverModule'][property + '_OnChange'];
      if (typeof OnChange === 'function') result = await OnChange(value) || {};

      if (Object.keys(result).length === 0 &&
        (serverDoc && serverDoc.onValueChanged) &&
        (typeof serverDoc.onValueChanged === 'function')) {
        result = await serverDoc.onValueChanged(property, value, tx);
      }
      res.json(result);
    });
  } catch (err) { next(err); }
});

router.post('/command/:type/:command', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      const doc: IFlatDocument = JSON.parse(JSON.stringify(req.body.doc), dateReviverUTC);
      const command: string = req.params.command;
      const type: DocTypes = req.params.type as DocTypes;
      const args: { [key: string]: any } = req.params.args as any;
      const serverDoc = await createDocumentServer(type, doc, tx);

      const docModule: (args: { [key: string]: any }) => Promise<void> = serverDoc['serverModule'][command];
      if (typeof docModule === 'function') await docModule(args);
      if (serverDoc.onCommand) await serverDoc.onCommand(command, args, tx);

      const view = await buildViewModel(serverDoc, tx);
      res.json(view);
    });
  } catch (err) { next(err); }
});

// Get tree for document list
router.get('/tree/:type', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      const query = `select id, description, parent from "Documents" where isfolder = 1 and type = @p1 order by description, parent`;
      res.json(await tx.manyOrNone(query, [req.params.type]));
    });
  } catch (err) { next(err); }
});

// Get formControlRef
router.get('/formControlRef/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      res.json(await lib.doc.formControlRef(req.params.id, tx));
    });
  } catch (err) { next(err); }
});

router.get('/startWorkFlow/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      const sourse = await lib.doc.byId(req.params.id, tx);
      if (sourse) {
        if (!sourse.timestamp) throw new Error('source document not saved');
        if (sourse['workflow']) throw new Error('workflow exists');
        const serverDoc = await createDocumentServer<DocumentWorkFlowServer>('Document.WorkFlow', undefined, tx);
        await serverDoc.baseOn!(sourse.id, tx);
        await insertDocument(serverDoc, tx);
        await postDocument(serverDoc, tx);
        res.json(serverDoc);
      }
    });
  } catch (err) { next(err); }
});

router.post('/setApprovingStatus/:id/:Status', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      try {
        const sourse = await lib.doc.byId(req.params.id, tx);
        if (sourse) {
          if (!sourse.timestamp) throw new Error('source document not saved');
          sourse['Status'] = req.params.Status;
          const serverDoc = await createDocumentServer(sourse.type as DocTypes, sourse, tx);
          if (serverDoc.timestamp) {
            await unpostDocument(serverDoc, tx);
            await updateDocument(serverDoc, tx);
          } else {
            await insertDocument(serverDoc, tx);
          }
          await postDocument(serverDoc, tx);
          res.json((await buildViewModel(serverDoc, tx)));
        }
      } catch (err) { throw err; }
      finally { await lib.util.postMode(false, tx); }
    });
  } catch (err) { next(err); }
});
