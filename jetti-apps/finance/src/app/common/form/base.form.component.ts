import { CdkTrapFocus } from '@angular/cdk/a11y';
import { Location } from '@angular/common';
import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, OnDestroy, OnInit, QueryList, ViewChildren } from '@angular/core';
import { FormControl, FormGroup, FormArray } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { MenuItem } from 'primeng/components/common/menuitem';
import { merge, of as observableOf, Subscription } from 'rxjs';
import { filter, take } from 'rxjs/operators';
import { v1 } from 'uuid';
import { dateReviverLocal } from '../../../../../../jetti-api/server/fuctions/dateReviver';
import { calculateDescription } from '../../../../../../jetti-api/server/models/common-types';
import { DocumentBase, DocumentOptions, Ref, Relation } from '../../../../../../jetti-api/server/models/document';
import { DocService } from '../../common/doc.service';
import { FormControlInfo } from '../dynamic-form/dynamic-form-base';
import { patchOptionsNoEvents, DynamicFormService } from '../dynamic-form/dynamic-form.service';
import { LoadingService } from '../loading.service';
import { TabsStore } from '../tabcontroller/tabs.store';
import { AuthService } from 'src/app/auth/auth.service';
import { createDocument } from '../../../../../../jetti-api/server/models/documents.factory';
import { DocTypes } from '../../../../../../jetti-api/server/models/documents.types';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-form',
  templateUrl: './base.form.component.html'
})
export class BaseDocFormComponent implements OnInit, OnDestroy {

  @Input() id = this.route.snapshot.params.id as string;
  @Input() type = this.route.snapshot.params.type as DocTypes;
  @Input() form = this.route.snapshot.data.detail as FormGroup;
  @ViewChildren(CdkTrapFocus) cdkTrapFocus: QueryList<CdkTrapFocus>;

  isCopy = this.route.snapshot.queryParams.command === 'copy';
  isDoc = this.type.startsWith('Document.');

  get Form() { return this.form; }
  get viewModel() { return this.Form.getRawValue() as DocumentBase; }
  get docDescription() { return <string>this.Form['metadata'].description; }
  get metadata() { return <DocumentOptions>this.Form['metadata']; }
  get relations() { return (this.Form['metadata'].relations || []) as Relation[]; }
  get v() { return <FormControlInfo[]>this.Form['orderedControls']; }
  get vk() { return <{ [key: string]: FormControlInfo }>this.Form['byKeyControls']; }
  get tables() { return (<FormControlInfo[]>this.Form['orderedControls']).filter(t => t.type === 'table'); }
  get hasTables() { return this.tables.length > 0; }
  get description() { return <FormControl>this.Form.get('description'); }
  get isPosted() { return <boolean>!!this.Form.get('posted').value; }
  get isDeleted() { return <boolean>!!this.Form.get('deleted').value; }
  get isNew() { return !this.Form.get('timestamp').value; }
  get isFolder() { return !!this.Form.get('isfolder').value; }
  get commands() {
    return (this.metadata['commands'] as any[] || []).map(c => {
      if (c && typeof c.command === 'function') return c;
      return (<MenuItem>{
        label: c.label, icon: c.icon,
        command: () => this.commandOnSever(c.command)
      });
    });
  }
  get copyTo() {
    return (this.metadata['copyTo'] as any[] || []).map(c => {
      if (c && typeof c.command === 'function') return c;
      const { description, icon } = createDocument(c).Prop() as DocumentOptions;
      return (<MenuItem>{ label: description, icon, command: (event) => this.baseOn(c) });
    });
  }
  get module() { return this.metadata['clientModule'] || {}; }

  private _subscription$: Subscription = Subscription.EMPTY;
  private _descriptionSubscription$: Subscription = Subscription.EMPTY;
  private _saveCloseSubscription$: Subscription = Subscription.EMPTY;
  private _postSubscription$: Subscription = Subscription.EMPTY;
  private uuid = this.route.snapshot.queryParams.uuid;

  constructor(public router: Router, public route: ActivatedRoute, public lds: LoadingService, public auth: AuthService,
    public cd: ChangeDetectorRef, public ds: DocService, public location: Location,
    public tabStore: TabsStore, private dss: DynamicFormService) { }

  ngOnInit() {

    this._subscription$ = merge(...[this.ds.save$, this.ds.delete$, this.ds.post$, this.ds.unpost$]).pipe(
      filter(doc => doc.id === this.id))
      .subscribe(doc => {
        this.Form.patchValue(doc, patchOptionsNoEvents);
        if (this.isDoc) { this.showDescription(); }
        this.Form.markAsPristine();
      });

    this._saveCloseSubscription$ = this.ds.saveClose$.pipe(
      filter(doc => doc.id === this.id))
      .subscribe(doc => {
        this.Form.markAsPristine();
        this.close();
      });

    this._descriptionSubscription$ = merge(...[
      this.Form.get('date')!.valueChanges,
      this.Form.get('code')!.valueChanges,
      this.Form.get('Group') ? this.Form.get('Group')!.valueChanges : observableOf('')])
      .pipe(filter(_ => this.isDoc)).subscribe(_ => this.showDescription());

  }

  refresh() {
    this.dss.getViewModel$(this.type, this.viewModel.id).pipe(take(1)).subscribe(formGroup => {
      this.form = formGroup;
      setTimeout(() => this.cd.detectChanges());
    });
  }

  showDescription() {
    if (this.isDoc) {
      const date = this.Form.get('date')!.value;
      const code = this.Form.get('code')!.value;
      const group = this.Form.get('Group') && this.Form.get('Group')!.value ? this.Form.get('Group')!.value.value : '';
      const value = calculateDescription(this.docDescription, JSON.parse(JSON.stringify(date), dateReviverLocal), code, group);
      this.description.patchValue(value, patchOptionsNoEvents);
    }
  }

  Save() { this.showDescription(); this.ds.save(this.viewModel); }
  delete() { this.ds.delete(this.viewModel.id); }
  post() { const doc = this.viewModel; this.ds.post(doc); }
  unPost() { this.ds.unpost(this.viewModel); }
  postClose() { const doc = this.viewModel; this.ds.post(doc, true); }
  copy() {
    return this.router.navigate(
      [this.viewModel.type, v1().toUpperCase()], { queryParams: { copy: this.id } });
  }

  goto() {
    return this.router.navigate([this.viewModel.type],
      { queryParams: { goto: this.id, posted: this.viewModel.posted }, replaceUrl: true });
  }

  private _close() {
    const tab = this.tabStore.state.tabs.find(t => t.docID === this.id);
    if (tab) {
      this.tabStore.close(tab);
      const returnTab = this.tabStore.state.tabs[this.tabStore.selectedIndex];
      this.router.navigate([returnTab.docType, returnTab.docID]);
    }
  }

  close() {
    if (this.Form.pristine) { this._close(); return; }
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

  baseOn(type: DocTypes, Operation?: Ref) {
    this.router.navigate([type, v1()],
      { queryParams: { base: this.id, Operation } });
  }

  commandOnSever(method: string) {
    this.ds.api.onCommand(this.Form.getRawValue(), method, {}).then(value => {
      const form = this.dss.getViewModel(this.type, this.Form['schema'], value);
      this.form = form;
      setTimeout(() => this.cd.detectChanges());
    });
  }

  commandOnClient(method: string) {
    this.module[method](this.Form.getRawValue()).then(value => {
      this.Form.patchValue(value || {}, patchOptionsNoEvents);
      this.Form.markAsDirty();
    });
  }

  startWorkFlow() {
    this.ds.startWorkFlow(this.id).then(doc => {
      this.Form.patchValue({ workflow: { id: doc.id, type: doc.type, code: doc.code, value: doc.description } });
      this.Save();
      this.router.navigate([doc.type, doc.id]);
    });
  }

  ngOnDestroy() {
    this._subscription$.unsubscribe();
    this._descriptionSubscription$.unsubscribe();
    this._saveCloseSubscription$.unsubscribe();
    this._postSubscription$.unsubscribe();
    this.ds.showDialog(this.uuid, this.viewModel);
  }

}
