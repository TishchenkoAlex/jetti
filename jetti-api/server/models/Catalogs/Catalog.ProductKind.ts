import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.ProductKind',
  description: 'Виды номенклатуры',
  icon: 'fa fa-list',
  menu: 'Виды номенклатуры',
  prefix: 'PRODKIND-',
  commands: [{method: 'ParametersFill', label: 'Заполнить параметры', order: 1, icon: 'pi pi-plus'}]
})
export class CatalogProductKind extends DocumentBase {

  @Props({ type: 'Catalog.ProductKind', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'enum', label: 'Type', value: ['GOODS', 'SERVICE', 'WORK'], required: true, order: 3 })
  ProductType = '';

  @Props({ type: 'table', label: 'Parameters' })
  Parameters: Parameter[] = [new Parameter()];

}

export class Parameter {

  @Props({ type: 'string' })
  PropName = '';

  @Props({ type: 'boolean' })
  Visible = '';

  @Props({ type: 'boolean' })
  Readonly = '';

  @Props({ type: 'boolean' })
  Required = '';

  @Props({ type: 'string' })
  Info = '';

}

