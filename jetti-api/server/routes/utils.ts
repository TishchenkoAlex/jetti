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

router.get('/batch/actual', async (req: Request, res: Response, next: NextFunction) => {
  try {
    const sdb = SDB(req);
    res.json(await sdb.manyOrNone(`
      SELECT s.*, d.description [document.description], c.description [company.description] FROM (
        SELECT s.*,
        (SELECT TOP 1 document FROM [dbo].[Register.Accumulation.Inventory] WHERE date = s.date and company = s.[company.id]) [document.id]
        FROM (
          SELECT i.company [company.id], MIN(i.date) date
          FROM [dbo].[Register.Accumulation.Inventory.Protocol] p
          INNER JOIN [dbo].[Register.Accumulation.Inventory] i ON p.document = i.document
          GROUP BY  i.company) s
        ) s
        LEFT JOIN Documents d ON s.[document.id] = d.id
        LEFT JOIN Documents c ON s.[company.id] = c.id
      ORDER BY date;`));
  } catch (err) { next(err); }
});
