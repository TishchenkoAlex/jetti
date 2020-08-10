import { JDocument, Props, Ref, DocumentBase } from '../document';

@JDocument({
  type: 'Catalog.Person.Contract',
  description: 'Договор с физ.лицом',
  icon: 'fa fa-list',
  menu: 'Договоры с физ.лицами',
  prefix: 'CONTR.P-'
})
export class CatalogPersonContract extends DocumentBase {

  @Props({ type: 'Catalog.Person.Contract', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'string', style: { width: '300px' }, readOnly: true })
  description = '';

  @Props({ type: 'Catalog.Person', required: true, order: 1 })
  owner: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true })
  currency: Ref = null;

  @Props({ type: 'enum', value: ['OPEN', 'CLOSE', 'PENDING'], required: true })
  Status = 'OPEN';

  @Props({ type: 'date', required: true })
  StartDate: Ref = null;

  @Props({ type: 'date', required: true })
  EndDate: Ref = null;

  @Props({ type: 'Catalog.Person.BankAccount', required: true,
      owner: [
        { dependsOn: 'owner', filterBy: 'owner' }
      ] })
  BankAccount: Ref = null;

}
