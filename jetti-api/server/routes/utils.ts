import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { sdb } from '../mssql';

export const router = express.Router();

router.get('/operations/groups', async (req: Request, res: Response, next: NextFunction) => {
  try {
    res.json(await sdb.manyOrNone(`
      SELECT id, type, description as value, code FROM "Documents" WHERE type = 'Catalog.Operation.Group' ORDER BY description`));
  } catch (err) { next(err); }
});
