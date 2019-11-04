import { JQueue } from '../Tasks/tasks';
import { FormPost } from './Form.Post';
import { MSSQL } from '../../mssql';
import { ICallRequest } from './form.factory';
import { FormBase } from './form';
import { FormBatch } from './Form.Batch';
import { IServerForm } from './serverFrom';

export default class FormBatchServer extends FormBatch implements IServerForm {

  async Execute(tx: MSSQL, user: string) {

    (await JQueue.add({
      job: { id: 'bacth', description: 'Batch ' },
      user: user,
      company: this.company,
    }, { jobId: 'FormBatchServer' }));
    return this;
  }
}
