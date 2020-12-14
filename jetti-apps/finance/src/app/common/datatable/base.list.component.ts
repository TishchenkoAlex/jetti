import { AuthService } from 'src/app/auth/auth.service';
import { ChangeDetectionStrategy, Component, Input, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FilterMetadata } from 'primeng/components/common/filtermetadata';
import { MenuItem } from 'primeng/components/common/menuitem';
import { SortMeta } from 'primeng/components/common/sortmeta';
import { iif as _if, merge, Observable, Subject, Subscription, fromEvent, combineLatest } from 'rxjs';
import { debounceTime, filter, map, take } from 'rxjs/operators';
import { v1 } from 'uuid';
import { ColumnDef } from '../../../../../../jetti-api/server/models/column';
import { DocTypes } from '../../../../../../jetti-api/server/models/documents.types';
import { buildColumnDef } from '../../../../../../jetti-api/server/routes/utils/columns-def';
import { FormListFilter, FormListOrder, FormListSettings } from '../../../../../../jetti-api/server/models/user.settings';
import { calendarLocale, dateFormat } from '../../primeNG.module';
import { scrollIntoViewIfNeeded } from '../utils';
import { UserSettingsService } from '../../auth/settings/user.settings.service';
import { ApiDataSource } from './api.datasource.v2';
import { DocService } from '../doc.service';
import { LoadingService } from '../loading.service';
import { IViewModel } from '../../../../../../jetti-api/server/models/common-types';
import { Table } from './table';
import { DynamicFormService } from '../dynamic-form/dynamic-form.service';
import { DocumentOptions, DocumentBase } from '../../../../../../jetti-api/server/models/document';
import { TabsStore } from '../tabcontroller/tabs.store';
import { Type } from '../../../../../../jetti-api/server/models/type';

// @Component({
//   changeDetection: ChangeDetectionStrategy.OnPush,
//   selector: 'j-list',
//   templateUrl: 'base.list.component.html',
// })
export class BaseDocListComponent implements OnInit, OnDestroy {
  @Input() pageSize;
  @Input() type: DocTypes;
  @Input() settings: FormListSettings = new FormListSettings();
  @Input() data: IViewModel;

  locale = calendarLocale; dateFormat = dateFormat;

  constructor(public route: ActivatedRoute, public router: Router, public ds: DocService, public tabStore: TabsStore,
    public uss: UserSettingsService, public lds: LoadingService, public dss: DynamicFormService, public auth: AuthService) { }

  private _docSubscription$: Subscription = Subscription.EMPTY;
  private _routeSubscruption$: Subscription = Subscription.EMPTY;
  private _debonceSubscription$: Subscription = Subscription.EMPTY;
  private _debonce$ = new Subject<{ col: any, event: any, center: string }>();

  pageSize$: Observable<number>;
  @ViewChild('tbl', { static: false }) tbl: Table;

  get isDoc() { return Type.isDocument(this.type); }
  get isCatalog() { return Type.isCatalog(this.type); }
  get id() { return this.selection && this.selection[0] && this.selection[0].id; }
  set id(id: string) { this.selection = [{ id, type: this.type }]; }

  queryParamsGoto: string;
  group = '';
  columns: ColumnDef[] = [];
  selection: any[] = [];
  contextMenuSelection = [];
  filters: { [s: string]: FilterMetadata } = {};
  multiSortMeta: SortMeta[] = [];
  contexCommands: MenuItem[] = [];
  ctxData = { column: '', value: undefined };
  showTree = false;
  showTreeButton = true;
  postedCol: ColumnDef = ({
    field: 'posted', filter: { left: 'posted', center: '=', right: null }, type: 'boolean', label: 'posted',
    style: {}, order: 0, readOnly: false, required: false, hidden: false, value: undefined, headerStyle: {}
  });
  dataSource: ApiDataSource;
  readonly = false;

  async ngOnInit() {
    if (!this.type) this.type = this.route.snapshot.params.type;
    if (!this.group) this.group = this.route.snapshot.params.group;
    if (!this.settings) this.settings = this.data.settings;
    this.queryParamsGoto = this.route.snapshot.queryParams.goto;

    this.dataSource = new ApiDataSource(this.ds.api, this.type, this.pageSize, true);

    await this.prepareColumns();

    if (this.data.metadata['Group']) this.settings.filter.push({ left: 'Group', center: '=', right: this.data.metadata['Group'] });

    this.showTree = this.data.metadata.hierarchy === 'folders';
    if (this.pageSize) this.showTree = false;
    this.showTreeButton = this.showTree;

    if (this.showTree) this.settings.filter.push({ left: 'isfolder', center: '=', right: false });

    const scrollHeight = () => window.innerHeight - 270;

    if (!this.pageSize) {
      this.dataSource.pageSize = Math.max(Math.round(scrollHeight() / 28 - 1), 1);
      this.pageSize$ = fromEvent(window, 'resize')
        .pipe(debounceTime(500), map(evt => {
          this.dataSource.pageSize = Math.max(Math.round(scrollHeight() / 28 - 1), 1);
          const id = this.dataSource.renderedData.length > 0 ? (this.dataSource.renderedData[0] as DocumentBase).id : null;
          this.dataSource.refresh(id);
          return this.dataSource.pageSize;
        }));
    }

    this.setSortOrder();
    this.setFilters();
    this.setContextMenu(this.columns);

    this._docSubscription$ = merge(...[
      this.ds.save$, this.ds.delete$, this.ds.saveClose$, this.ds.goto$, this.ds.post$, this.ds.unpost$]).pipe(
        filter(doc => doc
          && doc.type === this.type
          && !!(!this.group || !doc['Group'] || this.group === doc['Group']['id'])))
      .subscribe(doc => {
        const exist = (this.dataSource.renderedData as DocumentBase[]).find(d => d.id === doc.id);
        if (exist) {
          this.dataSource.refresh(exist.id);
          this.id = exist.id;
        } else {
          this.dataSource.goto(doc.id);
          this.id = doc.id;
        }
      });

    // обработка команды найти в списке
    this._routeSubscruption$ = this.route.params.pipe(
      filter(params => params.type === this.type && params.group === this.group && this.route.snapshot.queryParams.goto))
      .subscribe(params => {
        this.refresh(this.route.snapshot.queryParams.goto);
        const route: any[] = [this.type];
        if (this.group) route.push('group', this.group);
        setTimeout(() => this.router.navigate(route, { replaceUrl: true }));
      });

    this._debonceSubscription$ = this._debonce$.pipe(debounceTime(1000))
      .subscribe(async event => await this._update(event.col, event.event, event.center));
    this.readonly = this.auth.isRoleAvailableReadonly();
  }

  private async prepareColumns() {

    if (!this.data && this.type) {
      const DocMeta = await this.ds.api.getDocMetaByType(this.type);
      this.data = { schema: DocMeta.Props, metadata: DocMeta.Prop as DocumentOptions, columnsDef: [], model: {}, settings: this.settings };
    }

    this.columns = buildColumnDef(this.data.schema, this.settings);
    this.columns = [...this.columns.filter(c => !c.hidden)];

  }

  private setFilters() {
    this.settings.filter
      .filter(c => !(c.right == null || c.right === undefined))
      .forEach(f => this.filters[f.left] = { matchMode: f.center, value: f.right });
  }

  private setSortOrder() {
    this.multiSortMeta = this.settings.order
      .filter(e => !!e.order)
      .map(e => <SortMeta>{ field: e.field, order: e.order === 'asc' ? 1 : -1 });
    if (this.multiSortMeta.length === 0) {
      if (this.isCatalog) this.multiSortMeta.push({ field: 'description', order: 1 });
      if (this.isDoc) this.multiSortMeta.push({ field: 'date', order: 1 });
    }
  }

  private async _update(col: ColumnDef | undefined, event, center, id = null) {
    if (!col) return;
    if ((Array.isArray(event)) && event[1]) { event[1].setHours(23, 59, 59, 999); }
    this.filters[col.field] = { matchMode: center || (col.filter && col.filter.center), value: event };

    if (col.field === 'Operation' && (Type.isOperation(this.type) || this.type === 'Document.Operation')) {
      let type = 'Document.Operation';
      if (event && event.id) type = await this.ds.api.getIndexedOperationType(event.id);
      if (this.type !== type) {
        this.type = type as DocTypes;
        this.dataSource.type = this.type;
        this.data = undefined;
        await this.prepareColumns();
      }
    }

    this.id = id;
    this.prepareDataSource(this.multiSortMeta);
    if (this.id) this.goto(this.id);
    else this.last();
  }

  update(col: ColumnDef | { field: string, filter: any }, event, center = 'like') {
    if (!event || (typeof event === 'object' && !event.value && !(Array.isArray(event)))) {
      if (typeof event !== 'boolean') event = null;
    }
    this._debonce$.next({ col, event, center });
  }

  onLazyLoad(event: { multiSortMeta: SortMeta[]; }) {
    this.multiSortMeta = event.multiSortMeta;
    this.prepareDataSource();
    if (this.queryParamsGoto) {
      this.goto(this.queryParamsGoto);
      return;
    }
    if (this.id) this.dataSource.sort();
    else this.isCatalog ? this.first() : this.last();
  }

  private prepareDataSource(multiSortMeta: SortMeta[] = this.multiSortMeta) {
    this.dataSource.id = this.id;
    const order = multiSortMeta
      .map(el => <FormListOrder>({ field: el.field, order: el.order === -1 ? 'desc' : 'asc' }));
    const Filter = Object.keys(this.filters)
      .map(f => <FormListFilter>{ left: f, center: this.filters[f].matchMode, right: this.filters[f].value });
    this.dataSource.formListSettings = { filter: Filter, order };
  }

  private setContextMenu(columns: ColumnDef[]) {
    this.contexCommands = [
      {
        label: 'Select (All)', icon: 'fa fa-check-square',
        command: (event) => this.selection = this.dataSource.renderedData
      },
      {
        label: 'Quick filter', icon: 'pi pi-search',
        command: async (event) => await this._update(columns.find(c => c.field === this.ctxData.column), this.ctxData.value, null, this.id)
      },
      ...(this.data.metadata.copyTo || []).map(el => {
        const { label, icon } = el;
        return <MenuItem>{ label, icon, command: (event) => this.copyTo(el.type) };
      })];
  }

  private buildFiltersParamQuery() {
    const filters = {};
    Object.keys(this.filters)
      .filter(f => this.filters[f].value && this.filters[f].value.id)
      .forEach(f => filters[f] = this.filters[f].value.id);
    return filters;
  }

  add() {
    const id = v1().toUpperCase();
    this.router.navigate([this.type, id],
      { queryParams: { new: id, ...this.buildFiltersParamQuery() } });
  }

  copy() {
    this.router.navigate([this.selection[0].type, v1().toUpperCase()],
      { queryParams: { copy: this.selection[0].id } });
  }

  copyTo(type: DocTypes) {
    this.router.navigate([type, v1().toUpperCase()],
      { queryParams: { base: this.selection[0].id } });
  }

  open() {
    this.router.navigate([this.selection[0].type, this.selection[0].id]);
  }

  async delete() {
    for (const doc of this.selection) { await this.ds.delete(doc.id); }
  }

  async post(mode = 'post') {
    const tasksCount = this.selection.length; let i = tasksCount;
    for (const s of this.selection) {
      if (s.deleted) continue;
      this.lds.counter = Math.round(100 - ((i--) / tasksCount * 100));

      try {
        if (mode === 'post') await this.ds.posById(s.id);
        else await this.ds.unpostById(s.id);
        s.posted = mode === 'post';
        const row = this.dataSource.renderedData.find(e => s.id === e.id);
        this.ds.showOnPostDocMessage({ ...row, ...s });
      } catch (err) {
        this.ds.openSnackBar('error', s.description, err);
      }

      this.selection = [s];
      setTimeout(() => scrollIntoViewIfNeeded(this.type, 'ui-state-highlight'));
    }
    this.lds.counter = 0;
    this.dataSource.refresh(this.selection[0].id);
  }

  parentChange(event) {
    this.id = null;
    this.filters['parent'] = {
      matchMode: '=',
      value: event && event.data && event.data.id ? {
        id: event.data.id,
        code: '',
        type: this.type,
        description: event.data.description
      } : null
    };
    this.prepareDataSource();
    this.dataSource.sort();
  }

  onContextMenuSelect(event) {
    let el = (event.originalEvent as MouseEvent).target as any;
    if (!el) return;
    while (!el.id && el.lastElementChild) { el = el.lastElementChild; }
    const value = event.data[el.id];
    this.ctxData = { column: el.id, value: value && value.id ? value : value };
    this.id = event.data.id;
  }

  first() {
    this.selection = [];
    this.dataSource.result$.pipe(take(1)).subscribe(d => {
      if (d.length > 0) this.id = d[0].id;
    });
    this.dataSource.first();
  }

  private listen() {
    this.selection = [];
    this.dataSource.result$.pipe(take(1)).subscribe(d => {
      if (d.length > 0) this.id = d[d.length - 1].id;
    });
  }

  last() { this.listen(); this.dataSource.last(); }
  prev() { this.listen(); this.dataSource.prev(); }
  next() { this.listen(); this.dataSource.next(); }

  private listenRefresh(id: string) {
    this.selection = [];
    this.dataSource.result$.pipe(take(1)).subscribe(d => {
      if (d.length > 0) {
        const row = d.find(el => el.id === id);
        if (row) this.id = row.id;
      }
    });
  }

  refresh(id: string) { this.listenRefresh(id); this.dataSource.refresh(id); }
  goto(id: string) { this.listenRefresh(id); this.dataSource.goto(id); }

  ngOnDestroy() {
    this._docSubscription$.unsubscribe();
    this._routeSubscruption$.unsubscribe();
    this._debonceSubscription$.unsubscribe();
    this._debonce$.complete();
    // if (!this.route.snapshot.queryParams.goto) { this.saveUserSettings(); }
  }

  private saveUserSettings() {
    const formListSettings: FormListSettings = {
      filter: (Object.keys(this.filters) || [])
        .map(f => (<FormListFilter>{ left: f, center: this.filters[f].matchMode, right: this.filters[f].value })),
      order: ((<SortMeta[]>this.multiSortMeta) || [])
        .map(o => <FormListOrder>{ field: o.field, order: o.order === 1 ? 'asc' : 'desc' }),
    };
    // this.uss.setFormListSettings(this.type, formListSettings);
  }
}
