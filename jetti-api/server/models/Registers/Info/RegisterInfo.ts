import { SQLGenegator } from '../../../fuctions/SQLGenerator.MSSQL';
import { PropOptions, Props, Ref, symbolProps } from './../../document';
import { RegisterInfoTypes } from './factory';

export interface RegisterInfoOptions {
  type: RegisterInfoTypes;
  description: string;
}

export function JRegisterInfo(props: RegisterInfoOptions) {
  return function classDecorator<T extends new (...args: any[]) => {}>(constructor: T) {
    Reflect.defineMetadata(symbolProps, props, constructor);
    return class extends constructor {
      type = props.type;
    };
  };
}
export class RegisterInfo {

  @Props({ type: 'string', hidden: true, hiddenInList: true, required: true })
  type: RegisterInfoTypes | null = null;

  @Props({ type: 'datetime', required: true })
  date: Date;

  @Props({ type: 'Catalog.Company', required: true })
  company: Ref = null;

  @Props({ type: 'Types.Document', hiddenInList: true, required: true })
  document: Ref = null;

  constructor(init: Partial<RegisterInfo>) {
    Object.assign(this, init);
    this.type = (this.Prop() as RegisterInfoOptions).type;
  }

  private targetProp(target: Object, propertyKey: string): PropOptions {
    const result = Reflect.getMetadata(symbolProps, target, propertyKey);
    return result;
  }

  public Prop(propertyKey: string = 'this'): PropOptions | RegisterInfoOptions {
    if (propertyKey === 'this') {
      return Reflect.getMetadata(symbolProps, this.constructor);
    } else {
      return Reflect.getMetadata(symbolProps, this.constructor.prototype, propertyKey);
    }
  }

  Props() {
    const result: { [x: string]: PropOptions } = {};
    for (const prop of Object.keys(this)) {
      const Prop = this.targetProp(this, prop);
      if (!Prop) { continue; }
      result[prop] = Prop;
    }
    return result;
  }

  QueryList() { return SQLGenegator.QueryRegisterInfoList(this.Props(), this.type as string); }
}
