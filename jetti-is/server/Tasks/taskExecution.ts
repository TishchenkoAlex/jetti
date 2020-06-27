import * as Queue from 'bull';
// import { TASKS_POOL } from '../../sql.pool.tasks';

export default async function (job: Queue.Job) {
  // const params = job.data;
  // const sdbq = new MSSQL(TASKS_POOL, params.user);

  try {
    // await lib.util.adminMode(true, sdbq);
    // const query = `
    //   SELECT d.id, d.date, d.description
    //   FROM [dbo].[Documents] d
    //   WHERE (1 = 1) AND
    //     d.company = @p1
    //     ${params.StartDate ? ' AND date between @p2 AND @p3 ' : ''}
    //     ${params.Operation ? ` AND JSON_VALUE(doc, '$.Operation') = @p4 ` : ``}
    //     ${params.rePost ? ' AND posted = 1' : ' AND posted = 0 '} AND
    //     d.deleted = 0 and d.type LIKE 'Document.%' AND
    //     (d.[user] <> 'E050B6D0-FAED-11E9-B75B-A35013C043AE' OR d.[user] IS NULL)
    //   ORDER BY d.date;`;
    // const docs = await sdbq.manyOrNone<{ date: Date, description: string, id: Ref, companyName: string }>(
    //   query, [params.company, params.StartDate, params.EndDate, params.Operation]);
    // job.data.message = `found ${docs.length} docs for ${params.companyName}, id=${params.company}`;
    // await job.progress(0);
    // if (docs.length) {
    //   const TaskList: any[] = [];
    //   const count = docs.length;
    //   let offset = 0;
    //   job.data.job['total'] = docs.length;
    //   job.data.message = `job started for ${params.companyName}, total dosc = ${docs.length} documents`;
    //   await job.update(job.data); await job.progress(0);
    //   for (const doc of docs) {
    //     offset = offset + 1;
    //     job.data.message = `${params.companyName}, ${offset} of ${count}, last doc -> [${doc.description}]`;
    //     try {
    //       await sdbq.tx(async tx => { await lib.doc.postById(doc.id, tx); });
    //     } catch (ex) {
    //       job.data.message = `!${ex}, ${job.data.message}`;
    //     }
    //     await job.update(job.data); await job.progress(offset);
    //   }
    // }
    // job.data.message = `job complete for ${params.companyName}`;
    // await job.progress(100);
  } catch (ex) { throw ex; }
  finally {

  }
}
