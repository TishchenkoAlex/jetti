import { ChangeDetectionStrategy, Component, QueryList, ViewChildren } from '@angular/core';
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

/*   @HostListener('keydown', ['$event'])
  onKeyDown(event: KeyboardEvent) {
    if (event.keyCode === 27 && this.tabStore.selectedIndex) {
      this.handleClose({ originalEvent: event, index: this.tabStore.selectedIndex });
    }
  }
 */
  constructor(
    private router: Router, private route: ActivatedRoute, private ds: DocService, public tabStore: TabsStore) {

    this.route.params
      .subscribe(params => {
        const index = tabStore.state.tabs.findIndex(el => el.docType === params.type && el.docID === (params.id || ''));
        if (index > -1) {
          setTimeout(() => this.tabStore.selectedIndex = index);
        } else {
          const newLink: TabDef = {
            docType: params.type, docID: (params.id || ''), icon: 'list', routerLink: this.router.url, header: params.type
          };
          tabStore.push(newLink);
          setTimeout(() => this.tabStore.selectedIndex = this.tabStore.selectedIndex);
        }
        if (this.components) {
          const component = this.components.find(e => e.id === (params.id || '') && e.type === params.type);
          if (component && component.componentRef.instance.focus) component.componentRef.instance.focus();
        }
        setTimeout(() => scrollIntoViewIfNeeded(params.type, 'ui-state-highlight'));
      });

    this.route.data.pipe(filter(data => data.detail)).subscribe(this.updateTabTitle(tabStore));

    merge(...[this.ds.save$, this.ds.delete$]).pipe(filter(doc => doc.id === this.route.snapshot.params.id))
      .subscribe(doc => {
        const tab = tabStore.state.tabs.find(i => i.docID === doc.id && i.docType === doc.type);
        if (tab) {
          tab.header = doc.description;
          tabStore.replace(tab);
        }
      });
  }

  private updateTabTitle(tabStore: TabsStore) {
    return data => {
      if (data.detail instanceof FormGroup) {
        const doc = data.detail.getRawValue() as INoSqlDocument;
        const metadata = data.detail['metadata'];
        const tab = tabStore.state.tabs.find(i => (i.docType === metadata.type && i.docID === (doc.id || '')));
        if (tab) {
          tab.header = doc.description || metadata.description || tab.docType;
          tab.icon = metadata.icon;
          tabStore.replace(tab);
        }
      } else {
        if (data.detail.metadata) {
          const tab = tabStore.state.tabs.find(i => (i.docType === data.detail.metadata.type) && !i.docID);
          if (tab) {
            tab.header = data.detail.metadata.menu;
            tab.icon = data.detail.metadata.icon;
            tabStore.replace(tab);
          }
        }
      }
    };
  }

  selectedIndexChange(event) {
    (event.originalEvent as Event).stopImmediatePropagation();
    const tab = this.tabStore.state.tabs[event.index];
    this.router.navigate([tab.docType, tab.docID]);
  }

  handleClose(event) {
    (event.originalEvent as Event).stopImmediatePropagation();
    const tab = this.tabStore.state.tabs[event.index];
    const component = this.components.find(e => e.id === tab.docID && e.type === tab.docType);
    if (component && component.componentRef.instance.Close) {
      component.componentRef.instance.Close();
    } else {
      this.tabStore.close(tab);
      const returnTab = this.tabStore.state.tabs[this.tabStore.state.selectedIndex];
      this.router.navigate([returnTab.docType, returnTab.docID]);
    }
    setTimeout(() => this.tabStore.selectedIndex = this.tabStore.selectedIndex);
  }
}
