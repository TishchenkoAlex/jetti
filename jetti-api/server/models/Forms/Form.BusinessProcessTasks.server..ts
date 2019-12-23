import { IServerForm } from './form.factory.server';
import { FormBusinessProcessTasks } from './Form.BusinessProcessTasks';

export default class FormBusinessProcessTasksServer extends FormBusinessProcessTasks implements IServerForm {
  async Execute() {
    return this;
  }
}
