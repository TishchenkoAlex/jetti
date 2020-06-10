import { IServerDocument } from './../documents.factory.server';
import { MSSQL } from '../../mssql';
import { CatalogEmployee } from './Catalog.Employee';
import { lib } from '../../std.lib';
import { Ref } from '../document';

export class CatalogEmployeeServer extends CatalogEmployee implements IServerDocument {

  beforeSave = async (tx: MSSQL): Promise<this> => {

    const defVal = '<пусто>';
    const getDescription = async (id: Ref): Promise<string> => {
      if (!id) return defVal;
      const ob = await lib.doc.byId(id, tx);
      return ob && ob.description ? ob.description : defVal;
    };

    this.description = `${await getDescription(this.Person)} (${await getDescription(this.company)})`;
    return this;
  }

}
