import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.Scenario',
  description: 'Budget scenario',
  icon: 'fa fa-list',
  menu: 'Сценарии бюджета',
})
export class CatalogScenario extends DocumentBase {

  @Props({ type: 'Catalog.Scenario', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'Catalog.Currency', required: true, style: { width: '100px' } })
  currency: Ref = null;

}
