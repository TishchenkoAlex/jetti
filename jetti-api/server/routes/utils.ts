import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { SDB } from './middleware/db-sessions';

export const router = express.Router();

router.get('/operations/groups', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      res.json(await tx.manyOrNone(`
      SELECT id, type, description as value, code FROM "Documents" WHERE type = 'Catalog.Operation.Group' ORDER BY description`));
    });
  } catch (err) { next(err); }
});
