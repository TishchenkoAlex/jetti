import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { BPApi } from 'src/app/services/bpapi.service';
import { take } from 'rxjs/operators';
import { SelectItem } from 'primeng/api';
import { trigger, state, style, transition, animate } from '@angular/animations';
import { FilterUtils } from 'primeng/components/utils/filterutils';
import { Observable } from 'rxjs';
import { DocService } from 'src/app/common/doc.service';
import { calendarLocale, dateFormat } from 'src/app/primeNG.module';
import { Router } from '@angular/router';
import { ITask } from './task.object';
import { ChangeDetectionStrategy } from '@angular/compiler/src/core';

@Component({
  templateUrl: 'tasks-list.component.html',
  selector: 'bp-tasks-list',
  changeDetection: ChangeDetectionStrategy.OnPush,
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

  Tasks$: Observable<ITask[]>;
  columns: { field: string, header: string, type: string, style: {} }[];
  UserDecisions: SelectItem[];
  columnsLength: number;
  TaskComp = false;

  constructor(public TaskService: BPApi, public ds: DocService, public router: Router, public cd: ChangeDetectorRef) {
  }

  ngOnInit() {
    this.loadTasks();
    this.fillColums();

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
      { field: 'TaskID', header: 'Задача №', type: 'string', style: { 'text-align': 'center', 'width': '5em' } },
      { field: 'TaskDate', header: 'Дата', type: 'date', style: { 'text-align': 'center', 'width': '10em' } },
      // { field: 'TaskName', header: 'Задача', type: 'string', style: { 'text-align': 'center', 'width': '15em' } },
      // {field: 'ProcessID', header: 'Процесс №'},
      { field: 'Company', header: 'Организация', type: 'string', style: { 'text-align': 'center', 'width': '12em' } },
      { field: 'CashRecipient', header: 'Получатель', type: 'string', style: { 'text-align': 'center', 'width': '12em' } },
      { field: 'Subdivision', header: 'Подразделение', type: 'string', style: { 'text-align': 'center', 'width': '12em' } },
      { field: 'ItemName', header: 'Статья ДДС', type: 'string', style: { 'text-align': 'center', 'width': '15em' } },
      { field: 'Summ', header: 'Сумма', type: 'number', style: { 'text-align': 'right', 'width': '8em' } },
      // { field: 'AutorName', header: 'Автор', type: 'string', style: {'text-align': 'center', 'width' : '15em'} },
      // { field: 'UserDecision', header: 'Решение', type: 'string', style: { 'text-align': 'center', 'width': '8em' } },
      // { field: 'ControlDate', header: 'Cрок', type: 'date', style: { 'text-align': 'center', 'width': '10em' } },
      // { field: 'HoursRemaining', header: 'Остаток, ч', type: 'string', style: { 'text-align': 'center', 'width': '5em' } },
      { field: 'Comment', header: 'Комментарий', type: 'string', style: { 'text-align': 'center', 'width': '12em' } }
    ];
    this.columnsLength = this.columns.length;
  }

  open(task: ITask) {
    this.router.navigate([task.baseType, task.baseId]);
  }

  async loadTasks() {
    this.Tasks$ = this.TaskService.GetTasks(20);
  }

  CompleteTask(task: ITask) {
    if (task.DecisionID && !task.DecisionComment) {
      this.ds.openSnackBar('error', 'Задача не выполнена', `Укажите причину ${task.DecisionID === 1 ? ' отклонения ' : ' доработки'}`);
      return;
    }

    try {
      this.TaskService.CompleteTask(task).pipe(take(1)).subscribe(res => {
        if (res.ErrorMessage) {
          this.ds.openSnackBar('error', 'Ошибка выполнения задачи', res.ErrorMessage);
        } else {
          task.DecisionComment = '';
          task.Completed = true;
          task.CanApprove = false;
          task.CanModify = false;
          task.CanReject = false;
          task.UserDecision = !task.DecisionID ? 'Утвердить' : task.DecisionID === 1 ? 'Отклонить' : 'Доработать';
          this.ds.openSnackBar('success', 'Задача выполнена', `${task.TaskName} №${task.TaskID} выполнена!`);
          this.cd.detectChanges();
        }
      });
    } catch (error) {
      this.ds.openSnackBar('error', 'Ошибка выполнения задачи', error);
    }
  }
}
