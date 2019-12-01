import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Operation',
  description: 'Правило операции',
  icon: 'fa fa-list',
  menu: 'Правила операций',
  dimensions: [
    { Group: 'Catalog.Operation.Group' }
  ],
  prefix: 'RULE-',
  relations: [
    { name: 'Operations', type: 'Document.Operation', field: 'Operation' }
  ],
  copyTo: [
    'Document.Operation'
  ],
  hierarchy: 'folders'
})
export class CatalogOperation extends DocumentBase {

  @Props({ type: 'Catalog.Operation', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'Catalog.Operation.Group', order: 2, label: 'Operation group', required: true, style: { width: '30%' } })
  Group: Ref = null;

  @Props({ type: 'string', order: 3, required: true, style: { width: '50%' } })
  description = '';

  @Props({ type: 'javascript', required: true, hiddenInList: true, style: { height: '600px' }, value: '' })
  script = '';

  @Props({ type: 'javascript', hiddenInList: true, style: { height: '600px' } })
  module = '';

  @Props({ type: 'table', required: true })
  Parameters: Parameter[] = [new Parameter()];

  @Props({ type: 'table', label: 'Copy to...' })
  CopyTo: CopyTo[] = [new CopyTo()];

  @Props({ type: 'table', label: 'Commands on server' })
  commandsOnServer: Command[] = [new Command()];

  @Props({ type: 'table', label: 'Commands on client' })
  commandsOnClient: Command[] = [new Command()];
}

class Parameter {
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

  @Props({ type: 'string'})
  icon = '';

  @Props({ type: 'number', required: true })
  order: number | null = null;
}
