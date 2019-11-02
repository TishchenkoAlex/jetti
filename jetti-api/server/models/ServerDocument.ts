import { PatchValue } from '../models/common-types';
import { MSSQL } from '../mssql';
import { DocumentBase, Ref } from './document';
import { PostResult } from './post.interfaces';


export abstract class DocumentBaseServer extends DocumentBase implements ServerDocument {

  onCreate(tx: MSSQL): Promise<DocumentBase> {
    throw new Error('Method not implemented.');
  }

  beforeSave(tx: MSSQL): Promise<DocumentBase> {
    throw new Error('Method not implemented.');
  }

  afterSave(tx: MSSQL): Promise<DocumentBase> {
    throw new Error('Method not implemented.');
  }

  beforePost(tx: MSSQL): Promise<DocumentBase> {
    throw new Error('Method not implemented.');
  }

  onPost(tx: MSSQL): Promise<PostResult> {
    throw new Error('Method not implemented.');
  }

  afterPost(tx: MSSQL): Promise<DocumentBase> {
    throw new Error('Method not implemented.');
  }

  beforeDelete(tx: MSSQL): Promise<DocumentBase> {
    throw new Error('Method not implemented.');
  }

  afterDelete(tx: MSSQL): Promise<DocumentBase> {
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

  beforeSave?(tx: MSSQL): Promise<DocumentBase>;
  afterSave?(tx: MSSQL): Promise<DocumentBase>;

  beforePost?(tx: MSSQL): Promise<DocumentBase>;
  onPost?(tx: MSSQL): Promise<PostResult>;
  afterPost?(tx: MSSQL): Promise<DocumentBase>;

  beforeDelete?(tx: MSSQL): Promise<DocumentBase>;
  afterDelete?(tx: MSSQL): Promise<DocumentBase>;

  onValueChanged?(prop: string, value: any, tx: MSSQL): Promise<PatchValue | {} | { [key: string]: any }>;
  onCommand?(command: string, args: any, tx: MSSQL): Promise<any>;

  baseOn?(id: Ref, tx: MSSQL): Promise<DocumentBase>;
}
