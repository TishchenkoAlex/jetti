import { ChangeDetectionStrategy, Component, OnInit, ViewChild, Input } from '@angular/core';
import { SelectItem } from 'primeng/components/common/selectitem';
// tslint:disable-next-line:import-blacklist
import { Observable } from 'rxjs';
import { map, take } from 'rxjs/operators';
import { BaseDocListComponent } from './../../common/datatable/base.list.component';
import { DocTypes } from '../../../../../../jetti-api/server/models/documents.types';
import { IViewModel } from '../../../../../../jetti-api/server/models/common-types';
import { AuthService } from 'src/app/auth/auth.service';
import { FormListSettings, FormListFilter } from '../../../../../../jetti-api/server/models/user.settings';


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
      <div fxFlex>
        <j-autocomplete-png [ngModel]="super?.filters['user']?.value" [inputStyle]="{'background-color': 'lightgoldenrodyellow'}"
          (ngModelChange)="super.update({field: 'user', filter: null}, $event, '=')"
          id="user" placeholder="Select user" type="Catalog.User">
        </j-autocomplete-png>
      </div>
      </div>
  </div>
  <j-list [data]="this.data" [type]="this.type" [settings]="settings" ></j-list>
  `
})
export class OperationListComponent implements OnInit {
  @Input() type: DocTypes;
  @Input() data: IViewModel;

  @ViewChild(BaseDocListComponent, { static: true }) super: BaseDocListComponent;

  operationsGroups$: Observable<SelectItem[]>;

  settings = new FormListSettings();

  constructor(public appAuth: AuthService) { }

  ngOnInit() {
    this.operationsGroups$ = this.super.ds.api.getOperationsGroups().pipe(
      map(data => [
        { label: '(All)', value: null },
        ...data.map(el => <SelectItem>({ label: el.value, value: el })) || []
      ]));
    this.appAuth.userProfile$.pipe(take(1)).subscribe(u => {
      const filter = new FormListFilter('user', '=', u.account.env);
      this.settings.filter = [filter];
    });
  }

  onChange(event) {
    this.super.filters.Group = { matchMode: '=', value: event.value };
    this.super.prepareDataSource();
    this.super.dataSource.sort();
  }

}
