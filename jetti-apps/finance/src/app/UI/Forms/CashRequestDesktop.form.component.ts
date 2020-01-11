import { Component, ChangeDetectionStrategy, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { _baseDocFormComponent } from 'src/app/common/form/_base.form.component';
import { Observable } from 'rxjs';
import { Router, ActivatedRoute } from '@angular/router';
import { MediaObserver } from '@angular/flex-layout';
import { DynamicFormService } from 'src/app/common/dynamic-form/dynamic-form.service';
import { DocService } from 'src/app/common/doc.service';
import { AuthService } from 'src/app/auth/auth.service';
import { TabsStore } from 'src/app/common/tabcontroller/tabs.store';
import { BPApi } from 'src/app/services/bpapi.service';
import { take } from 'rxjs/operators';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-CashRequestDesktop-form',
  templateUrl: './CashRequestDesktop.form.component.html',
  styles: [`
        .valid {
            background-color: #1CA979 !important;
            color: #ffffff !important;
        }

        .error {
            background-color: #2CA8B1 !important;
            color: #ffffff !important;
        }
    `
  ]
})
export class CashRequestDesktopComponent extends _baseDocFormComponent implements OnInit, OnDestroy {

  data$: Observable<any[]>;
  columns = [

    { field: 'date', label: 'Дата', type: 'date', style: '', editable: false },
    { field: 'company_field', label: 'Организация', type: 'string', style: '', editable: false },
    { field: 'CashRequest_name', label: 'Заявка на расход ДС', type: 'string', style: '', editable: false },
    { field: 'CashOrBank_name', label: 'Отправитель', type: 'string', style: '', editable: false },
    { field: 'CashRecipient_name', label: 'Получатель', type: 'string', style: '', editable: false },
    { field: 'currency_name', label: 'Валюта', type: 'string', style: '', editable: false },
    { field: 'Amount', label: 'Согласовано', type: 'number', style: '', editable: false },
    { field: 'AmountToPay', label: 'К оплате', type: 'number', style: '', editable: true }
  ];

  selectedRows = [];

  constructor(public router: Router, public route: ActivatedRoute, public media: MediaObserver, public dss: DynamicFormService,
    public cd: ChangeDetectorRef, public ds: DocService, public auth: AuthService, public tabStore: TabsStore, public bpApi: BPApi) {
      super(router, route, auth, ds, tabStore, dss, cd);
  }

  async Execute() {
    this.data$ = this.bpApi.CashRequestDesktop();
  }

  async Create() {
    const model = this.viewModel as any;
    model['CashRequests'] = this.selectedRows.map(e => (
      { CashRequest: { code: '', id: e.CashRequest, type: 'Document.CasheRequest', value: '' } }
    ));
    this.ds.api.execute('Form.CashRequestDesktop', 'Create', model).pipe(take(1)).subscribe(d => {  });
  }

  onEditableChanged(column, event, index, rowData) {

    if (rowData.AmountToPay > rowData.Amount) { rowData = { ...rowData, AmountToPay: rowData.Amount }; }
    if (rowData.AmountToPay < 0) { rowData.AmountToPay = 0; }
    if (rowData.AmountToPay > 0 && this.selectedRows.indexOf(rowData) === -1) {
      this.selectedRows = [this.selectedRows, rowData];
    }
    if (rowData.AmountToPay === 0 && this.selectedRows.indexOf(rowData) !== -1) {
      this.selectedRows = this.selectedRows.splice(this.selectedRows.indexOf(rowData));
    }
    let sumToPay = 0;
    this.selectedRows.forEach(e => { sumToPay += Number(e.AmountToPay); });
  }

}
