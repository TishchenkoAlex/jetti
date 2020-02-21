import { ChangeDetectionStrategy, Component, EventEmitter, Input, OnDestroy, OnInit, Output, ChangeDetectorRef } from '@angular/core';
import { Router } from '@angular/router';
import { TreeNode, SortMeta, FilterMetadata } from 'primeng/api';
import { merge, Observable, Subject, Subscription } from 'rxjs';
import { filter, map, switchMap, tap, take, debounceTime } from 'rxjs/operators';
import { v1 } from 'uuid';
import { ITree } from '../../../../../../jetti-api/server/models/common-types';
import { DocumentBase, DocumentOptions } from '../../../../../../jetti-api/server/models/document';
import { DocTypes } from '../../../../../../jetti-api/server/models/documents.types';
import { DocService } from '../../common/doc.service';
import { ApiService } from '../../services/api.service';
import { LoadingService } from '../loading.service';
import { ColumnDef } from '../../../../../../jetti-api/server/models/column';
import { FormListOrder, FormListFilter, FormListSettings } from '../../../../../../jetti-api/server/models/user.settings';
import { createDocument } from '../../../../../../jetti-api/server/models/documents.factory';
import { ApiDataSource } from './api.datasource.v2';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-hierarchy-list',
  templateUrl: 'base.hierarchy-list.component.html',
})
export class BaseHierarchyListComponent implements OnInit, OnDestroy {
  @Output() selectionChange = new EventEmitter();
  @Input() type: DocTypes;
  @Input() id: string;
  @Input() showCommands = true;
  @Input() scrollHeight = `${(window.innerHeight - 275)}px`;
  @Input() settings: FormListSettings = new FormListSettings();
  
  treeNodes$: Observable<TreeNode[]>;
  treeNodes: TreeNode[] = [];
  selection: TreeNode;
  columns: ColumnDef[] = [];
  doc: DocumentBase | undefined;
  dataSource: ApiDataSource;
  multiSortMeta: SortMeta[] = [];
  filters: { [s: string]: FilterMetadata } = {};

  get isDoc() { return this.type.startsWith('Document.'); }
  get isCatalog() { return this.type.startsWith('Catalog.'); }

  private _docSubscription$: Subscription = Subscription.EMPTY;
  private _debonceSubscription$: Subscription = Subscription.EMPTY;
  private debonce$ = new Subject<{ col: any, event: any, center: string }>();

  // tslint:disable-next-line: max-line-length
  constructor(private api: ApiService, public router: Router, public ds: DocService, public lds: LoadingService, private cd: ChangeDetectorRef) { }

  ngOnInit() {
    const columns: ColumnDef[] = [];
    const data = [{ description: 'string' }, { code: 'string' }, { id: 'string' }];
    this.dataSource = new ApiDataSource(this.ds.api, this.type, 20, true);

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

    this._debonceSubscription$ = this.debonce$.pipe(debounceTime(500))
      .subscribe(event => this._update(event.col, event.event, event.center));

    this.setSortOrder();
    this.setFilters();
    this.prepareDataSource();

    this.TreeNodesBuild();


  }


  TreeNodesBuild() {
    const id = this.selection && (this.selection.parent || !!this.treeNodes.filter(e => !e.data.hlevel).length) ? this.selection.data.id : '';
    this.treeNodes$ = this.api.getDocList(this.type, id, 'first', 1000, 0, this.dataSource.formListSettings.order, this.dataSource.formListSettings.filter, true).pipe(
      map(tree => <TreeNode[]>this.buildTreeNodes(tree.data, null)),
      tap(treeNodes => {
        // treeNodes.filter(node => !!node.children.length).forEach(el => el.data.description += ` [${el.children.length}]`);
        this.treeNodes = treeNodes;
      }));
  }

  private findDoc(tree: TreeNode[], id: string): TreeNode | undefined {
    if (!id) { return undefined; }
    const result = tree.find(el => el.data.id === id);
    if (result) return result;
    for (let i = 0; i < tree.length; i++) {
      const childrenResult = this.findDoc(tree[i].children || [], id);
      if (childrenResult) return childrenResult;
    }
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

  setSelection(id: string) {
    this.selection = this.findDoc(this.treeNodes, id);
    this.cd.markForCheck();
  }

  private buildTreeNodes(tree: any[], parent: string | null): TreeNode[] {
    return tree.filter(el => el.hparent === parent).map(el => {
      return <TreeNode>{
        data: el,
        expanded: true,
        expandedIcon: 'pi pi-folder-open',
        collapsedIcon: 'pi pi-folder',
        children: this.buildTreeNodes(tree, el.id) || [],
      };
    });
  }

  prepareDataSource(multiSortMeta: SortMeta[] = this.multiSortMeta) {
    this.dataSource.id = this.id;
    const order = multiSortMeta
      .map(el => <FormListOrder>({ field: el.field, order: el.order === -1 ? 'desc' : 'asc' }));
    const Filter = Object.keys(this.filters)
      .map(f => <FormListFilter>{ left: f, center: this.filters[f].matchMode, right: this.filters[f].value });
    this.dataSource.formListSettings = { filter: Filter, order };
  }

  private _update(col: ColumnDef, event, center) {
    if ((Array.isArray(event)) && event[1]) { event[1].setHours(23, 59, 59, 999); }
    this.filters[col.field] = { matchMode: center || (col.filter && col.filter.center), value: event };
    this.prepareDataSource(this.multiSortMeta);
    this.dataSource.sort();
  }
  update(col: ColumnDef, event, center = 'like') {
    if (!event || (typeof event === 'object' && !event.value && !(Array.isArray(event)))) { event = null; }
    this.filters[col.field] = { matchMode: center || (col.filter && col.filter.center), value: event };
    this.prepareDataSource(this.multiSortMeta);
    this.TreeNodesBuild();
    // this.debonce$.next({ col, event, center });
  }

  add() {
    const id = v1().toUpperCase();
    this.router.navigate([this.type, id],
      { queryParams: { new: id, isfolder: true, parent: this.selection.data.id } });
  }

  copy() {
    const id = v1().toUpperCase();
    this.router.navigate([this.type, id],
      { queryParams: { copy: this.selection.data.id, isfolder: true, parent: this.selection.data.id } });
  }

  open = () => {
    this.router.navigate([this.type, this.selection.data.id], { queryParams: {} });
  }

  delete = () => this.ds.delete(this.selection.data.id);

  onDragEnd(event) {
  }

  onNodeSelect(event) {
    if (event.node.data.isfolder) this.TreeNodesBuild();
  }

  onLazyLoad(event) {
    this.multiSortMeta = event.multiSortMeta;
    this.treeNodes.sort();
  }

  ngOnDestroy() {
    this._docSubscription$.unsubscribe();
  }
}
