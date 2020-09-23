import { IFormControlPlacing } from './../dynamic-form/dynamic-form-base';
import { CdkTrapFocus } from '@angular/cdk/a11y';
import { ChangeDetectorRef, Input, OnDestroy, OnInit, QueryList, ViewChildren, Directive } from '@angular/core';
import { FormControl, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { merge, of as observableOf, Subscription, BehaviorSubject, Observable } from 'rxjs';
import { filter, take, map } from 'rxjs/operators';
import { v1 } from 'uuid';
import { dateReviverLocal } from '../../../../../../jetti-api/server/fuctions/dateReviver';
import { calculateDescription, IViewModel } from '../../../../../../jetti-api/server/models/common-types';
import { DocumentBase, DocumentOptions, Ref, Relation, Command, CopyTo } from '../../../../../../jetti-api/server/models/document';
import { DocService } from '../doc.service';
import { FormControlInfo } from '../dynamic-form/dynamic-form-base';
import { patchOptionsNoEvents, DynamicFormService, getFormGroup } from '../dynamic-form/dynamic-form.service';
import { TabsStore } from '../tabcontroller/tabs.store';
import { AuthService } from 'src/app/auth/auth.service';
import { DocTypes } from '../../../../../../jetti-api/server/models/documents.types';
import { FormBase } from '../../../../../../jetti-api/server/models/Forms/form';
import { MenuItem } from 'primeng/api/public_api';
import { Type } from '../../../../../../jetti-api/server/models/type';

export declare interface IFormEventsModel {
  onOpen(): void;
  beforeSave(): void;
  beforeClose(): void;
  beforeDelete(): void;
  beforePost(): void;
  beforeCopy(): void;
  beforeUnPost(): void;
}

@Directive()
// tslint:disable-next-line: directive-class-suffix
export class _baseDocFormComponent implements OnDestroy, OnInit, IFormEventsModel {

  @Input() id: string;
  @Input() type: DocTypes;
  @Input() data: FormGroup;
  @ViewChildren(CdkTrapFocus) cdkTrapFocus: QueryList<CdkTrapFocus>;

  get isDoc() { return Type.isDocument(this.type); }
  get isForm() { return Type.isForm(this.type); }
  get isCatalog() { return Type.isCatalog(this.type); }

  isCopy: boolean;
  isHistory: boolean;
  readonly: boolean;
  navigateCommands: MenuItem[] = [];

  private readonly _form$ = new BehaviorSubject<FormGroup>(undefined);
  form$ = this._form$.asObservable();

  viewModel$ = this.form$.pipe(map(f => f.getRawValue() as DocumentBase | FormBase));
  docDescription$ = this.form$.pipe(map(f => <string>f['metadata'].description));
  metadata$ = this.form$.pipe(map(f => <DocumentOptions>f['metadata']));
  relations$ = this.form$.pipe(map(f => (f && f['metadata'] && f['metadata'].relations || []) as Relation[]));
  v$ = this.form$.pipe(map(f => (<FormControlInfo[]>f['orderedControls'])));
  vk$ = this.form$.pipe(map(f => (<{ [key: string]: FormControlInfo }>f['byKeyControls'])));
  tables$ = this.form$.pipe(map(f => (<FormControlInfo[]>f['orderedControls']).filter(t => t.controlType === 'table')));
  hasTables$ = this.tables$.pipe(map(t => t.length > 0));
  description$ = this.form$.pipe(map(f => (<FormControl>f.get('description'))));
  isPosted$ = this.form$.pipe(map(f => (<boolean>!!f.get('posted').value)));
  isDeleted$ = this.form$.pipe(map(f => (<boolean>!!f.get('deleted').value)));
  isNew$ = this.form$.pipe(map(f => (!f.get('timestamp').value)));
  isFolder$ = this.form$.pipe(map(f => (!!f.get('isfolder').value)));
  isDirty$ = this.form$.pipe(map(f => (<boolean>!!f.dirty)));
  commands$ = this.metadata$.pipe(map(m => {
    return (m && m['commands'] as Command[] || []).map(c => (
      <MenuItem>{
        label: c.label, icon: c.icon,
        command: () => this.commandOnSever(c.method, c.clientModule)
      }));
  }));
  copyTo$ = this.metadata$.pipe(map(m => {
    return (m && m['copyTo'] as CopyTo[] || []).map(c => {
      const { label, icon, Operation, type } = c;
      return (<MenuItem>{ label, icon, command: () => this.baseOn(type, Operation) });
    });
  }));
  module$: Observable<{ [x: string]: Function }> = this.metadata$.pipe(map(m => {
    return (new Function('', m.module || '{}').bind(this)());
  }));

  get form() { return this._form$.value; }
  get viewModel() { return this.form.getRawValue(); }
  get metadata() { return <DocumentOptions>this.form['metadata']; }
  get docDescription() { return <string>this.metadata.description; }
  get relations() { return (this.metadata.relations || []) as Relation[]; }
  get v() { return <FormControlInfo[]>this.form['orderedControls']; }
  get controlsPlacement() { return <IFormControlPlacing[]>this.form['controlsPlacement'].filter(e => e.panel !== 'Main'); }
  get vk() { return <{ [key: string]: FormControlInfo }>this.form['byKeyControls']; }
  get tables() { return (<FormControlInfo[]>this.form['orderedControls']).filter(t => t.controlType === 'table' && !t.panel); }
  get hasTables() { return this.tables.length > 0; }
  get headFields() {
    return <FormControlInfo[]>this.v.filter(el =>
      el.order !== 777
      && !el.isAdditional
      && !el.panel
      && el.controlType !== 'table'
      && el.controlType !== 'script'
      && el.order !== 1000
      && el.order > 0);
  }
  get fieldsetsFields() { return <FormControlInfo[]>this.v.filter(el => (el.order === 777)); }
  get additionalFields() { return <FormControlInfo[]>this.v.filter(el => (el.isAdditional)); }
  get description() { return <FormControl>this.form.get('description'); }
  get isPosted() { return <boolean>!!this.form.get('posted').value; }
  get isDeleted() { return <boolean>!!this.form.get('deleted').value; }
  get isNew() { return !this.form.get('timestamp').value; }
  get isFolder() { return !!this.form.get('isfolder').value; }
  get isDirty() { return !!this.form.dirty; }
  get commands() {
    return (this.metadata['commands'] as Command[] || []).map(c => {
      return (<MenuItem>{
        label: c.label, icon: c.icon,
        command: () => this.commandOnSever(c.method)
      });
    });
  }
  get copyTo() {
    return (this.metadata['copyTo'] as CopyTo[] || []).map(c => {
      return (<MenuItem>{ label: c.label, icon: c.icon, command: (event) => this.baseOn(c.type, c.Operation) });
    });
  }
  get module(): { [x: string]: Function } { return new Function('', this.metadata.module || '{}').bind(this)(); }
  get settings() {
    return this.relations.map(r => ({
      order: [], filter: [
        { left: r.field, center: '=', right: { id: this.viewModel.id, type: this.viewModel.type, value: this.viewModel.description } }]
    }));
  }

  private _subscription$: Subscription = Subscription.EMPTY;
  private _formSubscription$: Subscription = Subscription.EMPTY;
  private _descriptionSubscription$: Subscription = Subscription.EMPTY;
  private _saveCloseSubscription$: Subscription = Subscription.EMPTY;
  private _postSubscription$: Subscription = Subscription.EMPTY;
  private _uuid = this.route.snapshot.queryParams.uuid;

  constructor(
    public router: Router, public route: ActivatedRoute, public auth: AuthService,
    public ds: DocService, public tabStore: TabsStore, public dss: DynamicFormService,
    public cd: ChangeDetectorRef) { }

  ngOnInit() {

    this.isCopy = !!this.route.snapshot.queryParams.copy;
    this.isHistory = !!this.route.snapshot.queryParams.history;
    this.readonly = !this.isHistory && this.auth.isRoleAvailableReadonly();

    this._subscription$ = merge(...[this.ds.save$, this.ds.delete$, this.ds.post$, this.ds.unpost$]).pipe(
      filter(doc => doc.id === this.id))
      .subscribe(doc => {
        this.isCopy = false;
        this.form.patchValue(doc, patchOptionsNoEvents);
        this.form.markAsPristine();
        this._form$.next(this.form);
        if (this.isDoc) { this.showDescription(); }
      });

    this._saveCloseSubscription$ = this.ds.saveClose$.pipe(
      filter(doc => doc.id === this.id))
      .subscribe(doc => {
        this.isCopy = false;
        this.form.markAsPristine();
        this._form$.next(this.form);
        this.close();
      });

    setTimeout(() => {
      this._descriptionSubscription$ = merge(...[
        this.form.get('date')!.valueChanges,
        this.form.get('code')!.valueChanges,
        this.form.get('Group') ? this.form.get('Group')!.valueChanges : observableOf('')])
        .pipe(filter(_ => this.isDoc)).subscribe(_ => this.showDescription());
    });

    this._form$.next(this.data);
    this.onOpen();

    this._formSubscription$ = this.ds.form$.pipe(filter(f => f.value.id === this.id)).subscribe(form => {
      this.Next(form);
    });

    if (this.isHistory || this.readonly) this.form.disable(patchOptionsNoEvents);
    this.navigateCommands.push(<MenuItem>{ label: 'Show in list', command: () => this.goto() });
    this.navigateCommands.push(<MenuItem>{ label: 'Used in...', command: () => this.usedIn() });
  }

  refresh() {
    this.dss.getViewModel$(this.type, this.viewModel.id).pipe(take(1)).subscribe(formGroup => {
      this.Next(formGroup);
      setTimeout(() => this.onOpen());
    });
  }

  public Next(formGroup: FormGroup) {
    const orderedControls = [...formGroup['orderedControls']];
    const byKeyControls = { ...formGroup['byKeyControls'] };
    formGroup['orderedControls'] = [];
    formGroup['byKeyControls'] = {};
    this.cd.detach();
    this._form$.next(formGroup);
    setTimeout(() => {
      this.cd.detectChanges();
      formGroup['orderedControls'] = orderedControls;
      formGroup['byKeyControls'] = byKeyControls;
      this._form$.next(formGroup);
      setTimeout(() => {
        this.cd.detectChanges();
        setTimeout(() => {
          this.cd.reattach();
          this.cd.markForCheck();
        });
      });
    });
  }

  showDescription() {
    if (this.isDoc) {
      const date = this.form.get('date')!.value;
      const code = this.form.get('code')!.value;
      const group = this.form.get('Group') && this.form.get('Group')!.value ? this.form.get('Group')!.value.value : '';
      const value = calculateDescription(this._form$.value['metadata'].description,
        JSON.parse(JSON.stringify(date), dateReviverLocal), code, group);
      this.description.patchValue(value, patchOptionsNoEvents);
    }
  }

  save() { this.beforeSave(); this.showDescription(); this.ds.save(this.viewModel as DocumentBase); }
  delete() { this.beforeDelete(); this.ds.delete(this.viewModel.id); }
  post(close = false) { this.beforePost(); const doc = this.viewModel; this.ds.post(doc as DocumentBase, close); }
  unPost() { this.beforeUnPost(); this.ds.unpost(this.viewModel as DocumentBase); }
  postClose() { this.post(true); }

  copy() {
    this.beforeCopy();
    return this.router.navigate(
      [this.viewModel.type, v1().toUpperCase()], { queryParams: { copy: this.id } });
  }

  goto() {
    const route = [this.viewModel.type];
    const group = this.viewModel.Group && this.viewModel.Group.id;
    if (group) route.push('group', group);
    return this.router.navigate(route,
      { queryParams: { goto: this.id, posted: this.viewModel.posted }, replaceUrl: true });
  }

  usedIn() { this.router.navigate(['Form.SearchAndReplace', this.id], {}); }

  private _close() {
    const tab = this.tabStore.state.tabs.find(t => t.id === this.id && t.type === this.type);
    if (tab) {
      this.tabStore.close(tab);
      let Group = '';
      const GroupControl = this.form.get('Group');
      if (GroupControl) Group = GroupControl.value.id;
      const parentTab = this.tabStore.state.tabs.find(t => t.type === this.type && !t.id && t.group === Group);
      if (parentTab) {
        const route = [parentTab.type];
        if (parentTab.group) route.push('group', parentTab.group);
        this.router.navigate(route);
      } else {
        const returnTab = this.tabStore.state.tabs[this.tabStore.selectedIndex];
        const route = [returnTab.type];
        if (returnTab.group) route.push('group', returnTab.group);
        route.push(returnTab.id);
        this.router.navigate(route);
      }
    }
  }

  close() {
    this.beforeClose();
    if (this.form.pristine) { this._close(); return; }
    this.ds.confirmationService.confirm({
      header: 'Discard changes and close?',
      message: this.description.value || this.docDescription,
      icon: 'fa fa-question-circle',
      accept: this._close.bind(this),
      reject: this.focus.bind(this),
      key: this.id
    });
    this.cd.detectChanges();
  }

  onOpen() { this.executeDocumentModuleMethod('onOpen'); }
  beforeSave() { this.executeDocumentModuleMethod('beforeSave'); }
  beforeClose() { this.executeDocumentModuleMethod('beforeClose'); }
  beforeDelete() { this.executeDocumentModuleMethod('beforeDelete'); }
  beforePost() { this.executeDocumentModuleMethod('beforePost'); }
  beforeCopy() { this.executeDocumentModuleMethod('beforeCopy'); }
  beforeUnPost() { this.executeDocumentModuleMethod('beforeUnPost'); }

  private executeDocumentModuleMethod(methodName: string, params?: [{ key: string, value: any }]) {
    const func = new Function('', this.metadata.module).bind(this)();
    if (func) {
      const method = func[methodName];
      if (method) {
        method().catch(e => { this.ds.openSnackBar('error', `On execute method \"${methodName}\"`, e); });
      }
    }
  }

  focus() {
    const autoCapture = this.cdkTrapFocus.find(el => el.autoCapture);
    if (autoCapture) autoCapture.focusTrap.focusFirstTabbableElementWhenReady();
  }

  print() {
    throw new Error('Print not implemented!');
  }

  baseOn(type: DocTypes, Operation: Ref) {
    this.router.navigate([type, v1().toLocaleUpperCase()],
      { queryParams: { base: this.id, Operation } });
  }

  commandOnSever(method: string, clientModule?: string) {
    this.ds.api.onCommand(this.viewModel, method, {}).then((value: IViewModel) => {
      const form = getFormGroup(value.schema, value.model, true);
      form['metadata'] = value.metadata;
      this.Next(form);
      this.form.markAsDirty();

      if (clientModule) {
        const func = new Function('', clientModule).bind(this)();
        const afterExecution = func['afterExecution'];
        if (afterExecution) afterExecution();
      }
    });
  }

  commandOnClient(method: string) {
    this.module[method](this.viewModel).then(value => {
      this.form.patchValue(value || {}, patchOptionsNoEvents);
      this.form.markAsDirty();
      this._form$.next(this.form);
    });
  }

  startWorkFlow() {
    this.ds.startWorkFlow(this.id).then(doc => {
      this.form.patchValue({ workflow: { id: doc.id, type: doc.type, code: doc.code, value: doc.description } });
      this.save();
      this.router.navigate([doc.type, doc.id]);
    });
  }

  throwError(title: string, message: string) {
    this.ds.openSnackBar('error', title, message);
    throw new Error(`${title}: ${message}`);
  }

  ngOnDestroy() {
    this._subscription$.unsubscribe();
    this._formSubscription$.unsubscribe();
    this._descriptionSubscription$.unsubscribe();
    this._saveCloseSubscription$.unsubscribe();
    this._postSubscription$.unsubscribe();
    this.ds.showDialog(this._uuid, this.form.getRawValue() as DocumentBase);
  }
}
