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

  @Props({ type: 'date', order: 2})
  StartDate = null;

  @Props({ type: 'date', order: 3 })
  EndDate = null;

  @Props({ type: 'boolean', order: 4})
  rePost = false;
}

