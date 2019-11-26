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
      SELECT TOP 1000 d.id, d.date, d.description
      FROM [dbo].[Documents] d
      WHERE (1 = 1) AND
        d.company = '${params.company}' AND
        d.posted = 0 and d.deleted = 0 and d.type LIKE 'Document.%' AND
        d.[ExchangeBase] IS NOT NULL
      ORDER BY d.date;`;
    const docs = await sdbq.manyOrNone<{ date: Date, description: string, id: Ref, companyName: string }>(query);
    job.data.message = `found ${docs.length} docs for ${params.companyName}, id=${params.company}`;
    await job.progress(0);
    if (docs.length) {
      const TaskList: any[] = [];
      const count = docs.length;
      let offset = 0;
      job.data.job['total'] = docs.length;
      job.data.message = `job started for ${params.companyName}, total dosc = ${docs.length} documents`;
      await job.update(job.data);
      await job.progress(0);
      while (offset < count) {
        for (let i = 0; i < 50; i++) {
          if (!docs[offset]) break;
          const q = lib.doc.postById(docs[offset].id, sdbq);
          TaskList.push(q);
          offset = offset + 1;
        }
        await Promise.all(TaskList);
        TaskList.length = 0;
        job.data.message = `${params.companyName}, ${offset} of ${count}, last doc -> [${docs[offset - 1].description}]`;
        await job.update(job.data);
        await job.progress(offset);
      }
    }
    job.data.message = `job complete for ${params.companyName}`;
    await job.progress(100);
  } catch (ex) { throw ex; }
  finally { await lib.util.postMode(false, sdbq); }
}

