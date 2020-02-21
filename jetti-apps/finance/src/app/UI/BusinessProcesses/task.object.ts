export interface IFieldProp {
  name: string;
  label: string;
  visible: boolean;
  style: {};
  type: string;
}

export interface ITaskCompleteResult {
  Completed: boolean;
  TaskID: number;
  ErrorMessage: string;
}

export interface ITask {

  TaskName: string;
  TaskID: number;
  ProcessID: string;
  Subdivision: string;
  Company: string;
  CashRecipient: string,
  ItemName: string;
  Summ: number;
  AutorName: string;
  TaskDate: string;
  UserDecision: string;
  ControlDate: string;
  HoursRemaining: number;
  Completed: boolean;
  CanApprove: boolean;
  CanReject: boolean;
  CanModify: boolean;
  Comment: string;
  DecisionComment: string;
  CurrentTask: boolean;
  Detailed: boolean;
  BaseDocumentID: string;
  baseType: string;
  baseId: string;
}

export class ProcessParticipants {

  Согласующий = '';
  Completed: boolean;
  Роль = '';
  ШагСогласования: number;
  ДатаВыполнения: Date;
  Комментарий = '';
  Решение = '';
  ПроцессНомер;
  ЗадачаДата: Date;
  ЗадачаНомер: number;
  Current: boolean;
  КонтрольныйСрок: Date;
  ПросроченоЧасов: number;

  public static getFields(): IFieldProp[] {
    return [{ name: 'ШагСогласования', label: 'Шаг', visible: true, style: { 'width' : '5em'} , type: 'number' },
    { name: 'Согласующий', label: 'Согласующий', visible: true, style: { 'width' : '15em'} , type: 'string' },
    { name: 'Роль', label: 'Роль', visible: true, style: { 'width' : '12em'}, type: 'string' },
    { name: 'ДатаВыполнения', label: 'Выполнена', visible: true, style: { 'width' : '10em'}, type: 'date' },
    { name: 'Решение', label: 'Решение', visible: true, style: { 'width' : '8em'}, type: 'string' },
    { name: 'КонтрольныйСрок', label: 'Срок', visible: true, style: { 'width' : '10em'}, type: 'date' },
    { name: 'ПросроченоЧасов', label: 'Просрочено, ч', visible: true, style: { 'width' : '5em'}, type: 'number' },
    { name: 'Комментарий', label: 'Комментарий', visible: true, style: { 'width' : '15em'}, type: 'string' }];
  }
}
