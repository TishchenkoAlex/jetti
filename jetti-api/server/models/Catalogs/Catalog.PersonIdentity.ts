import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.PersonIdentity',
  description: 'Тип документа',
  icon: 'fa fa-list',
  menu: 'Типы документов'
})
export class CatalogPersonIdentity extends DocumentBase {

  @Props({ type: 'Catalog.PersonIdentity', hiddenInList: true, order: -1 })
  parent: Ref = null;

}
