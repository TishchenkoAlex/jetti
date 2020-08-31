import { IServerDocument } from './../documents.factory.server';
import { MSSQL } from '../../mssql';
import { lib } from '../../std.lib';
import { CatalogProductKind, Parameter } from './Catalog.ProductKind';

export class CatalogProductKindServer extends CatalogProductKind implements IServerDocument {

  async onCreate(tx: MSSQL) {
    if (!this.Parameters.length) await this.ParametersFill(tx);
    return this;
  }

  async onCommand(command: string, tx: MSSQL) {
    if (this[command]) await this[command](tx);
    return this;
  }

  async ParametersFill(tx: MSSQL) {

    const product = await lib.doc.createDocServer('Catalog.Product', undefined, tx);
    const props = product.Props();
    this.Parameters = Object.keys(props)
      .filter(e => props[e].order === 666)
      .map(key => ({ PropName: key } as Parameter));

  }

}
