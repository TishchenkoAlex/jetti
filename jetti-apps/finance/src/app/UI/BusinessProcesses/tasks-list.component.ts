import { Component, OnInit } from '@angular/core';
import { BPApi } from 'src/app/services/bpapi.service';
import { take } from 'rxjs/operators';
import { SelectItem } from 'primeng/api';
import { Task } from './task.object';
import { trigger, state, style, transition, animate } from '@angular/animations';
import { FilterUtils } from 'primeng/components/utils/filterutils';
import { Observable } from 'rxjs';

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
      transition('* <=> *', animate('400ms cubic-bezier(0.86, 0, 0.07, 1)'))
    ])]
})

export class TaskListComponent implements OnInit {

  Tasks: {};
  Tasks$: Observable<Task[]>;
  columns: { field: string, header: string, style: string }[];
  UserDecisions: SelectItem[];
  columnsLength: number;
  constructor(public TaskService: BPApi) {

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
      // {field: 'TaskName', header: 'Задача'},
      { field: 'TaskID', header: 'Задача №', style: 'text-align: center; width: 5em' },
      { field: 'TaskDate', header: 'Дата', style: 'text-align: center; width: 5em' },
      // {field: 'ProcessID', header: 'Процесс №'},
      { field: 'Subdivision', header: 'Подразделение', style: 'text-align: center; width: 10em' },
      { field: 'ItemName', header: 'Статья ДДС', style: 'text-align: center; width: 5em' },
      { field: 'Summ', header: 'Сумма', style: 'text-align: center; width: 5em' },
      // {field: 'AutorName', header: 'Автор'},
      { field: 'UserDecision', header: 'Решение', style: 'text-align: center; width: 5em' },
      // {field: 'ControlDate', header: 'Контрольный срок'},
      { field: 'HoursRemaining', header: 'Остаток, ч', style: 'text-align: center; width: 5em' },
      // {field: 'Completed', header: 'Выполнена'},
      { field: 'Comment', header: 'Комментарий', style: 'text-align: center; width: 20em' }
    ];
    this.columnsLength = this.columns.length;
  }

  async loadTasks() {
    // this.Tasks = this.TaskService.GetTasks(20).pipe(take(1)).subscribe(Tasks => { this.Tasks = Tasks; });
     this.Tasks$ = this.TaskService.GetTasks(20);
  }

  async CompleteTask(task: Task, UserDecisionID: number): Promise<void> {
    if (UserDecisionID > 0 && !task.DecisionComment.trim()) {
      return;
    }
    let res = this.TaskService.CompleteTask(task.TaskID, UserDecisionID, task.DecisionComment);
    // .pipe(take(1)).subscribe(res => {
      task.CurrentTask = false;
      task.DecisionComment = '';
      task.Completed = true;
      task.CanApprove = false;
      task.CanModify = false;
      task.CanReject = false;
      task.UserDecision = UserDecisionID === 0 ? 'Утвердить' : 'Отклонить';
      await this.loadTasks();
    // }
    // );
  }
}
