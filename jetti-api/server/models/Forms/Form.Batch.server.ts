import { JQueue } from '../Tasks/tasks';
import { MSSQL } from '../../mssql';
import { FormBatch } from './Form.Batch';
import { IServerForm } from './form.factory.server';
import { lib } from '../../std.lib';
import { IJWTPayload } from '../../routes/auth';

export default class FormBatchServer extends FormBatch implements IServerForm {

  async Execute(tx: MSSQL, user: IJWTPayload) {
    const data = {
      job: { id: 'batch', description: 'Batch ' },
      userId: user.email,
      user: user,
      company: this.company,
      tx: tx
    };
    await JQueue.add(data);
    return this;
  }
}
