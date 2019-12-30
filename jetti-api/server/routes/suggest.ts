import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { ISuggest } from '../models/common-types';
import { SDB } from './middleware/db-sessions';
import { StorageType } from '../models/document';
import { FormListFilter } from '../models/user.settings';

export const router = express.Router();

router.post('/suggest/:type', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const type = req.params.type as string;
    const filter = req.query.filter as string;
    const filters = req.body.filters as FormListFilter[];

    let filterQuery = `(1 = 1)`;
    filters.forEach(f => {
      const value = f.right.id ? f.right.id : f.right;
      filterQuery += `
    AND [${f.left}] = N'${value}'`;
    });

    const query = `
    SELECT top 10 id as id, description as value, code as code, type as type, isfolder
    FROM [${type}.v] WITH (NOEXPAND) WHERE ${filterQuery}
    AND (description LIKE @p1 OR code LIKE @p1)
    ORDER BY type, description, code`;

    const data = await sdb.manyOrNone<ISuggest>(query, ['%' + filter + '%']);
    res.json(data);
  } catch (err) { next(err); }
});
