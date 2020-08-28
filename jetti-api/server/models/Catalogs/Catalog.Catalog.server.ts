import { DocTypes } from './../documents.types';
import { CatalogCatalog, Parameter } from './Catalog.Catalog';
import { IServerDocument } from './../documents.factory.server';
import { MSSQL } from '../../mssql';
import { PropOptions, DocumentBase, DocumentOptions } from '../document';
import { lib } from '../../std.lib';
import { riseUpdateMetadataEvent, IDynamicProps } from '../Dynamic/dynamic.common';


export class CatalogCatalogServer extends CatalogCatalog implements IServerDocument {

  async onCommand(command: string, args: any, tx: MSSQL): Promise<{ [x: string]: any }> {
    this[command](args, tx);
    return this;
  }

  async updateSQLViews() {
    await lib.meta.updateSQLViewsByType(this.typeString as any);
  }

  async riseUpdateMetadataEvent() {
    await riseUpdateMetadataEvent();
  }

  async beforeDelete(tx: MSSQL) { return this; }

  async getDynamicMetadata(): Promise<IDynamicProps> {
    return { type: this.typeString, Prop: await this.getProp(), Props: await this.getProps() };
  }

  async getProp(): Promise<Function> {

    return (): DocumentOptions => {
      return {
        type: this.typeString as DocTypes,
        description: this.description,
        presentation: this.presentation as any,
        icon: this.icon,
        menu: this.menu,
        prefix: this.prefix,
        hierarchy: this.hierarchy as any,
        module: this.module,
        dimensions: this.dimensions as any || [],
        relations: this.relations as any || [],
        copyTo: this.CopyTo as any || [],
        commands: this.commandsOnServer as any
      };
    };
  }

  async getProps(): Promise<Function> {

    const res = (new DocumentBase()).Props();

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
