import { DocumentBase, JDocument, Props, Ref } from '../document';
import { CatalogBankAccount } from './Catalog.BankAccount';

@JDocument({
  type: 'Catalog.Contract',
  description: 'Договор контрагента',
  icon: 'fa fa-list',
  menu: 'Договоры контрагента',
  prefix: 'CONTR-'
})
export class CatalogContract extends DocumentBase {

  @Props({ type: 'Catalog.Contract', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Counterpartie', required: true, order: 1 })
  owner: Ref = null;

  @Props({ type: 'enum', value: ['AR', 'AP', 'EXPORT'], required: true })
  kind = 'AR';

  @Props({ type: 'Catalog.BusinessDirection', required: true })
  BusinessDirection: Ref = null;

  @Props({ type: 'enum', value: ['OPEN', 'CLOSE', 'PENDING'], required: true })
  Status = 'OPEN';

  @Props({ type: 'Catalog.Currency', required: true })
  currency: Ref = null;

  @Props({ type: 'Catalog.Manager', required: false })
  Manager: Ref = null;

}