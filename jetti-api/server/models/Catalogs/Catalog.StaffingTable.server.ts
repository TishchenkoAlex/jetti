import { IServerDocument } from './../documents.factory.server';
import { MSSQL } from '../../mssql';
import { CatalogStaffingTable } from './Catalog.StaffingTable';
import { lib } from '../../std.lib';
import { Ref } from '../document';

export class CatalogStaffingTableServer extends CatalogStaffingTable implements IServerDocument {

  beforeSave = async (tx: MSSQL): Promise<this> => {

    const defVal = '<пусто>';
    const getDescription = async (id: Ref): Promise<string> => {
      if (!id) return defVal;
      const ob = await lib.doc.byId(id, tx);
      return ob && ob.description ? ob.description : defVal;
    };

    this.description = `${this.CloseDate ? '(closed) ' : ''}${await getDescription(this.JobTitle)} / ${await getDescription(this.Department)}`;
    return this;
  }

}
