import { MSSQL } from '../../mssql';
import { IServerDocument } from '../documents.factory.server';
import { CatalogProductCategory } from './Catalog.ProductCategory';

export class CatalogProductCategoryServer extends CatalogProductCategory implements IServerDocument {

  async beforeDelete(tx: MSSQL) {
    if (!this.id) return this;
    const exist = await tx.oneOrNone<{ idCount: number }>(
      `select count(id) idCount
      from [dbo].[Catalog.Product.v]
      where
      deleted = 0 and
      ProductCategory = @p1`, [this.id]);
    if (exist) throw new Error(`Deletion prohibited: there are ${exist.idCount} products with a category "${this.description}"`);

    return this;
  }

}
