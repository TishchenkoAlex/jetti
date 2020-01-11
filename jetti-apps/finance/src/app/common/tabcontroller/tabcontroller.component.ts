import { ChangeDetectionStrategy, Component, QueryList, ViewChildren, ChangeDetectorRef, ViewChild, HostListener } from '@angular/core';
import { FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { merge } from 'rxjs';
import { filter } from 'rxjs/operators';
import { INoSqlDocument } from '../../../../../../jetti-api/server/models/documents.factory';
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
        let index = tabStore.state.tabs.findIndex(el => el.docType === params.type && el.docID === (params.id || ''));
        if (index === -1) {
          const header = this.getTabTitle(this.route.snapshot.data.detail);
          const newLink: TabDef = {
            docType: params.type, docID: (params.id || ''), icon: header.icon, routerLink: this.router.url,
            header: header.header, data: this.route.snapshot.data.detail, query: this.route.snapshot.queryParams
          };
          tabStore.push(newLink);
          index = tabStore.selectedIndex;
        }
        setTimeout(() => this.tabStore.selectedIndex = index);
        setTimeout(() => scrollIntoViewIfNeeded(params.type, 'ui-state-highlight'));
      });

    merge(...[this.ds.save$, this.ds.delete$]).pipe(filter(doc => doc.id === this.route.snapshot.params.id))
      .subscribe(doc => {
        const tab = tabStore.state.tabs.find(i => i.docID === doc.id && i.docType === doc.type);
        if (tab) {
          tab.header = doc.description;
          tabStore.replace(tab);
        }
      });
  }

  private getTabTitle(detail) {
    if (detail instanceof FormGroup) {
      const doc = detail.getRawValue() as INoSqlDocument;
      const metadata = detail['metadata'];
      return { header: doc.description || metadata.description, icon: metadata.icon };
    } else {
      if (detail.metadata) {
        return { header: detail.metadata.menu, icon: detail.metadata.icon };
      }
    }
  }

  selectedIndexChange(event) {
    (event.originalEvent as Event).stopImmediatePropagation();
    const tab = this.tabStore.state.tabs[event.index];
    this.router.navigate([tab.docType, tab.docID], { queryParams: tab.query });
  }

  handleClose(event) {
    (event.originalEvent as Event).stopImmediatePropagation();
    let tab = this.tabStore.state.tabs[event.index];
    const component = this.components.find(e => e.id === tab.docID && e.type === tab.docType);
    if (component && component.componentRef.instance.close) {
      component.componentRef.instance.close();
    } else {
      this.tabStore.close(tab);
      tab = this.tabStore.state.tabs[this.tabStore.selectedIndex];
      this.router.navigate([tab.docType, tab.docID], { queryParams: tab.query });
    }
  }
}
