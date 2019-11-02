import { sdbq } from '../../mssql';
import { DocTypes } from '../documents.types';
import { JQueue } from '../Tasks/tasks';
import { FormPost } from './Form.Post';
import { FormTypes } from './form.types';

export interface ICallRequest {
  type: FormTypes | DocTypes;
  formView: { [x: string]: any };
  method: string;
  params: any[];
  user: string;
  userID: string;
}

export default class FormPostServer extends FormPost {

  constructor(private CallRequest: ICallRequest) {
    super();
    Object.assign(this, CallRequest);
  }

  async Execute(tx = sdbq, CR: ICallRequest) {
    const endDate = new Date(this.CallRequest.formView.EndDate);
    endDate.setHours(23, 59, 59, 999);

    const result = (await JQueue.add({
      job: { id: 'post', description: '(job) post Invoices' },
      user: this.CallRequest.user,
      type: this.CallRequest.formView.type.id,
      company: this.CallRequest.formView.company.id,
      StartDate: this.CallRequest.formView.StartDate,
      EndDate: endDate
    }, { jobId: 'FormPostServer' }));
  }

}


