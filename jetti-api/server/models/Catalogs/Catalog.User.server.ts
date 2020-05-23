import { CatalogUser } from './Catalog.User';
import { IServerDocument } from './../documents.factory.server';
import { MSSQL } from '../../mssql';

export class CatalogUserServer extends CatalogUser implements IServerDocument {

  // TODO: update RLS on change code
  beforeSave = async (tx: MSSQL): Promise<this> => {
    if (false && this.code && !this.deleted) {
      const query = `SELECT description FROM [dbo].[Documents] WHERE code = @p1 and id <> @p2 ORDER BY description`;
      const exist = await tx.manyOrNone<{ description: string }>(query, [this.code, this.id]);
      if (exist.length) throw new Error(`User with code ${this.code} already exists: ${exist.map(e => e.description).join(',')}`);
    }
    return this;
  }

}
