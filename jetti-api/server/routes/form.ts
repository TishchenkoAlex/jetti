import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { dateReviverUTC } from '../fuctions/dateReviver';
import { SQLGenegator } from '../fuctions/SQLGenerator.MSSQL';
import { MSSQL } from '../mssql';
import { SDB } from './middleware/db-sessions';
import { createFormServer } from '../models/Forms/form.factory.server';
import { FormTypes } from '../models/Forms/form.types';
import { FormBase } from '../models/Forms/form';
import { User } from './user.settings';
import { lib } from '../std.lib';
import { IViewModel } from '../models/common-types';
import { DocumentOptions } from '../models/document';
import { FormListSettings } from '../models/user.settings';
import { ColumnDef } from '../models/column';

export const router = express.Router();

function noSqlDocument(flatDoc: FormBase) {
  if (!flatDoc) throw new Error(`noSqlDocument: source is null!`);
  const { id, date, type, code, description, company, user, posted, deleted, isfolder, parent, info, timestamp, ...doc } = flatDoc;
  return { id, date, type, code, description, company, user, posted, deleted, isfolder, parent, info, timestamp, doc };
}

export async function buildViewModel<T>(ServerDoc: FormBase, tx: MSSQL) {
  const viewModelQuery = SQLGenegator.QueryObjectFromJSON(ServerDoc.Props());
  const NoSqlDocument = JSON.stringify(noSqlDocument(ServerDoc));
  return await tx.oneOrNone<T>(viewModelQuery, [NoSqlDocument]);
}

router.post('/form/:type/execute', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const user = User(req);
    const doc: FormBase = JSON.parse(JSON.stringify(req.body), dateReviverUTC);
    doc.type = req.params.type as FormTypes;
    doc.user = user;
    const serverDoc = createFormServer(doc);
    await serverDoc.Execute();
    const view = await buildViewModel(serverDoc, sdb);
    res.json(view);
  } catch (err) { next(err); }
});

router.post('/form/:type/:method', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const user = User(req);
    const doc: FormBase = JSON.parse(JSON.stringify(req.body), dateReviverUTC);
    doc.type = req.params.type as FormTypes;
    doc.user = user;
    const serverDoc = createFormServer(doc);
    await serverDoc[req.params.method]();
    serverDoc.user = null  as any;
    const result: IViewModel = {
      metadata: serverDoc.Prop() as DocumentOptions,
      schema: serverDoc.Props(),
      model: (await buildViewModel<FormBase>(serverDoc, sdb))!,
      columnsDef: [] as ColumnDef[],
      settings: new FormListSettings(),
    };
    res.json(result);
  } catch (err) { next(err); }
});

router.post('/form/:type/nonmodel/:method', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const user = User(req);
    const doc: FormBase = JSON.parse(JSON.stringify(req.body), dateReviverUTC);
    doc.type = req.params.type as FormTypes;
    doc.user = user;
    const serverDoc = createFormServer(doc);
    res.json(await serverDoc[req.params.method]());
  } catch (err) { next(err); }
});

