import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Department',
  description: 'Подразделение',
  icon: 'fa fa-list',
  menu: 'Подразделения',
  prefix: 'DEP-',
  hierarchy: 'folders',
  relations: [
    { name: 'Cash registers', type: 'Catalog.CashRegister', field: 'Department' },
    { name: 'Acquiring terminals', type: 'Catalog.AcquiringTerminal', field: 'Department' },
    { name: 'Storehouses', type: 'Catalog.Storehouse', field: 'Department' }
  ],
})
export class CatalogDepartment extends DocumentBase {

  @Props({ type: 'Catalog.Department', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.BusinessRegion' })
  BusinessRegion: Ref = null;

  @Props({ type: 'date', label: 'Opening date' })
  OpeningDate = new Date();

  @Props({ type: 'Catalog.TaxOffice', hiddenInList: true })
  TaxOffice: Ref = null;

}
