import { CatalogCompany } from './Catalog.Company';
import { IServerDocument } from './../documents.factory.server';
import { MSSQL } from '../../mssql';
import { CatalogContract } from './Catalog.Contract';
import { lib } from '../../std.lib';

export class CatalogContractServer extends CatalogContract implements IServerDocument {

  async onValueChanged(prop: string, value: any, tx: MSSQL) {

    switch (prop) {
      case 'company':
        if (value && value.id) {
          const comp = await lib.doc.byIdT<CatalogCompany>(value.id, tx);
          this.currency = comp!.currency || this.currency;
        }
        break;
      default:
        break;
    }
    return this;
  }

}
