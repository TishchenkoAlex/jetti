import * as Queue from 'bull';
import { ColumnDef } from './column';
import { DocumentOptions, Ref } from './document';
import { AllDocTypes, AllTypes } from './documents.types';
import { FormListFilter, FormListOrder, FormListSettings } from './user.settings';
import { simpleTypes } from './Types/Types.factory';

export interface MenuItem { type: string; icon: string; label: string; items?: MenuItem[]; routerLink?: string[]; }

export interface DocListRequestBody {
  id: string; type: AllDocTypes; command: string; count: number; offset: number;
  filter: FormListFilter[];
  order: FormListOrder[];
  listOptions?: DocListOptions;
}
export interface DocListOptions {
  withHierarchy: boolean;
  hierarchyDirectionUp: boolean;
}

export interface Continuation { first: { id: Ref, type: string } | null; last: { id: Ref, type: string } | null; }
export interface DocListResponse { data: any[]; continuation: Continuation; }

export interface MenuItem { type: string; description: string; icon: string; menu: string; }

export interface RefValue {
  id: string;
  type: string;
  code: string;
  value: string | number | boolean;
}

export interface PatchValue { [x: string]: (boolean | number | string | RefValue | {}); }

export interface IJettiTask {
  id: number;
  description: string;
  user: string;
  progress: number;
  status: boolean;
  error: string;
  url: string;
  name: string;
}

export interface IEvent {
  id: string;
  startedAt: Date;
  endedAt: Date;
  description: string;
  user: string;
  error: string;
  progress: number;
  url: string;
}

export interface IJob {
  id: string;
  progress: number;
  opts: { [x: string]: any };
  delay: number;
  timestamp: number;
  returnvalue: any;
  attemptsMade: number;
  failedReason: string;
  finishedOn: number;
  processedOn: number;
  data: { [x: string]: any };
  message: string;
}

export interface IJobs {
  Active: IJob[];
  Completed: IJob[];
  Delayed: IJob[];
  Failed: IJob[];
  Waiting: IJob[];
  RepeatableJobs?: Queue.JobInformation[];
}

export interface IJWTPayload {
  email: string;
  description: string;
  isAdmin: boolean;
  roles: any[];
  env: { [x: string]: string };
}

export interface IAccount extends IJWTPayload {
  created: string;
  password: string;
  status: string;
}

export interface ILoginResponse {
  account: IAccount | undefined;
  token: string;
  photo?: any;
}

export interface ITree {
  id: string;
  description: string;
  parent: string;
}

export interface ISuggest {
  id: string;
  type: AllTypes;
  code: string;
  value: string;
  deleted: boolean;
  description?: string;
}

export function calculateDescription(description: string, date: Date | string, code: string, group = '') {
  const Group = group ? '(' + group + ')' : '';
  const value = `${description} ${Group} #${code}, ${date ?
    new Date(date).toISOString() :
    (new Date()).toISOString()}`;
  return value;
}

export interface IViewModel {
  schema: { [x: string]: any };
  columnsDef: ColumnDef[];
  metadata: DocumentOptions;
  settings: FormListSettings;
  model: { [x: string]: any };
}



export class Type {

  public static isOperation(type: string) {
    return type && type.startsWith('Operation.');
  }

  public static isDocument(type: string) {
    return type && (type.startsWith('Document.') || this.isOperation(type));
  }

  public static isCatalog(type: string) {
    return type && type.startsWith('Catalog.');
  }

  public static isType(type: string) {
    return type && type.startsWith('Types.');
  }

  public static isJournal(type: string) {
    return type && type.startsWith('Journal.');
  }

  public static isForm(type: string) {
    return type && type.startsWith('Form.');
  }

  // stored types
  public static isRefType(type: string) {
    return this.isDocument(type) || this.isCatalog(type);
  }

  public static defaultValue(type: AllTypes) {
    if (this.isRefType(type)) return null;
    const simple = simpleTypes().find(e => e.type === type);
    return simple ? simple.defaultValue : null;
  }
}
