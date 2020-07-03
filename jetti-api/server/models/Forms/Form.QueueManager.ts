import { FormBase, JForm } from './form';
import { Props, Ref } from '../document';

@JForm({
  type: 'Form.QueueManager',
  description: 'Queue manager',
  icon: 'fas fa-hammer',
  menu: 'Queue manager'
})
export class FormQueueManager extends FormBase {

  @Props({ type: 'Catalog.Company', order: 1, hidden: true })
  company: Ref = null;

  @Props({ type: 'date', order: 2, label: 'Начало', panel: 'Журнал задач' })
  StartDate: Date | null = null;

  @Props({ type: 'date', order: 3, label: 'Окончание', panel: 'Журнал задач' })
  EndDate: Date | null = null;

  @Props({ type: 'enum', order: 4, label: 'Состояние', value: ['all', 'completed', 'waiting', 'active', 'delayed', 'failed'], panel: 'Журнал задач' })
  Status = 'all';

  @Props({ type: 'enum', order: 4, label: 'Очередь', value: ['JETTI', 'IS'], panel: 'Журнал задач' })
  QueueId = 'JETTI';

  @Props({ type: 'table', label: 'Повторяющиеся', panel: 'Повторяющиеся' })
  Repeatable: Repeatable[] = [new Repeatable()];

  @Props({ type: 'Document.Operation', order: 6, label: 'Задание', panel: 'Новая задача' })
  CustomTask: Ref = null;

  @Props({ type: 'string', order: 7, label: 'Имя метода', panel: 'Новая задача' })
  MethodName = 'executeTask';

  @Props({ type: 'string', order: 8, label: 'Расписание (Cron expression)', panel: 'Новая задача' })
  CronExpression = '';

  @Props({ type: 'number', order: 9, label: 'Начать через # минут', panel: 'Новая задача' })
  Delay = 0;

  @Props({ type: 'number', order: 9, label: 'Повторять каждые # минут', panel: 'Новая задача' })
  Every = 0;

  @Props({ type: 'string', order: 9, label: 'Наименование', panel: 'Новая задача' })
  JobName = '';

  @Props({ type: 'number', order: 9, label: 'Попыток', panel: 'Новая задача' })
  Attempts = 3;

  @Props({ type: 'table', panel: 'Журнал задач' })
  JobsStat: JobsStat[] = [new JobsStat()];

}

class JobsStat {

  @Props({ type: 'boolean', label: ' ' })
  selected = '';

  @Props({ type: 'string', readOnly: true, label: 'Состояние' })
  status = '';

  @Props({ type: 'string', readOnly: true, label: 'Наименование' })
  description = '';

  @Props({ type: 'string', readOnly: true, label: 'Вид задачи' })
  id = '';

  @Props({ type: 'number', readOnly: true, label: 'Выполнено, %' })
  progress = 0;

  @Props({ type: 'datetime', readOnly: true, label: 'Начало' })
  processedOn = '';

  @Props({ type: 'datetime', readOnly: true, label: 'Завершение' })
  finishedOn = '';

  @Props({ type: 'string', readOnly: true, label: 'Продолжительность' })
  duration = '';

  @Props({ type: 'string', readOnly: true, label: 'Код (внутр)' })
  code = '';

  @Props({ type: 'string', readOnly: true, label: 'ID (внутр)' })
  jobid = '';

  @Props({ type: 'string', readOnly: true, label: 'Cron' })
  cron = '';

  @Props({ type: 'number', readOnly: true, label: 'Попыток' })
  attempts = '';

  @Props({ type: 'string', readOnly: true, label: 'Описание' })
  info = '';

  @Props({ type: 'Document.Operation', readOnly: true, label: 'Операция' })
  TaskOperation = '';

  @Props({ type: 'string', readOnly: true, label: 'Текст ошибки' })
  failedReason = '';


  // status
  // progress,
  // attemptsMade,
  // failedReason,
  // progressOn,
  // finishedOn
  // durationSeconds, user,
  // processId,
  // TaskOperation,
  // id,
  // description,
  // jobid,
  // delay,
  // attempts,
  // count,
  // cron,
  // startDate

}

class Repeatable {

  @Props({ type: 'boolean', label: 'Пометка' })
  flag = false;

  @Props({ type: 'string', label: 'Наименование' })
  name = '';

  @Props({ type: 'datetime', label: 'Следующее' })
  next: Date | null = null;

  @Props({ type: 'string', label: 'Расписание (Cron expression)' })
  cron = '';

  @Props({ type: 'datetime', label: 'Дата окончания' })
  endDate: Date | null = null;

  @Props({ type: 'number', label: 'Каждые # мин' })
  everyMin = 0;

  @Props({ type: 'string', label: 'Повторять через' })
  everyString = '';

  @Props({ type: 'string', readOnly: true, label: 'Описание' })
  info = '';

  @Props({ type: 'string' })
  id: string | undefined = '';

  @Props({ type: 'string' })
  key = '';

}



