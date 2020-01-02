import { CdkTrapFocus } from '@angular/cdk/a11y';
import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, QueryList, ViewChildren, OnDestroy } from '@angular/core';
import { MediaObserver } from '@angular/flex-layout';
import { FormControl, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { FormBase } from '../../../../../../jetti-api/server/models/Forms/form';
import { AuthService } from '../../auth/auth.service';
import { DocService } from '../../common/doc.service';
import { FormControlInfo } from 'src/app/common/dynamic-form/dynamic-form-base';
import { TabsStore } from 'src/app/common/tabcontroller/tabs.store';
import { take, filter, sampleTime } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import * as IO from 'socket.io-client';
import { BPApi } from 'src/app/services/bpapi.service';
import { Observable } from 'rxjs';
import { CashRequestDesktop } from '../../../../../../jetti-api/server/models/Forms/Form.CashRequestDesktop';

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

export class CashRequestDesktopComponent {

  @Input() id = Math.random().toString();
  @Input() type = this.route.snapshot.params.type as string;
  @Input() form: FormGroup = this.route.snapshot.data.detail;
  @ViewChildren(CdkTrapFocus) cdkTrapFocus: QueryList<CdkTrapFocus>;

  get model() { return this.form.getRawValue() as CashRequestDesktop; }

  get docDescription() { return <string>this.form['metadata'].description; }
  get v() { return <FormControlInfo[]>this.form['orderedControls']; }
  get vk() { return <{ [key: string]: FormControlInfo }>this.form['byKeyControls']; }
  get hasTables() { return !!(<FormControlInfo[]>this.form['orderedControls']).find(t => t.controlType === 'table'); }
  get tables() { return (<FormControlInfo[]>this.form['orderedControls']).filter(t => t.controlType === 'table'); }
  get description() { return <FormControl>this.form.get('description'); }

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

  constructor(public router: Router, public route: ActivatedRoute, public media: MediaObserver,
    public cd: ChangeDetectorRef, public ds: DocService, private auth: AuthService, public tabStore: TabsStore, public bpApi: BPApi) {
  }

  private _close() {
    this.tabStore.close(this.tabStore.state.tabs[this.tabStore.selectedIndex]);
    const returnTab = this.tabStore.state.tabs[this.tabStore.selectedIndex];
    this.router.navigate([returnTab.docType, returnTab.docID]);
  }

  Close() {
    if (this.form.pristine) { this._close(); return; }
    this.ds.confirmationService.confirm({
      header: 'Discard changes and close?',
      message: '',
      icon: 'fa fa-question-circle',
      accept: this._close.bind(this),
      reject: this.focus.bind(this),
      key: this.id
    });
    this.cd.detectChanges();
  }

  focus() {
    const autoCapture = this.cdkTrapFocus.find(el => el.autoCapture);
    if (autoCapture) autoCapture.focusTrap.focusFirstTabbableElementWhenReady();
  }

  async Execute() {
    this.data$ = this.bpApi.CashRequestDesktop();
    //   if (this.data$.length) {
    //     Object.keys(this.data$[0]).forEach(el => {
    //       this.dataFields$.push({ name: el, label: el });
    //     });
    //   } else { this.dataFields = [] }
    // });
  }

  async Create() {
    const model = this.model as any;
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

  onRowEditInit(rowData) {
  }

  onRowEditSave(rowData) {
  }

  onRowEditCancel(rowData, index: number) {
  }

}

