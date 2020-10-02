import { AuthService } from 'src/app/auth/auth.service';
import { ChangeDetectionStrategy, Component, EventEmitter, Input, OnDestroy, OnInit, Output } from '@angular/core';
import { FilterMetadata, SortMeta } from 'primeng/api';
import { Subject, Subscription, merge } from 'rxjs';
import { debounceTime, filter } from 'rxjs/operators';
import { ColumnDef } from '../../../../../jetti-api/server/models/column';
import { ISuggest } from '../../../../../jetti-api/server/models/common-types';
import { DocumentBase, DocumentOptions, StorageType } from '../../../../../jetti-api/server/models/document';
import { DocTypes } from '../../../../../jetti-api/server/models/documents.types';
import { FormListFilter, FormListOrder, FormListSettings } from '../../../../../jetti-api/server/models/user.settings';
import { ApiDataSource } from '../common/datatable/api.datasource.v2';
import { calendarLocale, dateFormat } from '../primeNG.module';
import { ApiService } from '../services/api.service';
import { DocService } from '../common/doc.service';
import { LoadingService } from '../common/loading.service';
import { ActivatedRoute, Router } from '@angular/router';
import { v1 } from 'uuid';
import { TreeNode } from 'primeng/api';
import { Type } from '../../../../../jetti-api/server/models/type';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-suggest-hierarchy-list',
  templateUrl: './suggest.dialog.hierarchy.component.html'
})
export class SuggestDialogHierarchyComponent implements OnInit, OnDestroy {

  @Input() type: DocTypes;
  @Input() id: string;
  @Input() uuid: string;
  @Input() storageType: StorageType;
  @Input() settings: FormListSettings = new FormListSettings();
  @Output() Select = new EventEmitter<ISuggest>();
  @Output() Close = new EventEmitter();

  locale = calendarLocale;
  dateFormat = dateFormat;
  doc: { Prop, Props } | undefined;
  columns: ColumnDef[] = [];
  selectedNode: TreeNode | null;
  selectedRow: DocumentBase = null;
  filters: { [s: string]: FilterMetadata } = {};
  multiSortMeta: SortMeta[] = [];
  initNodes = true;
  readonly = false;

  treeNodes: TreeNode[] = [];
  treeNodesVisible = false;
  hierarchy = false;
  formListSettings: FormListSettings;
  dataSource: ApiDataSource;
  scrollHeight = 700;

  showDeleted = false;

  private _debonceSubscription$: Subscription = Subscription.EMPTY;
  private _debonce$ = new Subject<{ col: any, event: any, center: string }>();
  private _docSubscription$: Subscription = Subscription.EMPTY;

  get isDoc() { return Type.isDocument(this.type); }
  get isCatalog() { return Type.isCatalog(this.type); }
  get selectionData() { return this.treeNodesVisible ? (this.selectedNode ? this.selectedNode.data : null) : this.selectedRow; }
  get isSelectEnabled() {
    const sel = this.selectionData;
    return sel &&
      (
        this.storageType === 'all' ||
        (!this.storageType && !sel.isfolder) ||
        (this.storageType === 'folders' && sel.isfolder) ||
        (this.storageType === 'elements' && !sel.isfolder)
      );
  }

  constructor(private api: ApiService, public ds: DocService, public lds: LoadingService,
    public route: ActivatedRoute, public router: Router, private auth: AuthService) { }

  async ngOnInit() {
    this.readonly = this.auth.isRoleAvailableReadonly();
    const data = [{ description: 'string' }, { code: 'string' }, { id: 'string' }];
    if (this.type) {
      if (!this.type.startsWith('Types.')) this.doc = await this.api.getDocMetaByType(this.type);
      this.dataSource = new ApiDataSource(this.api, this.type, 18, true);
    }
    const schema = this.doc ? this.doc.Props : {};
    const dimensions = this.doc ? (this.doc.Prop as DocumentOptions).dimensions || [] : [];
    [...data, ...dimensions].forEach(el => {
      const field = Object.keys(el)[0];
      const fieldProp = schema[field];
      if (fieldProp && !fieldProp.hidden) {
        const type = el[field];
        let value = fieldProp.value;
        if (type === 'enum') {
          value = [{ label: '', value: null }, ...(value || [] as string[]).map((e: any) => ({ label: e, value: e }))];
        }
        this.columns.push({
          field,
          type: <DocTypes>(fieldProp.type || type),
          label: fieldProp.label || field,
          hidden: false,
          required: true,
          readOnly: false,
          sort: new FormListOrder(field),
          order: fieldProp.order || 0,
          style: fieldProp.style || { width: '200px' },
          value: value,
          headerStyle: fieldProp.style || { width: '200px', 'text-align': 'center' }
        });
      }
    });

    this.hierarchy = (this.doc.Prop as DocumentOptions).hierarchy === 'folders';
    this.treeNodesVisible = this.hierarchy && !this.settings.filter.length;


    this.setFilters();
    this.setSortOrder();
    this.showDeletedSet(false);
    this.caclPageSize();
    this.prepareDataSource();

    // this.dataSource.result$.pipe(take(1)).subscribe(data => { this.selection = this.dataSource.selectedNode });

    this.dataSource.result$.subscribe(rows => {
      if (this.treeNodesVisible) {
        const selectedNodeId = this.selectedNode ? this.selectedNode.key : this.id ? this.id : this.dataSource.id;
        this.selectedNode = null;
        this.treeNodes = this.buildTreeNodes(rows, null);
        this.findSelectedNode(this.treeNodes, selectedNodeId);
        // if (this.selectedNode && !this.selectedNode.leaf) this.selectedNode.expanded = true;
      } else {
        this.selectedRow = rows.find(e => e.id === this.id);
      }
    });

    this._docSubscription$ = merge(...[
      this.ds.save$, this.ds.delete$, this.ds.saveClose$, this.ds.goto$, this.ds.post$, this.ds.unpost$]).pipe(
        filter(doc => doc && doc.type === this.type))
      .subscribe(doc => {

        if (this.treeNodesVisible) {
          this.selectedNode = null;
          this.id = doc.id;
          setTimeout(() => this.loadNodes(doc.id), 20);
        } else {
          const exist = (this.dataSource.renderedDataList).find(d => d.id === doc.id);
          if (exist) {
            this.dataSource.refresh(exist.id);
            this.id = exist.id;
          } else {
            this.dataSource.goto(doc.id);
            this.id = doc.id;
          }
        }
      });


    this._debonceSubscription$ = this._debonce$.pipe(debounceTime(1000))
      .subscribe(event => this._update(event.col, event.event, event.center));

    if (this.treeNodesVisible) this.loadNodes();

  }

  isFilterFixed(columnField: string) {
    return !!this.settings.filter.find(e => e.left === columnField && e.isFixed);
  }

  private caclPageSize() {
    const scrollHeight = () => window.innerHeight * 0.625;
    this.dataSource.pageSize = Math.max(Math.round(scrollHeight() / 28), 1);
    this.scrollHeight = this.dataSource.pageSize * 28;
  }

  private findSelectedNode(tree: TreeNode[], id: string | null) {
    if (this.selectedNode) return;
    const filteredById = tree.filter(el => el.key === id);
    if (filteredById.length) this.selectedNode = filteredById[0];
    else tree.filter(el => el.children.length).forEach(node => this.findSelectedNode(node.children, id));
  }

  onLazyLoad(event) {
    this.multiSortMeta = event.multiSortMeta;
    if (this.treeNodesVisible && event.sortField) {
      if (this.multiSortMeta.filter(e => e.field === event.sortField).length)
        this.multiSortMeta.filter(e => e.field === event.sortField).forEach(sf => sf.order = event.sortOrder);
      else this.multiSortMeta.push({ field: event.sortField, order: event.sortOrder });
    }
    this.prepareDataSource();
    this.dataSource.sort();
  }

  loadNodes(id = null) {
    this.dataSource.listOptions.hierarchyDirectionUp = false;
    if (id && id === this.selectedNode.key) {
      this.dataSource.listOptions.hierarchyDirectionUp = this.selectedNode.expanded;
    }
    if (!id) {
      const sel = this.selectedNode;
      if (this.initNodes && this.id) {
        // const ob = await this.ds.api.byId(this.id);
        // if (ob.parent)
        id = this.id;
      } else if (sel && sel.parent) id = !sel.expanded ? sel.key : sel.parent.key;
      else if (sel) {
        const topLevel = this.treeNodes.filter(e => e.parent === null).length > 1;
        id = topLevel ? sel.key : null;
      }
    }
    this.dataSource.id = id;
    if (this.initNodes) { this.initNodes = false; this.dataSource.sort(); } else this.dataSource.first();
  }

  private buildTreeNodes(tree: any[], parent?: string | null, parentNode?: TreeNode | null): TreeNode[] {
    return tree.filter(el => el.parent.id === parent).map(el => {
      const node = <TreeNode>{
        key: el.id,
        data: el,
        leaf: !el.isfolder,
        icon: 'pi pi-folder-open',
        expanded: false,
        expandedIcon: 'pi pi-folder-open',
        collapsedIcon: 'pi pi-folder',
        children: this.buildTreeNodes(tree, el.id) || [],
      };
      node.expanded = !node.leaf && node.children.length > 0;
      return node;
    });
  }

  showDeletedSet(showDeleted: boolean, update = false) {
    this.showDeleted = showDeleted;
    if (showDeleted) delete this.filters['deleted'];
    else this.filters['deleted'] = { matchMode: '=', value: 0 };
    if (update) {
      this.prepareDataSource(this.multiSortMeta);
      if (this.treeNodesVisible) this.loadNodes(this.selectedRow ? this.selectedRow.id : null);
      else this.dataSource.sort();
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

  private _update(col: ColumnDef | undefined, event, center, id = null) {
    if (!col) return;
    this.prepareDataSource();
    if (this.treeNodesVisible) this.loadNodes(this.selectedRow ? this.selectedRow.id : null);
    else this.dataSource.sort();
  }

  update(col: ColumnDef, event, center = 'like') {
    if (!event || (typeof event === 'object' && !event.value && !(Array.isArray(event)))) {
      if (typeof event !== 'boolean') event = null;
    }
    if (event === null) delete this.filters[col.field];
    else this.filters[col.field] = { matchMode: center || (col.filter && col.filter.center), value: event };
    this._debonce$.next({ col, event, center });
  }

  onNodeDblclick(node: { node: TreeNode }) {
    const Node = node.node;
    if (Node.leaf) { this.select(node); return; }
    Node.expanded = !Node.expanded;
    this.onNodeExpand(node);
  }

  onNodeExpand(node: { node: TreeNode }) {
    const Node = node.node;
    this.selectedNode = Node;
    this.loadNodes(Node.key);
  }

  prepareDataSource(multiSortMeta: SortMeta[] = this.multiSortMeta) {
    this.dataSource.id = this.id;
    const order = multiSortMeta
      .map(el => <FormListOrder>({ field: el.field, order: el.order === -1 ? 'desc' : 'asc' }));
    const Filter = Object.keys(this.filters)
      .map(f => <FormListFilter>{ left: f, center: this.filters[f].matchMode, right: this.filters[f].value });
    this.dataSource.formListSettings = { filter: Filter, order };
    this.formListSettings = { filter: Filter, order };
    const treeNodesVisibleBefore = this.treeNodesVisible;
    this.treeNodesVisible = this.hierarchy && (!Filter.length || (Filter.length === 1 && !this.showDeleted));
    this.dataSource.listOptions.withHierarchy = this.treeNodesVisible;
    if (!this.treeNodesVisible && this.storageType !== 'all') {
      let isFolderFilter = this.formListSettings.filter.find(e => e.left === 'isFolder');
      if (!isFolderFilter) {
        isFolderFilter = { left: 'isFolder', center: '=', right: this.storageType === 'folders' };
        this.formListSettings.filter.push(isFolderFilter);
      }
    }
    if (treeNodesVisibleBefore !== this.treeNodesVisible) {
      if (this.treeNodesVisible && this.selectedRow) { this.id = this.selectedRow.id; this.initNodes = true; }
      // tslint:disable-next-line: one-line
      else if (!this.treeNodesVisible && this.selectedNode) { this.id = this.selectedNode.key; }
      // tslint:disable-next-line: one-line
      else this.id = null;
      this.caclPageSize();
    }
  }

  select(row) {
    this.selectedNode = row.node ? row.node : row;
    if (!this.isSelectEnabled) return;
    const sel = this.selectionData;
    const selection: ISuggest = { id: sel.id, type: sel.type, code: sel.code, value: sel.description, deleted: sel.deleted };
    this.Select.emit(selection);
  }

  private buildFiltersParamQuery() {
    const filters = {};
    Object.keys(this.filters)
      .filter(f => this.filters[f].value && this.filters[f].value.id)
      .forEach(f => filters[f] = this.filters[f].value.id);
    return filters;
  }

  private getCurrentParent() {
    const result = { parent: null };
    if (this.treeNodesVisible && this.selectedNode) {
      result.parent = this.selectedNode.data.isfolder ? this.selectedNode.data.id : this.selectedNode.data.parent.id;
    }
    return result;
  }

  add(isFolder = false) {
    this.Close.emit();
    const id = v1().toUpperCase();
    this.router.navigate([this.type, id],
      { queryParams: { new: id, ...this.buildFiltersParamQuery(), ...this.getCurrentParent(), isfolder: isFolder, uuid: this.uuid } });
  }

  copy() {
    this.Close.emit();
    this.router.navigate([this.type, v1().toUpperCase()],
      { queryParams: { copy: this.selectedNode.key, uuid: this.uuid } });
  }

  open(id = null) {
    this.Close.emit();
    this.router.navigate([this.type, id ? id : this.selectedNode.key],
      { queryParams: { uuid: this.uuid } });
  }

  delete() {
    if (this.selectedNode) {
      this.ds.delete(this.selectedNode.key);
      this.loadNodes();
    }
  }

  ngOnDestroy() {
    this._docSubscription$.unsubscribe();
    this._debonceSubscription$.unsubscribe();
    this._debonce$.complete();
  }
}
