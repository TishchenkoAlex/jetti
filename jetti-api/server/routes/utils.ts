import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { sdb } from '../mssql';
import { User } from './user.settings';

export const router = express.Router();

router.get('/operations/groups', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await sdb.tx(async tx => {
      res.json(await tx.manyOrNone(`
      SELECT id, type, description as value, code FROM "Documents" WHERE type = 'Catalog.Operation.Group' ORDER BY description`));
    }, User(req));
  } catch (err) { next(err); }
});
