import { FormBase, JForm } from './form';
import { Props, Ref } from '../document';

@JForm({
  type: 'Form.CashRequestDesktop',
  description: 'Cash request desktop',
  icon: 'fa fa-money',
  menu: 'Cash request desktop',
})
export class CashRequestDesktop extends FormBase {

  @Props({ type: 'Catalog.Company', order: 1 })
  company: Ref = null;

  @Props({ type: 'date', order: 2 })
  StartDate: Date | null = null;

  @Props({ type: 'date', order: 3 })
  EndDate: Date | null = null;

  @Props({ type: 'enum', order: 4, value: ['prepared', 'creation'] })
  Mode = 'prepared';

  @Props({ type: 'table', order: 5, label: 'Cash requests', hiddenInForm: true })
  CashRequests: CashRequest[] = [new CashRequest()];

}

class CashRequest {
  @Props({ type: 'Document.CashRequest', required: true, style: { width: '100%' }})
  CashRequest: Ref = null;
}
