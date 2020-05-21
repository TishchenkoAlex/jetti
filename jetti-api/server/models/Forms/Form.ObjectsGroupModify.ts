import { FormBase, JForm } from './form';
import { Props, Ref } from '../document';

export enum errorKinds {
  ObjectNotFound = 'Object not found',
  OnSave = 'On save',
  IncorrectType = 'Incorrect type',
  IncorrectTablePartLength = 'Incorrect table part length',
}
export type errorKind = keyof typeof errorKinds;

@JForm({
  type: 'Form.ObjectsGroupModify',
  description: 'Групповое изменение объектов',
  icon: 'fas fa-edit',
  menu: 'Изменение объектов',
})

export class FormObjectsGroupModify extends FormBase {

  @Props({ type: 'enum', value: ['LOAD', 'MODIFY', 'TESTING'] })
  Mode = 'LOAD';

  @Props({ type: 'string', controlType: 'textarea' })
  Text = '';

  @Props({ type: 'Catalog.Operation' })
  OperationType = null;

  @Props({ type: 'Types.Object' })
  CatalogType = '';

  @Props({ type: 'boolean', isAdditional: true })
  CheckTypes = true;

  @Props({ type: 'boolean', isAdditional: true })
  ClearTableParts = false;

  @Props({ type: 'boolean', isAdditional: true })
  SaveInAdminMode = false;

  @Props({ type: 'string', isAdditional: true })
  ColumnsSeparator = '\t';

  @Props({ type: 'string', isAdditional: true })
  RowsSeparator = '\n';

  @Props({ type: 'table' })
  ColumnsMatching: ColumnMatching[] = [new ColumnMatching()];

  @Props({ type: 'table' })
  SelectedObjects: SelectedObject[] = [new SelectedObject()];

  @Props({ type: 'table' })
  Errors: ErrorRow[] = [new ErrorRow()];

  @Props({ type: 'table' })
  RecieverProps: RecieverProp[] = [new RecieverProp()];

}

export class RecieverProp {

  @Props({ type: 'enum', value: [''] })
  Label = '';

  @Props({ type: 'string' })
  Key = '';

  @Props({ type: 'string' })
  Type = '';

  // @Props({ type: 'enum', value: ['=', '>=', '<=', '<', '>', 'like', 'in', 'beetwen', 'is null'] })
  // matchOperator = '=';

}

export class ErrorRow {

  @Props({ type: 'time' })
  Time = new Date;

  @Props({ type: 'number' })
  RowNumber = 0;

  @Props({ type: 'string' })
  ObjectId = '';

  @Props({ type: 'enum', value: Object.keys(errorKinds), readOnly: true })
  ErrorKind = '';

  @Props({ type: 'string', readOnly: true })
  Text = '';

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

export class ColumnMatching {

  @Props({ type: 'enum', value: [] })
  ColumnFrom = '';

  @Props({ type: 'string', readOnly: true })
  ColumnTo = '';

  @Props({ type: 'string', readOnly: true })
  ColumnToLabel = '';

  @Props({ type: 'string', readOnly: true })
  TablePartTo = '';

  @Props({ type: 'string', readOnly: true })
  ColumnToType = '';

  @Props({ type: 'enum', value: ['Object id', 'Object key', 'Table part row id', ''] })
  ColumnRole = '';

  @Props({ type: 'boolean' })
  LoadIfEmptyInObject = false;

  @Props({ type: 'boolean' })
  LoadEmptyValues = false;

}
