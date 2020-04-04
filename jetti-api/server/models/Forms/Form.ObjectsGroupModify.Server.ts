import { IServerForm } from './form.factory.server';
import { FormObjectsGroupModify } from './Form.ObjectsGroupModify';

export default class FormObjectsGroupModifyServer extends FormObjectsGroupModify implements IServerForm {

  async Execute() {
    return this;
  }

}
