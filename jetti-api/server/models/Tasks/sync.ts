import * as Queue from 'bull';
import { lib } from '../../std.lib';
import { MSSQL } from '../../mssql';
import { Ref } from '../document';
import { TASKS_POOL } from '../../sql.pool.tasks';

export default async function (job: Queue.Job) {
  const params = job.data;
  const sdbq = new MSSQL(params.user, TASKS_POOL);

  await lib.util.postMode(true, sdbq);
  try {
    const query = `
      SELECT id, date, description
      FROM [dbo].[Documents]
      WHERE posted = 0 and deleted = 0
        AND [ExchangeBase] IS NOT NULL
      ORDER BY date;
    `;
    const docs = await sdbq.manyOrNone<{ date: Date, description: string, id: Ref }>(query);
    if (docs.length) {
      const TaskList: any[] = [];
      const count = docs.length; let offset = 0;
      job.data.job['total'] = docs.length;
      await job.update(job.data);
      await job.progress(0);
      while (offset < count) {
        let i = 0;
        for (i = 0; i < 50; i++) {
          if (!docs[i + offset]) break;
          const q = lib.doc.postById(docs[i + offset].id, sdbq);
          TaskList.push(q);
        }
        await Promise.all(TaskList);
        TaskList.length = 0;
        offset = offset + 1;
        job.data.message = `${offset * i} of ${count}, last doc = [${docs[offset].description}]`;
        await job.update(job.data);
        await job.progress(offset * i);
      }
    }
    await job.progress(100);
  } catch (ex) { throw ex; }
  finally { await lib.util.postMode(false, sdbq); }
}

