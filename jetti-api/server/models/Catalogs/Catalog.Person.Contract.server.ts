import { IServerDocument } from './../documents.factory.server';
import { MSSQL } from '../../mssql';
import { lib } from '../../std.lib';
import { CatalogPersonContract } from './Catalog.Person.Contract';
import { CatalogPerson } from './Catalog.Person';

export class CatalogPersonContractServer extends CatalogPersonContract implements IServerDocument {

  beforeSave = async (tx: MSSQL): Promise<this> => {
    if (!this.owner || !this.StartDate || !this.EndDate || !this.currency) throw new Error('Заполнены не все обязательные реквизиты');
    const owner = await lib.doc.byIdT<CatalogPerson>(this.owner, tx);
    if (!owner || !owner!.Code1) throw new Error(`Не указан ИНН у владельца ${owner!.description}`);
    this.description = `Договор №${this.code} от ${lib.util.formatDate(this.StartDate as any)} (${owner!.Code1} - ${owner!.description})`;
    return this;
  }

}

export const getPersonContract = async (params: any[], tx: MSSQL) => {
  const query = `SELECT TOP 1 id
  FROM [dbo].[Catalog.Person.Contract.v]
  where [owner] = @p1
  and [company] = @p2
  and [Status] = 'OPEN'
  and @p3 between [StartDate] and [EndDate]`;
  const res = await tx.oneOrNone<{ id: string }>(query, params);
  return res ? res.id : null;
};
