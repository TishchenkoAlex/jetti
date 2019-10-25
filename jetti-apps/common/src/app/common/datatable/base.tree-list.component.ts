import { ChangeDetectionStrategy, Component, EventEmitter, Input, OnDestroy, OnInit, Output } from '@angular/core';
import { Router } from '@angular/router';
import { TreeNode } from 'primeng/api';
import { merge, Observable, Subject, Subscription } from 'rxjs';
import { filter, map, switchMap, tap } from 'rxjs/operators';
import { v1 } from 'uuid';
import { ITree } from '../../../../../../jetti-api/server/models/api';
import { DocumentBase } from '../../../../../../jetti-api/server/models/document';
import { DocTypes } from '../../../../../../jetti-api/server/models/documents.types';
import { DocService } from '../../common/doc.service';
import { ApiService } from '../../services/api.service';
import { LoadingService } from '../loading.service';
import { BaseDocListComponent } from './base.list.component';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-tree-list',
  templateUrl: 'base.tree-list.component.html',
})
export class BaseTreeListComponent implements OnInit, OnDestroy {
  @Output() selectionChange = new EventEmitter();
  @Input() type: DocTypes;
  @Input() owner: BaseDocListComponent;
  treeNodes$: Observable<TreeNode[]>;
  selection: TreeNode;

  private paginator = new Subject<DocumentBase>();
  private _docSubscription$: Subscription = Subscription.EMPTY;
  get scrollHeight() { return `${(window.innerHeight - 275)}px`; }

  constructor(private api: ApiService, public router: Router, public ds: DocService, public lds: LoadingService) { }

  ngOnInit() {

    this._docSubscription$ = merge(...[this.ds.save$, this.ds.delete$, this.ds.saveClose$, this.ds.goto$]).pipe(
      filter(doc => doc && doc.type === this.type)).
      subscribe(doc => this.paginator.next(doc));

    this.treeNodes$ = this.paginator.pipe(
      switchMap(doc => {
        return this.api.tree(this.type).pipe(
          map(tree => <TreeNode[]>[{
            label: '(All)',
            data: { id: undefined, description: '(All)' },
            expanded: true,
            expandedIcon: 'fa fa-folder-open',
            collapsedIcon: 'fa fa-folder',
            children: this.buildTreeNodes(tree, null),
          }]),
          tap(treeNodes => {
            let current: TreeNode | undefined = treeNodes[0];
            if (doc) {
              const findDoc = this.findDoc(treeNodes, doc);
              if (findDoc) current = findDoc;
            }
            this.selection = current;
          }));
      }));
    setTimeout(() => this.paginator.next());
  }

  private findDoc(tree: TreeNode[], doc: DocumentBase): TreeNode | undefined {
    const result = tree.find(el => el.data.id === (doc.parent as any).id);
    if (result) return result;
    for (let i = 0; i < tree.length; i++) {
      const childrenResult = this.findDoc(tree[i].children || [], doc);
      if (childrenResult) return childrenResult;
    }
  }

  private buildTreeNodes(tree: ITree[], parent: string | null): TreeNode[] {
    return tree.filter(el => el.parent === parent).map(el => {
      return <TreeNode>{
        label: el.description,
        data: { id: el.id, description: el.description },
        expanded: true,
        expandedIcon: 'fa fa-folder-open',
        collapsedIcon: 'fa fa-folder',
        children: this.buildTreeNodes(tree, el.id) || [],
      };
    });
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

  onSelectionChange(event) {
    this.selectionChange.emit(event);
  }

  onDragEnd(event) {
    // console.log('drop', event);
  }

  onNodeSelect(event) {
    this.selectionChange.emit(event.node);
  }

  ngOnDestroy() {
    this._docSubscription$.unsubscribe();
  }
}
