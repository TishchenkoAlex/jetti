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
    if (!user) this.user = { email: '', description: '', env: {}, isAdmin: false, roles: [] }
    else this.user = user;
  }

  @Props({ type: 'string', hidden: true, hiddenInList: true })
  user: IJWTPayload;

  @Props({ type: 'string', hidden: true, hiddenInList: true })
  id = v1();

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
    const result: { [x: string]: any } = {};
    for (const prop of Object.keys(this)) {
      const Prop = Object.assign({}, this.targetProp(this, prop));
      if (!Prop) { continue; }
      for (const el in result[prop]) {
        if (typeof result[prop][el] === 'function') result[prop][el] = result[prop][el].toString();
      }
      result[prop] = Prop;
      const value = (this as any)[prop];
      if (Array.isArray(value) && value.length) {
        const arrayProp: { [x: string]: any } = {};
        for (const arrProp of Object.keys(value[0])) {
          const PropArr = Object.assign({}, this.targetProp(value[0], arrProp));
          if (!PropArr) { continue; }
          arrayProp[arrProp] = PropArr;
        }
        result[prop][prop] = arrayProp;
      }
    }
    return result;
  }
}
