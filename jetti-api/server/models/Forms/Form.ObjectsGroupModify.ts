import { FormBase, JForm } from './form';
import { Props, Ref } from '../document';

@JForm({
  type: 'Form.ObjectsGroupModify',
  description: 'Групповое изменение объектов',
  icon: 'fas fa-edit',
  menu: 'Изменение объектов',
})
export class FormObjectsGroupModify extends FormBase {

  @Props({ type: 'string', controlType: 'textarea' })
  Text = '';

  @Props({ type: 'enum', value: ['LOAD', 'MODIFY'] })
  Mode = 'LOAD';

  @Props({ type: 'boolean' })
  CustomSeparators = false;

  @Props({ type: 'string' })
  ColumnsSeparator = '\t';

  @Props({ type: 'string' })
  RowsSeparator = '\n';

  @Props({ type: 'Catalog.Operation' })
  OperationType = null;

  @Props({ type: 'Catalog.Catalogs' })
  Catalog = null;

  @Props({ type: 'string' })
  СolumnFromString = '';

  @Props({ type: 'table' })
  СolumnsMatching: СolumnMatching[] = [new СolumnMatching()];

  @Props({ type: 'table' })
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

export class СolumnMatching {

  @Props({ type: 'enum', value: [] })
  СolumnFrom = '';

  @Props({ type: 'string', readOnly: true })
  СolumnTo = '';

  @Props({ type: 'string', readOnly: true })
  СolumnToLabel = '';

  @Props({ type: 'string', readOnly: true })
  TablePartTo = '';

  @Props({ type: 'string', readOnly: true })
  СolumnToType = '';

}
