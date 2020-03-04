import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.PlanningScenario',
  description: 'Сценарий планирования',
  icon: 'fa fa-list',
  menu: 'Сценарии планирования',
  hierarchy: 'folders'
})
export class CatalogPlanningScenario extends DocumentBase {

  @Props({ type: 'Catalog.PlanningScenario', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
