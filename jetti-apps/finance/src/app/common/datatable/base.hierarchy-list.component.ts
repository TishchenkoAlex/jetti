import { AuthService } from 'src/app/auth/auth.service';
import { ChangeDetectionStrategy, Component, Input, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { iif as _if, merge, Observable, Subject, Subscription, fromEvent, of } from 'rxjs';
import { debounceTime, filter, map, take } from 'rxjs/operators';
import { v1 } from 'uuid';
import { ColumnDef } from '../../../../../../jetti-api/server/models/column';
import { DocTypes } from '../../../../../../jetti-api/server/models/documents.types';
import { buildColumnDef } from '../../../../../../jetti-api/server/routes/utils/columns-def';
import { FormListFilter, FormListOrder, FormListSettings } from '../../../../../../jetti-api/server/models/user.settings';
import { calendarLocale, dateFormat } from '../../primeNG.module';
import { scrollIntoViewIfNeeded } from '../utils';
import { UserSettingsService } from './../../auth/settings/user.settings.service';
import { ApiDataSource } from './../../common/datatable/api.datasource.v2';
import { DocService } from './../../common/doc.service';
import { LoadingService } from './../../common/loading.service';
import { IViewModel } from '../../../../../../jetti-api/server/models/common-types';
import { DynamicFormService } from '../dynamic-form/dynamic-form.service';
import { DocumentOptions } from '../../../../../../jetti-api/server/models/document';
import { TabsStore } from '../tabcontroller/tabs.store';
import { TreeNode, MenuItem, FilterMetadata, SortMeta } from 'primeng/api';
import { Table } from 'primeng/table';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-hierarchy-list',
  templateUrl: 'base.hierarchy-list.component.html',
})
export class BaseHierarchyListComponent implements OnInit, OnDestroy {
  @Input() pageSize;
  @Input() type: DocTypes;
  @Input() settings: FormListSettings = new FormListSettings();
  @Input() data: IViewModel;

  locale = calendarLocale; dateFormat = dateFormat;

  constructor(public route: ActivatedRoute, public router: Router, public ds: DocService, public tabStore: TabsStore,
    public uss: UserSettingsService, public lds: LoadingService, public dss: DynamicFormService,
    private auth: AuthService) { }

  private _pageSizeSubscription$: Subscription = Subscription.EMPTY;
  private _pageSize$ = new Subject<number>();
  private _docSubscription$: Subscription = Subscription.EMPTY;
  private _routeSubscruption$: Subscription = Subscription.EMPTY;
  private _debonceSubscription$: Subscription = Subscription.EMPTY;
  private _debonce$ = new Subject<{ col: any, event: any, center: string }>();
  private _resizeSubscription$: Subscription = Subscription.EMPTY;

  pageSize$: Observable<number>;


  @ViewChild('tbl') tbl: Table;

  get isDoc() { return this.type.startsWith('Document.'); }
  get isCatalog() { return this.type.startsWith('Catalog.'); }
  get id() { return this.selectedData ? this.selectedData.id : null; }
  set id(id: string) { this.selection = [{ id, type: this.type }]; this.selectedNode = { data: { id: id }, key: id, type: this.type }; }
  get selectedData() {
    return this.treeNodesVisible ?
      (this.selectedNode ? this.selectedNode.data : null) :
      (this.selection && this.selection.length ? this.selection[0] : null);
  }

  postedCol: ColumnDef = ({
    field: 'posted', filter: { left: 'posted', center: '=', right: null }, type: 'boolean', label: 'posted',
    style: {}, order: 0, readOnly: false, required: false, hidden: false, value: undefined, headerStyle: {}
  });
  group = '';
  columns: ColumnDef[] = [];
  selection: any[] = [];
  contextMenuSelection = [];
  ctxData = { column: '', value: undefined };
  contexCommands: { list: MenuItem[], tree: MenuItem[] } = { list: [], tree: [] };
  filters: { [s: string]: FilterMetadata } = {};
  multiSortMeta: SortMeta[] = [];
  showDeleted = false;
  dataSource: ApiDataSource;
  readonly = false;

  treeNodes$: Observable<TreeNode[]>;
  treeNodes: TreeNode[] = [];
  hierarchy = false;
  treeNodesVisible = false;
  initNodes = true;
  selectedNode: TreeNode = null;
  presentationTypes = [
    { label: 'Tree', value: 'Tree' },
    { label: 'List', value: 'List' },
    { label: 'Auto', value: 'Auto' }
  ];
  presentation = 'Auto';
  addMenuItems: MenuItem[];

  async ngOnInit() {
    if (!this.type) this.type = this.route.snapshot.params.type;
    if (!this.group) this.group = this.route.snapshot.params.group;
    if (!this.settings) this.settings = this.data.settings;
    if (this.route.snapshot.queryParams.goto) {
      this.initNodes = true;
      this.id = this.route.snapshot.queryParams.goto;
    }

    if (!this.data && this.type) {
      const DocMeta = await this.ds.api.getDocMetaByType(this.type);
      this.data = { schema: DocMeta.Props, metadata: DocMeta.Prop as DocumentOptions, columnsDef: [], model: {}, settings: this.settings };
    }
    this.columns = buildColumnDef(this.data.schema, this.settings);
    if (this.data.metadata['Group']) this.settings.filter.push({ left: 'Group', center: '=', right: this.data.metadata['Group'] });

    this.hierarchy = this.data.metadata.hierarchy === 'folders';
    this.treeNodesVisible = this.hierarchy && !this.settings.filter.length;
    this.columns = [...this.columns.filter(c => !c.hidden)];

    if (this.hierarchy) {
      const descriptionColumn = this.columns.filter(c => c.field === 'description' && this.columns.indexOf(c) !== 0);
      if (descriptionColumn.length) {
        this.columns = [descriptionColumn[0], ...this.columns.filter(c => c.field !== 'description')];
      }
    }

    this.dataSource = new ApiDataSource(this.ds.api, this.type, this.pageSize, true);
    this.dataSource.id = this.id;
    this.dataSource.listOptions.withHierarchy = this.treeNodesVisible;

    this.addMenuItemsFill();
    this.setSortOrder();
    this.setFilters();
    this.showDeletedSet(false);
    this.prepareDataSource();
    this.setContextMenu(this.columns);

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

    this.treeNodes$ = this.dataSource.result$.pipe(map(rows => {
      if (this.treeNodesVisible) {
        const selectedNodeId = this.selectedNode ? this.selectedNode.key : this.dataSource.id;
        this.selectedNode = null;
        this.treeNodes = this.buildTreeNodes(rows, null);
        this.findSelectedNode(this.treeNodes, selectedNodeId);
        // if (this.selectedNode && !this.selectedNode.leaf) this.selectedNode.expanded = true;
        return this.treeNodes;
      }
    }));

    // обработка команды найти в списке
    this._routeSubscruption$ = this.route.params.pipe(
      filter(params => params.type === this.type && params.group === this.group && this.route.snapshot.queryParams.goto))
      .subscribe(params => {
        const id = this.route.snapshot.queryParams.goto;
        this.initNodes = true;
        this.refresh(id);
        const route: any[] = [this.type];
        if (this.group) route.push('group', this.group);
        setTimeout(() => this.router.navigate(route, { replaceUrl: true }));
      });

    this._resizeSubscription$ = fromEvent(window, 'resize').subscribe(e => {
      this._pageSize$.next(this.getPageSize());
    });

    this._pageSizeSubscription$ = this._pageSize$.pipe(debounceTime(50))
      .subscribe(pageSize => {
        this.dataSource.pageSize = pageSize;
        this.pageSize$ = of(pageSize);
        if (this.id) this.goto(this.id);
        else this.first();
      });

    this._debonceSubscription$ = this._debonce$.pipe(debounceTime(1000))
      .subscribe(event => this._update(event.col, event.event, event.center));

    this._pageSize$.next(this.getPageSize());
    this.readonly = this.auth.isRoleAvailableReadonly();

  }

  isNoFiltered() {
    const f = this.dataSource.formListSettings.filter.length;
    return !f || (!this.showDeleted && f === 1);
  }

  private getPageSize() {
    return Math.max(Math.round((window.innerHeight - 270) / 28 - 1), 1);
  }

  private findSelectedNode(tree: TreeNode[], id: string | null) {
    if (this.selectedNode || !id) return;
    const filteredById = tree.filter(el => el.key === id);
    if (filteredById.length) this.selectedNode = filteredById[0];
    else tree.filter(el => el.children.length).forEach(node => this.findSelectedNode(node.children, id));
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

  private _update(col: ColumnDef | undefined, event, center, id = null) {
    if (!col) return;
    if ((Array.isArray(event)) && event[1]) { event[1].setHours(23, 59, 59, 999); }
    this.filters[col.field] = { matchMode: center || (col.filter && col.filter.center), value: event };
    if (id) this.id = id;
    this.prepareDataSource(this.multiSortMeta);
    this._pageSize$.next(this.getPageSize());
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
    if (this.id) this.goto(this.id);
    else this.isCatalog ? this.first() : this.last();
  }

  loadNodes(id = null) {
    this.dataSource.listOptions.hierarchyDirectionUp = false;
    if (id && id === this.selectedNode.key) {
      this.dataSource.listOptions.hierarchyDirectionUp = this.selectedNode.expanded;
    }
    if (!id) {
      const sel = this.selectedNode;
      if (this.initNodes && this.id) {
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

  onNodeDblclick(node: { node: TreeNode }) {
    const Node = node.node;
    if (Node.leaf) { this.open(Node.key); return; }
    Node.expanded = !Node.expanded;
    this.onNodeExpand(node);
  }

  onNodeExpand(node: { node: TreeNode }) {
    const Node = node.node;
    this.selectedNode = Node;
    this.loadNodes(Node.key);
  }

  private prepareDataSource(multiSortMeta: SortMeta[] = this.multiSortMeta) {
    this.dataSource.id = this.id;
    const order = multiSortMeta
      .map(el => <FormListOrder>({ field: el.field, order: el.order === -1 ? 'desc' : 'asc' }));
    const Filter = Object.keys(this.filters)
      .filter(el => this.filters[el].value || el === 'deleted')
      .map(f => <FormListFilter>{ left: f, center: this.filters[f].matchMode, right: this.filters[f].value });
    this.dataSource.formListSettings = { filter: Filter, order };
    const treeNodesVisibleBefore = this.treeNodesVisible;
    // tslint:disable-next-line: max-line-length
    this.treeNodesVisible = this.presentation !== 'List' && this.hierarchy && (!Filter.length || (Filter.length === 1 && !this.showDeleted));
    this.dataSource.listOptions.withHierarchy = this.treeNodesVisible;
    if (treeNodesVisibleBefore !== this.treeNodesVisible) this.onTreeNodesVisibleChange();
  }

  private setContextMenu(columns: ColumnDef[]) {

    const qFilterCommand = {
      label: 'Quick filter', icon: 'pi pi-search',
      command: (event) => this._update(columns.find(c => c.field === this.ctxData.column), this.ctxData.value, null, this.id)
    };

    const selectAllCommand = {
      label: 'Select (All)', icon: 'fa fa-check-square',
      command: (event) => this.selection = this.dataSource.renderedDataList
    };

    const clearAllFilters = {
      label: 'Clear all filters', icon: 'far fa-trash-alt',
      command: (event) => this.clearAllFilters()
    };

    this.contexCommands.tree = [
      qFilterCommand,
      clearAllFilters,
      ...(this.data.metadata.copyTo || []).map(el => {
        const { label, icon } = el;
        return <MenuItem>{ label, icon, command: (event) => this.copyTo(el.type) };
      })];

    this.contexCommands.list = [selectAllCommand, ...this.contexCommands.tree];
  }

  clearAllFilters() {
    this.filters = {};
    if (!this.showDeleted) this.showDeletedSet(false);
    this.prepareDataSource(); this.goto(this.id);
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
    if (this.treeNodesVisible && this.selectedData) {
      result.parent = this.selectedData.isfolder ? this.selectedData.id : this.selectedData.parent.id;
    }
    return result;
  }

  add(isFolder = false) {
    const id = v1().toUpperCase();
    this.router.navigate([this.type, id],
      { queryParams: { new: id, ...this.buildFiltersParamQuery(), ...this.getCurrentParent(), isfolder: isFolder } });
  }

  copy() {
    this.router.navigate([this.type, v1().toUpperCase()],
      { queryParams: { copy: this.selectedData.id } });
  }

  copyTo(type: DocTypes) {
    this.router.navigate([type, v1().toUpperCase()],
      { queryParams: { base: this.selectedData.id } });
  }

  open(id = null) {
    const selId = id ? id : this.id ? this.id : null;
    if (!selId) return;
    this.router.navigate([this.type, selId]);
  }

  delete() {
    if (this.treeNodesVisible && this.selectedNode) this.ds.delete(this.selectedNode.key);
    else this.selection.forEach(el => this.ds.delete(el.id));
  }

  async post(mode = 'post') {
    const tasksCount = this.selection.length; let i = tasksCount;
    for (const s of this.selection) {
      if (s.deleted) continue;
      this.lds.counter = Math.round(100 - ((i--) / tasksCount * 100));
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
      setTimeout(() => scrollIntoViewIfNeeded(this.type, 'p-state-highlight'));
    }
    this.lds.counter = 0;
    this.dataSource.refresh(this.selection[0].id);
  }

  addMenuItemsFill() {
    this.addMenuItems = [
      {
        label: 'View', items: [
          { label: 'Tree', command: () => { this.presentation = 'Tree'; this.onChangePresentation(); } },
          { label: 'List', command: () => { this.presentation = 'List'; this.onChangePresentation(); } },
          { label: 'Auto', command: () => { this.presentation = 'Auto'; this.onChangePresentation(); } }
        ]
      },
      { separator: true },
      { label: 'Clear filters', command: () => { this.clearAllFilters(); } },
      { separator: true },
      { label: 'Show deleted', command: () => { this.showDeletedSet(!this.showDeleted, true); } },
    ];
  }

  showDeletedSet(showDeleted: boolean, update = false) {
    this.showDeleted = showDeleted;
    this.addMenuItems[this.addMenuItems.length - 1].label = `${this.showDeleted ? 'Hide' : 'Show'} deleted`;
    if (showDeleted) delete this.filters['deleted'];
    else this.filters['deleted'] = { matchMode: '=', value: 0 };
    if (update) {
      this.prepareDataSource(this.multiSortMeta);
      this._pageSize$.next(this.getPageSize());
    }
  }

  onChangePresentation() {
    const treeNodesVisibleBefore = this.treeNodesVisible;
    switch (this.presentation) {
      case 'List':
        this.treeNodesVisible = false;
        break;
      case 'Tree':
        this.treeNodesVisible = true;
        this.filters = {};
        this.showDeletedSet(this.showDeleted);
        break;
      case 'Auto':
        const dsFilter = this.dataSource.formListSettings.filter;
        this.treeNodesVisible = this.hierarchy && (!!dsFilter.length || (dsFilter.length === 1 && !this.showDeleted));
        break;
      default:
        break;
    }
    if (treeNodesVisibleBefore !== this.treeNodesVisible) {
      this.onTreeNodesVisibleChange();
      this.prepareDataSource(this.multiSortMeta);
      this._pageSize$.next(this.getPageSize());
    }
  }

  onTreeNodesVisibleChange() {
    this.dataSource.listOptions.withHierarchy = this.treeNodesVisible;
    if (this.treeNodesVisible && this.selection.length > 0) { this.id = this.selection[0].id; this.initNodes = true; }
    // tslint:disable-next-line: one-line
    else if (!this.treeNodesVisible && this.selectedNode) this.id = this.selectedNode.key;
    else this.id = null;
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
    if (!el.id) return;
    const dataStorage = this.treeNodesVisible ? event.node.data : event.data;
    const value = dataStorage[el.id];
    this.ctxData = { column: el.id, value: value && value.id ? value : value };
    this.id = dataStorage.id;
  }

  first() {
    // this.selection = [];
    this.dataSource.result$.pipe(take(1)).subscribe(d => {
      if (d.length > 0 && !this.treeNodesVisible) this.id = d[0].id;
    });
    this.dataSource.first();
  }

  private listen() {
    // this.selection = [];
    this.dataSource.result$.pipe(take(1)).subscribe(d => {
      if (d.length > 0 && !this.treeNodesVisible) this.id = d[d.length - 1].id;
    });
  }

  last() { this.listen(); this.dataSource.last(); }
  prev() { this.listen(); this.dataSource.prev(); }
  next() { this.listen(); this.dataSource.next(); }

  private listenRefresh(id: string) {
    // this.selection = [];
    this.dataSource.result$.pipe(take(1)).subscribe(d => {
      if (d.length > 0 && !this.treeNodesVisible) {
        const row = d.find(el => el.id === id);
        if (row) this.id = row.id;
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
    this._debonce$.complete();
    this._pageSize$.complete();
    this._pageSizeSubscription$.unsubscribe();
    this._resizeSubscription$.unsubscribe();
    // if (!this.route.snapshot.queryParams.goto) { this.saveUserSettings(); }
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
}
