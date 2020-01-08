import { CdkTrapFocus } from '@angular/cdk/a11y';
import { Location } from '@angular/common';
import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, OnDestroy, OnInit, QueryList, ViewChildren } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { MenuItem } from 'primeng/components/common/menuitem';
import { merge, of as observableOf, Subscription, throwError } from 'rxjs';
import { filter, take } from 'rxjs/operators';
import { v1 } from 'uuid';
import { dateReviverLocal } from '../../../../../../jetti-api/server/fuctions/dateReviver';
import { calculateDescription } from '../../../../../../jetti-api/server/models/common-types';
import { DocumentBase, DocumentOptions, Ref } from '../../../../../../jetti-api/server/models/document';
import { DocService } from '../../common/doc.service';
import { AuthService } from 'src/app/auth/auth.service';
import { FormControlInfo } from 'src/app/common/dynamic-form/dynamic-form-base';
import { patchOptionsNoEvents } from 'src/app/common/dynamic-form/dynamic-form.service';
import { LoadingService } from 'src/app/common/loading.service';
import { TabsStore } from 'src/app/common/tabcontroller/tabs.store';
import { BPApi } from 'src/app/services/bpapi.service';
import { createDocument } from '../../../../../../jetti-api/server/models/documents.factory';
import { DocTypes } from '../../../../../../jetti-api/server/models/documents.types';

@Component({
  selector: 'doc-CashRequest',
  templateUrl: 'Document.CashRequest.html'
})
export class DocumentCashRequestComponent implements OnInit, OnDestroy {

  @Input() id = this.route.snapshot.params.id as string;
  @Input() type = this.route.snapshot.params.type as string;
  @Input() form = this.route.snapshot.data.detail as FormGroup;
  @ViewChildren(CdkTrapFocus) cdkTrapFocus: QueryList<CdkTrapFocus>;

  get model() { return this.form.getRawValue() as DocumentBase; }

  isDoc = this.type.startsWith('Document.');
  isCopy = this.route.snapshot.queryParams.command === 'copy';
  get docDescription() { return <string>this.form['metadata'].description; }
  get metadata() { return <DocumentOptions>this.form['metadata']; }
  get relations() { return this.form['metadata'].relations || []; }
  get v() { return <FormControlInfo[]>this.form['orderedControls']; }
  get vk() { return <{ [key: string]: FormControlInfo }>this.form['byKeyControls']; }
  get viewModel() { return this.form.getRawValue(); }
  get hasTables() { return !!(<FormControlInfo[]>this.form['orderedControls']).find(t => t.controlType === 'table'); }
  get tables() { return (<FormControlInfo[]>this.form['orderedControls']).filter(t => t.controlType === 'table'); }
  get description() { return <FormControl>this.form.get('description'); }
  get isPosted() { return <boolean>!!this.form.get('posted')!.value; }
  get isDeleted() { return <boolean>!!this.form.get('deleted')!.value; }
  get isNew() { return !this.form.get('timestamp')!.value; }
  get isFolder() { return (!!this.form.get('isfolder')!.value); }
  get commands() { return (<MenuItem[]>this.form['metadata']['commands']) || []; }
  get copyTo() { return (<MenuItem[]>this.form['metadata']['copyTo']) || []; }
  get module() { return this.form['metadata']['clientModule'] || {}; }
  get readonlyMode() { return !this.isNew && this.form.get('Status').value !== 'PREPARED'; }

  private _subscription$: Subscription = Subscription.EMPTY;
  private _descriptionSubscription$: Subscription = Subscription.EMPTY;
  private _saveCloseSubscription$: Subscription = Subscription.EMPTY;
  private _postSubscription$: Subscription = Subscription.EMPTY;

  constructor(public router: Router, public route: ActivatedRoute, public lds: LoadingService, private auth: AuthService,
    public cd: ChangeDetectorRef, public ds: DocService, public location: Location, public tabStore: TabsStore,
    private bpApi: BPApi) { }

  ngOnInit() {
    this._subscription$ = merge(...[this.ds.save$, this.ds.delete$, this.ds.post$, this.ds.unpost$]).pipe(
      filter(doc => doc.id === this.id))
      .subscribe(doc => {
        this.form.patchValue(doc, patchOptionsNoEvents);
        if (this.isDoc) { this.showDescription(); }
        this.form.markAsPristine();
      });

    if (this.isNew) {
      this.form.get('Status').setValue('PREPARED');
      this.form.get('workflowID').setValue('');
      this.form.get('Operation').setValue('Оплата поставщику');
    }

    this.initCopyTo();
    this._saveCloseSubscription$ = this.ds.saveClose$.pipe(
      filter(doc => doc.id === this.id))
      .subscribe(doc => {
        this.form.markAsPristine();
        this.Close();
      });

    this._descriptionSubscription$ = merge(...[
      this.form.get('date')!.valueChanges,
      this.form.get('code')!.valueChanges,
      this.form.get('Group') ? this.form.get('Group')!.valueChanges : observableOf('')])
      .pipe(filter(_ => this.isDoc)).subscribe(_ => this.showDescription());

    if (this.readonlyMode) { this.form.disable({ emitEvent: false} ); }
  }


  baseOn(type: DocTypes, Operation?: Ref) {
    this.router.navigate([type, v1()],
      { queryParams: { base: this.id, Operation } });
  }

  private initCopyTo() {
    const prop = createDocument(this.type as any).Prop() as DocumentOptions;
    (prop.copyTo || []).map(el => {
      const { description, icon } = createDocument(el).Prop() as DocumentOptions;
      this.copyTo.push({ label: description, icon, command: (event) => this.baseOn(el) });
    });
  }

  showDescription() {
    if (this.isDoc) {
      const date = this.form.get('date')!.value;
      const code = this.form.get('code')!.value;
      const group = this.form.get('Group') && this.form.get('Group')!.value ? this.form.get('Group')!.value.value : '';
      const value = calculateDescription(this.docDescription, JSON.parse(JSON.stringify(date), dateReviverLocal), code, group);
      this.description.patchValue(value, patchOptionsNoEvents);
    }
  }

  Save() { this.showDescription(); this.ds.save(this.model); }
  Delete() { this.ds.delete(this.model.id); this.form.enable(); }

  Post() { const doc = this.model; this.ds.post(doc); }
  unPost() { this.ds.unpost(this.model); }
  PostClose() { const doc = this.model; this.ds.post(doc, true); }
  Copy() { return this.router.navigate([this.model.type, v1().toUpperCase()], { queryParams: { copy: this.id } }); }

  onOperationChanges(operation: string) {

    // 'Оплата поставщику',
    // 'Перечисление налогов и взносов',
    // 'Оплата ДС в другую организацию',
    // 'Выдача ДС подотчетнику',
    // 'Оплата по кредитам и займам полученным',
    // 'Прочий расход ДС',
    // 'Выдача займа контрагенту',
    // 'Возврат оплаты клиенту'

    this.vk['CashOrBank'].required = operation === 'Оплата ДС в другую организацию';
    this.vk['CashOrBankIn'].required = operation === 'Оплата ДС в другую организацию';
    this.vk['PaymentKind'].required = operation === 'Оплата по кредитам и займам полученным';
    this.vk['BalanceAnalytics'].required = operation === 'Перечисление налогов и взносов';

    this.vk['CashRecipient'].required =
      `Оплата поставщику
      Перечисление налогов и взносов
      Оплата ДС в другую организацию
      Выдача ДС подотчетнику
      Оплата по кредитам и займам полученным
      Выдача займа контрагенту
      Возврат оплаты клиенту`.indexOf(operation) !== -1;

    this.vk['Contract'].required =
      `Оплата поставщику
      Возврат оплаты клиенту`.indexOf(operation) !== -1;

    this.vk['ExpenseOrBalance'].required =
      `Перечисление налогов и взносов
      Прочий расход ДС`.indexOf(operation) !== -1;

    this.vk['Loan'].required =
      `Оплата по кредитам и займам полученным
      Выдача займа контрагенту`.indexOf(operation) !== -1;

    this.form.markAsTouched();
  }

  onCashKindChange(event) {

    let CashKindType = '';
    if (event === 'BANK') {
      CashKindType = 'Catalog.BankAccount';
    } else {
      CashKindType = 'Catalog.CashRegister';
    }

    this.form.get('CashOrBank').setValue(
      { id: null, code: null, type: CashKindType, value: null },
      { onlySelf: false, emitEvent: false }
    );
  }

  StartProcess() {
    this.bpApi.StartProcess(this.model, this.metadata.type).pipe(take(1)).subscribe(data => {
      this.form.get('workflowID').setValue(data);
      this.form.get('Status').setValue('AWAITING');
      this.Post();
      this.form.disable({emitEvent: false});
      this.ds.openSnackBar('success', 'process started', 'Процесс согласования стартован');
    });
  }

  Goto() {
    return this.router.navigate([this.model.type],
      { queryParams: { goto: this.id, posted: this.model.posted }, replaceUrl: true });
  }

  private _close() {
    const tab = this.tabStore.state.tabs.find(t => t.docID === this.id);
    if (tab) {
      this.tabStore.close(tab);
      const parentTab = this.tabStore.state.tabs.find(t => t.docType === this.type && !t.docID);
      if (parentTab) {
        this.router.navigate([parentTab.docType, parentTab.docID]);
      } else {
        const returnTab = this.tabStore.state.tabs[this.tabStore.selectedIndex];
        this.router.navigate([returnTab.docType, returnTab.docID]);
      }
    }
  }

  Close() {
    if (this.form.pristine || this.readonlyMode) { this._close(); return; }
    this.ds.confirmationService.confirm({
      header: 'Discard changes and close?',
      message: this.description.value,
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

  Print = () => {
    throw new Error('Print not implemented!');
  }

  commandOnSever(method: string) {
    this.ds.api.onCommand(this.form.value, method, {}).then(value => {
      this.form.patchValue(value || {}, patchOptionsNoEvents);
      this.form.markAsDirty();
    });
  }

  commandOnClient(method: string) {
    this.module[method](this.form.getRawValue()).then(value => {
      this.form.patchValue(value || {}, patchOptionsNoEvents);
      this.form.markAsDirty();
    });
  }

  startWorkFlow() {
    this.ds.startWorkFlow(this.id).then(doc => {
      this.form.patchValue({ workflow: { id: doc.id, type: doc.type, code: doc.code, value: doc.description } });
      this.Save();
      this.router.navigate([doc.type, doc.id]);
    });
  }

  ngOnDestroy() {
    this._subscription$.unsubscribe();
    this._descriptionSubscription$.unsubscribe();
    this._saveCloseSubscription$.unsubscribe();
    this._postSubscription$.unsubscribe();
  }

}
