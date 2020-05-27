import { FormBase, JForm } from './form';
import { Props, Ref } from '../document';

@JForm({
  type: 'Form.QueueManager',
  description: 'Queue manager',
  icon: 'fas fa-hammer',
  menu: 'Queue manager'
})
export class FormQueueManager extends FormBase {

  @Props({ type: 'Catalog.Company', order: 1, hidden: true })
  company: Ref = null;

  @Props({ type: 'date', order: 2 })
  StartDate: Date | null = null;

  @Props({ type: 'date', order: 3 })
  EndDate: Date | null = null;

  @Props({ type: 'string', order: 4 })
  JobId = '';

  @Props({ type: 'number', order: 5 })
  timeout = '';

  @Props({ type: 'table' })
  AnyTable: AnyTable[] = [new AnyTable()];

  // @Props({ type: 'javascript', isAdditional: true, style: { height: '50vh', width: '100%' }, value: '' })
  // JobScript = '';
}

class AnyTable {

  @Props({ type: 'string', hidden: true })
  Key = '';

}



