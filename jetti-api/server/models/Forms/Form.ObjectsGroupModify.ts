import { FormBase, JForm } from './form';
import { Props, Ref } from '../document';

@JForm({
  type: 'Form.ObjectsGroupModify',
  description: 'Групповое изменение объектов',
  icon: 'fas fa-edit',
  menu: 'Изменение объектов',
  commands: [{label: 'Load from CSV', icon: '', command: () => {}}]
})
export class FormObjectsGroupModify extends FormBase {

  @Props({type: 'table'})
  SelectedObjects: SelectedObject[] = [new SelectedObject()];

}

export class SelectedObject {

  @Props({ type: 'Types.Object' })
  Object: Ref = null;

  @Props({ type: 'string' })
  Type = '';

  @Props({ type: 'Catalog.Company' })
  Company: Ref = null;

  @Props({ type: 'datetime' })
  Date = null;

}
