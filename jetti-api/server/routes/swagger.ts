import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { dateReviverUTC } from '../fuctions/dateReviver';
import { IFlatDocument, INoSqlDocument } from '../models/documents.factory';
import { createDocumentServer, DocumentBaseServer } from '../models/documents.factory.server';
import { lib } from './../std.lib';import { MSSQL } from '../mssql';
import { SDB } from './middleware/db-sessions';
import { JETTI_POOL } from '../sql.pool.jetti';

export const router = express.Router();

export interface IUpdateDocumentRequest {
  document: INoSqlDocument,
  options: IUpdateOptions,
}

export interface IUpdateOptions {
  updateType: 'Insert' | 'Update' | 'InsertOrUpdate',
  commands: string[], // document server methods name
  searchKey: { key: string, value?: any }[],
  queueFlow: number
}

// Get raw document by id
router.get('/document/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const tx = new MSSQL(JETTI_POOL);
    let noSqlDoc: INoSqlDocument | null = null;
    const flatDoc = await lib.doc.byId(req.params.id, tx);
    if (flatDoc) {
      noSqlDoc = await lib.doc.noSqlDocument(flatDoc);
      delete noSqlDoc?.doc['serverModule'];
      noSqlDoc!.docByKeys = Object.keys(noSqlDoc!.doc)
        .map(key => ({ key: key, value: noSqlDoc!.doc[key] }));
      if (req.query.asArray === 'true') res.json(Object.entries(flatDoc));
    }
    res.json(noSqlDoc);

  } catch (err) { next(err); }
});

router.get('/document/meta/:type/:operationId', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const tx = new MSSQL(JETTI_POOL);
    const flatDocument = { id: (await lib.util.GUID()), Operation: req.params.operationId || null };
    const docServer = await lib.doc.createDocServer(req.params.type as any, flatDocument as any, tx);
    const props = docServer.Props();
    res.json({ prop: docServer.Prop(), props: props });

  } catch (err) { next(err); }
});

// router.post('/document_simple', async (req: Request, res: Response, next: NextFunction) => {
//   try {
//     const sdb = SDB(req);
//     await sdb.tx(async tx => {
//       await lib.util.adminMode(true, tx);
//       try {
//         const { document, options } = JSON.parse(JSON.stringify(req.body), dateReviverUTC) as IUpdateDocumentRequest;
//         if (options.skipExisting && document.id && (await lib.doc.byId(document.id, tx))) {
//           res.json(document); return;
//         }
//         if (!document.code) document.code = await lib.doc.docPrefix(document.type, tx);
//         const serverDoc = await createDocumentServer(document.type as DocTypes, document, tx);
//         if (serverDoc.timestamp) {
//           await updateDocument(serverDoc, tx);
//           if (serverDoc.posted && serverDoc.isDoc && options.saveMode === 'Post') {
//             await unpostDocument(serverDoc, tx);
//             await postDocument(serverDoc, tx);
//           }
//         } else {
//           await insertDocument(serverDoc, tx);
//         }
//         res.json(serverDoc);
//       } catch (ex) { throw new Error(ex); }
//       finally { await lib.util.adminMode(false, tx); }
//     });
//   } catch (err) { next(err); }
// });

router.post('/document', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      await lib.util.adminMode(true, tx);
      try {
        const { document, options } = JSON.parse(JSON.stringify(req.body), dateReviverUTC) as IUpdateDocumentRequest;
        res.statusCode = 405;

        if (!document.type) { res.json(`Document type not specified`); return; }
        if (!options.searchKey && options.updateType !== 'Insert') { res.json(`Search key is not specified`); return; }

        let docServer: DocumentBaseServer | null = null;
        let flatDocument: any = null;
        let existDoc = await lib.doc.findDocumentByKey(options.searchKey, tx);

        if (!existDoc && options.updateType === 'Update')
          res.json(`Document not found by: ${JSON.stringify(options.searchKey)}`);
        else if (existDoc && existDoc.length > 1)
          res.json(`Found ${existDoc.length} documents by ${JSON.stringify(options.searchKey)}`);
        else if (existDoc && existDoc.length === 1) {
          if (options.updateType === 'Insert') {
            res.json(`Document already exists with ${JSON.stringify(options.searchKey)}`);
          } else {
            flatDocument = existDoc[0];
            res.statusCode = 200;
          }
        } else if (!existDoc && options.updateType.includes('Insert')) res.statusCode = 200;
        else res.json(`Bad arguments`);

        if (res.statusCode !== 200) return;

        if (!flatDocument) {
          flatDocument = { id: document.id || (await lib.util.GUID()) };
          if (document.type === 'Document.Operation') {
            flatDocument.Operation = document.doc.Operation;
            if (!flatDocument.Operation) { res.json(`Value of required field 'Operation' are not filled`); return; };
          }
        }

        docServer = await lib.doc.createDocServer(document.type, flatDocument as any, tx);

        res.statusCode = 405;

        const props = docServer.Props();
        const propsKeys = Object.keys(props);

        const excludedProps = ['doc', 'docByKey', 'serverModule'];

        if (document.docByKeys) {
          const unknowKeys = document.docByKeys
            .filter(keyVal => !propsKeys.includes(keyVal.key))
            .map(keyVal => `${keyVal.key}`)
            .join(',');

          if (unknowKeys.length) {
            res.json(`Incorrect document meta: fields ${unknowKeys} do not exist in document type.`);
            return;
          };

          document.docByKeys
            .forEach(keyVal => docServer![keyVal.key] = keyVal.value)

        } else if (document.doc) {
          const unknowKeys = Object.keys(document.doc)
            .filter(key => !propsKeys.includes(key))
            .map(key => `${key}`)
            .join(',');

          if (unknowKeys.length) {
            res.json(`Incorrect document meta: fields ${unknowKeys} do not exist in document type.`);
            return;
          };

          Object.keys(document.doc)
            .forEach(key => docServer![key] = document.doc[key])
        }

        Object.keys(document)
          .filter(key => !excludedProps.includes(key))
          .forEach(key => docServer![key] = document[key]);

        const emptyProps = propsKeys
          .filter(key => props[key].required && !docServer![key])
          .map(key => `${key}`)
          .join(',');

        if (emptyProps.length) { res.json(`Values of required fields are not filled: ${emptyProps}`); return; };

        if (docServer.type === 'Document.Operation' && !docServer['Operation']) { res.json(`Value of required field 'Operation' are not filled`); return; };

        if (options.commands) {
          for (const command of options.commands) {
            if (docServer[command]) {
              try {
                await docServer[command]()
              } catch (ex) {
                res.json(`Error on executing "${command}"`);
                return;
              }
            } else {
              res.json(`Unknow command "${command}"`);
              return;
            }
          }
        };

        await lib.doc.saveDoc(
          docServer,
          tx,
          options.queueFlow,
          { withExchangeInfo: !!(docServer['ExchangeBase'] || docServer['ExchangeCode']) }
        );

        const docByKeys = Object.keys(docServer['doc']).map(key => ({ key: key, value: docServer!['doc'][key] }));
        delete docServer['doc'];
        res.statusCode = 200;
        const noSqlDoc = await lib.doc.noSqlDocument(docServer);
        noSqlDoc!.docByKeys = docByKeys;
        res.json(noSqlDoc);

      } catch (ex) { res.statusCode = 405; res.json(`Unknow error: ${JSON.stringify(ex.message)}`); }
      finally { await lib.util.adminMode(false, tx); }
    });
  } catch (err) { next(err); }
});

router.delete('/document/:id', async (req: Request, res: Response, next: NextFunction) => {
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
        res.json({ Status: 'OK' })
      } catch (ex) { res.status(500).json({ ...ex, Error: ex.message }) }
      finally { await lib.util.adminMode(false, tx); }
    });
  } catch (err) { next(err); }
});

router.post('/executeOperation', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      await lib.util.adminMode(true, tx);
      try {
        let err = '';
        let { operationId, method, args } = JSON.parse(req.body);
        let oper: DocumentBaseServer | null = null;
        if (!operationId) err = 'Empty arg "operationId"';
        else oper = await lib.doc.createDocServerById(operationId as any, tx);
        if (!oper) err = `Operation with id ${operationId} does not exist`;
        else {

          const method = args.method || 'RESTMethod';
          let result = {};
          const docModule: (args: { [key: string]: any }) => Promise<any> = oper['serverModule'][args.method || 'RESTMethod'];
          if (typeof docModule === 'function') result = await docModule(args);
          res.json(result);
        }
      } catch (ex) { throw new Error(ex); }
      finally { await lib.util.adminMode(false, tx); }
    });
  } catch (err) { next(err); }
});