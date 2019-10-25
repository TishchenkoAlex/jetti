import { SQLGenegator } from '../../../fuctions/SQLGenerator.MSSQL';
import { PropOptions, Props, Ref, symbolProps } from './../../document';
import { RegisterAccumulationTypes } from './factory';

export interface RegisterAccumulationOptions {
  type: RegisterAccumulationTypes;
  description: string;
}

export function JRegisterAccumulation(props: RegisterAccumulationOptions) {
  return function classDecorator<T extends new(...args: any[]) => {}>(constructor: T) {
    Reflect.defineMetadata(symbolProps, props, constructor);
    return class extends constructor {
      type = props.type;
    };
  };
}
export class RegisterAccumulation {
  query: string;
  @Props({ type: 'boolean', required: true })
  kind: boolean;

  @Props({ type: 'string', hidden: true, hiddenInList: true , required: true})
  type: RegisterAccumulationTypes | null = null;

  @Props({ type: 'datetime', required: true })
  date = new Date();

  @Props({ type: 'Types.Document', hidden: true, hiddenInList: true, required: true })
  document: Ref = null;

  @Props({ type: 'Catalog.Company', required: true })
  company: Ref = null;

  constructor (kind: boolean, public data: { [x: string]: any } = {}) {
    this.kind = kind;
    Object.keys(data).forEach(k => this[k] = data[k]);
  }

  private targetProp(target: Object, propertyKey: string): PropOptions {
    const result = Reflect.getMetadata(symbolProps, target, propertyKey);
    return result;
  }

  public Prop(propertyKey: string = 'this'): PropOptions | RegisterAccumulationOptions {
    if (propertyKey === 'this') {
      return Reflect.getMetadata(symbolProps, this.constructor);
    } else {
      return Reflect.getMetadata(symbolProps, this.constructor.prototype, propertyKey);
    }
  }

  Props() {
    const result: { [x: string]: any } = {};
    for (const prop of Object.keys(this)) {
      const Prop = this.targetProp(this, prop);
      if (!Prop) { continue; }
      result[prop] = Prop;
    }
    return result;
  }

  QueryList() { return SQLGenegator.QueryRegisterAccumulatioList(this.Props(), this.type as string); }
}

