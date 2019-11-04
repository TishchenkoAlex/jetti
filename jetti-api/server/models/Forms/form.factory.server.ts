import { FormBase } from './form';
import { FormTypes } from './form.types';
import FormPostServer from './Form.Post.server';
import FormBatchServer from './Form.Batch.server';
import { IServerForm } from './serverFrom';

export interface IRegisteredServerForm<T extends FormBase> {
  type: FormTypes;
  class: T;
}

export function createFormServer(type: FormTypes) {
  const doc = RegisteredForms.find(el => el.type === type);
  if (doc) {
    const createInstance = <T extends FormBase & IServerForm>(c: new () => T): T => new c();
    const result = createInstance(doc.class);
    return result;
  } else throw new Error(`FORM type ${type} is not registered`);
}

const RegisteredForms: IRegisteredServerForm<any>[] = [
  { type: 'Form.Post', class: FormPostServer },
  { type: 'Form.Batch', class: FormBatchServer },
];


