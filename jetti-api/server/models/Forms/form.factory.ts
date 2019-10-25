import { FormPost } from './Form.Post';
import { FormBase } from './form';
import { FormTypes } from './form.types';

export interface IRegisteredForm<T extends FormBase> {
  type: FormTypes;
  class: T;
}

export function createForm(type: FormTypes) {
  const doc = RegisteredForms.find(el => el.type === type);
  if (doc) {
    const createInstance = <T extends FormBase>(c: new () => T): T => new c();
    const result = createInstance(doc.class);
    return result;
  } else throw new Error(`FORM type ${type} is not registered`);
}

export const RegisteredForms: IRegisteredForm<any>[] = [
  { type: 'Form.Post', class: FormPost },
];


