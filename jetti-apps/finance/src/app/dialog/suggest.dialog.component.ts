import { AuthService } from 'src/app/auth/auth.service';
import { ChangeDetectionStrategy, Component, EventEmitter, Input, OnDestroy, OnInit, Output, ViewChild } from '@angular/core';
import { FilterMetadata } from 'primeng/components/common/filtermetadata';
import { SortMeta } from 'primeng/components/common/sortmeta';
import { Subject, Subscription, merge } from 'rxjs';
import { debounceTime, filter, map, take } from 'rxjs/operators';
import { ColumnDef } from '../../../../../jetti-api/server/models/column';
import { ISuggest } from '../../../../../jetti-api/server/models/common-types';
import { DocumentBase, DocumentOptions, StorageType } from '../../../../../jetti-api/server/models/document';
import { createDocument } from '../../../../../jetti-api/server/models/documents.factory';
import { DocTypes } from '../../../../../jetti-api/server/models/documents.types';
import { FormListFilter, FormListOrder, FormListSettings } from '../../../../../jetti-api/server/models/user.settings';
import { ApiDataSource } from '../common/datatable/api.datasource.v2';
import { calendarLocale, dateFormat } from '../primeNG.module';
import { ApiService } from '../services/api.service';
import { BaseTreeListComponent } from '../common/datatable/base.tree-list.component';
import { DocService } from '../common/doc.service';
import { LoadingService } from '../common/loading.service';
import { ActivatedRoute, Router } from '@angular/router';
import { v1 } from 'uuid';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-suggest-list',
  templateUrl: './suggest.dialog.component.html'
})
export class SuggestDialogComponent implements OnInit, OnDestroy {
  locale = calendarLocale; dateFormat = dateFormat;

  @Input() type: DocTypes;
  @Input() id: string;
  @Input() uuid: string;
  @Input() storageType: StorageType;
  @Input() pageSize = 100;
  @Input() settings: FormListSettings = new FormListSettings();
  @Output() Select = new EventEmitter<ISuggest>();
  @Output() Close = new EventEmitter();
  @ViewChild(BaseTreeListComponent, { static: false }) tl: BaseTreeListComponent;

  doc: DocumentBase | undefined;

  columns: ColumnDef[] = [];
  selection: any[] = [];
  filters: { [s: string]: FilterMetadata } = {};
  multiSortMeta: SortMeta[] = [];
  readonly = false;

  get sid() { return { id: this.selection && this.selection.length ? this.selection[0].id : '', type: this.type }; }
  set sid(value: { id: string, type?: DocTypes }) {
    this.selection = [{ id: value.id, type: this.type }];
  }

  get isDoc() { return this.type.startsWith('Document.'); }
  get isCatalog() { return this.type.startsWith('Catalog.'); }
  showTree = false;
  showTreeButton = false;
  dataSource: ApiDataSource;

  private _docSubscription$: Subscription = Subscription.EMPTY;
  private _debonceSubscription$: Subscription = Subscription.EMPTY;
  private debonce$ = new Subject<{ col: any, event: any, center: string }>();

  constructor(private api: ApiService, public ds: DocService, public lds: LoadingService,
    public route: ActivatedRoute, public router: Router, private auth: AuthService) { }

  ngOnInit() {
    this.readonly = this.auth.isRoleAvailable('Readonly');
    const columns: ColumnDef[] = [];
    const data = [{ description: 'string' }, { code: 'string' }, { id: 'string' }];
    try { this.doc = createDocument(this.type); } catch { }
    const schema = this.doc ? this.doc.Props() : {};
    const dimensions = this.doc ? (this.doc.Prop() as DocumentOptions).dimensions || [] : [];
    [...data, ...dimensions].forEach(el => {
      const field = Object.keys(el)[0]; const type = el[field];
      let value = schema[field] && schema[field].value;
      if (type === 'enum') {
        value = [{ label: '', value: null }, ...(value || [] as string[]).map((el: any) => ({ label: el, value: el }))];
      }
      columns.push({
        field, type: <DocTypes>(schema[field] && schema[field].type || type), label: schema[field] && schema[field].label || field,
        hidden: !!(schema[field] && schema[field].hidden), required: true, readOnly: false, sort: new FormListOrder(field),
        order: schema[field] && schema[field].order || 0, style: schema[field] && schema[field].style || { width: '150px' },
        value: value,
        headerStyle: schema[field] && schema[field].style || { width: '150px', 'text-align': 'center' }
      });
    });

    this.columns = [...columns.filter(c => !c.hidden)];
    if (this.doc) {
      this.showTree = (this.doc.Prop() as DocumentOptions).hierarchy === 'folders';
      this.showTreeButton = this.showTree;
    }

    this.dataSource = new ApiDataSource(this.api, this.type, this.pageSize, true);
    this.setSortOrder();
    this.setFilters();
    this.prepareDataSource();

    this.dataSource.result$.pipe(take(1),
      map(rows => rows.find(r => r.id === this.id)),
      filter(row => row !== undefined)).subscribe(row => {
        this.selection = [row as DocumentBase];
        if (this.tl) this.tl.setSelection(row.parent['id']);
      });

    this._debonceSubscription$ = this.debonce$.pipe(debounceTime(500))
      .subscribe(event => this._update(event.col, event.event, event.center));

    this._docSubscription$ = merge(...[
      this.ds.delete$]).pipe(
        filter(doc => doc && doc.type === this.type))
      .subscribe(doc => {
        const exist = (this.dataSource.renderedData).find(d => d.id === doc.id);
        if (exist) {
          this.dataSource.refresh(exist.id);
          this.sid = { id: exist.id };
        } else {
          this.dataSource.goto(doc.id);
          this.sid = { id: doc.id };
        }
      });
  }

  private setFilters() {
    this.settings.filter
      .filter(c => !(c.right === null || c.right === undefined))
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

  private _update(col: ColumnDef, event, center) {
    if ((Array.isArray(event)) && event[1]) { event[1].setHours(23, 59, 59, 999); }
    this.filters[col.field] = { matchMode: center || (col.filter && col.filter.center), value: event };
    this.prepareDataSource(this.multiSortMeta);
    this.dataSource.sort();
  }
  update(col: ColumnDef, event, center = 'like') {
    if (!event || (typeof event === 'object' && !event.value && !(Array.isArray(event)))) { event = null; }
    this.debonce$.next({ col, event, center });
  }

  onLazyLoad(event) {
    this.multiSortMeta = event.multiSortMeta;
    this.prepareDataSource();
    this.dataSource.sort();
  }

  prepareDataSource(multiSortMeta: SortMeta[] = this.multiSortMeta) {
    this.dataSource.id = this.id;
    const order = multiSortMeta
      .map(el => <FormListOrder>({ field: el.field, order: el.order === -1 ? 'desc' : 'asc' }));
    const Filter = Object.keys(this.filters)
      .map(f => <FormListFilter>{ left: f, center: this.filters[f].matchMode, right: this.filters[f].value });
    this.dataSource.formListSettings = { filter: Filter, order };
  }

  select(row: DocumentBase) {
    const selection: ISuggest = { id: row.id, type: row.type, code: row.code, value: row.description, deleted: row.deleted };
    this.Select.emit(selection);
  }

  parentChange(event) {
    this.selection = [];
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

  private buildFiltersParamQuery() {
    const filters = {};
    Object.keys(this.filters)
      .filter(f => this.filters[f].value && this.filters[f].value.id)
      .forEach(f => filters[f] = this.filters[f].value.id);
    return filters;
  }

  add() {
    this.Close.emit();
    const id = v1().toUpperCase();
    this.router.navigate([this.type, id],
      { queryParams: { new: id, ...this.buildFiltersParamQuery(), uuid: this.uuid } });
  }

  copy() {
    this.Close.emit();
    this.router.navigate([this.selection[0].type, v1().toUpperCase()],
      { queryParams: { copy: this.selection[0].id, uuid: this.uuid } });
  }

  open() {
    this.Close.emit();
    this.router.navigate([this.selection[0].type, this.selection[0].id],
      { queryParams: { uuid: this.uuid } });
  }

  delete() {
    this.selection.forEach(el => this.ds.delete(el.id));
  }

  ngOnDestroy() {
    this._debonceSubscription$.unsubscribe();
    this.debonce$.complete();
    this._docSubscription$.unsubscribe();
  }

}
