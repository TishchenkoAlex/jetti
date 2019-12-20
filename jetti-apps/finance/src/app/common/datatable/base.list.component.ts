import { ChangeDetectionStrategy, Component, Input, OnDestroy, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FilterMetadata } from 'primeng/components/common/filtermetadata';
import { MenuItem } from 'primeng/components/common/menuitem';
import { SortMeta } from 'primeng/components/common/sortmeta';
import { iif as _if, merge, Observable, of, Subject, Subscription, fromEvent } from 'rxjs';
import { debounceTime, filter, map, tap, take, shareReplay } from 'rxjs/operators';
import { v1 } from 'uuid';
import { ColumnDef } from '../../../../../../jetti-api/server/models/column';
import { DocTypes } from '../../../../../../jetti-api/server/models/documents.types';
import { buildColumnDef } from '../../../../../../jetti-api/server/routes/utils/columns-def';
import { FormListFilter, FormListOrder, FormListSettings } from '../../../../../../jetti-api/server/models/user.settings';
import { calendarLocale, dateFormat } from '../../primeNG.module';
import { scrollIntoViewIfNeeded } from '../utils';
import { DocumentOptions } from './../../../../../../jetti-api/server/models/document';
import { createDocument } from './../../../../../../jetti-api/server/models/documents.factory';
import { UserSettingsService } from './../../auth/settings/user.settings.service';
import { ApiDataSource } from './../../common/datatable/api.datasource.v2';
import { DocService } from './../../common/doc.service';
import { LoadingService } from './../../common/loading.service';
import { IViewModel } from '../../../../../../jetti-api/server/models/common-types';

const WH = 278;

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-list',
  templateUrl: 'base.list.component.html',
})
export class BaseDocListComponent implements OnInit, OnDestroy {
  locale = calendarLocale; dateFormat = dateFormat;

  constructor(public route: ActivatedRoute, public router: Router, public ds: DocService,
    public uss: UserSettingsService, public lds: LoadingService) { }

  private _docSubscription$: Subscription = Subscription.EMPTY;
  private _routeSubscruption$: Subscription = Subscription.EMPTY;
  private _debonceSubscription$: Subscription = Subscription.EMPTY;
  private debonce$ = new Subject<{ col: any, event: any, center: string }>();
  resizeObservable$: Observable<string>;

  scrollHeight = `${(window.innerHeight - WH)}px`;

  @Input() pageSize = Math.round((window.innerHeight - WH) / 28);
  @Input() type: DocTypes;
  @Input() settings: FormListSettings;
  get isDoc() { return this.type.startsWith('Document.'); }
  get isCatalog() { return this.type.startsWith('Catalog.'); }
  get id() { return { id: this.selection && this.selection.length ? this.selection[0].id : '', posted: true }; }
  set id(value: { id: string, posted: boolean }) {
    this.selection = [{ id: value.id, type: this.type, posted: value.posted }];
  }

  columns: ColumnDef[] = [];
  selection: any[] = [];
  contextMenuSelection = [];
  filters: { [s: string]: FilterMetadata } = {};
  multiSortMeta: SortMeta[] = [];
  contexCommands: MenuItem[] = [];
  ctxData = { column: '', value: undefined };
  showTree = false;
  showTreeButton = true;
  routeData = this.route.snapshot.data.detail as IViewModel;
  postedCol: ColumnDef = ({
    field: 'posted', filter: { left: 'posted', center: '=', right: null }, type: 'boolean', label: 'posted',
    style: {}, order: 0, readOnly: false, required: false, hidden: false, value: undefined, headerStyle: {}
  });
  dataSource: ApiDataSource;

  ngOnInit() {
    const dependFromRoute = !this.type;
    if (!this.type) this.type = this.route.snapshot.params.type;
    if (!this.settings) this.settings = this.routeData.settings;
    this.dataSource = new ApiDataSource(this.ds.api, this.type, this.pageSize, true);

    const Doc = createDocument(this.type);
    const Props = Doc.Props();
    this.columns = buildColumnDef(Props, this.settings);

    this.showTree = (Doc.Prop() as DocumentOptions).hierarchy === 'folders';
    this.showTreeButton = this.showTree;

    this.resizeObservable$ = fromEvent(window, 'resize')
      .pipe(debounceTime(500), map(evt => {
        const h = window.innerHeight - WH;
        this.dataSource.pageSize = Math.round(h / 28);
        const id = this.dataSource.renderedData.length > 0 ? this.dataSource.renderedData[0].id : null;
        this.dataSource.refresh(id);
        return `${h}px`;
      }));

    this.setSortOrder();
    this.setFilters();
    this.setContextMenu(this.columns);

    this.columns = [...this.columns.filter(c => (!c.hidden && !(c.field === 'description' && this.isDoc)))];

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
    if (dependFromRoute) {
      this._routeSubscruption$ = this.route.queryParams.pipe(
        filter(params => this.route.snapshot.params.type === this.type && params.goto && !this.route.snapshot.params.id))
        .subscribe(params => {
          const exist = this.dataSource.renderedData.find(d => d.id === params.goto);
          if (exist) {
            this.router.navigate([this.type], { replaceUrl: true }).then(() =>
              this.refresh(params.goto));
          } else {
            this.router.navigate([this.type], { replaceUrl: true }).then(() => {
              this.filters = {};
              this.prepareDataSource();
              this.goto(params.goto);
            });
          }
        });
    }

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

  private _update(col: ColumnDef | undefined, event, center) {
    if (!col) return;
    if ((Array.isArray(event)) && event[1]) { event[1].setHours(23, 59, 59, 999); }
    this.filters[col.field] = { matchMode: center || (col.filter && col.filter.center), value: event };
    this.id = { id: null, posted: null };
    this.prepareDataSource(this.multiSortMeta);
    this.last();
  }
  update(col: ColumnDef | { field: string, filter: any }, event, center = 'like') {
    if (!event || (typeof event === 'object' && !event.value && !(Array.isArray(event)))) {
      if (typeof event !== 'boolean') event = null;
    }
    this.debonce$.next({ col, event, center });
  }

  onLazyLoad(event: { multiSortMeta: SortMeta[]; }) {
    this.multiSortMeta = event.multiSortMeta;
    this.prepareDataSource();
    if (this.id.id) this.dataSource.sort();
    else this.isCatalog ? this.first() : this.last();
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
    this.id = { id: null, posted: false };
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

  private listen() {
    this.selection = [];
    this.dataSource.result$.pipe(take(1)).subscribe(d => {
      if (d.length > 0)this.id = { id: d[d.length - 1].id, posted: d[d.length - 1].posted };
    });
  }

  last() {
    this.listen();
    this.dataSource.last();
  }

  first() {
    this.selection = [];
    this.dataSource.result$.pipe(take(1)).subscribe(d => {
      if (d.length > 0) this.id = { id: d[0].id, posted: d[0].posted };
    });
    this.dataSource.first();
  }

  prev() {
    this.listen();
    this.dataSource.prev();
  }

  next() {
    console.log(this.filters);
    this.listen();
    this.dataSource.next();
  }


  private listenRefresh(id: string) {
    this.selection = [];
    this.dataSource.result$.pipe(take(1)).subscribe(d => {
      if (d.length > 0) {
        const row = d.find(el => el.id === id);
        if (row)
          this.id = { id: row.id, posted: row.posted };
      }
    });
  }

  refresh(id: string) {
    this.listenRefresh(id);
    this.dataSource.refresh(id);
  }

  goto(id: string) {
    this.listenRefresh(id);
    this.dataSource.goto(id);
  }

  ngOnDestroy() {
    this._docSubscription$.unsubscribe();
    this._routeSubscruption$.unsubscribe();
    this._debonceSubscription$.unsubscribe();
    this.debonce$.complete();
    // if (!this.route.snapshot.queryParams.goto) { this.saveUserSettings(); }
  }

}
