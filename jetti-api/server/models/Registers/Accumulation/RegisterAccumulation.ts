import { SQLGenegator } from '../../../fuctions/SQLGenerator.MSSQL';
import { PropOptions, Props, Ref, symbolProps } from './../../document';
import { RegisterAccumulationTypes } from './factory';
import { v1 } from 'uuid';

export interface RegisterAccumulationOptions {
  type: RegisterAccumulationTypes;
  description: string;
}

export function JRegisterAccumulation(props: RegisterAccumulationOptions) {
  return function classDecorator<T extends new (...args: any[]) => {}>(constructor: T) {
    Reflect.defineMetadata(symbolProps, props, constructor);
    return class extends constructor {
      type = props.type;
    };
  };
}
export class RegisterAccumulation {
  @Props({ type: 'string', required: true, hidden: true, hiddenInList: true, value: 'newid()' })
  id = v1().toLocaleUpperCase();

  @Props({ type: 'string', required: false, hidden: true, hiddenInList: true })
  parent = null;

  @Props({ type: 'boolean', required: true, value: '0' })
  kind = true;

  @Props({ type: 'boolean', required: true, value: '0' })
  calculated = false;

  @Props({ type: 'number', required: true, hidden: true, hiddenInList: true, value: '1' })
  exchangeRate = 1;

  @Props({ type: 'string', hidden: true, hiddenInList: true, required: true })
  type: RegisterAccumulationTypes | null = null;

  @Props({ type: 'datetime', required: true, dimension: true })
  date = new Date();

  @Props({ type: 'Types.Document', hidden: true, hiddenInList: true, required: true })
  document: Ref = null;

  @Props({ type: 'Catalog.Company', required: true, dimension: true })
  company: Ref = null;

  constructor(init?: Partial<RegisterAccumulation>) {
    if (!init) return;
    Object.assign(this, init);
    this.type = (this.Prop() as RegisterAccumulationOptions).type;
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

