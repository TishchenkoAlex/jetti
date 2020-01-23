import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';
import { FormGroup } from '@angular/forms';
import { IViewModel } from '../../../../../../jetti-api/server/models/common-types';

export interface TabDef {
  header: string;
  icon: string;
  type: string;
  id: string;
  group: string;
  routerLink: string;
  query: { [x: string]: any };
  data: FormGroup | IViewModel | any;
}

interface TabsState {
  selectedIndex: number;
  tabs: TabDef[];
}

const initailState: TabsState = {
  selectedIndex: 0,
  tabs: [{
    header: 'Home', type: 'home', icon: 'fa fa-home',
    id: '', routerLink: '/' + 'home', data: null, query: {}, group: ''
  }]
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
    const index = this.state.tabs.findIndex(el => el.type === value.type && el.id === value.id && el.group === value.group);
    copy[index] = value;
    this._state.next(({
      ...this.state,
      tabs: copy,
    }));
  }

  close(value: TabDef) {
    const copy = [...this.state.tabs];
    const index = this.state.tabs.findIndex(el => el.type === value.type && el.id === value.id && el.group === value.group);
    const currentTab = this.state.tabs[this.state.selectedIndex];
    copy.splice(index, 1);
    let selectedIndex = copy.findIndex(el => el.type === currentTab.type && el.id === currentTab.id && el.group === currentTab.group);
    if (selectedIndex === -1) selectedIndex = Math.min(this.state.selectedIndex, copy.length - 1);
    this._state.next(({
      ...this.state,
      tabs: copy,
      selectedIndex: selectedIndex
    }));
  }

}
