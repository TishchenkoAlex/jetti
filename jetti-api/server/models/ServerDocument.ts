import { PatchValue } from '../models/common-types';
import { MSSQL } from '../mssql';
import { DocumentBase, Ref } from './document';
import { DocTypes } from './documents.types';
import { PostResult } from './post.interfaces';

export interface INoSqlDocument {
  id: Ref;
  date: Date;
  type: DocTypes;
  code: string;
  description: string;
  company: Ref;
  user: Ref;
  posted: boolean;
  deleted: boolean;
  isfolder: boolean;
  parent: Ref;
  info: string;
  timestamp: Date;
  doc: { [x: string]: any };
}

export interface IFlatDocument {
  id: Ref;
  date: Date;
  type: DocTypes;
  code: string;
  description: string;
  company: Ref;
  user: Ref;
  posted: boolean;
  deleted: boolean;
  isfolder: boolean;
  parent: Ref;
  info: string;
  timestamp: Date | null;
}

export abstract class DocumentBaseServer extends DocumentBase implements ServerDocument {

  onCreate(tx: MSSQL): Promise<DocumentBase> {
    throw new Error('Method not implemented.');
  }
  beforePost(tx: MSSQL): Promise<DocumentBase> {
    throw new Error('Method not implemented.');
  }
  onPost(tx: MSSQL): Promise<PostResult> {
    throw new Error('Method not implemented.');
  }
  afterPost(tx: MSSQL): Promise<void> {
    throw new Error('Method not implemented.');
  }
  beforeDelete(tx: MSSQL): Promise<void> {
    throw new Error('Method not implemented.');
  }
  afterDelete(tx: MSSQL): Promise<void> {
    throw new Error('Method not implemented.');
  }
  onValueChanged(prop: string, value: any, tx: MSSQL): Promise<PatchValue> {
    throw new Error('Method not implemented.');
  }
  onCommand(command: string, args: any, tx: MSSQL): Promise<any> {
    throw new Error('Method not implemented.');
  }
  baseOn(id: Ref, tx: MSSQL): Promise<DocumentBase> {
    throw new Error('Method not implemented.');
  }

}

export interface ServerDocument {
  onCreate?(tx: MSSQL): Promise<DocumentBase>;
  beforePost?(tx: MSSQL): Promise<DocumentBase>;
  onPost?(tx: MSSQL): Promise<PostResult>;
  afterPost?(tx: MSSQL): Promise<void>;

  beforeDelete?(tx: MSSQL): Promise<void>;
  afterDelete?(tx: MSSQL): Promise<void>;

  onValueChanged?(prop: string, value: any, tx: MSSQL): Promise<PatchValue | {} | { [key: string]: any }>;
  onCommand?(command: string, args: any, tx: MSSQL): Promise<any>;

  baseOn?(id: Ref, tx: MSSQL): Promise<DocumentBase>;
}
