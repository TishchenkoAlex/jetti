import { DocumentBase, JDocument, Props, Ref } from '../document';
import { CatalogBankAccount } from './Catalog.BankAccount';

@JDocument({
  type: 'Catalog.Counterpartie.BankAccount',
  description: 'Банковский счет контрагента',
  icon: 'fa fa-list',
  menu: 'Банк. счета контрагента',
  prefix: 'BANK.С-'
})
export class CatalogCounterpartieBankAccount extends CatalogBankAccount {

  @Props({ type: 'Catalog.Counterpartie.BankAccount', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Types.CounterpartieOrPerson', required: true, order: 1 })
  owner: Ref = null;

}
