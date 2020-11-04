import { DocTypes } from './../documents.types';
import { IServerDocument } from './../documents.factory.server';
import { MSSQL } from '../../mssql';
import { PropOptions, DocumentBase, DocumentOptions } from '../document';
import { getAdminTX, lib } from '../../std.lib';
import { riseUpdateMetadataEvent, IDynamicProps } from '../Dynamic/dynamic.common';
import { x100DATA_POOL } from '../../sql.pool.x100-DATA';
import { Type } from '../type';
import { CatalogRegister, Parameter } from './Catalog.Register';
import { RegisterAccumulationBalanceReport } from '../Registers/Accumulation/Balance.Reports';
import { RegisterInfo, RegisterInfoOptions } from '../Registers/Info/RegisterInfo';
import { RegisterAccumulationBank } from '../Registers/Accumulation/Bank';
import { RegisterAccumulation, RegisterAccumulationOptions } from '../Registers/Accumulation/RegisterAccumulation';
import { RegisterAccumulationBalanceRC } from '../Registers/Accumulation/Balance.RC';


export class CatalogRegisterServer extends CatalogRegister implements IServerDocument {

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
    res.dimension = props.dimension || false;
    res.resource = props.resource || false;
    Object.keys(props)
      .filter(key => !paramPropsKeys.includes(key) && key !== propsName)
      .forEach(key => paramProps[key] = props[key]);
    if (Object.keys(paramProps).length) {
      res.Props = JSON.stringify(paramProps);
    }
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
    this.Parameters = [];
    const props = doc.Props();
    const commonProps = [...Object.keys((this.registerType === 'Info' ? new RegisterInfo() : new RegisterAccumulation()).Props()), 'type'];
    const propsKeys = Object.keys(props).filter(key => !commonProps.includes(key));
    this.Parameters = propsKeys.map(key => this.getPropsAsParameter(key, props[key]));

    return this;
  }

  async beforeDelete(tx: MSSQL) { return this; }

  async getDynamicMetadata(): Promise<IDynamicProps> {
    return { type: this.typeString, Prop: await this.getProp(), Props: await this.getProps() };
  }

  async getProp(): Promise<Function> {
    return this.registerType === 'Info' ? await this.getPropInfo() : await this.getPropAccumulation();
  }

  async getPropInfo(): Promise<Function> {

    return (): RegisterInfoOptions => {
      const prop = {
        type: this.typeString as any,
        description: this.description
      };
      return prop;
    };
  }

  async getPropAccumulation(): Promise<Function> {

    return (): RegisterAccumulationOptions => {
      const prop = {
        type: this.typeString as any,
        description: this.description
      };
      return prop;
    };
  }

  async getProps(): Promise<Function> {

    const res = (this.registerType === 'Info' ? new RegisterInfo() : new RegisterAccumulation()).Props();

    const getParameterAsProps = (param: Parameter) => {
      let props = { label: param.label, type: param.type, dimension: param.dimension, resource: param.resource };
      if (param.Props) props = { ...props, ...JSON.parse(param.Props) };
      return props;
    };

    for (const param of this.Parameters) {
      res[param.parameter] = getParameterAsProps(param) as PropOptions;
    }

    res['type'] = { type: 'string' };

    return () => res;
  }

}
