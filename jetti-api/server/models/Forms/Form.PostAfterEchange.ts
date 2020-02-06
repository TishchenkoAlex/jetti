import { FormBase, JForm } from './form';
import { Props, Ref } from '../document';

@JForm({
  type: 'Form.PostAfterEchange',
  description: 'Post after IIKO',
  icon: 'fas fa-hammer',
  menu: 'Post after IIKO',
})
export class PostAfterEchange extends FormBase {

  @Props({ type: 'Catalog.Company', order: 1 })
  company: Ref = null;

  @Props({ type: 'date', order: 2 })
  StartDate: Date | null = null;

  @Props({ type: 'date', order: 3 })
  EndDate: Date | null = null;

  @Props({ type: 'Catalog.Operation', order: 4 })
  Operation: Ref = null;

  @Props({ type: 'boolean', order: 5 })
  rePost = false;
}

