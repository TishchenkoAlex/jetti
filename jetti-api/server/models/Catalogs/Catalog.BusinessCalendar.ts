import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.BusinessCalendar',
  description: 'Бизнес календарь',
  icon: 'fa fa-list',
  menu: 'Бизнес календари',
  prefix: 'bc-',
  relations: [
    { name: 'Departments', type: 'Catalog.Department', field: 'BusinessCalendar' },
    { name: 'Companies', type: 'Catalog.Company', field: 'BusinessCalendar' }]
})

export class CatalogBusinessCalendar extends DocumentBase {

  @Props({ type: 'Catalog.BusinessCalendar', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Country', required: true })
  Country: Ref = null;

}
