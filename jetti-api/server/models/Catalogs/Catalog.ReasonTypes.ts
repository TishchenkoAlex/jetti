import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.ReasonTypes',
  description: 'Вид причины',
  icon: 'fa fa-list',
  menu: 'Виды причин',
  hierarchy: 'folders'
})
export class CatalogReasonTypes extends DocumentBase {

  @Props({ type: 'Catalog.ReasonTypes' })
  parent: Ref = null;

}
