import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

export interface TabDef {
  header: string; icon: string; docType: string; docID: string; routerLink: string;
}

interface TabsState {
  selectedIndex: number;
  tabs: TabDef[];
}

const initailState: TabsState = {
  selectedIndex: 0,
  tabs: [{ header: 'Home', docType: 'home', icon: 'fa fa-home', docID: '', routerLink: '/' + 'home' }]
};

@Injectable()
export class TabsStore {

  private readonly _state: BehaviorSubject<TabsState> = new BehaviorSubject(initailState);
  get state() { return this._state.value; }
  state$ = this._state.asObservable();

  get selectedIndex() { return this.state.selectedIndex; }
  set selectedIndex(value) {
    this._state.next(({
      ...this.state,
      selectedIndex: value
    }));
  }

  push(value: TabDef) {
    this._state.next(({
      ...this.state,
      tabs: [...this.state.tabs, value],
      selectedIndex: this.state.tabs.length
    }));
  }

  replace(value: TabDef) {
    const copy = [...this.state.tabs];
    const index = this.state.tabs.findIndex(el => el.docType === value.docType && el.docID === value.docID);
    copy[index] = value;
    this._state.next(({
      ...this.state,
      tabs: copy,
    }));
  }

  close(value: TabDef) {
    const copy = [...this.state.tabs];
    const index = this.state.tabs.findIndex(el => el.docType === value.docType && el.docID === value.docID);
    const currentTab = this.state.tabs[this.state.selectedIndex];
    copy.splice(index, 1);
    let selectedIndex = copy.findIndex(el => el.docType === currentTab.docType && el.docID === currentTab.docID);
    if (selectedIndex === -1) selectedIndex = Math.min(this.state.selectedIndex, copy.length - 1);
    this._state.next(({
      ...this.state,
      tabs: copy,
      selectedIndex: selectedIndex
    }));
  }

}
