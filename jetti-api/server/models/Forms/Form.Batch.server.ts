import { JQueue } from '../Tasks/tasks';
import { MSSQL } from '../../mssql';
import { FormBatch } from './Form.Batch';
import { IServerForm } from './form.factory.server';

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
