import { DocumentBase, JDocument, Props, Ref } from '../document';

@JDocument({
  type: 'Catalog.Catalog',
  description: 'Catalog construcror',
  icon: 'fa fa-list',
  menu: 'Catalog construcror',
  commands: [
    { method: 'updateSQLViewsX100DATA', icon: 'pi pi-plus', label: 'Обновить SQL представления (X100-DATA)', order: 3 },
    { method: 'updateSQLViews', icon: 'pi pi-plus', label: 'Обновить SQL представления', order: 2 },
    { method: 'riseUpdateMetadataEvent', icon: 'pi pi-plus', label: 'Обновить метаданные', order: 1 }
  ]
})
export class CatalogCatalog extends DocumentBase {

  @Props({ type: 'Catalog.Catalog', hiddenInList: true, order: -1 })
  parent: Ref = null;

  @Props({ type: 'string', order: 3, required: true, style: { width: '50%' } })
  description = '';

  @Props({ type: 'string', label: 'type' })
  typeString = '';

  @Props({ type: 'string' })
  prefix = '';

  @Props({ type: 'string', value: 'fa fa-list', required: true })
  icon = 'fa fa-list';

  @Props({ type: 'string', required: true })
  menu = '';

  @Props({ type: 'enum', value: ['code', 'description'], required: true })
  presentation = 'description';

  @Props({ type: 'enum', value: ['folders', 'elements'], required: true })
  hierarchy = 'elements';

  @Props({ type: 'javascript', hiddenInList: true, style: { height: '50vh' }, panel: 'Module' })
  module = '';

  @Props({ type: 'table' })
  Parameters: Parameter[] = [new Parameter()];

  @Props({ type: 'table', label: 'Copy to...' })
  CopyTo: CopyTo[] = [new CopyTo()];

  @Props({ type: 'table', label: 'Commands on server' })
  commandsOnServer: Command[] = [new Command()];

  @Props({ type: 'table', label: 'Commands on client' })
  commandsOnClient: Command[] = [new Command()];

  @Props({ type: 'table', label: 'Relations' })
  relations: Relation[] = [new Relation()];

  @Props({ type: 'table', label: 'Dimensions' })
  dimensions: Dimension[] = [new Dimension()];
}

export class Parameter {
  @Props({ type: 'string', required: true })
  parameter = '';

  @Props({ type: 'string', required: true })
  label = '';

  @Props({ type: 'Catalog.Subcount', required: true })
  type: Ref = null;

  @Props({ type: 'number', required: true })
  order: number | null = null;

  @Props({ type: 'boolean', required: true })
  required = false;

  @Props({ type: 'javascript', label: 'change script', hiddenInList: true })
  change = '';

  @Props({ type: 'json', hiddenInList: true })
  tableDef = '';

  @Props({ type: 'json', hiddenInList: true })
  Props = '';
}

class CopyTo {
  @Props({ type: 'Catalog.Operation', required: true, style: { width: '400px' } })
  Operation: Ref = null;

  @Props({ type: 'javascript', label: 'script', hiddenInList: true })
  script = '';

  @Props({ type: 'javascript', label: 'script', hiddenInList: true })
  method = '';
}

class Command {
  @Props({ type: 'string', required: true })
  method = '';

  @Props({ type: 'string', required: true })
  label = '';

  @Props({ type: 'string' })
  icon = '';

  @Props({ type: 'number', required: true })
  order: number | null = null;
}

class Relation {

  @Props({ type: 'string', required: true })
  name = '';

  @Props({ type: 'Catalog.Subcount', required: true })
  type: Ref = null;

  @Props({ type: 'string' })
  field = '';

}

class Dimension {

  @Props({ type: 'string', required: true })
  name = '';

  @Props({ type: 'Catalog.Subcount', required: true })
  type: Ref = null;

}
