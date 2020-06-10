import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Salary.Analytics',
  description: 'Аналитика начислений/удержаний',
  icon: 'fa fa-list',
  menu: 'Аналитики нач/удерж',
  prefix: 'SAL.A-'
})
export class CatalogSalaryAnalytics extends DocumentBase {

  @Props({ type: 'Catalog.Salary.Analytics', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'enum', resource: true, value: ['INCOME', 'EXPENSE', 'PAID'] })
  SalaryKind = 'INCOME';

  @Props({ type: 'Catalog.Unit' })
  Unit: Ref = null;
}
