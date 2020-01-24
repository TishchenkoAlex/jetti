import { PropOptions, symbolProps, Props, Ref } from '../document';
import { FormTypes } from './form.types';
import { v1 } from 'uuid';
import { IJWTPayload } from '../common-types';

export interface FormOptions {
  type: FormTypes;
  description: string;
  icon: string;
  menu: string;
  commands?: { label: string, icon: string, command: () => any }[];
}

export function JForm(props: FormOptions) {
  return function classDecorator<T extends new(...args: any[]) => {}>(constructor: T) {
    Reflect.defineMetadata(symbolProps, props, constructor);
    return class extends constructor {
      type = props.type;
    };
  };
}

export class FormBase {

  constructor  (user?: IJWTPayload) {
    if (!user) this.user = { email: '', description: '', env: {}, isAdmin: false, roles: [] };
    else this.user = user;
  }

  @Props({ type: 'string', hidden: true, hiddenInList: true })
  user: IJWTPayload;

  @Props({ type: 'string', hidden: true, hiddenInList: true })
  id = v1().toLocaleUpperCase();

  @Props({ type: 'string', hidden: true, hiddenInList: true })
  type: FormTypes;

  @Props({ type: 'datetime', order: 1, hidden: true})
  date = new Date();

  @Props({ type: 'string', hidden: true, order: 2, style: { width: '135px' } })
  code = '';

  @Props({ type: 'string', order: 3, hidden: true, style: { width: '300px' } })
  description = '';

  @Props({ type: 'Catalog.Company', order: 4, hidden: true })
  company: Ref = null;

  @Props({ type: 'boolean', hidden: true, hiddenInList: true })
  posted = false;

  @Props({ type: 'boolean', hidden: true, hiddenInList: true })
  deleted = false;

  @Props({ type: 'Types.Subcount', hidden: true, hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'boolean', hidden: true, hiddenInList: true })
  isfolder = false;

  @Props({ type: 'string', hidden: true,  hiddenInList: true, order: -1, controlType: 'textarea' })
  info = '';

  @Props({ type: 'datetime', hiddenInList: true, order: -1, hidden: true })
  timestamp: Date | null = null;
  private targetProp(target: Object, propertyKey: string): PropOptions {
    const result = Reflect.getMetadata(symbolProps, target, propertyKey);
    return result;
  }

  Prop(propertyKey: string = 'this'): PropOptions | FormOptions {
    if (propertyKey === 'this') {
      return Reflect.getMetadata(symbolProps, this.constructor);
    } else {
      return Reflect.getMetadata(symbolProps, this.constructor.prototype, propertyKey);
    }
  }

  Props() {

    const proto = new this.constructor.prototype.constructor;

    const p = this.Prop() as FormOptions;

    const result: { [x: string]: PropOptions } = {};
    for (const prop of Object.keys(proto)) {
      const Prop = proto.targetProp(this, prop);
      if (!Prop) { continue; }
      result[prop] = Object.assign({}, Prop);
      const metadata = proto.Prop() as FormOptions;
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
}
