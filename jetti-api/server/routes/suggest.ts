import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { ISuggest } from '../models/common-types';
import { User } from './user.settings';
import { SDB } from './middleware/db-sessions';

export const router = express.Router();

router.get('/suggest/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    await sdb.tx(async tx => {
      const query = `
        SELECT id as id, description as value, code as code, type as type
        FROM "Documents" WHERE id = @p1`;
      const data = await tx.oneOrNone<ISuggest>(query, [req.params.id]);
      res.json(data);
    });
  } catch (err) { next(err); }
});

router.get('/suggest/:type/isfolder/*', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const type = req.params.type as string;
    const query = `
      SELECT top 10 id as id, description as value, code as code, type as type
      FROM "Documents" WHERE type = '${type}' AND isfolder = 1
      AND (description LIKE @p1 OR code LIKE @p1)
      ORDER BY type, description, code`;

    await sdb.tx(async tx => {
      const data = await tx.manyOrNone<any>(query, ['%' + req.params[0] + '%']);
      res.json(data);
    });
  } catch (err) { next(err); }
});

router.get('/suggest/:type/*', async (req: Request, res: Response, next: NextFunction) => {
  const sdb = SDB(req);
  const type = req.params.type as string;
  const query = `
    SELECT top 10 id as id, description as value, code as code, type as type
    FROM "Documents" WHERE type = '${type}' AND isfolder = 0
    AND (description LIKE @p1 OR code LIKE @p1)
    ORDER BY type, description, code`;
  try {
    await sdb.tx(async tx => {
      const data = await tx.manyOrNone<ISuggest>(query, ['%' + req.params[0] + '%']);
      res.json(data);
    });
  } catch (err) { next(err); }
});
