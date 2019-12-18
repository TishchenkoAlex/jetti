import { ChangeDetectionStrategy, Component, EventEmitter, Input, OnDestroy, OnInit, Output, ViewChild } from '@angular/core';
import { FilterMetadata } from 'primeng/components/common/filtermetadata';
import { SortMeta } from 'primeng/components/common/sortmeta';
import { Subject, Subscription } from 'rxjs';
import { debounceTime, filter, map, take } from 'rxjs/operators';
import { ColumnDef } from '../../../../../jetti-api/server/models/column';
import { ISuggest } from '../../../../../jetti-api/server/models/common-types';
import { DocumentBase, DocumentOptions } from '../../../../../jetti-api/server/models/document';
import { createDocument } from '../../../../../jetti-api/server/models/documents.factory';
import { DocTypes } from '../../../../../jetti-api/server/models/documents.types';
import { FormListFilter, FormListOrder, FormListSettings } from '../../../../../jetti-api/server/models/user.settings';
import { ApiDataSource } from '../common/datatable/api.datasource.v2';
import { calendarLocale, dateFormat } from '../primeNG.module';
import { ApiService } from '../services/api.service';
import { BaseTreeListComponent } from '../common/datatable/base.tree-list.component';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-suggest-list',
  templateUrl: './suggest.dialog.component.html'
})
export class SuggestDialogComponent implements OnInit, OnDestroy {
  locale = calendarLocale; dateFormat = dateFormat;

  @Input() type: DocTypes;
  @Input() id: string;
  @Input() pageSize = 100;
  @Input() settings: FormListSettings = new FormListSettings();
  @Output() Select = new EventEmitter<ISuggest>();
  @ViewChild(BaseTreeListComponent, { static: false }) tl: BaseTreeListComponent;

  doc: DocumentBase | undefined;

  columns: ColumnDef[] = [];
  selection: DocumentBase[] = [];
  filters: { [s: string]: FilterMetadata } = {};
  multiSortMeta: SortMeta[] = [];

  get isDoc() { return this.type.startsWith('Document.'); }
  get isCatalog() { return this.type.startsWith('Catalog.'); }
  get showTree() { return this.doc && this.doc.Prop && (<DocumentOptions>this.doc.Prop()).hierarchy === 'folders'; }

  dataSource: ApiDataSource;

  private _debonceSubscription$: Subscription = Subscription.EMPTY;
  private debonce$ = new Subject<{ col: any, event: any, center: string }>();

  constructor(private api: ApiService) { }

  ngOnInit() {
    const columns: ColumnDef[] = [];
    const data = [{ description: 'string' }, { code: 'string' }, { id: 'string' }];
    try { this.doc = createDocument(this.type); } catch { }
    const schema = this.doc ? this.doc.Props() : {};
    const dimensions = this.doc ? (this.doc.Prop() as DocumentOptions).dimensions || [] : [];
    const hierarchy = this.doc ? (this.doc.Prop() as DocumentOptions).hierarchy : 'elements';
    [...data, ...dimensions].forEach(el => {
      const field = Object.keys(el)[0]; const type = el[field];
      columns.push({
        field, type: <DocTypes>(schema[field] && schema[field].type || type), label: schema[field] && schema[field].label || field,
        hidden: !!(schema[field] && schema[field].hidden), required: true, readOnly: false, sort: new FormListOrder(field),
        order: schema[field] && schema[field].order || 0, style: schema[field] && schema[field].style || { width: '150px' },
        value: schema[field] && schema[field].value,
        headerStyle: schema[field] && schema[field].style || { width: '150px', 'text-align': 'center' }
      });
    });
    this.columns = [...columns.filter(c => !c.hidden)];

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
  }

  private setFilters() {
    this.settings.filter
      .filter(c => !!c.right)
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

  open(row: DocumentBase) {
    const selection: ISuggest = { id: row.id, type: row.type, code: row.code, value: row.description };
    this.Select.emit(selection);
  }

  ngOnDestroy() {
    this._debonceSubscription$.unsubscribe();
    this.debonce$.complete();
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

}
