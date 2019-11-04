import { FormBase, JForm } from './form';
import { Props, Ref } from '../document';

@JForm({
  type: 'Form.Batch',
  description: 'Batch',
  icon: 'fa fa-money',
  menu: 'Batch',
})
export class FormBatch extends FormBase {
  @Props({ type: 'Catalog.Company', order: 1, required: true })
  company: Ref = null;

}

