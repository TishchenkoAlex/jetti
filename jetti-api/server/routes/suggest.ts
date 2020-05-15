import { DocTypes } from './../models/documents.types';
import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { ISuggest, Type } from '../models/common-types';
import { SDB } from './middleware/db-sessions';
import { FormListFilter } from '../models/user.settings';
import { filterBuilder } from '../fuctions/filterBuilder';
import { createTypes, allTypes } from '../models/Types/Types.factory';
import { createDocument } from '../models/documents.factory';
import { DocumentOptions } from '../models/document';

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
    let query = '';
    if (Type.isType(type)) {
      const select = createTypes(type as any).getTypes()
        .map(el => (
          {
            type: el,
            description: (createDocument(el as DocTypes).Prop() as DocumentOptions).description
          }));
      query = suggestQuery(select);
    } else if (type === 'Catalog.Subcount') query = suggestQuery(allTypes(), 'Catalog.Subcount');
    else query = `${filterQuery.tempTable}
    SELECT top 10 id as id, description as value, code as code, description + ' (' + code + ')' as description, type as type, isfolder, deleted
    FROM [${type}.v] WITH (NOEXPAND)
    WHERE ${filterQuery.where}`;
    query = query.concat(
      `AND (description LIKE @p1 OR code LIKE @p1)
    ORDER BY type, description, deleted, code`);
    const data = await sdb.manyOrNone<ISuggest>(query, ['%' + filterLike + '%']);
    res.json(data);
  } catch (err) { next(err); }
});

function suggestQuery(select: { type: string; description: string; }[], type = '') {
  let query = '';
  for (const row of select) {
    query += `SELECT
      N'${type ? row.description : ''}' "value",
      '${row.type}' AS "id",
      '${type || row.type}' "type",
      '${row.type}' "code",
      N'${row.description}' + ' ('+ '${row.type}' + ')' "description",
      CAST(1 AS BIT) posted,
      CAST(0 AS BIT) deleted,
      CAST(0 AS BIT) isfolder,
      NULL parent
      UNION ALL\n`;
  }
  query = `SELECT * FROM (${query.slice(0, -(`UNION ALL\n`).length)}) d WHERE (1=1)\n`;
  return query;
}
