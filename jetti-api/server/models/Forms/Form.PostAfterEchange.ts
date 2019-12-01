import { FormBase, JForm } from './form';
import { Props, Ref } from '../document';

@JForm({
  type: 'Form.PostAfterEchange',
  description: 'Post after IIKO',
  icon: 'fa fa-money',
  menu: 'Post after IIKO',
})
export class PostAfterEchange extends FormBase {

  @Props({ type: 'Catalog.Company', order: 1})
  company: Ref = null;

}

