import { CdkTrapFocus } from '@angular/cdk/a11y';
import { Location } from '@angular/common';
import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, OnDestroy, OnInit, QueryList, ViewChildren } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { MenuItem } from 'primeng/components/common/menuitem';
import { merge, of as observableOf, Subscription } from 'rxjs';
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
import { TaskComponent } from 'src/app/UI/BusinessProcesses/task.component';

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
  get hasTables() { return !!(<FormControlInfo[]>this.form['orderedControls']).find(t => t.type === 'table'); }
  get tables() { return (<FormControlInfo[]>this.form['orderedControls']).filter(t => t.type === 'table'); }
  get description() { return <FormControl>this.form.get('description'); }
  get isPosted() { return <boolean>!!this.form.get('posted')!.value; }
  get isDeleted() { return <boolean>!!this.form.get('deleted')!.value; }
  get isNew() { return !this.form.get('timestamp')!.value; }
  get isFolder() { return (!!this.form.get('isfolder')!.value); }
  get commands() { return (<MenuItem[]>this.form['metadata']['commands']) || []; }
  get copyTo() { return (<MenuItem[]>this.form['metadata']['copyTo']) || []; }
  get module() { return this.form['metadata']['clientModule'] || {}; }
  get getStatus() { return <string>this.form.get('Status').value; }
  get readonlyMode() { return false; }
    //  <string>this.form.get('Status').value !== 'PREPARED'; }

  private _subscription$: Subscription = Subscription.EMPTY;
  private _descriptionSubscription$: Subscription = Subscription.EMPTY;
  private _saveCloseSubscription$: Subscription = Subscription.EMPTY;
  private _postSubscription$: Subscription = Subscription.EMPTY;
  private _StatusChanges$: Subscription = Subscription.EMPTY;
  private _workflowIDChanges$: Subscription = Subscription.EMPTY;

  constructor(public router: Router, public route: ActivatedRoute, public lds: LoadingService, private auth: AuthService,
    public cd: ChangeDetectorRef, public ds: DocService, public location: Location, public tabStore: TabsStore,
    private bpApi: BPApi) { }

  ngOnInit() {
    // tslint:disable-next-line: max-line-length
    this._StatusChanges$ = this.form.get('Status').valueChanges.subscribe(v => { v === 'PREPARED' ? this.form.enable() : this.form.disable(); });
    this._workflowIDChanges$ = this.form.get('workflowID').valueChanges.subscribe(v => { this.form.get('Status').setValue('AWAITING'); });
    this._subscription$ = merge(...[this.ds.save$, this.ds.delete$, this.ds.post$, this.ds.unpost$]).pipe(
      filter(doc => doc.id === this.id))
      .subscribe(doc => {
        this.form.patchValue(doc, patchOptionsNoEvents);
        if (this.isDoc) { this.showDescription(); }
        this.form.markAsPristine();
      });

    this.form.get('Operation').setValue('Оплата поставщику');
    this.form.get('Status').setValue('PREPARED');

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
  Delete() { this.ds.delete(this.model.id); }
  Post() { const doc = this.model; this.ds.post(doc); }
  unPost() { this.ds.unpost(this.model); }
  PostClose() { const doc = this.model; this.ds.post(doc, true); }
  Copy() { return this.router.navigate([this.model.type, v1().toUpperCase()], { queryParams: { copy: this.id } }); }

  StartProcess() {
    // const pres = this.form.pristine;
    // if (!pres) { return; }
    // tslint:disable-next-line: max-line-length
    this.bpApi.StartProcess(this.form.value, this.metadata.type).pipe(take(1)).subscribe(data => { this.form.get('workflowID').setValue(data); });
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

  baseOn(id: Ref) {
    this.router.navigate([this.type, v1()],
      { queryParams: { base: this.id, Operation: id } });
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
    this._workflowIDChanges$.unsubscribe();
    this._StatusChanges$.unsubscribe();
  }

}
