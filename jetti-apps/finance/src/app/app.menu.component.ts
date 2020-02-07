import { animate, state, style, transition, trigger } from '@angular/animations';
import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Input } from '@angular/core';
import { MenuItem } from 'primeng/components/common/menuitem';
import { Observable, of, iif } from 'rxjs';
import { mergeMap, tap } from 'rxjs/operators';
import { AppComponent } from './app.component';
import { ApiService } from './services/api.service';

@Component({
  changeDetection: ChangeDetectionStrategy.Default,
  selector: 'app-menu',
  template: `
    <ul app-submenu
      [item]="(model$ | async) || []"
      root="true"
      class="layout-menu layout-main-menu clearfix"
      [reset]="reset"
      visible="true"
      parentActive="true">
    </ul>`
})
export class AppMenuComponent {

  @Input() reset: boolean;

  model$: Observable<MenuItem[]>;

  constructor(public app: AppComponent, private cd: ChangeDetectorRef, private api: ApiService) {

    this.model$ = this.app.auth.userProfile$.pipe(
      mergeMap(acc =>
        iif(() => acc.account === undefined,
          of([]),
          iif(() => {
            const menu = localStorage.getItem('SubSystemsMenu');
            return menu && menu.length && menu.length > 2;
          },
            of(JSON.parse(localStorage.getItem('SubSystemsMenu'))),
            this.api.SubSystemsMenu()),
        )),
      tap(sub => {
        localStorage.setItem('SubSystemsMenu', JSON.stringify(sub));
      }));
  }
}

@Component({
  selector: '[app-submenu]',
  template: `
    <ng-template ngFor let-child let-i="index" [ngForOf]="(root ? item : item.items)">
      <li [ngClass]="{'active-menuitem': isActive(i)}" [class]="child.badgeStyleClass" *ngIf="child.visible === false ? false : true">
        <a [href]="child.url" (click)="itemClick($event,child,i)"
           class="ripplelink" *ngIf="!child.routerLink"
            [attr.tabindex]="!visible ? '-1' : null" [attr.target]="child.target">
            <i [ngClass]="child.icon"></i><span>{{child.label}}</span>
            <i class="fa fa-fw fa-angle-down menuitem-toggle-icon" *ngIf="child.items"></i>
            <span class="menuitem-badge" *ngIf="child.badge">{{child.badge}}</span>
        </a>
        <a (click)="itemClick($event,child,i)" class="ripplelink" *ngIf="child.routerLink"
            [routerLink]="child.routerLink" routerLinkActive="active-menuitem-routerlink"
            [attr.tabindex]="!visible ? '-1' : null" [attr.target]="child.target">
            <i [ngClass]="child.icon"></i><span>{{child.label}}</span>
            <i class="fa fa-fw fa-angle-down menuitem-toggle-icon" *ngIf="child.items"></i>
            <span class="menuitem-badge" *ngIf="child.badge">{{child.badge}}</span>
        </a>
        <div class="layout-menu-tooltip">
            <div class="layout-menu-tooltip-arrow"></div>
            <div class="layout-menu-tooltip-text">{{child.label}}</div>
        </div>
        <div class="submenu-arrow" *ngIf="child.items"></div>
        <ul app-submenu [item]="child" *ngIf="child.items" [visible]="isActive(i)" [reset]="reset"
            [@children]="(false)&&root ? isActive(i) ?
             'visible' : 'hidden' : isActive(i) ? 'visibleAnimated' : 'hiddenAnimated'">
        </ul>
      </li>
    </ng-template>
  `,
  animations: [
    trigger('children', [
      state('hiddenAnimated', style({
        height: '0px'
      })),
      state('visibleAnimated', style({
        height: '*'
      })),
      state('visible', style({
        display: 'block'
      })),
      state('hidden', style({
        display: 'none'
      })),
      transition('visibleAnimated => hiddenAnimated', animate('400ms cubic-bezier(0.86, 0, 0.07, 1)')),
      transition('hiddenAnimated => visibleAnimated', animate('400ms cubic-bezier(0.86, 0, 0.07, 1)'))
    ])
  ]
})
export class AppSubMenuComponent {

  @Input() item: MenuItem;
  @Input() root: boolean;
  @Input() visible: boolean;

  _reset: boolean;
  activeIndex: number | null;

  constructor(public app: AppComponent) { }

  itemClick(event: Event, item: MenuItem, index: number) {
    if (this.root) {
      this.app.menuHoverActive = !this.app.menuHoverActive;
    }

    // avoid processing disabled items
    if (item.disabled) {
      event.preventDefault();
      return true;
    }

    // activate current item and deactivate active sibling if any
    this.activeIndex = (this.activeIndex === index) ? null : index;

    // execute command
    if (item.command) {
      item.command({ originalEvent: event, item: item });
    }

    // prevent hash change
    if (item.items || (!item.url && !item.routerLink)) {
      setTimeout(() => {
        this.app.layoutMenuScrollerViewChild.moveBar();
      }, 450);
      event.preventDefault();
    }

    // hide menu
    if (!item.items) {
      this.app.resetMenu = false;
      this.app.overlayMenuActive = false;
      this.app.staticMenuMobileActive = false;
      this.app.menuHoverActive = !this.app.menuHoverActive;
    }
  }

  isActive(index: number): boolean {
    return this.activeIndex === index;
  }

  @Input() get reset(): boolean {
    return this._reset;
  }

  set reset(val: boolean) {
    this._reset = val;
  }
}
