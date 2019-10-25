import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { ISuggest } from '../models/api';
import { sdb } from '../mssql';

export const router = express.Router();

router.get('/suggest/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const query = `
        SELECT id as id, description as value, code as code, type as type
        FROM "Documents" WHERE id = @p1`;
    const data = await sdb.oneOrNone<ISuggest>(query, [req.params.id]);
    res.json(data);
  } catch (err) { next(err); }
});

router.get('/suggest/:type/isfolder/*', async (req: Request, res: Response, next: NextFunction) => {
  let query = '';
  const type = req.params.type as string;
  try {
    query = `
      SELECT top 10 id as id, description as value, code as code, type as type
      FROM "Documents" WHERE type = '${req.params.type}' AND isfolder = 1
      AND (description LIKE @p1 OR code LIKE @p1)
      ORDER BY type, description`;
    const data = await sdb.manyOrNone<any>(query, ['%' + req.params[0] + '%']);
    res.json(data);
  } catch (err) { next(err); }
});

router.get('/suggest/:type/*', async (req: Request, res: Response, next: NextFunction) => {
  let query = '';
  const type = req.params.type as string;
  try {
    query = `
      SELECT top 10 id as id, description as value, code as code, type as type
      FROM "Documents" WHERE type = '${req.params.type}' AND isfolder = 0
      AND (description LIKE @p1 OR code LIKE @p1)
      ORDER BY type, description`;
    const data = await sdb.manyOrNone<ISuggest>(query, ['%' + req.params[0] + '%']);
    res.json(data);
  } catch (err) { next(err); }
});
