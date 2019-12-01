import * as express from 'express';
import { NextFunction, Request, Response } from 'express';
import { ISuggest } from '../models/common-types';
import { User } from './user.settings';
import { SDB } from './middleware/db-sessions';
import { StorageType } from '../models/document';

export const router = express.Router();

router.get('/suggest/:type', async (req: Request, res: Response, next: NextFunction) => {
  const sdb = SDB(req);
  const type = req.params.type as string;
  const filter = req.query.filter as string;
  const storageType = req.query.storageType as StorageType;

  let storageTypeFilter = '(1 = 1)';
  if (storageType === 'folders') storageTypeFilter = 'isfolder = 1';
  else if (storageType === 'items') storageTypeFilter = 'isfolder = 0';

  const query = `
    SELECT top 10 id as id, description as value, code as code, type as type, isfolder
    FROM "Documents" WHERE type = N'${type}' AND ${storageTypeFilter}
    AND (description LIKE @p1 OR code LIKE @p1)
    ORDER BY type, description, code`;

  try {
    await sdb.tx(async tx => {
      const data = await tx.manyOrNone<ISuggest>(query, ['%' + filter + '%']);
      res.json(data);
    });
  } catch (err) { next(err); }
});
