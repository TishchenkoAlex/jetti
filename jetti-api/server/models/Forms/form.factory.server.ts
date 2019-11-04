import { FormBase } from './form';
import { FormTypes } from './form.types';
import FormPostServer from './Form.Post.server';
import FormBatchServer from './Form.Batch.server';
import { MSSQL } from '../../mssql';

export interface IServerForm {
  Execute(tx: MSSQL, user: string): Promise<FormBase>;
}

export type FormBaseServer = FormBase & IServerForm;

export function createFormServer<T extends FormBaseServer>(init?: Partial<FormBase>) {
  if (init && init.type) {
    const doc = RegisteredServerForms.get(init.type);
    if (doc) {
      const result = <T>new doc;
      Object.assign(result, init);
      return result;
    }
  }
  throw new Error(`FORM type ${init!.type} is not registered`);
}

const RegisteredServerForms = new Map<FormTypes, typeof FormBase>([
  ['Form.Post', FormPostServer],
  ['Form.Batch', FormBatchServer]
]);
