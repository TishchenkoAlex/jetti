import * as Queue from 'bull';
import { MSSQL } from '../../mssql';
import { lib } from '../../std.lib';


export default async function (job: Queue.Job) {
  await job.progress(0);
  const params = job.data;
  const tx: MSSQL = job.data.tx;
  const query = `
    SELECT id FROM "Documents"
    WHERE (1=1) AND
      type = @p1 AND
      company = @p2 AND
      date between @p3 AND @p4
    ORDER BY
      date`;

  const startDate = new Date(params.StartDate);
  startDate.setUTCHours(0, 0, 0, 0);
  const endDate = new Date(params.EndDate);
  endDate.setUTCHours(23, 59, 59, 999);

  const list = await tx.manyOrNone<any>(query, [params.type, params.company, startDate.toJSON(), endDate.toJSON()]);
  const TaskList: any[] = [];
  const count = list.length; let offset = 0;
  job.data.job['total'] = list.length;
  await job.update(job.data);
    while (offset < count) {
      let i = 0;
      for (i = 0; i < 25; i++) {
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
