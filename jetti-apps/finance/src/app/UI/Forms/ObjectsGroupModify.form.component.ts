import { Component, ChangeDetectionStrategy, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { _baseDocFormComponent } from 'src/app/common/form/_base.form.component';
import { Router, ActivatedRoute } from '@angular/router';
import { AuthService } from 'src/app/auth/auth.service';
import { DocService } from 'src/app/common/doc.service';
import { TabsStore } from 'src/app/common/tabcontroller/tabs.store';
import { DynamicFormService, getFormGroup } from 'src/app/common/dynamic-form/dynamic-form.service';
import { LoadingService } from 'src/app/common/loading.service';
import { FormBase } from '../../../../../../jetti-api/server/models/Forms/form';
import { take } from 'rxjs/operators';
import { FormTypes } from '../../../../../../jetti-api/server/models/Forms/form.types';
import { IFormControlPlacing } from 'src/app/common/dynamic-form/dynamic-form-base';
import { Subscription, BehaviorSubject } from 'rxjs';

type panelModify = 'Тип объектов' | 'Параметры' | 'Дополнительно' | 'Фильтр' | 'Список объектов' | 'Новые значения реквизитов';
type panelLoad = 'Тип объектов' | 'Параметры' | 'Фильтр' | 'Список объектов' | 'Новые значения реквизитов';

type stepModify = 'start' | 'setProps' | 'setValues' | 'final';
type stepLoad = 'start' | 'dsad';

type mode = 'LOAD' | 'MODIFY';

const readFileAsText = (file) =>
  new Promise<string>((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsText(file);
    reader.onload = () => {
      resolve(reader.result as string);
    };
    reader.onerror = (error) => reject(error);
  });

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-objects-group-modify',
  templateUrl: './ObjectsGroupModify.form.component.html'
})
export class ObjectsGroupModifyComponent extends _baseDocFormComponent implements OnInit, OnDestroy {

  onlyViewMode = false;
  header = 'Групповое изменение объектов';
  clientDataStorage = '';
  step: stepLoad | stepModify | '' = 'start';
  panelsBySteps: {
    step: stepLoad | stepModify | '',
    panels: panelModify[] | panelLoad[],
    activePanel: panelModify | panelLoad
  }[];
  currentControls;
  step$ = new BehaviorSubject<stepLoad | stepModify | ''>('start');
  currentControls$ = new BehaviorSubject<any[]>([]);

  sub: Subscription;

  get Mode() { return this.form.get('Mode').value as mode; }
  get isModeLoad() { return this.Mode === 'LOAD'; }
  get isModeModify() { return this.Mode === 'MODIFY'; }
  get controlsPlacement() { return <IFormControlPlacing[]>this.form['controlsPlacement']; }

  constructor(
    public router: Router, public route: ActivatedRoute, public auth: AuthService,
    public ds: DocService, public tabStore: TabsStore, public dss: DynamicFormService,
    public lds: LoadingService, public cd: ChangeDetectorRef) {
    super(router, route, auth, ds, tabStore, dss, cd);
  }

  ngOnInit() {
    super.ngOnInit();
    const id = this.route.snapshot.params.id;
    this.step$.subscribe(step => { this.step = step; this.currentControlsRefresh(); });
    this.currentControls$.subscribe(controls =>
      this.currentControls = controls
    );
    this.currentControlsRefresh();
    this.form.get('Mode').setValue('MODIFY');
  }

  ngOnDestroy() {
    super.ngOnDestroy();
    this.step$.complete();
    this.currentControls$.complete();
  }

  close() {
    this.form.markAsPristine();
    super.close();
  }

  isPanelActive(panel: panelLoad | panelModify) {
    return !!this.panelsBySteps.find(e => e.step === this.step && e.activePanel === panel);
  }

  currentControlsRefresh() {
    this.fillStepsByPanels();
    const currentPanels = this.panelsBySteps.find(e => e.step === this.step);
    this.currentControls = this.controlsPlacement
      .filter(e => !!currentPanels.panels.find(cp => cp === e.panel))
      .map(e => ({ ...e, isActive: currentPanels.activePanel === e.panel }));
    this.currentControls$.next(this.currentControls);
  }

  fillStepsByPanels() {
    switch (this.Mode) {
      case 'MODIFY':
        this.panelsBySteps = [
          { step: 'start', panels: ['Тип объектов'], activePanel: 'Тип объектов' },
          { step: 'setProps', panels: ['Параметры'], activePanel: 'Параметры' },
          { step: 'setValues', panels: ['Параметры', 'Фильтр', 'Новые значения реквизитов', 'Тип объектов', 'Дополнительно'], activePanel: 'Фильтр' },
          // tslint:disable-next-line: max-line-length
          { step: 'final', panels: ['Параметры', 'Фильтр', 'Новые значения реквизитов', 'Список объектов', 'Дополнительно'], activePanel: 'Список объектов' },
        ];
        break;
      default:
        this.panelsBySteps = [{ step: 'start', panels: ['Тип объектов'], activePanel: 'Тип объектов' }];
        break;
    }
  }

  PasteTable() {
    const pastedValue = this.form.get('Text').value as string;
    if (!pastedValue) this.throwError('!', 'Не задан текст');
    const sep = this.getSeparators();
    const rows = pastedValue.split(sep.rows);
    if (!rows.length) this.throwError('!', 'Не найден разделитель строк');
    const cols = rows[0].split(sep.columns);
    if (!cols.length) this.throwError('!', 'Не найден разделитель колонок');
  }

  controlsByPanel(panel?: panelModify | panelLoad): IFormControlPlacing[] {
    const filt = panel ? e => e.panel === panel : e => !e.panel;
    return this.controlsPlacement.filter(filt);
  }

  getSeparators(): { rows: string, columns: string } {
    return { rows: this.form.get('RowsSeparator').value || '\n', columns: this.form.get('ColumnsSeparator').value || '\t' };
  }
  async matchColumnsByName() {
    await this.ExecuteServerMethod('matchColumnsByName');
  }

  async prepareToLoading() {
    await this.ExecuteServerMethod('prepareToLoading');
  }

  async fillLoadingTable() {
    await this.ExecuteServerMethod('fillLoadingTable');
  }

  async loadToTempTable() {
    await this.ExecuteServerMethod('loadToTempTable');
  }

  async saveDataIntoDB() {
    await this.ExecuteServerMethod('saveDataIntoDB');
  }

  async saveToJSON() {
    const docs = this.form.get('ObjectsList').value;
    if (!docs || !docs.length) return;
    const json = await this.ds.api.documentsDataAsJSON((docs as [{ id: string }]).map(e => e.id));
    if (json) this.ds.download(json, 'docInJSON.json');
    // await this.ExecuteServerMethod('exportToFile', 'final');
  }


  async loadFromJSON(event) {
    const file = event.files[0];
    this.form.get('Text').setValue(await readFileAsText(file));
    await this.ExecuteServerMethod('loadFromJSON', 'final');
  }

  async fillPropSettings() {
    await this.ExecuteServerMethod('fillPropSettings', 'setProps');
  }

  async createFilterAndModifyElements() {
    await this.ExecuteServerMethod('createFilterAndModifyElements', 'setValues');
  }

  async modify() {
    await this.ExecuteServerMethod('Modify', 'final');
  }

  async selectFilter() {
    await this.ExecuteServerMethod('selectFilter', 'final');
  }

  saveTableToCSV(tableName: string, colSplitter = ';') {
    const tableControl = this.form.get(tableName);
    if (!tableControl) this.throwError('!', `Table ${tableName} not found!`);
    const val = tableControl.value;
    if (!val || !val.length) this.throwError('!', `Table ${tableName} is empty!`);

    const valueToString = (anyVal: any) => {
      if (!anyVal) return '';
      if (typeof anyVal === 'string' || typeof anyVal === 'number') return anyVal;
      return anyVal && anyVal.type ? Object.values(anyVal).map(key => key).join(colSplitter) : JSON.stringify(anyVal);
    };

    const savedVal = val as Array<{}>;
    const head = savedVal[0];
    let res = Object.keys(head)
      .map(col => head[col] && head[col].type ? Object.keys(head[col]).map(key => col + '.' + key).join(colSplitter) : col)
      .join(colSplitter);
    savedVal.forEach(row =>
      res += '\n' + Object.values(row)
        .map(value => valueToString(value))
        .join(colSplitter)
    );
    this.ds.download(res, `T2C ${new Date}.csv`);
  }

  async saveToFile() {
    this.saveTableToCSV('ObjectsList');
  }

  async ReadRecieverStructure() {
    await this.ExecuteServerMethod('ReadRecieverStructure');
  }

  async ExecuteServerMethod(methodName: string, nextStep?: stepLoad | stepModify | '') {

    this.clientDataStorage = this.form.get('Text').value;
    this.ds.api.execute(this.type as FormTypes, methodName, this.form.getRawValue() as FormBase).pipe(take(1))
      .subscribe(value => {
        const form = getFormGroup(value.schema, value.model, true);
        form['metadata'] = value.metadata;
        super.Next(form);
        if (nextStep) this.step$.next(nextStep);
        this.form.get('Text').setValue(this.clientDataStorage);
        this.form.markAsDirty();
      });
  }
}

