import { ActivatedRoute } from '@angular/router';
import { ChangeDetectionStrategy, Component, OnInit, ViewChild, Input } from '@angular/core';
import { take } from 'rxjs/operators';
import { DocTypes } from '../../../../../../jetti-api/server/models/documents.types';
import { IViewModel } from '../../../../../../jetti-api/server/models/common-types';
import { AuthService } from 'src/app/auth/auth.service';
import { BaseHierarchyListComponent } from 'src/app/common/datatable/base.hierarchy-list.component';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
  <div fxLayout="column" style="padding: 6px" cdkTrapFocus [cdkTrapFocusAutoCapture]="true" cdkFocusInitial>
    <div fxLayout="row" fxLayout.xs="column" fxLayoutGap="35px" fxLayoutGap.xs="6px" style="margin-top: 12px; margin-bottom: 6px">
      <div fxFlex>
        <j-autocomplete-png [ngModel]="getSuperColumn('company')?.right" [inputStyle]="{'background-color': 'lightgoldenrodyellow'}"
          (ngModelChange)="super.update(getSuperColumn('company'), $event, '=')"
          id="company" placeholder="Select company" type="Catalog.Company">
        </j-autocomplete-png>
      </div>
      <div fxFlex *ngIf="!super.group">
        <j-autocomplete-png [ngModel]="getSuperColumn('Group')?.right" [inputStyle]="{'background-color': 'lightgoldenrodyellow'}"
          (ngModelChange)="super.update(getSuperColumn('Group'), $event, '=')"
          id="Group" placeholder="Select group of operation" type="Catalog.Operation.Group">
        </j-autocomplete-png>
      </div>
      <div fxFlex>
        <j-autocomplete-png [ngModel]="getSuperColumn('user')?.right" [inputStyle]="{'background-color': 'lightgoldenrodyellow'}"
          (ngModelChange)="super.update(getSuperColumn('user'), $event, '=')"
          id="user" placeholder="Select user" type="Catalog.User">
        </j-autocomplete-png>
      </div>
      </div>
  </div>
  <j-hierarchy-list [data]="this.data" [type]="this.type" ></j-hierarchy-list>
  `
})
export class OperationListComponent implements OnInit {
  @Input() type: DocTypes;
  @Input() data: IViewModel;

  @ViewChild(BaseHierarchyListComponent, { static: true }) super: BaseHierarchyListComponent;

  constructor(public appAuth: AuthService, public route: ActivatedRoute) { }


  ngOnInit() {
    if (this.route.snapshot.queryParams.goto) return;
    this.appAuth.userProfile$.pipe(take(1)).subscribe(u => {
      this.super.settings.filter.push({ left: 'user', center: '=', right: u.account.env });
    });
  }

  getSuperColumn(field: string) {
    return this.super.getColumn(field);
  }

}
