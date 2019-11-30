import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.AcquiringTerminal',
  description: 'Банковский терминал',
  icon: 'fa fa-list',
  menu: 'Банковские терминалы',
  prefix: 'AQTERM-'
})
export class CatalogAcquiringTerminal extends DocumentBase {

  @Props({ type: 'Catalog.AcquiringTerminal', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.BankAccount', required: true })
  BankAccount: Ref = null;

  @Props({ type: 'Catalog.Counterpartie', required: true })
  Counterpartie: Ref = null;

  @Props({ type: 'Catalog.Department'})
  Department: Ref = null;

}
