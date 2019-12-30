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
import { patchOptionsNoEvents, getFormGroup, DynamicFormService } from '../dynamic-form/dynamic-form.service';
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

  model: DocumentBase;
  docDescription: string;
  metadata: DocumentOptions;
  relations: Relation[];
  v: FormControlInfo[];
  vk: { [key: string]: FormControlInfo };
  hasTables: boolean;
  tables: FormControlInfo[];
  description: FormControl;
  isPosted: boolean;
  isDeleted: boolean;
  isNew: boolean;
  isFolder: boolean;
  commands: MenuItem[];
  copyTo: MenuItem[];
  module: any;
  schema: { [key: string]: any };

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
        this.form.patchValue(doc, patchOptionsNoEvents);
        if (this.isDoc) { this.showDescription(); }
        this.form.markAsPristine();
      });

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

    this.initForm(this.form);
  }

  initForm(form: FormGroup) {
    this.model = form.getRawValue() as DocumentBase;
    this.docDescription = form['metadata'].description as string;
    this.relations = [...<Relation[]>form['metadata'].relations];
    this.v = [...<FormControlInfo[]>form['orderedControls']];
    this.vk = { ...<{ [key: string]: FormControlInfo }>form['byKeyControls'] };
    this.hasTables = !!(<FormControlInfo[]>form['orderedControls']).find(t => t.type === 'table');
    this.tables = [...(<FormControlInfo[]>form['orderedControls']).filter(t => t.type === 'table')];
    this.description = <FormControl>form.get('description');
    this.isPosted = <boolean>!!form.get('posted')!.value;
    this.isDeleted = <boolean>!!form.get('deleted')!.value;
    this.isNew = !form.get('timestamp')!.value;
    this.isFolder = (!!form.get('isfolder')!.value);

    this.copyTo = [];
    [...(form['metadata']['copyTo'] || [])].map(el => {
      const { description, icon } = createDocument(el).Prop() as DocumentOptions;
      this.copyTo.push({ label: description, icon, command: (event) => this.baseOn(el) });
    });

    this.module = form['metadata']['clientModule'] || {};
    this.schema = { ...form['schema'] };
    if (form['metadata']['commands'] instanceof Array) {
      const commands = [...form['metadata']['commands']];
      form['metadata']['commands'] = [];
      for (const command of commands) {
        const item: MenuItem = {
          label: command.label, icon: command.icon,
          command: () => this.commandOnSever(command.command)
        };
        this.commands.push(item);
      }
    }
  }

  Refresh() {
    this.dss.getViewModel$(this.type, this.model.id).pipe(take(1)).subscribe(formGroup => {
      this.initForm(formGroup);
      this.form = formGroup;
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
  Delete() { this.ds.delete(this.model.id); }
  Post() { const doc = this.model; this.ds.post(doc); }
  unPost() { this.ds.unpost(this.model); }
  PostClose() { const doc = this.model; this.ds.post(doc, true); }
  Copy() {
    return this.router.navigate(
      [this.model.type, v1().toUpperCase()], { queryParams: { copy: this.id } });
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
    if (this.form.pristine) { this._close(); return; }
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
    this.ds.api.onCommand(this.form.value, method, {}).then(value => {
      this.initForm(getFormGroup(this.schema, value, true));
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
    this.ds.showDialog(this.uuid, this.model);
  }

}
