import 'reflect-metadata';
import { v1 } from 'uuid';
import { IFlatDocument } from './documents.factory';
import { AllTypes, DocTypes, PrimitiveTypes } from './documents.types';

export interface OwnerRef { dependsOn: string; filterBy: string; }
export interface ICommand { command: string; label: string; color?: string; icon: string; }
export type StorageType = 'folders' | 'elements' | 'all';

export interface PropOptions {
  type: AllTypes | AllTypes[];
  controlType?: PrimitiveTypes;
  label?: string;
  required?: boolean;
  readOnly?: boolean;
  hidden?: boolean;
  hiddenInList?: boolean;
  hiddenInForm?: boolean;
  order?: number;
  style?: { [x: string]: any };
  owner?: OwnerRef[] | null;
  totals?: number;
  change?: boolean;
  onChange?: Function;
  onChangeServer?: boolean;
  value?: any;
  unique?: boolean;
  dimension?: boolean;
  resource?: boolean;
  storageType?: StorageType;
}

export interface Relation { name: string; type: DocTypes; field: string; }

export interface DocumentOptions {
  type: DocTypes;
  description: string;
  icon: string;
  menu: string;
  dimensions?: { [x: string]: AllTypes }[];
  prefix?: string;
  commands?: ICommand[];
  presentation?: 'code' | 'description';
  hierarchy?: 'folders' | 'elements';
  copyTo?: DocTypes[];
  relations?: Relation[];
}

export type Ref = string | null;
export const symbolProps = Symbol('Props');

export function Props(props: PropOptions) {
  return Reflect.metadata(symbolProps, props);
}

export function JDocument(props: DocumentOptions) {
  return function classDecorator<T extends new (...args: any[]) => {}>(constructor: T) {
    Reflect.defineMetadata(symbolProps, props, constructor);
    return class extends constructor {
      type = props.type;
    };
  };
}

export class DocumentBase {

  @Props({ type: 'string', hidden: true, hiddenInList: true })
  id = v1();

  @Props({ type: 'string', hidden: true, hiddenInList: true })
  type: DocTypes;

  @Props({ type: 'datetime', order: 1 })
  date = new Date();

  @Props({ type: 'string', required: true, order: 2, style: { width: '135px' } })
  code = '';

  @Props({ type: 'string', order: 3, required: true, style: { width: '300px' } })
  description = '';

  @Props({ type: 'Catalog.Company', order: 4, required: true, onChangeServer: true , style: { width: '250px' }})
  company: Ref = null;

  @Props({ type: 'Catalog.User', hiddenInList: true, order: -1 })
  user: Ref = null;

  @Props({ type: 'boolean', hidden: true, hiddenInList: true })
  posted = false;

  @Props({ type: 'boolean', hidden: true, hiddenInList: true })
  deleted = false;

  @Props({ type: 'Types.Subcount', hidden: true, hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'boolean', hidden: true, hiddenInList: true })
  isfolder = false;

  @Props({ type: 'string', hiddenInList: true, order: -1, controlType: 'textarea' })
  info = '';

  @Props({ type: 'datetime', hiddenInList: true, order: -1, hidden: true })
  timestamp: Date | null = null;

  @Props({ type: 'Document.WorkFlow', hiddenInList: true, order: -1 })
  workflow: Ref = null;

  private targetProp(target: Object, propertyKey: string): PropOptions {
    const result = Reflect.getMetadata(symbolProps, target, propertyKey);
    return result;
  }

  Prop(propertyKey: string = 'this'): PropOptions | DocumentOptions {
    if (propertyKey === 'this') {
      return Reflect.getMetadata(symbolProps, this.constructor);
    } else {
      return Reflect.getMetadata(symbolProps, this.constructor.prototype, propertyKey);
    }
  }

  get isDoc() { return this.type && this.type.startsWith('Document.'); }
  get isCatalog() { return this.type && this.type.startsWith('Catalog.'); }
  get isType() { return this.type && this.type.startsWith('Types.'); }
  get isJornal() { return this.type && this.type.startsWith('Journal.'); }

  Props() {

    const proto = new this.constructor.prototype.constructor;

    this.targetProp(proto, 'description').hidden = proto.isDoc;
    this.targetProp(proto, 'date').hidden = proto.isCatalog;
    this.targetProp(proto, 'date').required = proto.isDoc;
    this.targetProp(proto, 'company').required = proto.isCatalog !== true;
    const p = this.Prop() as DocumentOptions;
    if (p && p.hierarchy === 'folders') this.targetProp(proto, 'parent').storageType = 'folders';
    else if (p && p.hierarchy === 'elements') this.targetProp(proto, 'parent').storageType = 'elements';
    else this.targetProp(proto, 'parent').storageType = 'elements';

    const result: { [x: string]: PropOptions } = {};
    for (const prop of Object.keys(proto)) {
      const Prop = proto.targetProp(this, prop);
      if (!Prop) { continue; }
      result[prop] = Object.assign({}, Prop);
      const metadata = proto.Prop() as DocumentOptions;
      if (metadata && metadata.hierarchy === undefined) metadata.hierarchy = 'elements';
      if (prop === 'code') {
        if (metadata && metadata.prefix) {
          result[prop].label = (Prop.label || prop) + ' (auto)';
          result[prop].required = false;
        }
      }
      for (const el in result[prop]) {
        if (typeof result[prop][el] === 'function') result[prop][el] = result[prop][el].toString();
      }
      const value = (proto as any)[prop];
      if (Array.isArray(value) && value.length) {
        const arrayProp: { [x: string]: any } = {};
        for (const arrProp of Object.keys(value[0])) {
          const PropArr = proto.targetProp(value[0], arrProp);
          if (!PropArr) { continue; }
          arrayProp[arrProp] = Object.assign({}, PropArr);
          for (const el in arrayProp[arrProp]) {
            if (typeof arrayProp[arrProp][el] === 'function') arrayProp[arrProp][el] = arrayProp[arrProp][el].toString();
          }
        }
        result[prop][prop] = arrayProp;
      }
    }
    this.Props = () => result;
    return result;
  }

  map(doc: IFlatDocument) {
    if (doc) Object.assign(this, doc);
  }

}
