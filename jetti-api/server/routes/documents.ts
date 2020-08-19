import { x100 } from './../x100.lib';
import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { DocumentBase, DocumentOptions, Ref } from '../../server/models/document';
import { dateReviverUTC } from '../fuctions/dateReviver';
import { SQLGenegator } from '../fuctions/SQLGenerator.MSSQL';
import { DocListRequestBody, IViewModel, PatchValue, RefValue, Type } from '../models/common-types';
import { createDocument, IFlatDocument, INoSqlDocument } from '../models/documents.factory';
import { createDocumentServer, DocumentBaseServer } from '../models/documents.factory.server';
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
import { ColumnDef } from '../models/column';

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
    const Operation: string | undefined = req.query.Operation as string || undefined;
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
          if (k === 'type' || k === 'id' || k === 'new' || k === 'base' || k === 'copy' || k === 'history') { continue; }
          if (typeof params[k] !== 'boolean') d[k] = params[k]; else d[k] = params[k];
        }
      };

      const command = req.query.new ? 'new' : req.query.copy ? 'copy' : req.query.base ? 'base' : req.query.history ? 'history' : '';
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
          const copy = await lib.doc.byId(req.query.copy as Ref, sdb);
          if (!copy) throw new Error(`base document ${req.query.copy} for copy is not found!`);
          const copyDoc = await createDocumentServer(type, copy, sdb);
          copyDoc.id = id; copyDoc.date = ServerDoc.date; copyDoc.code = '';
          copyDoc.posted = false; copyDoc.deleted = false; copyDoc.timestamp = null;
          copyDoc.parent = copyDoc.parent;
          if (userID) copyDoc.user = userID;
          ServerDoc.map(copyDoc);
          addIncomeParamsIntoDoc(params, ServerDoc);
          ServerDoc.description = 'Copy: ' + ServerDoc.description;
          if (ServerDoc.onCopy) await ServerDoc.onCopy(sdb);
          break;
        case 'base':
          if (ServerDoc.baseOn) await ServerDoc.baseOn(req.query.base as string, sdb);
          if (userID) ServerDoc.user = userID;
          break;
        case 'history':
          const history = await lib.doc.historyById(req.query.history as Ref, sdb);
          if (!history) throw new Error(`history version of document ${req.query.history} is not found!`);
          const histDoc = await createDocumentServer(type, history, sdb);
          ServerDoc.map(histDoc);
          addIncomeParamsIntoDoc(params, ServerDoc);
          ServerDoc.description = 'History: ' + ServerDoc.description;
          break;
        default:
          break;
      }
      model = (await buildViewModel<DocumentBase>(ServerDoc, sdb))!;
    }

    const columnsDef = buildColumnDef(ServerDoc.Props(), settings);
    const metadata = ServerDoc.Prop() as DocumentOptions;
    if (params.group) {
      metadata['Group'] = await lib.doc.formControlRef(params.group, sdb);
    }
    const result: IViewModel = { schema: ServerDoc.Props(), model, columnsDef, metadata, settings };
    res.json(result);
  } catch (err) { next(err); }
};

// restore object from his history version
router.get('/restore/:type/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const id: string = req.params.id;
    const type = req.params.type as DocTypes;
    const settings = new FormListSettings();
    const history = await lib.doc.historyById(id, sdb);
    const ServerDoc = await createDocumentServer(type, history!, sdb);
    ServerDoc.timestamp = new Date();
    const model = (await buildViewModel<DocumentBase>(ServerDoc, sdb))!;
    const columnsDef = buildColumnDef(ServerDoc.Props(), settings);
    const metadata = ServerDoc.Prop() as DocumentOptions;
    const result: IViewModel = { schema: ServerDoc.Props(), model, columnsDef, metadata, settings };
    res.json(result);
  } catch (err) { next(err); }
});

router.post('/view', viewAction);

// Delete or UnDelete document
router.delete('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      await lib.util.adminMode(true, tx);
      try {
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

        await tx.none(`
          DELETE FROM "Register.Account" WHERE document = @p1;
          DELETE FROM "Register.Info" WHERE document = @p1;
          DELETE FROM "Accumulation" WHERE document = @p1;
          UPDATE "Documents" SET deleted = @p3, posted = @p4, timestamp = GETDATE() WHERE id = @p1;
        `, [id, serverDoc.date, serverDoc.deleted, 0]);

        if (!doc.deleted) {
          const afterDelete: (tx: MSSQL) => Promise<void> = serverDoc['serverModule']['afterDelete'];
          if (typeof afterDelete === 'function') await afterDelete(tx);
          if (serverDoc && serverDoc.afterDelete) await serverDoc.afterDelete(tx);
        }

        const view = await buildViewModel(serverDoc, tx);
        res.json(view);
      } catch (ex) { throw new Error(ex); }
      finally { await lib.util.adminMode(false, tx); }
    });
  } catch (err) { next(err); }
});

router.post('/save', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      await lib.util.adminMode(true, tx);
      try {
        const doc: IFlatDocument = JSON.parse(JSON.stringify(req.body), dateReviverUTC);
        if (!doc.code) doc.code = await lib.doc.docPrefix(doc.type, tx);
        const serverDoc = await createDocumentServer(doc.type as DocTypes, doc, tx);
        if (serverDoc.timestamp) {
          await updateDocument(serverDoc, tx);
          if (serverDoc.posted && serverDoc.isDoc) {
            await unpostDocument(serverDoc, tx);
            await postDocument(serverDoc, tx);
          }
        } else {
          await insertDocument(serverDoc, tx);
        }
        res.json((await buildViewModel(serverDoc, tx)));
      } catch (ex) { throw new Error(ex); }
      finally { await lib.util.adminMode(false, tx); }
    });
  } catch (err) { next(err); }
});

router.post('/savepost', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      const doc: IFlatDocument = JSON.parse(JSON.stringify(req.body), dateReviverUTC);
      if (doc && doc.deleted) throw new Error('Cant POST deleted document');
      doc.posted = true;
      await lib.util.adminMode(true, tx);
      try {
        if (!doc.code) doc.code = await lib.doc.docPrefix(doc.type, tx);
        const serverDoc = await createDocumentServer(doc.type as DocTypes, doc, tx);
        await unpostDocument(serverDoc, tx);
        if (serverDoc.timestamp) {
          await updateDocument(serverDoc, tx);
        } else {
          await insertDocument(serverDoc, tx);
        }
        await postDocument(serverDoc, tx);
        res.json((await buildViewModel(serverDoc, tx)));
      } catch (ex) { throw new Error(ex); }
      finally { await lib.util.adminMode(false, tx); }
    });
  } catch (err) { next(err); }
});

router.post('/post', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      const doc: IFlatDocument = JSON.parse(JSON.stringify(req.body), dateReviverUTC);
      if (doc && doc.deleted) throw new Error('Cant POST deleted document');
      doc.posted = true;
      await lib.util.adminMode(true, tx);
      try {
        const serverDoc = await createDocumentServer(doc.type as DocTypes, doc, tx);
        await unpostDocument(serverDoc, tx);
        if (serverDoc.timestamp) {
          await updateDocument(serverDoc, tx);
        } else {
          await insertDocument(serverDoc, tx);
        }
        await postDocument(serverDoc, tx);
        res.json((await buildViewModel(serverDoc, tx)));
      } catch (ex) { throw new Error(ex); }
      finally { await lib.util.adminMode(false, tx); }
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

router.get('/getObjectPropertyById/:id/:valuePath', async (req: Request, res: Response, next: NextFunction) => {
  try {
    res.json(await lib.util.getObjectPropertyById(req.params.id, req.params.valuePath, SDB(req)));
  } catch (err) { next(err); }
});

router.get('/getDocMetaByType/:type', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const doc = createDocument(req.params.type as any);
    res.json({ Prop: doc.Prop(), Props: doc.Props() });
  } catch (err) { next(err); }
});

router.post('/getDocPropValuesByType', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { type, propNames } = req.body;
    const prop = createDocument(type).Prop();
    const propValues = propNames
      .filter(propName => Object.keys(prop).find(existProp => existProp === propName))
      .map(key => ({ propName: key, propValue: prop[key] }));
    res.json(propValues);
  } catch (err) { next(err); }
});

router.post('/valueChanges/:type/:property', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      await lib.util.adminMode(true, tx);
      try {
        const doc: IFlatDocument = JSON.parse(JSON.stringify(req.body.doc), dateReviverUTC);
        const value = JSON.parse(JSON.stringify(req.body.value), dateReviverUTC);
        const property: string = req.params.property;
        const type: DocTypes = req.params.type as DocTypes;

        doc[property] = typeof value === 'object' && value !== null ? value.id : value;
        const serverDoc = await createDocumentServer(type, doc, tx);

        const OnChange: (value: RefValue) => Promise<DocumentBaseServer> = serverDoc['serverModule'][property + '_OnChangeServer'];
        if (typeof OnChange === 'function') await OnChange(value);

        if (typeof serverDoc.onValueChanged === 'function') {
          await serverDoc.onValueChanged(property, value, tx);
        }
        const result: IViewModel = {
          metadata: serverDoc.Prop() as DocumentOptions,
          schema: serverDoc.Props(),
          model: (await buildViewModel<DocumentBase>(serverDoc, tx))!,
          columnsDef: [] as ColumnDef[],
          settings: new FormListSettings(),
        };
        res.json(result);
      } catch (ex) { throw new Error(ex); }
      finally { await lib.util.adminMode(false, tx); }
    });
  } catch (err) { next(err); }
});

router.post('/command/:type/:command', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      await lib.util.adminMode(true, tx);
      try {
        const doc: IFlatDocument = JSON.parse(JSON.stringify(req.body.doc), dateReviverUTC);
        const command: string = req.params.command;
        const type: DocTypes = req.params.type as DocTypes;
        const args: { [key: string]: any } = req.params.args as any;
        const serverDoc = await createDocumentServer(type, doc, tx);

        const docModule: (args: { [key: string]: any }) => Promise<void> = serverDoc['serverModule'][command];
        if (typeof docModule === 'function') await docModule(args);
        if (serverDoc.onCommand) await serverDoc.onCommand(command, args, tx);

        const result: IViewModel = {
          metadata: serverDoc.Prop() as DocumentOptions,
          schema: serverDoc.Props(),
          model: (await buildViewModel<DocumentBase>(serverDoc, tx))!,
          columnsDef: [] as ColumnDef[],
          settings: new FormListSettings(),
        };
        res.json(result);
      } catch (ex) { throw new Error(ex); }
      finally { await lib.util.adminMode(false, tx); }
    });
  } catch (err) { next(err); }
});

router.get('/ancestors/:id/:level', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    res.json(await lib.doc.Ancestors(req.params.id, sdb, req.params.level as any));
  } catch (err) { next(err); }
});

router.get('/descendants/:id/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    res.json(await lib.doc.Descendants(req.params.id, sdb));
  } catch (err) { next(err); }
});

router.get('/haveDescendants/:id/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    res.json(await lib.doc.haveDescendants(req.params.id, sdb));
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

// Get hierarchyList for document list
router.get('/hierarchyList/:type/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const tx = SDB(req);
    let result;
    if (req.params.id === 'top') { // top level
      const query = `
      SELECT doc.id, doc.parent, doc.isfolder, doc.description, 0 level, doc.deleted
      FROM Documents doc
      WHERE doc.parent is NULL and type = @p1
      order by doc.isfolder desc, description`;
      result = await tx.manyOrNone(query, [req.params.type]);
    } else {
      const query = `
      DROP TABLE IF EXISTS #Tree;

      SELECT id, [parent.id], description, LevelUp
      INTO #Tree
      FROM dbo.[Ancestors](@p1);
      SELECT res.id, res.parent, res.isfolder, res.description, MIN(res.LevelUp) level, doc.deleted
      from (
        SELECT doc.id id, doc.parent parent, doc.isfolder, doc.description, tree.LevelUp
          FROM #Tree tree INNER JOIN Documents doc ON tree.[parent.id] = doc.parent and tree.id = @p1
        UNION
        SELECT tree.id id, tree.[parent.id] parent, 1, tree.description, tree.LevelUp
          FROM #Tree tree
          WHERE tree.id <> @p1
        UNION
        SELECT doc.id, doc.parent, doc.isfolder, doc.description, 9 LevelUp
          FROM Documents doc
          WHERE id = @p1
        UNION
        SELECT doc.id, doc.parent, doc.isfolder, doc.description, 10 LevelUp
          FROM Documents doc
          WHERE doc.parent = @p1) res LEFT JOIN Documents doc on doc.id = res.id
      GROUP BY res.id, res.parent, res.isfolder, res.description, doc.deleted
      order by MIN(LevelUp), res.isfolder desc, res.description`;
      result = await tx.manyOrNone(query, [req.params.id]);
    }

    res.json(result);
  } catch (err) { next(err); }
});

// Get history list by object id
router.get('/getHistoryById/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      const query = `
      SELECT
        hist.id
        ,hist.posted
        ,hist.deleted
        ,hist.description
        ,hist.date
        ,hist.code
        ,hist.isfolder
        ,users.[description] as userName
        ,hist._timestamp as timestamp
        FROM [dbo].[Documents.Hisroty] hist
      LEFT JOIN [dbo].[Documents] users
        ON users.id = hist.[_user]
      WHERE _id = @p1
      ORDER BY [_timestamp] desc`;
      res.json(await tx.manyOrNone(query, [req.params.id]));
    });
  } catch (err) { next(err); }
});

router.get('/getDescedantsObjects/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      const ob = await lib.doc.byId(req.params.id, tx);
      const isCatalog = Type.isCatalog(ob?.type as any);
      const firstLimit = isCatalog ? 20 : 0;

      const getQueryText = (DocSelectText: string) => `
      select
      res.id,
      res.type,
      res.date,
      res.code,
      res.description,
      res.posted,
      res.deleted,
      CAST(ISNULL(res.amount, 0) AS money) amount,
      ISNULL(res.info,'') info,
      ISNULL(us.[User],'') N'user',
      comp.Company company
  from
      (select
        id, type, date, code, description, posted, deleted, company as companyID, JSON_VALUE(doc, N'$.Amount') amount, JSON_VALUE(doc, N'$.info') info, [user] as userID
      from Documents
      where id in (${DocSelectText})) res
      left join [Catalog.User] us on us.id = userID
      left join [Catalog.Company] comp on comp.id = companyID
  order by res.date, res.type, res.description`;

      let queryDocSelectText = isCatalog ?
        `select distinct TOP ${firstLimit} document
      from Accumulation
      where contains(data, @p1)`
        :
        ` select id
          from Documents
          where parent = @p1
      union
      select id
          from Documents
          where contains(doc, @p1)
      UNION
      SELECT parent
          from Documents
          WHERE id = @p1`;

      let resData = await tx.manyOrNone(getQueryText(queryDocSelectText), [req.params.id]);
      if (false && isCatalog && resData.length < firstLimit) {
        queryDocSelectText =
          `select TOP ${firstLimit - resData.length} id
      from Documents
      where contains(doc, @p1)`;
        // queryDocSelectText
        // .replace('Accumulation', 'Documents')
        // .replace('data', 'doc')
        // .replace('' + firstLimit, (firstLimit - resData.length).toString());
        resData = [...resData, ...await tx.manyOrNone(getQueryText(queryDocSelectText), [req.params.id])];
      }
      res.json(resData);
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
      const sourse = await lib.doc.byId(req.params.id, tx);
      if (sourse) {
        if (!sourse.timestamp) throw new Error('source document not saved');
        sourse['Status'] = req.params.Status;
        const serverDoc = await createDocumentServer(sourse.type as DocTypes, sourse, tx);
        await unpostDocument(serverDoc, tx);
        if (serverDoc.timestamp) {
          await updateDocument(serverDoc, tx);
        } else {
          await insertDocument(serverDoc, tx);
        }
        await postDocument(serverDoc, tx);
        res.json((await buildViewModel(serverDoc, tx)));
      }
    });
  } catch (err) { next(err); }
});

router.post('/createDocument/:type', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      const body = req.body;
      let flatDoc: IFlatDocument;
      let servDoc;
      const resOb = { id: '', code: '', error: '' };
      if (req.params.type !== 'Document.CashRequest') resOb.error = `Unsupported doc type: ${req.params.type}`;
      else {
        if (body.Id) {
          flatDoc = await lib.doc.byId(body.Id, tx) as any;
          if (!flatDoc) resOb.error = `Cant find doc with id: ${body.Id}`;
          else servDoc = await lib.doc.createDocServer(req.params.type as DocTypes, flatDoc, tx);
        } else servDoc = await lib.doc.createDocServer(req.params.type as DocTypes, undefined, tx);
        if (!resOb.error) {
          await servDoc.FillByWebAPIBody(body, tx);
          resOb.id = servDoc.id;
          resOb.code = servDoc.code;
          res.json(resOb);
        }
      }
    });
  } catch (err) { next(err); }
});

router.post('/updateOperationTaxCheck', async (req: Request, res: Response, next: NextFunction) => {
  try {
    res.json(await x100.util.updateOperationTaxCheck(req.body));
  } catch (err) { next(err); }
});

router.post('/attachments/del', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      res.json(await lib.util.delAttachments(req.body, tx));
    });
  } catch (err) { next(err); }
});

router.post('/attachments/add', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      res.json(await lib.util.addAttachments(req.body, tx));
    });
  } catch (err) { next(err); }
});

router.get('/attachments/getByOwner/:id/:withDeleted', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      res.json(await lib.util.getAttachmentsByOwner(req.params.id, req.params.withDeleted === 'true', tx));
    });
  } catch (err) { next(err); }
});

router.get('/attachments/getAttachmentStorageById/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      res.json(await lib.util.getAttachmentStorageById(req.params.id, tx));
    });
  } catch (err) { next(err); }
});

router.get('/attachments/getAttachmentsSettingsByOwner/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      res.json(await lib.util.getAttachmentsSettingsByOwner(req.params.id, tx));
    });
  } catch (err) { next(err); }
});

router.post('/documentsDataAsJSON', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      const docIDs = req.body.map(el => '\'' + el + '\'').join(',');
      const query = `SELECT * FROM Documents WHERE id IN(${docIDs})`;
      res.json(JSON.stringify(await tx.manyOrNone(query)));
    });
  } catch (err) { next(err); }
});
