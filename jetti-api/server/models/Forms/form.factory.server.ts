import { FormBase } from './form';
import { FormTypes } from './form.types';
import { dateReviverUTC } from '../../fuctions/dateReviver';
import PostAfterEchangeServer from './Form.PostAfterEchange.server';
import { FormBusinessProcessTasks } from './Form.BusinessProcessTasks';
import FormSearchAndReplaceServer from './Form.SearchAndReplace.Server';
import FormObjectsGroupModifyServer from './Form.ObjectsGroupModify.Server';
import FormQueueManagerServer from './Form.QueueManager.server';

export interface IServerForm {
  Execute(): Promise<FormBase>;
}

export type FormBaseServer = FormBase & IServerForm;

export function createFormServer<T extends FormBaseServer>(init?: Partial<FormBase>) {
  if (init && init.type) {
    const doc = RegisteredServerForms.get(init.type);
    if (doc) {
      const result = <T>new doc(init.user!);
      Object.assign(result, JSON.parse(JSON.stringify(init), dateReviverUTC));
      return result;
    }
  }
  throw new Error(`createFormServer: FORM type ${init!.type} is not registered`);
}

const RegisteredServerForms = new Map<FormTypes, typeof FormBase>([
  ['Form.PostAfterEchange', PostAfterEchangeServer],
  ['Form.BusinessProcessTasks', FormBusinessProcessTasks],
  ['Form.SearchAndReplace', FormSearchAndReplaceServer],
  ['Form.ObjectsGroupModify', FormObjectsGroupModifyServer],
  ['Form.QueueManager', FormQueueManagerServer],
]);
