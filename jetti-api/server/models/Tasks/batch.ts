import * as Queue from 'bull';
import { lib } from '../../std.lib';
import { MSSQL } from '../../mssql';
import { Ref } from '../document';

export default async function (job: Queue.Job) {
  await job.progress(0);
  const params = job.data;
  const tx: MSSQL = job.data.tx;

  const list = await tx.manyOrNone<{id: Ref, date: Date, description: string}>(`
    DECLARE @DOCS table(id uniqueidentifier, date datetime, description NVARCHAR(150));

    INSERT INTO @DOCS
    SELECT DISTINCT r.document, d.date, d.description  FROM [dbo].[Register.Accumulation] r
    WHERE type = 'Register.Accumulation.Inventory'
      AND company = ${params.company}
      AND date > (SELECT MIN(date) FROM [batch.status] WHERE company = ${params.company})
    LEFT JOIN Documents d ON d.id = r.document;

    DELETE FROM [dbo].[Register.Accumulation]
    WHERE type = 'Register.Accumulation.Inventory'
      company = ${params.company} AND
      date > (SELECT MIN(date) FROM [batch.status] WHERE company = ${params.company})

    SELECT * FROM @DOCS ORDER BY date, description;
  `);
  const endDate = new Date();
  endDate.setUTCHours(23, 59, 59, 999);

  const TaskList: any[] = [];
  const count = list.length; let offset = 0;
  job.data.job['total'] = list.length;
  await job.update(job.data);
    while (offset < count) {
      let i = 0;
      for (i = 0; i < 5; i++) {
        if (!list[i + offset]) break;
        const q = lib.doc.postById(list[i + offset].id, tx);
        TaskList.push(q);
      }
      offset = offset + i;
      await Promise.all(TaskList);
      TaskList.length = 0;
      await job.progress(Math.round(offset / count * 100));
    }
  await job.progress(100);
}
