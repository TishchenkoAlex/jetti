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
  return function classDecorator<T extends new (...args: any[]) => {}>(constructor: T) {
    Reflect.defineMetadata(symbolProps, props, constructor);
    return class extends constructor {
      type = props.type;
    };
  };
}

export type PropOption = keyof PropOptions;

export class FormBase {

  constructor(user?: IJWTPayload) {
    if (!user) this.user = { email: '', description: '', env: {}, isAdmin: false, roles: [] };
    else this.user = user;
  }

  @Props({ type: 'string', hidden: true, hiddenInList: true })
  user: IJWTPayload;

  @Props({ type: 'string', hidden: true, hiddenInList: true })
  id = v1().toLocaleUpperCase();

  @Props({ type: 'string', hidden: true, hiddenInList: true })
  type: FormTypes;

  @Props({ type: 'datetime', order: 1, hidden: true })
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

  @Props({ type: 'string', hidden: true, hiddenInList: true, order: -1, controlType: 'textarea' })
  info = '';

  @Props({ type: 'datetime', hiddenInList: true, order: -1, hidden: true })
  timestamp: Date | null = null;

  @Props({
    type: 'table', required: false, label: 'Dynamic props', order: 77
  })
  dynamicProps: DynamicProps[] = [new DynamicProps];

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

    this.DynamicPropsAdd(result);
    this.DynamicPropsMod(result);
    this.DynamicPropsDel(result);

    this.Props = () => result;
    return result;
  }

  //   getDynamicProps() {
  //     if (!this['schema']) return undefined;
  //     const props: { [x: string]: PropOptions } = this['schema'];
  //     const keys = Object.keys(props);
  //     const result = {};
  //     for (const key of keys) {
  //       const prop = props[key];
  //       if (prop.dynamic) result[key] = prop;
  //       else if (prop.type === 'table') {
  //         const table = prop[key];
  //         const columns = Object.keys(table);
  //         for (const col of columns) {
  //           if (table[col].dynamic) {
  //             result[key] = table;
  //             result[key][col] = table[col];
  //           }
  //         }
  //       }
  //     }
  //     return result;
  //   }

  DynamicPropsAdd(props: { [x: string]: PropOptions }) {
    // add tables
    const addTable = this.dynamicProps.filter(e => e.Kind === 'add' && e.Table);
    const tables = [...new Set(addTable.map(e => e.Table))];
    for (const tableName of tables) {
      const tableProps = addTable.filter(e => e.Table === tableName && !e.Filed);
      const tableOb = { type: 'table' };
      tableOb[tableName] = {};
      for (const tableProp of tableProps) {
        tableOb[tableProp.Options] = JSON.parse(tableProp.OptionsValue);
      }
      const tableFiledsProps = addTable.filter(e => e.Table === tableName && e.Filed);
      const tableFileds = [...new Set(tableFiledsProps.map(e => e.Filed))];
      for (const tableFiledName of tableFileds) {
        const tableFiledProps = addTable.filter(e => e.Table === tableName && e.Filed === tableFiledName);
        const tableFieldOb = {};
        for (const tableFiledProp of tableFiledProps) {
          tableFieldOb[tableFiledProp.Options] = JSON.parse(tableFiledProp.OptionsValue);
        }
        tableOb[tableName][tableFiledName] = tableFieldOb;
      }
      props[tableName] = tableOb as any;
      if (!Object.keys(this).includes(tableName)) this[tableName] = [];
    }

    // add fields
    const addfileds = this.dynamicProps.filter(e => e.Kind === 'add' && !e.Table);
    const fields = [...new Set(addfileds.map(e => e.Filed))];
    for (const fieldName of fields) {
      const filedProps = addfileds.filter(e => e.Filed === fieldName);
      const fieldOb = {};
      for (const filedProp of filedProps) {
        fieldOb[filedProp.Options] = JSON.parse(filedProp.OptionsValue);
      }
      props[fieldName] = fieldOb as any;
      if (!Object.keys(this).includes(fieldName)) this[fieldName] = null;
    }

  }

  DynamicPropsMod(props: { [x: string]: PropOptions }) {
    // mod tables
    const dynamicTables = this.dynamicProps.filter(e => e.Kind === 'mod' && e.Table);
    const tables = [...new Set(dynamicTables.map(e => e.Table))];
    for (const tableName of tables) {
      const tableProps = dynamicTables.filter(e => e.Table === tableName && !e.Filed);
      const tableOb = props[tableName];
      for (const tableProp of tableProps) {
        tableOb[tableProp.Options] = JSON.parse(tableProp.OptionsValue);
      }
      const tableFiledsProps = dynamicTables.filter(e => e.Table === tableName && e.Filed);
      const tableFileds = [...new Set(tableFiledsProps.map(e => e.Filed))];
      for (const tableFiledName of tableFileds) {
        const tableFiledProps = dynamicTables.filter(e => e.Table === tableName && e.Filed === tableFiledName);
        const tableFieldOb = tableOb[tableName][tableFiledName];
        for (const tableFiledProp of tableFiledProps) {
          tableFieldOb[tableFiledProp.Options] = JSON.parse(tableFiledProp.OptionsValue);
        }
        tableOb[tableName][tableFiledName] = tableFieldOb;
      }
      props[tableName] = tableOb as any;
    }

    // mod fields
    const dynamicFileds = this.dynamicProps.filter(e => e.Kind === 'mod' && !e.Table);
    const fields = [...new Set(dynamicFileds.map(e => e.Filed))];
    for (const fieldName of fields) {
      const filedProps = dynamicFileds.filter(e => e.Filed === fieldName);
      const fieldOb = props[fieldName];
      for (const filedProp of filedProps) {
        fieldOb[filedProp.Options] = JSON.parse(filedProp.OptionsValue);
      }
      props[fieldName] = fieldOb as any;
    }

  }

  DynamicPropsDel(props: { [x: string]: PropOptions }) {

    const dynamicTables = this.dynamicProps.filter(e => e.Kind === 'del' && e.Table);
    const tables = [...new Set(dynamicTables.map(e => e.Table))];
    for (const tableName of tables) {
      const tableProps = dynamicTables.filter(e => e.Table === tableName && !e.Filed);
      if (tableProps.length) { delete props[tableName]; continue; } // del tables
      const tableFiledsProps = dynamicTables.filter(e => e.Table === tableName && e.Filed);
      const tableFileds = [...new Set(tableFiledsProps.map(e => e.Filed))];
      for (const tableFiledName of tableFileds) {
        delete props[tableName][tableName][tableFiledName]; // del tableы columns
      }
    }

    // del fields
    const dynamicFileds = this.dynamicProps.filter(e => e.Kind === 'del' && !e.Table);
    const fields = [...new Set(dynamicFileds.map(e => e.Filed))];
    for (const fieldName of fields) {
      { delete props[fieldName]; continue; }
    }

  }

  DynamicPropsPush(kind: 'add' | 'mod' | 'del', options: PropOption, optionsValue: any, filed = '', table = '', setId = '') {
    this.dynamicProps.push({
      Kind: kind, Table: table, Filed: filed, Options: options.toString(), OptionsValue: JSON.stringify(optionsValue), SetId: setId
    });
  }

  DynamicPropsClearSet(setId) {
    this.dynamicProps = this.dynamicProps.filter(e => e.SetId !== setId);
  }

  DynamicPropsAddForObject(object: any, propName: string, setId: string) {
    if (object instanceof Array) {
      this.DynamicPropsAddForArray(object, propName, setId);
    }
  }

  DynamicPropsAddForArray(object: Array<any>, propName: string, setId: string) {
    if (!object.length) return;
    Object.keys(object[0]).forEach(key => {
      this.DynamicPropsPush('add', 'type', getInnerSimpleTypeByObject(object[0][key]), key, propName, setId);
    });
  }
}

export function getInnerSimpleTypeByObject(obj: any): string {
  const type = typeof obj;
  if (type !== 'object') return type;
  if (obj instanceof Date) return 'datetime';
  if (obj instanceof Array) return 'array';
  return 'string';
}

export class DynamicProps {

  @Props({ type: 'enum', value: ['add', 'mod', 'del'] })
  Kind = '';

  @Props({ type: 'string' })
  Table = '';

  @Props({ type: 'string' })
  Filed = '';

  @Props({ type: 'string' })
  Options = '';

  @Props({ type: 'string' })
  OptionsValue = '';

  @Props({ type: 'string' })
  SetId = '';

}
