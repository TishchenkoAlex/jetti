import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { ISuggest } from '../models/common-types';
import { SDB } from './middleware/db-sessions';
import { FormListFilter, FilterInterval } from '../models/user.settings';
import { filterBuilder } from '../fuctions/filterBuilder';

export const router = express.Router();

router.post('/suggestOld/:type', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const type = req.params.type as string;
    const filter = req.query.filter as string;
    const filters = req.body.filters as FormListFilter[];

    let filterQuery = `(1 = 1)`;
    filters.filter(e => e.right !== undefined).forEach(f => {
      const value = f.right.id ? f.right.id : f.right;
      filterQuery += `
    AND [${f.left}] = N'${value}'`;
    });

    const query = `
    SELECT top 10 id as id, description as value, code as code, type as type, isfolder, deleted
    FROM [${type}.v] WITH (NOEXPAND)
    WHERE ${filterQuery}
    AND (description LIKE @p1 OR code LIKE @p1)
    ORDER BY type, description, deleted, code`;

    const data = await sdb.manyOrNone<ISuggest>(query, ['%' + filter + '%']);
    res.json(data);
  } catch (err) { next(err); }

});


router.post('/suggest/:type', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    const type = req.params.type as string;
    const filterLike = req.query.filter as string;
    const filter = req.body.filters as FormListFilter[];
    const filterQuery = filterBuilder(filter);

    const query = `${filterQuery.tempTable}
    SELECT top 10 id as id, description as value, code as code, type as type, isfolder, deleted
    FROM [${type}.v] WITH (NOEXPAND)
    WHERE ${filterQuery.where}
    AND (description LIKE @p1 OR code LIKE @p1)
    ORDER BY type, description, deleted, code`;

    const data = await sdb.manyOrNone<ISuggest>(query, ['%' + filterLike + '%']);
    res.json(data);
  } catch (err) { next(err); }
});
