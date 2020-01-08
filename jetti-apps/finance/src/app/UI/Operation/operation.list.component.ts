import { ChangeDetectionStrategy, Component, OnInit, ViewChild } from '@angular/core';
import { SelectItem } from 'primeng/components/common/selectitem';
// tslint:disable-next-line:import-blacklist
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { BaseDocListComponent } from './../../common/datatable/base.list.component';
import { FormGroup, FormControl } from '@angular/forms';


@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
  <div fxLayout="column" style="padding: 6px" cdkTrapFocus [cdkTrapFocusAutoCapture]="true" cdkFocusInitial>
    <div fxLayout="row" fxLayout.xs="column" fxLayoutGap="35px" fxLayoutGap.xs="6px" style="margin-top: 12px; margin-bottom: 6px">
      <div fxFlex>
        <j-autocomplete-png [ngModel]="super?.filters['company']?.value" [inputStyle]="{'background-color': 'lightgoldenrodyellow'}"
          (ngModelChange)="super.update({field: 'company', filter: null}, $event, '=')"
          id="company" placeholder="Select company" type="Catalog.Company">
        </j-autocomplete-png>
      </div>
      <div fxFlex>
        <j-autocomplete-png [ngModel]="super?.filters['Group']?.value" [inputStyle]="{'background-color': 'lightgoldenrodyellow'}"
          (ngModelChange)="super.update({field: 'Group', filter: null}, $event, '=')"
          id="Group" placeholder="Select group of operation" type="Catalog.Operation.Group">
        </j-autocomplete-png>
      </div>
      </div>
  </div>
  <j-list></j-list>
  `
})
export class OperationListComponent implements OnInit {
  @ViewChild(BaseDocListComponent, { static: true }) super: BaseDocListComponent;

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
