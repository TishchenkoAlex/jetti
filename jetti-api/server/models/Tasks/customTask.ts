import * as Queue from 'bull';
import { lib } from '../../std.lib';
import { MSSQL } from '../../mssql';
import { TASKS_POOL } from '../../sql.pool.tasks';

export default async function (job: Queue.Job) {
  const params = job.data;
  const sdbq = new MSSQL(TASKS_POOL, params.user);

  try {
    await lib.util.adminMode(true, sdbq);

    await job.progress(0);

    await job.update(job.data);
    await job.progress(0);

    await job.progress(100);
  } catch (ex) {
    throw ex;
  }
  finally {
    await lib.util.adminMode(false, sdbq);
  }
}
