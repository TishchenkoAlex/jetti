import { JQueue } from '../Tasks/tasks';
import { FormPost } from './Form.Post';
import { IServerForm } from './form.factory.server';

export default class FormPostServer extends FormPost implements IServerForm {

  async Execute() {
    const endDate = new Date(this.EndDate);
    endDate.setHours(23, 59, 59, 999);
    const activeJobs = await JQueue.getActive();
    const jobs = activeJobs.filter(j => j.data.job.id === `post` && j.data.company === this.company);
    if (jobs.length === 0) {
      const result = await JQueue.add({
        job: { id: 'post', description: '(job) post' },
        user: this.user,
        type: this.type,
        company: this.company,
        StartDate: this.StartDate,
        EndDate: endDate
      });
    }
    return this;
  }

}


