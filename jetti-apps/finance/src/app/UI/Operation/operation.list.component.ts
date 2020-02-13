import { ActivatedRoute } from '@angular/router';
import { ChangeDetectionStrategy, Component, OnInit, ViewChild, Input } from '@angular/core';
import { take } from 'rxjs/operators';
import { BaseDocListComponent } from './../../common/datatable/base.list.component';
import { DocTypes } from '../../../../../../jetti-api/server/models/documents.types';
import { IViewModel } from '../../../../../../jetti-api/server/models/common-types';
import { AuthService } from 'src/app/auth/auth.service';

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
      <div fxFlex *ngIf="!super.group">
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
  <j-list [data]="this.data" [type]="this.type" ></j-list>
  `
})
export class OperationListComponent implements OnInit {
  @Input() type: DocTypes;
  @Input() data: IViewModel;

  @ViewChild(BaseDocListComponent, { static: true }) super: BaseDocListComponent;

  constructor(public appAuth: AuthService, public route: ActivatedRoute) { }

  ngOnInit() {
    if (this.route.snapshot.queryParams.goto) return;
    this.appAuth.userProfile$.pipe(take(1)).subscribe(u => {
      this.super.settings.filter.push({ left: 'user', center: '=', right: u.account.env });
    });
  }

}
