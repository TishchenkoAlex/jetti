import { JQueue } from '../Tasks/tasks';
import { FormPost } from './Form.Post';
import { IServerForm } from './form.factory.server';

export default class FormPostServer extends FormPost implements IServerForm {

  async Execute() {
    const endDate = new Date(this.EndDate);
    endDate.setHours(23, 59, 59, 999);

    const result = await JQueue.add({
      job: { id: 'post', description: '(job) post Invoices' },
      user: this.user,
      type: this.type,
      company: this.company,
      StartDate: this.StartDate,
      EndDate: endDate
    }, { jobId: 'FormPostServer' });

    return this;
  }

}


