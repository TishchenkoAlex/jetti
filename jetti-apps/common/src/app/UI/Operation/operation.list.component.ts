import { ChangeDetectionStrategy, Component, OnInit, ViewChild } from '@angular/core';
import { SelectItem } from 'primeng/components/common/selectitem';
// tslint:disable-next-line:import-blacklist
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { BaseDocListComponent } from './../../common/datatable/base.list.component';


@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <p-dropdown (onChange)="onChange($event)"
      [style]="{'width' : '100%'}"
      [scrollHeight]="500"
      [filter]="true"
      [showClear]="true"
      [options]="operationsGroups$ | async"
      [ngModel]="super?.filters['Group']?.value" [autofocus]="true">
    </p-dropdown>
    <j-list></j-list>`
})
export class OperationListComponent implements OnInit {
  @ViewChild(BaseDocListComponent, { static: true}) super: BaseDocListComponent;

  operationsGroups$: Observable<SelectItem[]>;

  ngOnInit() {
    this.operationsGroups$ = this.super.ds.api.getOperationsGroups().pipe(
      map(data => [
        { label: '(All)', value: null },
        ...data.map(el => <SelectItem>({ label: el.value, value: el })) || []
      ]));
  }

  onChange(event) {
    this.super.filters.Group = { matchMode: '=', value: event.value };
    this.super.prepareDataSource();
    this.super.dataSource.sort();
  }

}
