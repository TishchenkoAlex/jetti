import { Component, OnInit, Input } from '@angular/core';
import { BPApi } from 'src/app/services/bpapi.service';
import { take, debounceTime } from 'rxjs/operators';
import { SelectItem, SortMeta } from 'primeng/api';
import { trigger, state, style, transition, animate } from '@angular/animations';
import { FilterUtils } from 'primeng/components/utils/filterutils';
import { Observable, Subject, Subscription } from 'rxjs';
import { DocService } from 'src/app/common/doc.service';
import { FilterMetadata } from 'primeng/components/common/filtermetadata';
import { FormListSettings, FormListFilter, FormListOrder } from '../../../../../../jetti-api/server/models/user.settings';
import { ColumnDef } from '../../../../../../jetti-api/server/models/column';
import { calendarLocale, dateFormat } from 'src/app/primeNG.module';
import { Router } from '@angular/router';
import { ITask } from './task.object';

@Component({
  templateUrl: 'tasks-list.component.html',
  selector: 'bp-tasks-list',
  animations: [
    trigger('rowExpansionTrigger', [
      state('void', style({
        transform: 'translateX(-10%)',
        opacity: 0
      })),
      state('active', style({
        transform: 'translateX(0)',
        opacity: 1
      })),
      transition('* <=> *', animate('1400ms cubic-bezier(0.86, 0, 0.07, 1)'))
    ])]
})

export class TaskListComponent implements OnInit {
  locale = calendarLocale; dateFormat = dateFormat;

  settings = new FormListSettings();
  Tasks: {};
  Tasks$: Observable<ITask[]>;
  columns: { field: string, header: string, type: string, style: {} }[];
  UserDecisions: SelectItem[];
  columnsLength: number;
  filters: { [s: string]: FilterMetadata } = {};
  multiSortMeta: SortMeta[] = [];

  private _debonceSubscription$: Subscription = Subscription.EMPTY;
  private debonce$ = new Subject<{ col: any, event: any, center: string }>();

  constructor(public TaskService: BPApi, public ds: DocService, public router: Router) {

  }

  ngOnInit() {
    this.loadTasks();
    this.fillColums();
    this.setFilters();

    this._debonceSubscription$ = this.debonce$.pipe(debounceTime(1000))
      .subscribe(event => this._update(event.col, event.event, event.center));

    FilterUtils['custom'] = (value, filter): boolean => {
      if (filter === undefined || filter === null || filter.trim() === '') {
        return true;
      }
      if (value === undefined || value === null) {
        return false;
      }
      return parseInt(filter, 10) > value;
    };
  }

  fillColums(): void {
    this.columns = [
      { field: 'TaskID', header: 'Задача №', type: 'number', style: { 'text-align': 'center', 'width': '5em' } },
      { field: 'TaskDate', header: 'Дата', type: 'date', style: { 'text-align': 'center', 'width': '10em' } },
      { field: 'TaskName', header: 'Задача', type: 'string', style: { 'text-align': 'center', 'width': '15em' } },
      // {field: 'ProcessID', header: 'Процесс №'},
      { field: 'Subdivision', header: 'Подразделение', type: 'string', style: { 'text-align': 'center', 'width': '12em' } },
      { field: 'ItemName', header: 'Статья ДДС', type: 'string', style: { 'text-align': 'center', 'width': '15em' } },
      { field: 'Summ', header: 'Сумма', type: 'number', style: { 'text-align': 'center', 'width': '5em' } },
      // { field: 'AutorName', header: 'Автор', type: 'string', style: {'text-align': 'center', 'width' : '15em'} },
      { field: 'UserDecision', header: 'Решение', type: 'string', style: { 'text-align': 'center', 'width': '8em' } },
      { field: 'ControlDate', header: 'Cрок', type: 'date', style: { 'text-align': 'center', 'width': '10em' } },
      { field: 'HoursRemaining', header: 'Остаток, ч', type: 'number', style: { 'text-align': 'center', 'width': '5em' } },
      { field: 'Comment', header: 'Комментарий', type: 'string', style: { 'text-align': 'center', 'width': '12em' } }
    ];
    this.columnsLength = this.columns.length;
  }

  update(col: ColumnDef | { field: string, filter: any }, event, center = 'like') {
    if (!event || (typeof event === 'object' && !event.value && !(Array.isArray(event)))) {
      if (typeof event !== 'boolean') event = null;
    }
    this.debonce$.next({ col, event, center });
  }

  private _update(col: ColumnDef | undefined, event, center) {
    if (!col) return;
    if ((Array.isArray(event)) && event[1]) { event[1].setHours(23, 59, 59, 999); }
    this.filters[col.field] = { matchMode: center || (col.filter && col.filter.center), value: event };
    this.prepareDataSource(this.multiSortMeta);
  }

  prepareDataSource(multiSortMeta: SortMeta[] = this.multiSortMeta) {
    const order = multiSortMeta
      .map(el => <FormListOrder>({ field: el.field, order: el.order === -1 ? 'desc' : 'asc' }));
    const Filter = Object.keys(this.filters)
      .map(f => <FormListFilter>{ left: f, center: this.filters[f].matchMode, right: this.filters[f].value });
    this.settings = { filter: Filter, order };
  }

  open(task: ITask) {
    this.router.navigate([task.baseType, task.baseId]);
  }

  private setFilters() {
    this.settings.filter
      .filter(c => !(c.right == null || c.right === undefined))
      .forEach(f => this.filters[f.left] = { matchMode: f.center, value: f.right });
  }

  async loadTasks() {
    this.Tasks$ = this.TaskService.GetTasks(20);
  }

  async CompleteTask(task: ITask, UserDecisionID: number) {
    if (UserDecisionID > 0 && !task.DecisionComment) {
      this.ds.openSnackBar('error', 'Задача не выполнена', `Укажите причину ${UserDecisionID === 1 ? ' отклонения ' : ' доработки'}`);
      return;
    }

    try {
      this.TaskService.CompleteTask(task.TaskID, UserDecisionID, task.DecisionComment).pipe(take(1)).subscribe(res => {
        if (res.ErrorMessage) {
          this.ds.openSnackBar('error', 'Ошибка выполнения задачи', res.ErrorMessage);
        } else {
          this.ds.openSnackBar('success', 'Задача выполнена', `${task.TaskName} №${task.TaskID} выполнена!`);
          this.Tasks$.subscribe(r => { console.log(r); });
          task.DecisionComment = '';
          task.Completed = true;
          task.CanApprove = false;
          task.CanModify = false;
          task.CanReject = false;
          task.UserDecision = UserDecisionID === 0 ? 'Утвердить' : UserDecisionID === 1 ? 'Отклонить' : 'Доработать';
        }
      });
    } catch (error) {
      this.ds.openSnackBar('error', 'Ошибка выполнения задачи', error);
    }

  }
}
