import { Component, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { _baseDocFormComponent, IFormEventsModel } from 'src/app/common/form/_base.form.component';
import { Router, ActivatedRoute } from '@angular/router';
import { LoadingService } from 'src/app/common/loading.service';
import { AuthService } from 'src/app/auth/auth.service';
import { DocService } from 'src/app/common/doc.service';
import { TabsStore } from 'src/app/common/tabcontroller/tabs.store';
import { BPApi } from 'src/app/services/bpapi.service';
import { DynamicFormService } from 'src/app/common/dynamic-form/dynamic-form.service';
import { DocumentBase } from '../../../../../../jetti-api/server/models/document';
import { take } from 'rxjs/operators';
import { ApiService } from 'src/app/services/api.service';

@Component({
  selector: 'doc-CashRequest',
  templateUrl: 'Document.CashRequest.html'
})
export class DocumentCashRequestComponent extends _baseDocFormComponent implements OnInit, OnDestroy, IFormEventsModel {
  get readonlyMode() { return !this.isSuperUser && !this.isNew && ['PREPARED', 'MODIFY'].indexOf(this.form.get('Status').value) === -1; }
  constructor(public router: Router, public route: ActivatedRoute, public lds: LoadingService, public auth: AuthService,
    public cd: ChangeDetectorRef, public ds: DocService, public tabStore: TabsStore,
    private bpApi: BPApi, public dss: DynamicFormService, private api: ApiService) {
    super(router, route, auth, ds, tabStore, dss, cd);
  }

  isSuperUser = false;
  canModifyProcess = false;

  ngOnInit() {
    super.ngOnInit();
    if (this.isHistory) return;
    this.onOpen();
  }

  getValue(fieldName: string): any {
    return this.form.get(fieldName).value;
  }

  setValue(fieldName: string, value: any, options?: any) {
    this.form.get(fieldName).setValue(value, options);
  }

  onOperationChanges(operation: string) {

    // 'Оплата поставщику',
    // 'Перечисление налогов и взносов',
    // 'Оплата ДС в другую организацию',
    // 'Выдача ДС подотчетнику',
    // 'Оплата по кредитам и займам полученным',
    // 'Прочий расход ДС',
    // 'Выдача займа контрагенту',
    // 'Возврат оплаты клиенту'
    // 'Выплата заработной платы'
    // tslint:disable
    if (operation === 'Выплата заработной платы') this.form.get('PayRollKind').enable({ emitEvent: false }); else this.form.get('PayRollKind').disable({ emitEvent: false });

    if (operation === 'Оплата ДС в другую организацию') this.form.get('CashOrBankIn').enable({ emitEvent: false }); else this.form.get('CashOrBankIn').disable({ emitEvent: false });
    if (operation === 'Перечисление налогов и взносов') this.form.get('BalanceAnalytics').enable({ emitEvent: false }); else this.form.get('BalanceAnalytics').disable({ emitEvent: false });

    if (`Выплата заработной платы
    Оплата по кредитам и займам полученным`.indexOf(operation) !== -1) this.form.get('PaymentKind').enable({ emitEvent: false }); else this.form.get('PaymentKind').disable({ emitEvent: false });

    if (`Оплата поставщику
    Перечисление налогов и взносов
    Оплата ДС в другую организацию
    Выдача ДС подотчетнику
    Оплата по кредитам и займам полученным
    Выдача займа контрагенту
    Выплата заработной платы без ведомости
    Возврат оплаты клиенту`.indexOf(operation) !== -1) this.form.get('CashRecipient').enable({ emitEvent: false }); else this.form.get('CashRecipient').disable({ emitEvent: false });

    // if (`Выплата заработной платы
    // Оплата ДС в другую организацию`.indexOf(operation) !== -1) this.form.get('CashOrBank').enable({emitEvent:false}); else this.form.get('CashOrBank').disable({emitEvent:false});

    if (`Оплата поставщику
    Возврат оплаты клиенту`.indexOf(operation) !== -1) this.form.get('Contract').enable({ emitEvent: false }); else this.form.get('Contract').disable({ emitEvent: false });

    if (`Перечисление налогов и взносов
    Прочий расход ДС`.indexOf(operation) !== -1) this.form.get('ExpenseOrBalance').enable({ emitEvent: false }); else this.form.get('ExpenseOrBalance').disable({ emitEvent: false });

    if (`Оплата по кредитам и займам полученным
    Выдача займа контрагенту`.indexOf(operation) !== -1) this.form.get('Loan').enable({ emitEvent: false }); else this.form.get('Loan').disable({ emitEvent: false });

    `TaxPaymentCode
    TaxOfficeCode2
    TaxPayerStatus
    TaxBasisPayment
    TaxPaymentPeriod`.split('\n').forEach(el => { this.vk[el.trim()].required = operation === 'Перечисление налогов и взносов' });

    this.vk['CashOrBank'].required = operation === 'Выплата заработной платы';
    this.form.markAsTouched();

    let CashRecipient = null;

    switch (operation) {
      case 'Оплата ДС в другую организацию':
        CashRecipient = this.getValue('CashRecipient');
        const CashOrBankIn = this.getValue('CashOrBankIn');
        if (!CashOrBankIn || CashOrBankIn.type !== 'Catalog.BankAccount') {
          this.setValue('CashOrBankIn',
            { id: null, code: null, type: 'Catalog.BankAccount', value: null },
            { onlySelf: false, emitEvent: false }
          );
        }
        if (!CashRecipient || CashRecipient.type !== 'Catalog.Company') {
          this.setValue('CashRecipient',
            { id: null, code: null, type: 'Catalog.Company', value: null },
            { onlySelf: false, emitEvent: false }
          );
        }
        break;
      case 'Перечисление налогов и взносов':
        const TaxRate = this.getValue('TaxRate');
        if (!TaxRate || TaxRate.id !== '7CFE6E50-35EA-11EA-A185-21EAFAF35D68') {
          let a = this.api.byId('7CFE6E50-35EA-11EA-A185-21EAFAF35D68').then(val => {
            this.setValue('TaxRate',
              { id: val.id, code: val.code, type: 'Catalog.TaxRate', value: val.description },
              { onlySelf: false, emitEvent: false })
          })
        };
        break;
      case 'Выплата заработной платы без ведомости':
        CashRecipient = this.getValue('CashRecipient');
        if (!CashRecipient || CashRecipient.type !== 'Catalog.Person') {
          this.setValue('CashRecipient',
            { id: null, code: null, type: 'Catalog.Person', value: null },
            { onlySelf: false, emitEvent: false }
          );
        }
        break;
      default:
        break;
    }


  }

  beforePost() {
    const oper = this.getValue('Operation');
    const CashRecipient = this.getValue('CashRecipient');
    if ((!CashRecipient || !CashRecipient.value) && `Оплата поставщику
    Перечисление налогов и взносов
    Оплата ДС в другую организацию
    Выдача ДС подотчетнику
    Оплата по кредитам и займам полученным
    Выдача займа контрагенту
    Возврат оплаты клиенту`.includes(oper)) this.throwError('Ошибка', 'Не указан получатель');
    const CashRecipientBankAccount = this.getValue('CashRecipientBankAccount');
    if (oper === 'Оплата поставщику' && (!CashRecipientBankAccount || !CashRecipientBankAccount.value)) this.throwError('Ошибка', 'Не указан счет получателя');
  }


  async onOpen() {

    this.isSuperUser = this.auth.isRoleAvailable('Cash request admin');
    this.canModifyProcess = this.isSuperUser ||
      (this.getValue('Status').value === 'MODIFY'
        && await this.bpApi.isUserCurrentExecutant(this.getValue('workflowID').value));

    if (this.isSuperUser) {
      this.form.enable({ emitEvent: false });
      this.vk.Status.readOnly = false;
    }

    if (this.isNew) {
      this.setValue('Status', 'PREPARED', { emitEvent: false });
      this.setValue('workflowID', '', { emitEvent: false });
      this.setValue('PayDay', null, { emitEvent: false });
      if (this.getValue('Amount') === 0) this.setValue('Amount', null, { emitEvent: false });
      if (!this.getValue('Operation')) this.setValue('Operation', 'Оплата поставщику', { emitEvent: false });
      this.onOperationChanges(this.getValue('Operation'));
    }

    if (this.readonlyMode) {
      this.form.disable({ emitEvent: false });
      this.form.get('info').enable({ emitEvent: false });
    }
  }

  refresh() {
    this.dss.getViewModel$(this.type, this.viewModel.id).pipe(take(1)).subscribe(formGroup => {
      this.Next(formGroup);
      this.onOpen();
    });
  }

  onCashKindChange(event) {
    if (event === 'ANY') return;
    const CashOrBank = this.getValue('CashOrBank');
    let CashKindType = '';
    if (event === 'BANK') {
      CashKindType = 'Catalog.BankAccount';
    } else {
      CashKindType = 'Catalog.CashRegister';
    }
    if (!CashOrBank || CashOrBank.type !== CashKindType) {
      this.setValue('CashOrBank',
        { id: null, code: null, type: CashKindType, value: null },
        { onlySelf: false, emitEvent: false }
      );
    }
  }

  StartProcess() {
    this.bpApi.StartProcess(
      this.viewModel as DocumentBase,
      this.metadata.type,
      this.auth.userProfile.account.email).pipe(take(1)).subscribe(data => this.handleBpApiResponse(data));
  }

  ContinueAgreement() {
    this.bpApi.ModifyProcess(
      this.viewModel as DocumentBase,
      this.metadata.type,
      this.auth.userProfile.account.email,
      this.getValue('workflowID').value).pipe(take(1)).subscribe(data => this.handleBpApiResponse(data));
  }

  handleBpApiResponse(response: any) {
    switch (response) {
      case 'APPROVED':
        this.setValue('workflowID', '');
        this.setValue('Status', 'APPROVED');
        this.ds.openSnackBar('success', 'Заявка утверждена', 'Согласование не требуется');
        break;
      default:
        this.setValue('workflowID', response);
        this.setValue('Status', 'AWAITING');
        this.ds.openSnackBar('success', 'Согласование запущено', `Стартован процесс №${response}`);
        break;
    }
    this.post();
    this.form.disable({ emitEvent: false });
  }

  print() {
    window.open('https://bi.x100-group.com/ReportServer/Pages/ReportViewer.aspx?/Jetti/Print/ActSalary&rs:Command=Render&rc:Parameters=false&document=' + this.id, '_blank');
  }

  OpenReport() {
    window.open('https://bi.x100-group.com/Reports/report/Jetti/Cash/CashRequest?rs:Command=Render', '_blank');
  }
}