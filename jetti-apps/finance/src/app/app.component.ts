import { AfterViewInit, ChangeDetectionStrategy, Component, ViewChild } from '@angular/core';
import { SwUpdate } from '@angular/service-worker';
import { ScrollPanel } from '../../node_modules/primeng/scrollpanel';
import { AuthService } from './auth/auth.service';

enum MenuOrientation { STATIC, OVERLAY, SLIM, HORIZONTAL }

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements AfterViewInit {

  layoutCompact = true;
  layoutMode: MenuOrientation = MenuOrientation.STATIC;
  darkMenu = false;
  profileMode = 'inline';
  rotateMenuButton: boolean;
  topbarMenuActive: boolean;
  overlayMenuActive: boolean;
  staticMenuDesktopInactive: boolean;
  staticMenuMobileActive: boolean;
  rightPanelActive: boolean;
  rightPanelClick: boolean;
  layoutMenuScroller: HTMLDivElement;
  menuClick: boolean;
  topbarItemClick: boolean;
  activeTopbarItem: any;
  resetMenu: boolean;
  menuHoverActive: boolean;

  @ViewChild('layoutMenuScroller', {static: false }) layoutMenuScrollerViewChild: ScrollPanel;

  constructor(
    public auth: AuthService, private swUpdate: SwUpdate) {

    if (this.swUpdate.isEnabled) {
      this.swUpdate.available.subscribe(() => {
        if (confirm('Jetti apps: New version available. Load new version?')) {
          window.location.reload();
        }
      });

    }
  }

  ngAfterViewInit() {
    setTimeout(() => this.layoutMenuScrollerViewChild.moveBar(), 100);
  }

  onMenuButtonClick(event) {
    this.menuClick = true;
    this.rotateMenuButton = !this.rotateMenuButton;
    this.topbarMenuActive = false;

    if (this.layoutMode === MenuOrientation.OVERLAY) {
      this.overlayMenuActive = !this.overlayMenuActive;
    } else {
      if (this.isDesktop()) {
        this.staticMenuDesktopInactive = !this.staticMenuDesktopInactive;
      } else {
        this.staticMenuMobileActive = !this.staticMenuMobileActive;
      }
    }

    event.preventDefault();
  }

  onMenuClick($event) {
    this.menuClick = true;
    this.resetMenu = false;
    setTimeout(() => this.layoutMenuScrollerViewChild.moveBar(), 450);
  }

  onTopbarMenuButtonClick(event) {
    this.topbarItemClick = true;
    this.topbarMenuActive = !this.topbarMenuActive;

    this.hideOverlayMenu();

    event.preventDefault();
  }

  onTopbarItemClick(event, item) {
    this.topbarItemClick = true;

    if (this.activeTopbarItem === item) {
      this.activeTopbarItem = null;
    } else {
      this.activeTopbarItem = item;
    }

    event.preventDefault();
  }

  onTopbarSubItemClick(event) {
    event.preventDefault();
  }

  hideOverlayMenu() {
    this.rotateMenuButton = false;
    this.overlayMenuActive = false;
    this.staticMenuMobileActive = false;
  }

  isTablet() {
    const width = window.innerWidth;
    return width <= 1024 && width > 640;
  }

  isDesktop() {
    return window.innerWidth > 1024;
  }

  isMobile() {
    return window.innerWidth <= 640;
  }

  isOverlay() {
    return this.layoutMode === MenuOrientation.OVERLAY;
  }

  changeToStaticMenu() {
    this.layoutMode = MenuOrientation.STATIC;
  }

  changeToOverlayMenu() {
    this.layoutMode = MenuOrientation.OVERLAY;
  }

}
