import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { dateReviverUTC } from '../fuctions/dateReviver';
import { SQLGenegator } from '../fuctions/SQLGenerator.MSSQL';
import { IFlatDocument } from '../models/documents.factory';
import { User } from './user.settings';
import { MSSQL } from '../mssql';
import { SDB } from './middleware/db-sessions';
import { createFormServer } from '../models/Forms/form.factory.server';
import { FormTypes } from '../models/Forms/form.types';
import { FormBase } from '../models/Forms/form';

export const router = express.Router();

async function buildViewModel(ServerDoc: FormBase, tx: MSSQL) {
  const viewModelQuery = SQLGenegator.QueryObjectFromJSON(ServerDoc.Props());
  const NoSqlDocument = JSON.stringify(ServerDoc);
  return await tx.oneOrNone<{ [key: string]: any }>(viewModelQuery, [NoSqlDocument]);
}

// Select documents list for UI (grids/list etc)
router.post('/execute', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const user = User(req);
    const doc: IFlatDocument = JSON.parse(JSON.stringify(req.body), dateReviverUTC);
    const type = doc.type as FormTypes;
    const serverDoc = createFormServer(type);
    serverDoc.Execute(sdb, user.email);
    const view = await buildViewModel(serverDoc, sdb);
    res.json(view);
  } catch (err) { next(err); }
});
