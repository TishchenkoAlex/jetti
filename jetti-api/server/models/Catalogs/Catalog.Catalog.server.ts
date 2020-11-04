import { DocTypes } from './../documents.types';
import { CatalogCatalog, Dimension, Parameter } from './Catalog.Catalog';
import { IServerDocument } from './../documents.factory.server';
import { MSSQL } from '../../mssql';
import { PropOptions, DocumentBase, DocumentOptions } from '../document';
import { getAdminTX, lib } from '../../std.lib';
import { riseUpdateMetadataEvent, IDynamicProps } from '../Dynamic/dynamic.common';
import { x100DATA_POOL } from '../../sql.pool.x100-DATA';
import { Type } from '../type';


export class CatalogCatalogServer extends CatalogCatalog implements IServerDocument {

  async onCommand(command: string, args: any, tx: MSSQL): Promise<{ [x: string]: any }> {
    await this[command](args, tx);
    return this;
  }

  async updateSQLViews() {
    await lib.meta.updateSQLViewsByType(this.typeString as any);
  }

  async createSequence() {
    const err = await getAdminTX().metaSequenceCreate(`Sq.${this.typeString}`);
    if (err) throw Error(err);
  }

  async updateSQLViewsX100DATA() {
    await lib.meta.updateSQLViewsByType(this.typeString as any, new MSSQL(x100DATA_POOL), false);
  }

  async riseUpdateMetadataEvent() {
    await riseUpdateMetadataEvent();
  }

  getPropsAsParameter(propsName: string, props: { [x: string]: any }) {
    const res: Parameter = new Parameter;
    const paramPropsKeys = Object.keys(res);
    const paramProps = {};
    res.parameter = propsName;
    res.type = props.type.toString();
    res.label = props.label || propsName;
    res.required = props.required || false;
    res.order = props.order || 0;
    res.change = props.change || '';
    Object.keys(props)
      .filter(key => !paramPropsKeys.includes(key) && key !== propsName)
      .forEach(key => paramProps[key] = props[key]);
    if (Object.keys(paramProps).length) {
      res.Props = JSON.stringify(paramProps);
    }
    if (res.type === 'table')
      res.tableDef = JSON.stringify(props[propsName]);
    return res;
  }

  async fillByType(_: any, tx: MSSQL) {
    if (!this.typeString) throw new Error('Type is not defined');

    const mapDimension = (dimension: any) =>
      ({ name: Object.keys(dimension)[0], type: dimension[Object.keys(dimension)[0]] });

    const doc = await lib.doc.createDocServer(this.typeString as any, undefined, tx, false);
    const prop = doc.Prop();
    const thisProp = this.Prop();
    const thisPropKeys = Object.keys(thisProp).filter(e => e !== 'type');
    Object.keys(prop)
      .filter(key => thisPropKeys.includes(key))
      .forEach(key => this[key] = prop[key]);
    this.relations = prop['relations'];
    this.dimensions = prop['dimensions'] ? prop['dimensions'].map(e => mapDimension(e)) : [];
    this.Parameters = [];
    const props = doc.Props();
    const commonProps = [...Object.keys((new DocumentBase).Props()), 'type'];
    const propsKeys = Object.keys(props).filter(key => !commonProps.includes(key));
    this.Parameters = propsKeys.map(key => this.getPropsAsParameter(key, props[key]));

    return this;
  }

  async beforeDelete(tx: MSSQL) { return this; }

  async getDynamicMetadata(): Promise<IDynamicProps> {
    return { type: this.typeString, Prop: await this.getProp(), Props: await this.getProps() };
  }

  async getProp(): Promise<Function> {

    return (): DocumentOptions => {
      const mapDimension = (dimension: Dimension) => {
        const res = {};
        res[dimension.name] = dimension.name;
        res['type'] = dimension.type;
        return res;
      };
      const prop = {
        type: this.typeString as DocTypes,
        description: this.description,
        presentation: this.presentation as any,
        icon: this.icon,
        menu: this.menu,
        prefix: this.prefix,
        hierarchy: this.hierarchy as any,
        module: this.module,
        dimensions: this.dimensions ? this.dimensions.map(e => mapDimension(e)) : [] as any,
        relations: this.relations as any || [],
        copyTo: this.CopyTo as any || [],
        commands: this.commandsOnServer as any
      };
      return prop;
    };
  }

  async getProps(): Promise<Function> {

    const res = (new DocumentBase()).Props();
    if (Type.isCatalog(this.typeString)) delete res['date'];

    const getParameterAsProps = (param: Parameter) => {
      let props = { label: param.label, type: param.type, order: param.order, required: param.required };
      if (param.Props) props = { ...props, ...JSON.parse(param.Props) };
      if (!param.tableDef) return props;
      props[param.parameter] = JSON.parse(param.tableDef);
      return props;
    };

    for (const param of this.Parameters) {
      res[param.parameter] = getParameterAsProps(param) as PropOptions;
    }

    res['type'] = { type: 'string', hidden: true, hiddenInList: true };

    return () => res;
  }

}
