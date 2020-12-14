import { Injectable, OnDestroy } from '@angular/core';
import { MessageService } from 'primeng/api';
import { Subject } from 'rxjs';
import { BehaviorSubject } from 'rxjs/internal/BehaviorSubject';
import { filter, take } from 'rxjs/operators';
import { v4 } from 'uuid';
import { FormListSettings, IUserSettings } from '../../../../../../jetti-api/server/models/user.settings';
import { findTaxCheckAttachmentsByOperationId } from '../../../../../../jetti-api/server/x100/functions/taxCheck';
import { ApiService } from '../../services/api.service';

export abstract class UserSettitngsState {
  settings?: IUserSettings[];
  selected?: IUserSettings;
  default?: IUserSettings;
  dontApply?: boolean;
}

export const hiddenColumns =
  ['id',
    'date',
    'user',
    // 'posted',
    'parent',
    'isfolder',
    'info',
    'timestamp',
    'workflow',
    'type'];
@Injectable({ providedIn: 'root' })
export class UserSettingsService implements OnDestroy {

  formListSettings$ = new Subject<FormListSettings>();
  _userSettings$ = new BehaviorSubject<UserSettitngsState>({});

  get selectedSettings() { return this.state.selected; }
  get defaultSettings() { return this.state.default; }
  get allSettings() { return this.state.settings; }
  get state() { return this._userSettings$.value; }
  get isModify() { return !!(this.selectedSettings && this.selectedSettings.isModify); }
  get readonly() { return !!(this.selectedSettings && this.selectedSettings.readonly); }
  get selectedSettingsDescription() {
    return this.selectedSettings ?
      `${this.isModify && !this.selectedSettings.description.startsWith('*') ? '*' : ''}${this.selectedSettings.description || ''}` : '';
  }

  set allSettings(settings: IUserSettings[]) {
    this._userSettings$.next({ ...this.state, settings, dontApply: true });
  }

  set selectedSettings(settings: IUserSettings) { this.setSelectedSettings(settings); }
  set selectedSettingsDescription(description: string) {
    this._userSettings$.next({ ...this.state, selected: { ...this.selectedSettings, description }, dontApply: true });
  }

  set isModify(mod: boolean) { this.selectedSettings.isModify = mod; }


  formListSettingsFilter$ = new Subject<FormListSettings>();
  _userSettingsFilter$ = new BehaviorSubject<UserSettitngsState>({});

  get selectedSettingsFilter() { return this.stateFilter.selected; }
  get defaultSettingsFilter() { return this.stateFilter.default; }
  get allSettingsFilter() { return this.stateFilter.settings; }
  get stateFilter() { return this._userSettingsFilter$.value; }
  get isModifyFilter() { return !!(this.selectedSettingsFilter && this.selectedSettingsFilter.isModify); }
  get readonlyFilter() { return !!(this.selectedSettingsFilter && this.selectedSettingsFilter.readonly); }
  get selectedSettingsDescriptionFilter() {
    return this.selectedSettingsFilter ?
      `${this.isModifyFilter && !this.selectedSettingsFilter.description.startsWith('*') ? '*' : ''}${this.selectedSettingsFilter.description || ''}` : '';
  }
  set allSettingsFilter(settings: IUserSettings[]) {
    this._userSettingsFilter$.next({ ...this.state, settings, dontApply: true });
  }
  set selectedSettingsFilter(settings: IUserSettings) { this.setSelectedSettings(settings); }
  set selectedSettingsDescriptionFilter(description: string) {
    this._userSettingsFilter$.next({ ...this.state, selected: { ...this.selectedSettingsFilter, description }, dontApply: true });
  }
  set isModifyFilter(mod: boolean) { this.selectedSettingsFilter.isModify = mod; }

  constructor(private api: ApiService, private messageService: MessageService) { }

  ngOnDestroy(): void {
    this._userSettings$.complete();
    this._userSettingsFilter$.complete();
  }

  copySettings() {
    const newSettings = {
      ...this.selectedSettings,
      id: v4().toLocaleUpperCase(),
      description: 'Copy: ' + this.selectedSettings.description,
      isModify: true,
      isNew: true,
      readonly: false
    };
    this._userSettings$.next({ ... this.state, selected: newSettings, dontApply: true });
  }

  copySettingsFilter() {
    const newSettings = {
      ...this.selectedSettingsFilter,
      id: v4().toLocaleUpperCase(),
      description: 'Copy: ' + this.selectedSettingsFilter.description,
      isModify: true,
      isNew: true,
      readonly: false
    };
    this._userSettingsFilter$.next({ ... this.stateFilter, selected: newSettings, dontApply: true });
  }

  loadSettings(type: string, user: string, defaultSettings: IUserSettings) {
    this.api.getUserSettings(type, user)
      .pipe(take(1))
      .subscribe(settings => {
        if (settings) {
          settings.forEach(set => this.cacheSettings(set));
          const settingsByKind = {
            filter: settings.filter(e => e.kind === 'filter'),
           columns: settings.filter(e => e.kind === 'columns') 
          };
          this._userSettings$.next({
            settings: [...settingsByKind.columns, defaultSettings],
            default: defaultSettings,
            selected: settingsByKind.columns.find(e => e.selected) ? settingsByKind.columns.find(e => e.selected) : settingsByKind.columns.length ? settingsByKind.columns[0] : defaultSettings
          });
          this._userSettingsFilter$.next({
            settings: [...settingsByKind.filter, defaultSettings],
            default: defaultSettings,
            selected: settingsByKind.filter.find(e => e.selected) ? settingsByKind.filter.find(e => e.selected) : settingsByKind.filter.length ? settingsByKind.filter[0] : defaultSettings
          });

        } else {
          this._userSettings$.next({ settings: [defaultSettings], default: defaultSettings, selected: defaultSettings });
          this._userSettingsFilter$.next({ settings: [defaultSettings], default: defaultSettings, selected: defaultSettings });
        }
      });
  }

  async setSelectedSettings(settings: IUserSettings) {
    const dontApply = settings.isModify;
    if (settings.isModify) await this.saveSettingsAsSelected(settings);
    else this.showSuccessMessage(`Applied settings "${settings.description || 'DEFAULT'}"`);
    this._userSettings$.next({ ...this.state, selected: { ...settings, isModify: false, isNew: false }, dontApply });
  }

  async resetSelectedSettings() {
    const settings = this.selectedSettings.isNew ? this.defaultSettings : this.selectedSettings;
    this.selectedSettings = { ...settings, isModify: false };
  }

  deleteSelectedSettings() {
    if (!this.defaultSettings) throw new Error('Cant delete setting: default settings is not provided');
    const delDesc = this.selectedSettings.description;
    if (this.selectedSettings.id) this.api.deleteUserSettings(this.selectedSettings.id);
    this._userSettings$.next({
      ...this.state,
      selected: this.defaultSettings,
      settings: this.allSettings.filter(e => e.id !== this.selectedSettings.id),
      dontApply: false
    });
    this.showSuccessMessage(`Settings "${delDesc}" is deleted`);
  }

  async saveSettingsAsSelected(settings: IUserSettings) {
    if (settings.readonly) return;
    if (!settings.description || settings.description.trim() === '*') settings.description = '<unnamed>';
    const settingsToSave: IUserSettings[] = [];
    settingsToSave.push({ ...settings, selected: true });
    const oldSelected = this.allSettings.find(set => set.selected && set.id && set.id !== settings.id);
    if (oldSelected) settingsToSave.push({ ...oldSelected, selected: false });
    await this.saveSettings(settingsToSave);
  }

  async saveSettings(settings: IUserSettings[]) {
    const savedSettings = await this.api.saveUserSettings(settings);
    const allSettings = [...this.allSettings];
    for (const set of savedSettings) {
      set.isModify = false;
      set.isNew = false;
      this.showSuccessMessage(`Settings ${set.description} is saved`);
      this.cacheSettings(set);
      const oldSet = allSettings.find(e => e.id === set.id);
      if (oldSet) allSettings[allSettings.indexOf(oldSet)] = set;
      else allSettings.unshift(set);
    }
    this.allSettings = allSettings;
  }

  getSettingsFromCache(id: string) {
    if (!id) return null;
    const settings = localStorage.getItem(this.settingsCacheKey(id));
    return settings ? JSON.parse(settings) as IUserSettings : null;
  }

  cacheSettings(settings: IUserSettings) {
    return localStorage.setItem(this.settingsCacheKey(settings.id), JSON.stringify(settings));
  }

  settingsCacheKey(id: string) {
    return `formSettings: ${id} `;
  }

  private showSuccessMessage(summary: string, detail = '') {
    this.messageService.add({ severity: 'success', summary, detail, key: '1' });
  }
}
