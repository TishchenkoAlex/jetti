import { FormObjectsGroupModify } from './Form.ObjectsGroupModify';
import { FormBase } from './form';
import { FormTypes } from './form.types';
import { PostAfterEchange } from './Form.PostAfterEchange';
import { FormBusinessProcessTasks } from './Form.BusinessProcessTasks';
import { FormSearchAndReplace } from './Form.SearchAndReplace';
import { FormQueueManager } from './Form.QueueManager';

export function createForm<T extends FormBase>(init?: Partial<FormBase>) {
  if (init && init.type) {
    const doc = RegisteredForms.get(init.type);
    if (doc) {
      const result = <T>new doc();
      Object.assign(result, init);
      return result;
    }
  }
  throw new Error(`createForm: FORM type ${init && init.type} is not registered.`);
}

export const RegisteredForms = new Map<FormTypes, typeof FormBase>([
  ['Form.PostAfterEchange', PostAfterEchange],
  ['Form.SearchAndReplace', FormSearchAndReplace],
  ['Form.BusinessProcessTasks', FormBusinessProcessTasks],
  ['Form.ObjectsGroupModify', FormObjectsGroupModify],
  ['Form.QueueManager', FormQueueManager],
]);
