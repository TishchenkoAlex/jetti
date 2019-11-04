import { FormPost } from './Form.Post';
import { FormBase } from './form';
import { FormTypes } from './form.types';
import { FormBatch } from './Form.Batch';
import { DocTypes } from '../documents.types';

export interface IRegisteredForm<T extends FormBase> {
  type: FormTypes;
  class: T;
}

export interface ICallRequest {
  type: FormTypes | DocTypes;
  formView: { [x: string]: any };
  method: string;
  params: any[];
  user: string;
  userID: string;
}

export function createForm(type: FormTypes) {
  const doc = RegisteredForms.find(el => el.type === type);
  if (doc) {
    const createInstance = <T extends FormBase>(c: new () => T): T => new c();
    const result = createInstance(doc.class);
    return result;
  } else throw new Error(`FORM type ${type} is not registered`);
}

const RegisteredForms: IRegisteredForm<any>[] = [
  { type: 'Form.Post', class: FormPost },
  { type: 'Form.Batch', class: FormBatch },
];


