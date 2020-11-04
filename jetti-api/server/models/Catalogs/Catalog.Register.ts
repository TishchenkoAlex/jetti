import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.Register',
  description: 'Register constructor',
  icon: 'fa fa-list',
  menu: 'Register constructor',
  commands: [
    { method: 'updateSQLViewsX100DATA', icon: 'pi pi-plus', label: 'Обновить SQL представления (X100-DATA)', order: 3 },
    { method: 'updateSQLViews', icon: 'pi pi-plus', label: 'Обновить SQL представления', order: 2 },
    { method: 'riseUpdateMetadataEvent', icon: 'pi pi-plus', label: 'Обновить метаданные', order: 1 },
    { method: 'fillByType', icon: 'pi pi-plus', label: 'Заполнить по типу', order: 5 }
  ]
})
export class CatalogRegister extends DocumentBase {

  @Props({ type: 'Catalog.Register', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'enum', value: ['Accumulation', 'Info'], required: true })
  registerType = 'Info';

  @Props({ type: 'string', order: 3, required: true, style: { width: '50%' } })
  description = '';

  @Props({ type: 'string', label: 'type', required: true })
  typeString = '';

  @Props({ type: 'string', value: 'fa fa-list', required: true })
  icon = 'fa fa-list';

  @Props({ type: 'string', required: true })
  menu = '';

  @Props({ type: 'table' })
  Parameters: Parameter[] = [new Parameter()];

}

export class Parameter {
  @Props({ type: 'string', required: true })
  parameter = '';

  @Props({ type: 'string', required: true })
  label = '';

  @Props({ type: 'Catalog.Subcount', required: true })
  type: Ref = null;

  @Props({ type: 'boolean' })
  dimension = false;

  @Props({ type: 'boolean' })
  resource = false;

  @Props({ type: 'json', hiddenInList: true })
  Props = '';
}
