import * as Queue from 'bull';
import { lib } from '../../std.lib';
import { MSSQL } from '../../mssql';
import { TASKS_POOL } from '../../sql.pool.tasks';

export default async function (job: Queue.Job) {
  const params = job.data;
  const sdbq = new MSSQL(TASKS_POOL, params.user);

  const onTaskFailed = (Job: Queue.Job, errorText = '') => {
    Job.data.error = errorText;
    Job.update(Job.data);
    throw Error(errorText);
  };

  try {
    await lib.util.adminMode(true, sdbq);
    await job.progress(0);
    if (!job.data.TaskOperation) onTaskFailed(job, `Task operation not defined`);
    const serverDoc = await lib.doc.createDocServerById(job.data.TaskOperation, sdbq);
    job.data.error = '';
    if (!serverDoc) onTaskFailed(job, `Task operation not exist: ${job.data.TaskOperation}`);
    const command = job.data.command || 'executeTask';
    const docModule: (args: { [key: string]: any }) => Promise<void> = serverDoc!['serverModule'][command];
    if (typeof docModule !== 'function') onTaskFailed(job, `Task method not found: ${command}`);
    await docModule({ job: job });
    await job.progress(100);
  } catch (ex) {
    throw ex;
  }
  finally {
    await lib.util.adminMode(false, sdbq);
  }
}
