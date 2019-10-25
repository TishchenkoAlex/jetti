import { ChangeDetectionStrategy, Component, Input } from '@angular/core';
import { MenuItem, TreeNode } from 'primeng/api';
import { BaseTreeListComponent } from '../../common/datatable/base.tree-list.component';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-tree-list-toolbar',
  template: `
    <p-toolbar>
      <div class="ui-toolbar-group-left">
        <span *ngFor="let btn of buttons">
          <button *ngIf="btn.visible" pButton type="button" [ngClass]="btn.styleClass" [icon]="btn.icon" (click)="btn.command"></button>
        </span>
        <ng-content></ng-content>
      </div>
    </p-toolbar>`
})
export class BaseTreeListToolbarComponent {
  @Input() owner: BaseTreeListComponent;

  private _selection: TreeNode;
  get selection(): TreeNode { return this._selection; }
  @Input() set selection(value: TreeNode) {
    this._selection = value;
    this.recalcButtonsState();
  }

  buttons: MenuItem[] = [];
  initState() {
    // tslint:disable:max-line-length
    this.buttons = [
      { label: 'add', icon: 'fa fa-plus', styleClass: 'ui-button-success', command: this.owner.add.bind(this.owner), visible: true },
      { label: 'open', icon: 'fa fa-pencil-square-o', styleClass: 'ui-button-secondary', command: this.owner.open.bind(this.owner), visible: this.selection !== null },
      { label: 'delete', icon: 'fa fa-trash', styleClass: 'ui-button-danger', command: this.owner.delete.bind(this.owner), visible: this.selection !== null },
    ];
  }

  private recalcButtonsState() {
    if (!this.buttons.length) this.initState();
    this.buttons.find(b => b.label === 'delete')!.visible = this.selection !== null;
    this.buttons.find(b => b.label === 'open')!.visible = this.selection !== null && this.selection.data.id;
  }

}
