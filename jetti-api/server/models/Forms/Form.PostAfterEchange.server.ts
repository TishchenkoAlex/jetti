import { JQueue } from '../Tasks/tasks';
import { IServerForm } from './form.factory.server';
import { PostAfterEchange } from './FormPostAfterEchange';
import { lib } from '../../std.lib';
import { CatalogCompany } from '../Catalogs/Catalog.Company';
import { MSSQL } from '../../mssql';
import { TASKS_POOL } from '../../sql.pool.tasks';

export default class PostAfterEchangeServer extends PostAfterEchange implements IServerForm {
  async Execute() {
    const data = {
      job: { id: 'sync', description: '[IIKO exchange]' },
      user: null,
      company: this.company,
    };

    const sdbq = new MSSQL(this.user, TASKS_POOL);
    const companyObject = await lib.doc.byIdT<CatalogCompany>(this.company, sdbq);

    const activeJobs = await JQueue.getActive();
    const jobs = activeJobs.filter(j => j.data.job.id === 'sync' && j.data.company === this.company);
    if (jobs.length) throw new Error(`job ${jobs[0].data.job.id} for ${companyObject && companyObject.description} is already running`);

    await JQueue.add(data);
    return this;
  }
}
