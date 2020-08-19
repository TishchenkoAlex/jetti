import { ChangeDetectionStrategy, Component, QueryList, ViewChildren, ChangeDetectorRef, ViewChild, HostListener } from '@angular/core';
import { FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { merge } from 'rxjs';
import { filter } from 'rxjs/operators';
import { DocService } from '../doc.service';
import { DynamicComponent } from '../dynamic-component/dynamic-component';
import { scrollIntoViewIfNeeded } from '../utils';
import { TabDef, TabsStore } from './tabs.store';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'app-tabcontroller',
  templateUrl: './tabcontroller.component.html',
})
export class TabControllerComponent {

  @ViewChildren(DynamicComponent) components: QueryList<DynamicComponent>;

  constructor(private router: Router, private route: ActivatedRoute, private ds: DocService,
    public tabStore: TabsStore, private cd: ChangeDetectorRef) {

    this.tabStore.state$.subscribe(store => {
      setTimeout(() => this.cd.markForCheck());
    });

    this.route.params
      .subscribe(params => {
        let index = tabStore.state.tabs.findIndex(el =>
          el.type === params.type &&
          el.id === (params.id || '') &&
          el.group === (params.group || '')
        );
        if (index === -1) {
          const header = this.getTabTitle(this.route.snapshot.data.detail);
          const newLink: TabDef = {
            type: params.type,
            id: (params.id || ''),
            group: (params.group || ''),
            icon: header.icon,
            routerLink: this.router.url,
            query: this.route.snapshot.queryParams,
            header: header.header,
            data: this.route.snapshot.data.detail
          };
          tabStore.push(newLink);
          index = tabStore.selectedIndex;
        }
        setTimeout(() => this.tabStore.selectedIndex = index);
        setTimeout(() => scrollIntoViewIfNeeded(params.type, 'ui-state-highlight'));
      });

    merge(...[this.ds.save$, this.ds.delete$]).pipe(filter(doc => doc.id === this.route.snapshot.params.id))
      .subscribe(doc => {
        const tab = tabStore.state.tabs.find(i => i.id === doc.id && i.type === doc.type && i.group === (doc['Group'] || ''));
        if (tab) {
          tab.header = doc.description;
          tabStore.replace(tab);
        }
      });
  }

  private getTabTitle(detail) {
    if (detail instanceof FormGroup) {
      const doc = detail.getRawValue();
      const metadata = detail['metadata'];
      return { header: doc.description || metadata.description, icon: metadata.icon };
    } else {
      if (detail && detail.metadata) {
        let Group = '';
        if (detail.metadata.Group) Group = ` [${detail.metadata.Group.code}]`;
        return { header: detail.metadata.menu + Group, icon: detail.metadata.icon };
      }
    }
  }

  selectedIndexChange(event) {
    (event.originalEvent as Event).stopImmediatePropagation();
    const tab = this.tabStore.state.tabs[event.index];
    const route = [tab.type];
    if (tab.group) route.push('group', tab.group); else route.push(tab.id);
    this.router.navigate(route);
  }

  handleClose(event) {
    (event.originalEvent as Event).stopImmediatePropagation();
    let tab = this.tabStore.state.tabs[event.index];
    const component = this.components.find(e => e.id === tab.id && e.type === tab.type);
    if (component && component.componentRef.instance.close) {
      component.componentRef.instance.close();
    } else {
      this.tabStore.close(tab);
      tab = this.tabStore.state.tabs[this.tabStore.selectedIndex];
      const route = [tab.type];
      if (tab.group) route.push('group', tab.group); else route.push(tab.id);
      this.router.navigate(route);
    }
  }
}
