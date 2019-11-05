import * as Queue from 'bull';
import { lib } from '../../std.lib';
import { MSSQL } from '../../mssql';
import { Ref } from '../document';
import { TASKS_POOL } from '../../sql.pool.tasks';
import { createDocumentServer } from '../documents.factory.server';
import { DocTypes } from '../documents.types';
import { postDocument } from '../../routes/utils/post';

export default async function (job: Queue.Job) {
  await job.progress(0);
  const params = job.data;
  const sdbq = new MSSQL(params.user, TASKS_POOL);

  job.data.message = 'unpost all docs....';
  await job.progress(0);

  await sdbq.tx(async tx => {
    try {
      await lib.util.postMode(true, tx);

      const query = `
      DECLARE @DOCS table(id uniqueidentifier, date datetime, description NVARCHAR(150));

      INSERT INTO @DOCS
      SELECT DISTINCT r.document, d.date, d.description  FROM [dbo].[Accumulation] r
      LEFT JOIN Documents d ON d.id = r.document
      WHERE r.type = 'Register.Accumulation.Inventory'
        AND r.company = '${params.company}'
        AND r.date > (SELECT MIN(date) FROM [batch.status] WHERE company = '${params.company}');

      DELETE FROM [dbo].[Accumulation]
        WHERE type = 'Register.Accumulation.Inventory'
        AND company = '${params.company}' AND
        date > ISNULL((SELECT MIN(date) FROM [batch.status] WHERE company = '${params.company}'), cast(-53690 as datetime))

      UPDATE Documents SET posted = 0 WHERE id IN (SELECT id FROM @DOCS);
      SELECT * FROM @DOCS ORDER BY date, description;`;

      const list = await tx.manyOrNone<{ id: Ref, date: Date, description: string }>(query);

      job.data.message = 'post all docs....';
      await job.progress(0);
      const endDate = new Date();
      endDate.setUTCHours(23, 59, 59, 999);

      job.data.job['total'] = list.length;
      await job.update(job.data);
      let i = 0;
      for (const row of list) {
        const doc = (await lib.doc.byId(row.id, tx))!;
        const serverDoc = await createDocumentServer(doc.type as DocTypes, doc, tx);
        await postDocument(serverDoc, tx);
        job.data.message = serverDoc.description;
        await job.progress(Math.round(i / list.length * 100));
        i++;
      }
      const query2 = `UPDATE Documents SET posted = 1 HERE id IN (SELECT id FROM @DOCS);`;
      await tx.none(query);
      job.data.message = 'commit....';
    } catch (ex) {  await job.discard() ; throw ex; }
    finally { await job.progress(100); await lib.util.postMode(false, tx);  }
  });
}
