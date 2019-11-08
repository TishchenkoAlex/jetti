import * as Queue from 'bull';
import { lib } from '../../std.lib';
import { MSSQL } from '../../mssql';
import { Ref } from '../document';
import { TASKS_POOL } from '../../sql.pool.tasks';
import { createDocumentServer } from '../documents.factory.server';
import { DocTypes } from '../documents.types';
import { postDocument, updateDocument } from '../../routes/utils/post';

export default async function (job: Queue.Job) {
  const params = job.data;
  const sdbq = new MSSQL(params.user, TASKS_POOL);

  await lib.util.postMode(true, sdbq);
  try {
    const queryForGroupedDays = `
      SELECT DISTINCT CAST([date] AS DATE) date FROM [dbo].[Accumulation]
      WHERE document IN (
        SELECT document FROM [Register.Accumulation.Inventory.Protocol]
        WHERE (1 = 1)
          AND company = '${params.company}'
      )
      ORDER BY 1;`;
    const dates = await sdbq.manyOrNone<{ date: Date }>(queryForGroupedDays);

    if (dates.length) {
      const queryForTotalDocs = `
        SELECT COUNT(DISTINCT document) TotalDocs
        FROM [dbo].[Register.Accumulation.Inventory] r
        WHERE (1 = 1)
          AND r.company = '${params.company}'
          AND r.date >= '${dates[0].date.toJSON()}';`;
      const TotalDocsRec = await sdbq.oneOrNone<{ TotalDocs: number }>(queryForTotalDocs);

      if (TotalDocsRec) {
        job.data.job['total'] = TotalDocsRec.TotalDocs;
        await job.update(job.data);
        let progress = 0;
        let counter = 0;
        for (const day of dates) {
          await sdbq.tx(async tx => {
            const query = `
              DECLARE @DOCS table(id uniqueidentifier, date datetime, description NVARCHAR(150));

              INSERT INTO @DOCS
                SELECT DISTINCT r.document, d.date, d.description
                FROM [dbo].[Register.Accumulation.Inventory] r
                LEFT JOIN Documents d ON d.id = r.document
                WHERE (1 = 1)
                  AND r.company = '${params.company}'
                  AND r.date = '${day.date.toJSON()}';

              UPDATE Documents SET posted = 0 WHERE id IN (SELECT id FROM @DOCS);
              DELETE FROM [dbo].[Register.Accumulation.Inventory]
              WHERE (1 = 1)
                AND company = '${params.company}'
                AND date = '${day.date.toJSON()}';

              SELECT * FROM @DOCS ORDER BY date, description;`;
            const docs = await tx.manyOrNone<{ date: Date, description: string, id: Ref }>(query);
            for (const row of docs) {
              const doc = (await lib.doc.byId(row.id, tx))!;
              const serverDoc = await createDocumentServer(doc.type as DocTypes, doc, tx);
              await postDocument(serverDoc, tx);
              await tx.none(`
                UPDATE Documents SET posted = 1 WHERE id = '${doc.id}';
                DELETE FROM [Register.Accumulation.Inventory.Protocol] WHERE document = '${doc.id}';`);
              progress = Math.round((++counter) / TotalDocsRec.TotalDocs * 100);
              job.data.message = `${serverDoc.description}, ${progress}%`;
              await job.update(job.data);
              await job.progress(progress);
            }
            job.data.message = `commit date: ${day.date.toJSON()} ${progress}%`;
            await job.update(job.data);
            await job.progress(progress);
          });
        }
      }
    }
  } catch (ex) { throw ex; }
  finally { await lib.util.postMode(false, sdbq); }
}

