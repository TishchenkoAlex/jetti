import { JQueue } from '../Tasks/tasks';
import { IServerForm } from './form.factory.server';
import { PostAfterEchange } from './FormPostAfterEchange';
import { Job } from 'bull';

export default class PostAfterEchangeServer extends PostAfterEchange implements IServerForm {
  async Execute() {
    const data = {
      job: { id: 'sync', description: '[IIKO exchange]' },
      user: this.user,
      company: this.company,
    };

    const activeJobs = await JQueue.getActive();
    const jobs = activeJobs.filter(j => j.data.job.id === 'sync');
    if (jobs.length) throw new Error(`job ${jobs[0].data.job.id} is already running`);

    await JQueue.add(data);
    return this;
  }
}
