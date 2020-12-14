import { AuthService } from 'src/app/auth/auth.service';
import { ChangeDetectionStrategy, Component, Input, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { FilterMetadata } from 'primeng/components/common/filtermetadata';
import { MenuItem } from 'primeng/components/common/menuitem';
import { SortMeta } from 'primeng/components/common/sortmeta';
import { iif as _if, merge, Observable, Subject, Subscription, fromEvent, of, BehaviorSubject } from 'rxjs';
import { debounceTime, filter, map, take } from 'rxjs/operators';
import { v1 } from 'uuid';
import { ColumnDef } from '../../../../../../jetti-api/server/models/column';
import { DocTypes } from '../../../../../../jetti-api/server/models/documents.types';
import { buildColumnDef } from '../../../../../../jetti-api/server/routes/utils/columns-def';
import { FormListColumnProps, FormListFilter, FormListOrder, FormListSettings, IUserSettings, matchOperator, matchOperatorByType } from '../../../../../../jetti-api/server/models/user.settings';
import { calendarLocale, dateFormat } from '../../primeNG.module';
import { MaxTextWidth, scrollIntoViewIfNeeded } from '../utils';
import { hiddenColumns, UserSettingsService, UserSettitngsState } from './../../auth/settings/user.settings.service';
import { ApiDataSource } from './../../common/datatable/api.datasource.v2';
import { DocService } from './../../common/doc.service';
import { LoadingService } from './../../common/loading.service';
import { IViewModel } from '../../../../../../jetti-api/server/models/common-types';
import { Table } from './table';
import { DynamicFormService } from '../dynamic-form/dynamic-form.service';
import { DocumentBase, DocumentOptions } from '../../../../../../jetti-api/server/models/document';
import { TabsStore } from '../tabcontroller/tabs.store';
import { DialogService, DynamicDialogRef, TreeNode } from 'primeng/api';
import { Type } from '../../../../../../jetti-api/server/models/type';
import { ColumnsSettingsComponent } from 'src/app/dialog/columns.settings.dialog.component';
import { TreeTable } from 'primeng/treetable';
import { lib } from '../../../../../../jetti-api/server/std.lib';

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
    private auth: AuthService, public dialog: DialogService) { }

  private _pageSizeSubscription$: Subscription = Subscription.EMPTY;
  private _pageSize$ = new Subject<number>();
  private _docSubscription$: Subscription = Subscription.EMPTY;
  private _routeSubscription$: Subscription = Subscription.EMPTY;
  private _debonceSubscription$: Subscription = Subscription.EMPTY;
  private _debonce$ = new Subject<FormListFilter>();
  private _resizeSubscription$: Subscription = Subscription.EMPTY;

  private _usSubscription$: Subscription = Subscription.EMPTY;
  private _columnsSettingsDialogRef: DynamicDialogRef;
  private _columnSettingsProps = ['width', 'visibility'];

  pageSize$: Observable<number>;


  @ViewChild('tbl', { static: false }) tbl: Table;
  @ViewChild('treeTable', { static: false }) treeTable: TreeTable;

  get isDoc() { return Type.isDocument(this.type); }
  get isCatalog() { return Type.isCatalog(this.type); }
  get id() { return this.selectedData ? this.selectedData.id : null; }
  set id(id: string) { this.selection = [{ id, type: this.type }]; this.selectedNode = { data: { id: id }, key: id, type: this.type }; }
  get visibleColumns() { return this.columns.filter(column => column && !column.hidden); }
  get activeFilters() { return this.columns.filter(column => column.filter && column.filter.isActive).map(col => col.filter); }
  get allFilters() {
    return this.columns
      .filter(column => column.filter)
      .map(col => col.filter);
  }
  get selectedData() {
    return this.treeNodesVisible ?
      (this.selectedNode ? this.selectedNode.data : null) :
      (this.selection && this.selection.length ? this.selection[0] : null);
  }
  get matchOperatorsByType() {
    const res = {};
    Object.keys(matchOperatorByType).forEach(key => res[key] = matchOperatorByType[key].map(op => ({ label: op, value: op })));
    return res;
  }

  get dataViewTypeChangeCommands() {
    return [
      { label: 'Tree', command: () => { this._presentation = 'Tree'; this.onChangePresentation(); } },
      { label: 'List', command: () => { this._presentation = 'List'; this.onChangePresentation(); } },
      { label: 'Auto', command: () => { this._presentation = 'Auto'; this.onChangePresentation(); } }
    ];
  }

  set presentation(mode: 'List' | 'Tree' | '') {
    if (mode && !'List,Tree,Auto'.includes(mode)) return;
    this._presentation = mode || 'Auto';
    this.onChangePresentation();
  }

  postedCol: ColumnDef = ({
    field: 'posted', filter: { left: 'posted', center: '=', right: null }, type: 'boolean', label: 'posted',
    style: { width: '30px' }, order: 0, readOnly: false, required: false, hidden: false, value: undefined, headerStyle: {}
  });

  group = '';
  columns: ColumnDef[] = [];
  selection: any[] = [];
  contextMenuSelection = [];
  ctxData = { column: '', value: undefined };
  contexCommands: { list: MenuItem[], tree: MenuItem[] } = { list: [], tree: [] };
  filters: { [s: string]: FormListFilter } = {};
  multiSortMeta: SortMeta[] = [];
  showDeleted = false;
  dataSource: ApiDataSource;
  private _userEmail = this.auth.userEmail;
  sidebarDisplay = false;

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
  _presentation = 'Auto';
  _allColumns = this.auth.isRoleAvailableAllColumns();
  readonly = this.auth.isRoleAvailableReadonly();
  addMenuItems: MenuItem[];
  showActiveFilters = false;
  // matchOperatorByType: { [x: string]: matchOperator[] };

  // matchOperatorByTypeInit() {
  //   this.columns.map(e => e.type)
  // }

  async ngOnInit() {

    this.readRouteParams(this.route);

    if (!this.settings) this.settings = this.data.settings;
    if (!this.data && this.type) {
      const DocMeta = await this.ds.api.getDocMetaByType(this.type);
      this.data = { schema: DocMeta.Props, metadata: DocMeta.Prop as DocumentOptions, columnsDef: [], model: {}, settings: this.settings };
    }

    // default filters is always active
    this.settings.filter.forEach(e => e.isActive = true);

    this._initColumns();
    this._initdataSource();
    this.addMenuItemsFill();
    this.setSortOrder();
    this.setFilters();
    this.showDeletedSet(false);
    this.prepareDataSource();
    this.setContextMenu(this.columns);

    this._usSubscription$ = this.uss._userSettings$
      .pipe(filter(settings => settings && settings.selected && !settings.dontApply && settings.selected.type === this.type))
      .subscribe(settings => this.usSubscriptionHandler(settings));

    this._docSubscription$ = merge(...[
      this.ds.save$, this.ds.delete$, this.ds.saveClose$, this.ds.goto$, this.ds.post$, this.ds.unpost$]).pipe(
        filter(doc => doc
          && doc.type === this.type
          && !!(!this.group || !doc['Group'] || this.group === doc['Group']['id'])))
      .subscribe(doc => this.docSubscriptionHandler(doc));

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
    this._routeSubscription$ = this.route.params.pipe(
      filter(params => params.type === this.type && params.group === this.group && this.route.snapshot.queryParams.goto))
      .subscribe(params => this.routeSubscruptionHandler());

    this._resizeSubscription$ = fromEvent(window, 'resize').subscribe(e => {
      this._pageSize$.next(this.getPageSize());
    });

    this._pageSizeSubscription$ = this._pageSize$.pipe(debounceTime(50))
      .subscribe(pageSize => this.pageSizeSubscriptionHandler(pageSize));

    this._debonceSubscription$ = this._debonce$.pipe(debounceTime(1000))
      .subscribe(event => this._update(event));

    this.usLoad();

  }

  private readRouteParams(route: ActivatedRoute) {
    if (!this.type) this.type = route.snapshot.params.type;
    if (!this.group) this.group = route.snapshot.params.group;
    if (route.snapshot.queryParams.goto) {
      this.initNodes = true;
      this.id = route.snapshot.queryParams.goto;
    }
  }

  private _initColumns() {

    this.columns = buildColumnDef(this.data.schema, this.settings);
    if (this.data.metadata['Group']) this.settings.filter.push({ left: 'Group', center: '=', right: this.data.metadata['Group'] });

    this.hierarchy = this.data.metadata.hierarchy === 'folders';
    this.treeNodesVisible = this.hierarchy && !this.settings.filter.length;

    if (this.hierarchy) {
      const descriptionColumn = this.columns.find(c => c.field === 'description');
      if (descriptionColumn) {
        this.columns = [descriptionColumn, ...this.columns.filter(c => c.field !== 'description')];
      }
    }
    // this.columns = [...this.columns.filter(column => !hiddenColumns.includes(column.field))];
  }

  private _initdataSource() {
    this.dataSource = new ApiDataSource(this.ds.api, this.type, this.pageSize, true);
    this.dataSource.id = this.id;
    this.dataSource.listOptions.withHierarchy = this.treeNodesVisible;
  }

  private usSubscriptionHandler(settingsState: UserSettitngsState) {
    this.usApplyUserSettings(settingsState.selected.settings);
  }

  private pageSizeSubscriptionHandler(pageSize: number) {
    this.dataSource.pageSize = pageSize;
    this.pageSize$ = of(pageSize);
    if (this.id) this.goto(this.id);
    else this.first();
  }

  private routeSubscruptionHandler() {
    const id = this.route.snapshot.queryParams.goto;
    this.initNodes = true;
    this.refresh(id);
    const route: any[] = [this.type];
    if (this.group) route.push('group', this.group);
    setTimeout(() => this.router.navigate(route, { replaceUrl: true }));
  }


  private docSubscriptionHandler(doc: DocumentBase) {

    this.id = doc.id;
    const exist = (this.dataSource.renderedDataList).find(d => d.id === doc.id);
    if (exist) {
      const visibleFields = [...this.visibleColumns.map(e => e.field), 'posted', 'deleted'];
      const complexFields = this.visibleColumns
        .filter(col => Type.isRefType(col.type as any))
        .map(e => e.field);
      for (const key of visibleFields) {
        const isComplex = complexFields.includes(key);
        if ((isComplex && exist[key].id !== doc[key].id) ||
          (!isComplex && exist[key] !== doc[key] && JSON.stringify(exist[key]) !== JSON.stringify(doc[key]))) {
          this.dataSource.refresh(exist.id);
          break;
        }
      }
    } else if (this.treeNodesVisible) {
      this.selectedNode = null;
      this.loadNodes(doc.id);
    } else this.dataSource.goto(doc.id);
  }

  onFiltersEditInit() {

  }

  isNoFiltered() {
    return this.activeFilters.length;
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
      .filter(c => !(c.right == null || c.right === undefined) && c.isActive)
      .forEach(f => this.setColumnFilter(f.left, f));
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

  private setSettingsFilter(field: string, _filter: FormListFilter) {
    const settingsFilter = this.settings.filter.find(e => e.left === field);
    if (settingsFilter) {
      settingsFilter.isActive = _filter.isActive;
      settingsFilter.center = _filter.center;
      settingsFilter.right = _filter.right;
    } else
      this.settings.filter.push({ ..._filter });
  }

  private _update(_filter: FormListFilter) {
    if (!_filter.left) return;
    if ((Array.isArray(_filter.right)) && _filter.right[1]) { _filter.right[1].setHours(23, 59, 59, 999); }
    this.setColumnFilter(_filter.left, _filter);
    this.setSettingsFilter(_filter.left, _filter);
    this.prepareDataSource(this.multiSortMeta);
    this._pageSize$.next(this.getPageSize());
  }

  // private _update(col: ColumnDef | undefined, event, center, id = null, isActive: boolean) {
  //   if (!col) return;
  //   if ((Array.isArray(event)) && event[1]) { event[1].setHours(23, 59, 59, 999); }
  //   this.filters[col.field] = { matchMode: center || (col.filter && col.filter.center), value: event };
  //   const colFilter = this.settings.filter.find(e => e.left === col.field);
  //   if (colFilter) {
  //     colFilter.isActive = isActive;
  //     colFilter.center = center;
  //     colFilter.right = event;
  //   } else
  //     this.settings.filter.push({ ...col.filter, isActive });
  //   if (id) this.id = id;
  //   this.prepareDataSource(this.multiSortMeta);
  //   this._pageSize$.next(this.getPageSize());
  // }

  setColumnFilterIsActive(column: ColumnDef, isActive: boolean) {
    if (!column.filter) return;
    column.filter.isActive = isActive;
    this._debonce$.next(column.filter);
  }


  update(column: ColumnDef, event, center = 'like' as matchOperator) {
    if (!column) return;
    if (!event || (typeof event === 'object' && !event.value && !(Array.isArray(event)))) {
      if (typeof event !== 'boolean') event = null;
    }
    this._debonce$.next({ left: column.field, right: event, center: center || column.filter.center || '=', isActive: !!event });
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
      this.dataSource.listOptions.hierarchyDirectionUp = this.selectedNode.children.length === 0;
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
    const order = (multiSortMeta || [])
      .map(el => <FormListOrder>({ field: el.field, order: el.order === -1 ? 'desc' : 'asc' }));
    const listSettigns: FormListSettings = { filter: [...this.activeFilters], order };
    this.dataSource.formListSettings = listSettigns;
    const treeNodesVisibleBefore = this.treeNodesVisible;
    this.treeNodesVisible = this._presentation !== 'List' && this.hierarchy && !this.activeFilters.length;
    this.dataSource.listOptions.withHierarchy = this.treeNodesVisible;
    if (treeNodesVisibleBefore !== this.treeNodesVisible) this.onTreeNodesVisibleChange();
  }

  getColumnFilter(field: string) {
    return this.getColumn(field).filter;
  }

  setColumnFilter(field: string, _filter: FormListFilter) {
    return this.getColumn(field).filter = _filter;
  }

  getColumn(field: string) {
    if (!field) return null;
    const res = this.columns.find(e => e.field === field);
    if (!res) console.error('Unknow column: ' + field);
    return res;
  }


  private setContextMenu(columns: ColumnDef[]) {

    const qFilterCommand = {
      label: 'Quick filter', icon: 'pi pi-search',
      command: (event) => this._update({ left: this.ctxData.column, right: this.ctxData.value, center: '=', isActive: true })
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
    this.activeFilters.forEach(f => f.isActive = false);
    if (!this.showDeleted) this.showDeletedSet(false);
    this.prepareDataSource(); this.goto(this.id);
  }

  private buildFiltersParamQuery() {
    const filters = {};
    this.activeFilters
      .filter(f => f.right && f.right.id)
      .forEach(f => filters[f.left] = f.right.id);
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
      setTimeout(() => scrollIntoViewIfNeeded(this.type, 'ui-state-highlight'));
    }
    this.lds.counter = 0;
    this.dataSource.refresh(this.selection[0].id);
  }

  addMenuItemsHeight() {
    return this.addMenuItems.length * 27;
  }


  addMenuItemsFill() {

    const viewMenuItems = {
      label: 'View', items: this.dataViewTypeChangeCommands
    };

    this.addMenuItems = [
      { label: 'Reset view', command: () => { this._resetTables(); } },
      { separator: true },
      { label: 'Clear filters', command: () => { this.clearAllFilters(); } },
      { separator: true },
      { label: 'Show deleted', id: 'ShowDeleted', command: () => { this.showDeletedSet(!this.showDeleted, true); } },
      { separator: true },
      {
        label: 'Settings', items: [
          { label: 'Load', command: () => this.usLoad() },
          { label: 'Save', command: () => this.usSaveCurrentSettings() },
          { label: 'Default', command: () => this.uss.resetSelectedSettings() },
          {
            label: 'Columns...', command: () => this._showColumnsSettingsDialog()
          }
        ]
      },
    ];
    if (this.hierarchy) this.addMenuItems = [viewMenuItems, { separator: true }, ...this.addMenuItems];
  }

  private _showColumnsSettingsDialog(): void {
    this._columnsSettingsDialogRef = this.dialog.open(ColumnsSettingsComponent, {
      width: `${MaxTextWidth(this.columns.map(e => e.label), 13) * 1.62}px`,
      height: `${Math.min(window.innerHeight - 10, 27 * this.columns.length + 52)}px`,
      contentStyle: { 'overflow': 'auto' },
      transitionOptions: '400ms cubic-bezier(0.25, 0.8, 0.25, 1)',
      // header: 'Customize columns'
      showHeader: false,
      closeOnEscape: true,
      baseZIndex: 500,
      data: { settingsService: this.uss, columns: this.columns }
    });
    this._columnsSettingsDialogRef.onClose.pipe(take(1)).subscribe((columns: ColumnDef[]) => {
      if (!columns) return;
      this.settings.columns.visibility = {};
      columns.forEach(col => this.settings.columns.visibility[col.field] = !col.hidden);
      this.settings.columns.order = columns.map(col => col.field);
      this.usApplyColumnsProps();
      this._resetTables();
      this.usApplyUserSettings(this.settings);
    });
  }
  private _resetTables() {
    this.treeNodesVisible ? this.treeTable.reset() : this.tbl.reset();
  }

  showDeletedSet(showDeleted: boolean, update = false) {
    this.showDeleted = showDeleted;
    this.addMenuItems.find(e => e.id === 'ShowDeleted').label = `${this.showDeleted ? 'Hide' : 'Show'} deleted`;
    this.setColumnFilter('deleted', { left: 'deleted', isActive: this.showDeleted, center: '=', right: false });
    if (update) {
      this.prepareDataSource(this.multiSortMeta);
      this._pageSize$.next(this.getPageSize());
    }
  }

  setPresentationMode(mode: string = 'List' || 'Tree' || '') {
    this._presentation = mode;
    this.onChangePresentation();

  }
  onChangePresentation() {
    const treeNodesVisibleBefore = this.treeNodesVisible;
    switch (this._presentation) {
      case 'List':
        this.treeNodesVisible = false;
        break;
      case 'Tree':
        this.treeNodesVisible = true;
        this.clearAllFilters();
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
    const column = this.getColumn('parent');
    if (!column) return;
    column.filter = {
      isActive: true,
      left: 'parent',
      center: '=',
      right: event && event.data && event.data.id ? {
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
    this._routeSubscription$.unsubscribe();
    this._debonceSubscription$.unsubscribe();
    this._debonce$.complete();
    this._pageSize$.complete();
    this._pageSizeSubscription$.unsubscribe();
    this._resizeSubscription$.unsubscribe();
    this._usSubscription$.unsubscribe();
    this._columnsSettingsDialogRef.close();
    // if (!this.route.snapshot.queryParams.goto) { this.saveUserSettings(); }
  }


  onColResize(event) {
    const col = this._getColumnByElement(event.element);
    if (!col) console.log('Unknow col: ' + event.element.outerText);
    this.settings.columns.width[col.field] = `${event.element.offsetWidth}px`;
    // col.style['width'] = this.settings.columns.width[col.field];
    this.uss.isModify = true;
  }

  private _getColumnByElement(element: { outerText: string, offsetWidth: number }): ColumnDef {
    const label = element.outerText.trim();
    return this.columns.find(e => e.label === label);
  }

  onColReorder(event) {
    this.settings.columns.order = event.columns.map(e => e.field);
    this.usApplyColumnsProps();
    this.uss.isModify = true;
  }

  usApplyUserSettings(settings: FormListSettings) {
    // console.log(JSON.stringify(settings));
    this.settings = settings ? settings : this.uss.defaultSettings.settings;
    this.setFilters();
    this.setSortOrder();
    this.usApplyColumnsProps();
    this.prepareDataSource(this.multiSortMeta);
    this._pageSize$.next(this.getPageSize());
  }

  private usApplyColumnsProps() {

    this.columns = [
      ...this.settings.columns.order.map(field => this.columns.find(e => e.field === field)),
      ...this.columns.filter(col => !this.settings.columns.order.includes(col.field))
    ];

    for (const column of this.columns) {
      const colStyle = { ...column.style };
      for (const prop of this._columnSettingsProps) {
        if (!Object.keys(this.settings.columns[prop]).includes(column.field)) continue;
        const propVal = this.settings.columns[prop][column.field];
        if (prop === 'visibility')
          column.hidden = !propVal;
        else
          colStyle[prop] = propVal;
      }
      column.style = colStyle;
      // this._resetTables();
    }
  }

  _usOnUserSettingsBlur(event: any, dialog: any, isFilter = false) {
    if (this.uss.readonly || typeof dialog.value !== 'string') return;
    let settingsDesc = typeof dialog.value === 'string' ? dialog.value : dialog.value.description;
    if (!settingsDesc) settingsDesc = '<unnamed>';
    if (isFilter && this.uss.allSettingsFilter.find(e => e.id === this.uss.selectedSettingsFilter.id).description !== settingsDesc)
      this.uss.isModifyFilter = true;
    else if (!isFilter && this.uss.allSettings.find(e => e.id === this.uss.selectedSettings.id).description !== settingsDesc)
      this.uss.isModify = true; 
  }
 
  _usOnUserSettingsChange(event: any, dialog: any) {
    if (typeof event.value === 'string') return;
    this.uss.selectedSettings = event.value;
  }

  usSaveCurrentSettings() {
    this.uss.setSelectedSettings({ ...this.uss.selectedSettings, settings: this._getCurrentFormListSettings() });
  }

  invertColumnHidden(column: ColumnDef) {
    column.hidden = !column.hidden;
    this.uss.isModify = true;
  }

  private usLoad() {
    this.uss.loadSettings(this.type, this._userEmail, this.usGetDefaultSettings());
  }

  usGetDefaultSettings(): IUserSettings {
    return {
      readonly: true,
      type: this.type,
      user: this._userEmail,
      description: 'Default',
      id: '',
      settings: this._getCurrentFormListSettings()
    };
  }

  private _getCurrentFormListSettings(): FormListSettings {

    return {
      filter: this.activeFilters,
      order: ((<SortMeta[]>this.multiSortMeta) || [])
        .map(o => <FormListOrder>{ field: o.field, order: o.order === 1 ? 'asc' : 'desc' }),
      columns: this._getCurrentFormListSettingsColumns()
    };
  }

  private _getCurrentFormListSettingsColumns(): FormListColumnProps {
    const res: FormListColumnProps = { color: {}, width: {}, order: this.columns.map(col => col.field), visibility: {} };
    this.columns.forEach(col => {
      // res.color[col.field] = col.style['color'];
      res.width[col.field] = this.settings.columns.width[col.field] || col.style['width'];
      res.visibility[col.field] = !col.hidden;
    });
    return res;
  }

}
