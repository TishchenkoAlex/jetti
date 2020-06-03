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

  @Props({ type: 'enum', value: ['LOAD', 'MODIFY', 'TESTING'], label: 'Режим', panel: 'Общее' })
  Mode = 'LOAD';

  @Props({ type: 'string', controlType: 'textarea', panel: 'Загрузка из CSV', label: 'CSV' })
  Text = '';

  @Props({ type: 'Catalog.Operation', panel: 'Общее', label: 'Тип: операция' })
  OperationType = null;

  @Props({ type: 'Types.Object', panel: 'Общее', label: 'Тип: справочник' })
  CatalogType = '';

  @Props({ type: 'boolean', panel: 'Параметры', fieldset: 'Загрузка', label: 'Проверять соответствие типов' })
  CheckTypes = true;

  @Props({ type: 'boolean', panel: 'Параметры', fieldset: 'Загрузка', label: 'Очищать табличые части' })
  ClearTableParts = false;

  @Props({ type: 'boolean', panel: 'Параметры', fieldset: 'Загрузка', label: 'Запись с полными правами' })
  SaveInAdminMode = false;

  @Props({ type: 'string', panel: 'Параметры', fieldset: 'Загрузка', label: 'Разделитель колонк' })
  ColumnsSeparator = '\t';

  @Props({ type: 'string', panel: 'Параметры', fieldset: 'Загрузка', label: 'Разделитель строк' })
  RowsSeparator = '\n';

  @Props({ type: 'Document.Operation', label: 'Обработка изменения', panel: 'Параметры', fieldset: 'Изменение' })
  ChangeProcessing = null;

  @Props({ type: 'table', panel: 'Загрузка из CSV', label: 'Соответствие колонок' })
  ColumnsMatching: ColumnMatching[] = [new ColumnMatching()];

  @Props({ type: 'table', panel: 'Загрузка из CSV', hidden: true })
  SelectedObjects: SelectedObject[] = [new SelectedObject()];

  @Props({ type: 'table', panel: 'Ошибки', label: 'Ошибки' })
  Errors: ErrorRow[] = [new ErrorRow()];

  @Props({ type: 'table', panel: 'Служебное', label: 'Свойства приемника' })
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

  @Props({ type: 'enum', value: [], label: 'Колонка CSV' })
  ColumnFrom = '';

  @Props({ type: 'string', readOnly: true, label: 'Реквизит объекта (внутр)' })
  ColumnTo = '';

  @Props({ type: 'string', readOnly: true, label: 'Реквизит объекта' })
  ColumnToLabel = '';

  @Props({ type: 'string', readOnly: true, label: 'ТЧ объекта' })
  TablePartTo = '';

  @Props({ type: 'string', readOnly: true, label: 'Тип значения' })
  ColumnToType = '';

  @Props({ type: 'enum', value: ['Object id', 'Object key', 'Table part row id', ''], label: 'Роль колонки' })
  ColumnRole = '';

  @Props({ type: 'boolean', label: 'Заполнять пустые' })
  LoadIfEmptyInObject = false;

  @Props({ type: 'boolean', label: 'Загружать пустые' })
  LoadEmptyValues = false;

}
