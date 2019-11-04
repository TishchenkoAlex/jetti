import { FormPost } from './Form.Post';
import { FormBase } from './form';
import { FormTypes } from './form.types';
import { FormBatch } from './Form.Batch';

export function createForm<T extends FormBase>(init?: Partial<FormBase>) {
  if (init && init.type) {
    const doc = RegisteredForms.get(init.type);
    if (doc) {
      const result = <T>new doc;
      Object.assign(result, init);
      return result;
    }
  }
  throw new Error(`FORM type ${init!.type} is not registered.`);
}

const RegisteredForms = new Map<FormTypes, typeof FormBase>([
  ['Form.Post', FormPost],
  ['Form.Batch', FormBatch]
]);
