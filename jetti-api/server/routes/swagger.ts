import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { dateReviverUTC } from '../fuctions/dateReviver';
import { IFlatDocument } from '../models/documents.factory';
import { createDocumentServer, DocumentBaseServer } from '../models/documents.factory.server';
import { DocTypes } from '../models/documents.types';
import { lib } from './../std.lib';
import { postDocument, insertDocument, updateDocument, unpostDocument } from './utils/post';
import { MSSQL } from '../mssql';
import { SDB } from './middleware/db-sessions';

export const router = express.Router();

export interface IUpdateDocumentRequest {
  document: IFlatDocument,
  options: IUpdateOptions,
}

export interface IUpdateOptions {

  async: boolean,
  saveMode: 'Post' | 'Save',
  skipExisting: boolean, //"Existing documents will be skipped (default: false)",
  queueOptions: string //"QueueOptions in JSON"

}

// Get raw document by id
router.get('/document/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      const result = await lib.doc.byId(req.params.id, tx);
      if (result && req.query.asArray === 'true') res.json(Object.entries(result));
      res.json(result);
    });
  } catch (err) { next(err); }
});

router.post('/document', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      await lib.util.adminMode(true, tx);
      try {
        const { document, options } = JSON.parse(JSON.stringify(req.body), dateReviverUTC) as IUpdateDocumentRequest;
        if (options.skipExisting && document.id && (await lib.doc.byId(document.id, tx))) {
          res.json(document); return;
        }
        if (!document.code) document.code = await lib.doc.docPrefix(document.type, tx);
        const serverDoc = await createDocumentServer(document.type as DocTypes, document, tx);
        if (serverDoc.timestamp) {
          await updateDocument(serverDoc, tx);
          if (serverDoc.posted && serverDoc.isDoc && options.saveMode === 'Post') {
            await unpostDocument(serverDoc, tx);
            await postDocument(serverDoc, tx);
          }
        } else {
          await insertDocument(serverDoc, tx);
        }
        res.json(serverDoc);
      } catch (ex) { throw new Error(ex); }
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