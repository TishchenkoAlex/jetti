import { Ref } from '../document';
import { MSSQL } from '../../mssql';
import { FormBase } from './form';
import { ICallRequest } from './form.factory';

export interface IServerForm {
  Execute(tx: MSSQL, user: string): Promise<FormBase>;
}
