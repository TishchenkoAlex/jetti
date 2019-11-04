import { JQueue } from '../Tasks/tasks';
import { FormPost } from './Form.Post';
import { MSSQL } from '../../mssql';
import { ICallRequest } from './form.factory';
import { IServerForm } from './serverFrom';

export default class FormPostServer extends FormPost implements IServerForm {

  async Execute(tx: MSSQL, user: string) {
    const endDate = new Date(this.EndDate);
    endDate.setHours(23, 59, 59, 999);

    const result = (await JQueue.add({
      job: { id: 'post', description: '(job) post Invoices' },
      user: user,
      type: this.type,
      company: this.company,
      StartDate: this.StartDate,
      EndDate: endDate
    }, { jobId: 'FormPostServer' }));
    return this;
  }

}


