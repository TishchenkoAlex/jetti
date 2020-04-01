import { DocumentBase, JDocument, Props, Ref } from './../document';

@JDocument({
  type: 'Catalog.Operation',
  description: 'Правило операции',
  icon: 'fa fa-list',
  menu: 'Правила операций',
  dimensions: [
  ],
  prefix: 'RULE-',
  relations: [
    { name: 'Operations', type: 'Document.Operation', field: 'Operation' }
  ],
  copyTo: [
    { type: 'Document.Operation', icon: '', label: 'Operation', order: 1 }
  ],
  hierarchy: 'folders',
  module: `{const onOpen = async () => {this.readonly = this.readonly || !this.auth.isRoleAvailableOperationRulesDesigner()}; return {onOpen};}`
})
export class CatalogOperation extends DocumentBase {

  @Props({ type: 'Catalog.Operation', hiddenInList: true, order: -1, storageType: 'folders' })
  parent: Ref = null;

  @Props({ type: 'Catalog.Operation.Group', order: 2, label: 'Operation group', required: true, style: { width: '30%' } })
  Group: Ref = null;

  @Props({ type: 'string', order: 3, required: true, style: { width: '50%' } })
  description = '';

  @Props({ type: 'javascript', required: true, hiddenInList: true, style: { height: '50vh' }, value: '' })
  script = '';

  @Props({ type: 'javascript', hiddenInList: true, style: { height: '50vh' } })
  module = '';

  @Props({ type: 'table', required: true })
  Parameters: Parameter[] = [new Parameter()];

  @Props({ type: 'table', label: 'Copy to...' })
  CopyTo: CopyTo[] = [new CopyTo()];

  @Props({ type: 'table', label: 'Commands on server' })
  commandsOnServer: CommandOnServer[] = [new CommandOnServer()];

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

  @Props({ type: 'boolean' })
  required = false;

  @Props({ type: 'javascript', label: 'change script', hiddenInList: true, style: { width: '550px' } })
  change = '';

  @Props({ type: 'json', hiddenInList: true, style: { width: '550px' } })
  tableDef = '';

  @Props({ type: 'json', hiddenInList: true, style: { width: '550px' } })
  Props = '';
}

class CopyTo {
  @Props({ type: 'Catalog.Operation', required: true, style: { width: '400px' } })
  Operation: Ref = null;

  @Props({ type: 'javascript', label: 'script', hiddenInList: true, style: { width: '550px' } })
  script = '';

  @Props({ type: 'number', required: true })
  order: number | null = null;
}

class Command {
  @Props({ type: 'string', required: true })
  method = '';

  @Props({ type: 'string', required: true })
  label = '';

  @Props({ type: 'string' })
  icon = '';

  @Props({ type: 'number', required: true })
  order = 0;
}

class CommandOnServer extends Command {
  @Props({ type: 'javascript', label: 'Client module', hiddenInList: true, style: { width: '550px' } })
  clientModule = '';
}
