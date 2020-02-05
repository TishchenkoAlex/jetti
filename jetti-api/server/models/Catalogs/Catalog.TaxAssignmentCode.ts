import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.TaxAssignmentCode',
  description: 'КНП',
  icon: 'fa fa-list',
  menu: 'КНП',
})
export class CatalogTaxAssignmentCode extends DocumentBase {

  @Props({ type: 'Catalog.TaxAssignmentCode', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({type: 'string', hiddenInList: true})
  FullDescription = '';

}
