import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, OnDestroy, OnInit, QueryList, ViewChildren } from '@angular/core';
import { FormArray, FormGroup } from '@angular/forms';
import { merge, Subscription } from 'rxjs';
import { filter } from 'rxjs/operators';
import { ColumnDef } from '../../../../../../jetti-api/server/models/column';
import { TableDynamicControl } from '../../common/dynamic-form/dynamic-form-base';
import { cloneFormGroup, patchOptionsNoEvents } from '../../common/dynamic-form/dynamic-form.service';
import { ApiService } from '../../services/api.service';
import { EditableColumn } from '../datatable/table';
import { DocService } from '../doc.service';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-table-part-png',
  templateUrl: './table-parts.png.component.html',
})
export class TablePartsComponent implements OnInit, OnDestroy {
  @Input() formGroup: FormArray;
  @Input() control: TableDynamicControl;
  @ViewChildren(EditableColumn) editableColumns: QueryList<EditableColumn>;

  dataSource: any[];
  columns: ColumnDef[] = [];
  selection: any[] = [];
  showTotals = false;

  private _subscription$: Subscription = Subscription.EMPTY;
  private _valueChanges$: Subscription = Subscription.EMPTY;

  constructor(private api: ApiService, private ds: DocService, private cd: ChangeDetectorRef) { }

  ngOnInit() {
    this.columns = this.control.controls.map((el) => <ColumnDef>{
      field: el.key, type: el.controlType, label: el.label, hidden: el.hidden, onChange: el.onChange, onChangeServer: el.onChangeServer,
      order: el.order, style: el.style, required: el.required, readOnly: el.readOnly, totals: el.totals, value: el.value, control: el,
      headerStyle: { ...el.style, 'text-align' : 'center'}
    });
    this.control.controls.forEach(v => v.showLabel = false);
    this.showTotals = this.control.controls.findIndex(v => v.totals > 0) !== -1;
    this.dataSource = this.formGroup.getRawValue();

    this._subscription$ = merge(...[this.ds.save$, this.ds.delete$]).pipe(
      filter(doc => doc.id === this.formGroup.root.value.id)).subscribe(doc => {
        this.dataSource = doc[this.control.key];
        this.cd.detectChanges();
      });
  }

  getControl(i: number) {
    return this.formGroup.at(i) as FormGroup;
  }

  getControlValue(index: number, field: string, type: string) {

    const control = this.getControl(index).get(field);
    if (!control) return null;
    const value = control.value;
    if (type === 'datetime' && this.isDate(value)) return value;
    if (type === 'date' && this.isDate(value)) return value;
    const result = value && (value.value || typeof value === 'object' ? value.value || '' : value || '');
    return result;
  }

  private addCopy(newFormGroup: FormGroup) {
    newFormGroup.controls['index'].setValue(this.formGroup.length, patchOptionsNoEvents);
    this.formGroup.push(newFormGroup);
    this.dataSource.push(newFormGroup.getRawValue());
    this.selection = [newFormGroup.getRawValue()];
    this.formGroup.markAsDirty();
  }

  add() {
    const newFormGroup = cloneFormGroup(this.formGroup['sample']);
    Object.values(newFormGroup.controls).forEach(c => { if (c.validator) { c.setErrors({ 'required': true }, { emitEvent: false }); } });
    this.addCopy(newFormGroup);
    setTimeout(() => {
      const rows = this.editableColumns.toArray();
      const firsFiled = rows[0].field;
      for (let i = rows.length - 1; i >= 0; i--) {
        if (rows[i].field === firsFiled) return rows[i].openCell();
      }
    });
  }

  copy() {
    const newFormGroup = cloneFormGroup(this.formGroup.at(this.selection[0].index) as FormGroup);
    this.addCopy(newFormGroup);
  }

  delete() {
    for (const element of this.selection) {
      const rowIndex = this.formGroup.controls.findIndex((el: FormGroup) => el.controls['index'].value === element.index);
      this.formGroup.removeAt(rowIndex);
      this.formGroup.markAsDirty();
    }
    this.renum();
    this.dataSource = this.formGroup.getRawValue();
    const index = this.selection[0].index;
    const selectRow = this.dataSource[index] || this.dataSource[index - 1];
    this.selection = selectRow ? [selectRow] : [];
  }

  private renum() {
    for (let i = 0; i < this.formGroup.length; i++) {
      this.formGroup.at(i).get('index')!.patchValue(i, { emitEvent: false });
    }
  }

  onEditComplete(event) { }
  onEditInit(event) {  }
  onEditCancel(event) { }

  calcTotals(field: string): number {
    return (this.formGroup.value as any[]).map(v => v[field]).reduce((a, b) => a + b, 0);
  }

  isDate(value) {
    return value instanceof Date;
  }

  ngOnDestroy() {
    this._subscription$.unsubscribe();
    this._valueChanges$.unsubscribe();
  }

}
