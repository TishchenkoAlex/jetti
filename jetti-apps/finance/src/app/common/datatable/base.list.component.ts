import { ChangeDetectionStrategy, Component, Input, OnDestroy, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FilterMetadata } from 'primeng/components/common/filtermetadata';
import { MenuItem } from 'primeng/components/common/menuitem';
import { SortMeta } from 'primeng/components/common/sortmeta';
import { iif as _if, merge, Observable, of, Subject, Subscription } from 'rxjs';
import { debounceTime, filter, map, tap } from 'rxjs/operators';
import { v1 } from 'uuid';
import { ColumnDef } from '../../../../../../jetti-api/server/models/column';
import { IViewModel } from '../../../../../../jetti-api/server/models/common-types';
import { DocTypes } from '../../../../../../jetti-api/server/models/documents.types';
import { FormListFilter, FormListOrder, FormListSettings } from '../../../../../../jetti-api/server/models/user.settings';
import { calendarLocale, dateFormat } from '../../primeNG.module';
import { scrollIntoViewIfNeeded } from '../utils';
import { DocumentOptions } from './../../../../../../jetti-api/server/models/document';
import { createDocument } from './../../../../../../jetti-api/server/models/documents.factory';
import { UserSettingsService } from './../../auth/settings/user.settings.service';
import { ApiDataSource } from './../../common/datatable/api.datasource.v2';
import { DocService } from './../../common/doc.service';
import { LoadingService } from './../../common/loading.service';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-list',
  templateUrl: 'base.list.component.html',
})
export class BaseDocListComponent implements OnInit, OnDestroy {
  locale = calendarLocale; dateFormat = dateFormat;
  get scrollHeight() { return `${(window.innerHeight - 275)}px`; }

  constructor(public route: ActivatedRoute, public router: Router, public ds: DocService,
    public uss: UserSettingsService, public lds: LoadingService) { }

  private _docSubscription$: Subscription = Subscription.EMPTY;
  private _routeSubscruption$: Subscription = Subscription.EMPTY;
  private _debonceSubscription$: Subscription = Subscription.EMPTY;
  private debonce$ = new Subject<{ col: any, event: any, center: string }>();
  routeData = this.route.snapshot.data.detail as IViewModel;

  @Input() pageSize = 100;
  @Input() type: DocTypes;
  @Input() settings: FormListSettings;
  get isDoc() { return this.type.startsWith('Document.'); }
  get isCatalog() { return this.type.startsWith('Catalog.'); }
  get id() { return { id: this.selection && this.selection.length ? this.selection[0].id : '', posted: true }; }
  set id(value: { id: string, posted: boolean }) {
    this.selection = [{ id: value.id, type: this.type, posted: value.posted }];
  }

  columns$: Observable<ColumnDef[]>;
  selection: any[] = [];
  contextMenuSelection = [];
  filters: { [s: string]: FilterMetadata } = {};
  multiSortMeta: SortMeta[] = [];
  contexCommands: MenuItem[] = [];
  ctxData = { column: '', value: undefined };
  showTree = this.routeData.metadata.hierarchy === 'folders';
  showTreeButton = this.showTree;

  dataSource: ApiDataSource;

  ngOnInit() {
    if (!this.settings && this.routeData) this.settings = this.routeData.settings;
    if (!this.type) this.type = this.route.snapshot.params.type;

    const columns: ColumnDef[] = this.routeData ? this.routeData.columnsDef || [] : [];

    this.dataSource = new ApiDataSource(this.ds.api, this.type, this.pageSize, true);

    this.columns$ = _if(() => !!columns.length,
      of(columns),
      this.ds.api.getView(this.type).pipe(map(v => v.columnsDef))).pipe(
        // tslint:disable-next-line: no-use-before-declare
        tap(c => init(c)),
        map(d => d.filter(c => (!c.hidden && !(c.field === 'description' && this.isDoc)) || c.field === 'Group')));

    const init = (c: ColumnDef[]) => {
      this.setSortOrder();
      this.setFilters();
      this.setContextMenu(c);
    };

    this._docSubscription$ = merge(...[
        this.ds.save$, this.ds.delete$, this.ds.saveClose$, this.ds.goto$, this.ds.post$, this.ds.unpost$]).pipe(
      filter(doc => doc && doc.type === this.type))
      .subscribe(doc => {
        const exist = (this.dataSource.renderedData).find(d => d.id === doc.id);
        if (exist) {
          this.dataSource.refresh(exist.id);
          this.id = { id: exist.id, posted: exist.posted };
        } else {
          this.dataSource.goto(doc.id);
          this.id = { id: doc.id, posted: doc.posted };
        }
      });

    // обработка команды найти в списке
    this._routeSubscruption$ = this.route.queryParams.pipe(
      filter(params => this.route.snapshot.params.type === this.type && params.goto && !this.route.snapshot.params.id))
      .subscribe(params => {
        const exist = this.dataSource.renderedData.find(d => d.id === params.goto);
        if (exist) {
          this.router.navigate([this.type], { replaceUrl: true })
            .then(() => {
              this.dataSource.refresh(exist.id);
              this.id = { id: exist.id, posted: exist.posted };
            });
        } else {
          this.router.navigate([this.type], { replaceUrl: true })
            .then(() => {
              this.filters = {};
              this.prepareDataSource();
              this.dataSource.goto(params.goto);
              this.id = { id: params.goto, posted: params.posted };
            });
        }
      });

    this._debonceSubscription$ = this.debonce$.pipe(debounceTime(1000))
      .subscribe(event => this._update(event.col, event.event, event.center));
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

  // tslint:disable-next-line:member-ordering
  postedCol: ColumnDef = ({
    field: 'posted', filter: { left: 'posted', center: '=', right: null }, type: 'boolean', label: 'posted',
    style: {}, order: 0, readOnly: false, required: false, hidden: false, value: undefined, headerStyle: {}
  });
  private _update(col: ColumnDef | undefined, event, center) {
    if (!col) return;
    if ((Array.isArray(event)) && event[1]) { event[1].setHours(23, 59, 59, 999); }
    this.filters[col.field] = { matchMode: center || (col.filter && col.filter.center), value: event };

    this.prepareDataSource(this.multiSortMeta);
    this.dataSource.sort();
  }
  update(col: ColumnDef, event, center = 'like') {
    if (!event || (typeof event === 'object' && !event.value && !(Array.isArray(event)))) {
      if (typeof event !== 'boolean') event = null;
    }
    this.debonce$.next({ col, event, center });
  }

  onLazyLoad(event) {
    this.multiSortMeta = event.multiSortMeta;
    this.prepareDataSource();
    this.dataSource.sort();
  }

  prepareDataSource(multiSortMeta: SortMeta[] = this.multiSortMeta) {
    this.dataSource.id = this.id.id;
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
        command: (event) => this._update(columns.find(c => c.field === this.ctxData.column), this.ctxData.value, null)
      },
      ...((createDocument(this.type).Prop() as DocumentOptions).copyTo || []).map(el => {
        const { description, icon } = createDocument(el).Prop() as DocumentOptions;
        return <MenuItem>{ label: description, icon, command: (event) => this.copyTo(el) };
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

  delete() {
    this.selection.forEach(el => this.ds.delete(el.id));
  }

  async post(mode = 'post') {
    const tasksCount = this.selection.length; let i = tasksCount;
    for (const s of this.selection) {
      if (s.deleted) continue;
      this.lds.counter = Math.round(100 - ((--i) / tasksCount * 100));
      if (mode === 'post') {
        try {
          await this.ds.posById(s.id);
          s.posted = true;
        } catch (err) { this.ds.openSnackBar('error', s.description, err); }
      } else {
        try {
        await this.ds.unpostById(s.id);
        s.posted = false;
      } catch (err) { this.ds.openSnackBar('error', s.description, err); }
      }
      this.selection = [s];
      setTimeout(() => scrollIntoViewIfNeeded(this.type, 'ui-state-highlight'));
    }
    this.lds.counter = 0;
    this.dataSource.refresh(this.selection[0].id);
  }

  parentChange(event) {
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
    this.id = { id: event.data.id, posted: event.data.posted };
  }

  private saveUserSettings() {
    const formListSettings: FormListSettings = {
      filter: (Object.keys(this.filters) || [])
        .map(f => (<FormListFilter>{ left: f, center: this.filters[f].matchMode, right: this.filters[f].value })),
      order: ((<SortMeta[]>this.multiSortMeta) || [])
        .map(o => <FormListOrder>{ field: o.field, order: o.order === 1 ? 'asc' : 'desc' })
    };
    this.uss.setFormListSettings(this.type, formListSettings);
  }

  ngOnDestroy() {
    this._docSubscription$.unsubscribe();
    this._routeSubscruption$.unsubscribe();
    this._debonceSubscription$.unsubscribe();
    this.debonce$.complete();
    // if (!this.route.snapshot.queryParams.goto) { this.saveUserSettings(); }
  }

}
