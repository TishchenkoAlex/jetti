import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.ProductKind',
  description: 'Виды номенклатуры',
  icon: 'fa fa-list',
  menu: 'Виды номенклатуры',
  prefix: 'PRODKIND-',
})
export class CatalogProductKind extends DocumentBase {

  @Props({ type: 'Catalog.ProductKind', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'enum', label: 'Type', value: ['GOODS', 'SERVICE', 'WORK'], required: true, order: 3 })
  ProductType = '';

}
