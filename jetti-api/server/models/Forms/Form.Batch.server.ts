import { JQueue } from '../Tasks/tasks';
import { MSSQL } from '../../mssql';
import { FormBatch } from './Form.Batch';
import { IServerForm } from './form.factory.server';

export default class FormBatchServer extends FormBatch implements IServerForm {

  async Execute() {
    const data = {
      job: { id: `batch_${this.company}`, description: `[Batch actualisation for ${this.company}]` },
      user: this.user,
      company: this.company,
    };

    const activeJobs = await JQueue.getActive();
    const jobs = activeJobs.filter(j => j.data.job.id === `batch_${this.company}`);
    if (jobs.length) throw new Error(`job ${jobs[0].data.job.id} is already running`);

    await JQueue.add(data);
    return this;
  }
}
