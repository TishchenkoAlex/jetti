import { Injectable } from '@angular/core';
import { AbstractControl, FormArray, FormControl, FormGroup, Validators } from '@angular/forms';
import { of } from 'rxjs';
import { map } from 'rxjs/operators';
import { createForm } from '../../../../../../jetti-api/server/models/Forms/form.factory';
import { FormTypes } from '../../../../../../jetti-api/server/models/Forms/form.types';
import { ApiService } from '../../services/api.service';
// tslint:disable-next-line:max-line-length
import { AutocompleteFormControl, BooleanFormControl, DateFormControl, DateTimeFormControl, EnumFormControl, FormControlInfo, IFormControlInfo, NumberFormControl, ScriptFormControl, TableDynamicControl, TextareaFormControl, TextboxFormControl, ControlTypes, LinkFormControl } from './dynamic-form-base';
import { StorageType } from '../../../../../../jetti-api/server/models/document';
import { AllTypes } from '../../../../../../jetti-api/server/models/documents.types';

export function cloneFormGroup(formGroup: FormGroup): FormGroup {
  const newFormGroup = new FormGroup({});
  Object.keys(formGroup.controls).forEach(key => {
    const sourceFormControl = formGroup.controls[key] as FormControl;
    const cloneValue = typeof sourceFormControl.value === 'object' ?
      { ...sourceFormControl.value } : sourceFormControl.value;
    const cloneFormControl = sourceFormControl.validator ?
      new FormControl(cloneValue, { validators: sourceFormControl.validator }) :
      new FormControl(cloneValue);
    newFormGroup.registerControl(key, cloneFormControl);
  });
  return newFormGroup;
}

function toFormGroup(controls: FormControlInfo[]) {
  const group: { [key: string]: AbstractControl } = {};

  controls.forEach(control => {
    if (control instanceof TableDynamicControl) {
      const Row: { [key: string]: AbstractControl } = {};
      const arr: FormGroup[] = [];
      for (const item of control.controls) {
        Row[item.key] = item.required ? new FormControl(item.value, Validators.required) : new FormControl(item.value);
        Row[item.key]['formControlInfo'] = item;
      }
      arr.push(new FormGroup(Row));
      group[control.key] = control.required ? new FormArray(arr, Validators.required) : new FormArray(arr);
    } else {
      group[control.key] = control.required ? new FormControl(control.value, Validators.required) : new FormControl(control.value);
    }
    group[control.key]['formControlInfo'] = control;
  });
  const result = new FormGroup(group);
  return result;
}

export const patchOptionsNoEvents = { onlySelf: false, emitEvent: false, emitModelToViewChange: false, emitViewToModelChange: false };

export function getFormGroup(schema: { [x: string]: any }, model: { [x: string]: any }, isExists: boolean): FormGroup {
  let controls: FormControlInfo[] = [];

  const processRecursive = (v: { [x: string]: any }, f: FormControlInfo[]) => {
    Object.keys(v).map(key => {
      const prop = v[key];
      const hidden = !!prop['hidden'];
      const order = hidden ? -1 : prop['order'] * 1 || 999;
      const label: string = prop['label'] || key.toString();
      const type = prop['type'] || 'string' as AllTypes;
      const controlType = prop['controlType'] || prop['type'] || 'string' as ControlTypes;
      const required = !!prop['required'];
      const readOnly = !!prop['readOnly'];
      const disabled = !!prop['disabled'];
      const style = prop['style'];
      const totals = prop['totals'];
      const change = prop['change'];
      const owner = prop['owner'] || null;
      const onChange = prop['onChange'];
      const onChangeServer = !!prop['onChangeServer'];
      const storageType = prop['storageType'] as StorageType || 'elements';
      const headerStyle = prop['headerStyle'];
      const showLabel = prop['showLabel'] || true;
      const valuesOptions = prop['valuesOptions'] || [];
      let value = prop['value'];
      let newControl: FormControlInfo;
      const controlOptions: IFormControlInfo = {
        key, label, type: controlType, required, readOnly, headerStyle, showLabel, valuesOptions, controlType,
        hidden, disabled, change, order, style, onChange, owner, totals, onChangeServer, value, storageType
      };
      switch (controlType) {
        case 'table':
          value = [];
          processRecursive(v[key][key] || {}, value);
          newControl = new TableDynamicControl(controlOptions);
          (newControl as TableDynamicControl).controls = value;
          break;
        case 'boolean':
          newControl = new BooleanFormControl(controlOptions);
          break;
        case 'date':
          newControl = new DateFormControl(controlOptions);
          break;
        case 'datetime':
          newControl = new DateTimeFormControl(controlOptions);
          break;
        case 'number':
          newControl = new NumberFormControl(controlOptions);
          break;
        case 'javascript': case 'json':
          newControl = new ScriptFormControl(controlOptions);
          break;
        case 'textarea':
          newControl = new TextareaFormControl(controlOptions);
          break;
        case 'enum':
          newControl = new EnumFormControl(controlOptions);
          break;
        case 'link':
          newControl = new LinkFormControl(controlOptions);
          break;
        default:
          if (type.includes('.')) {
            controlOptions.type = controlType; // здесь нужен тип ссылки
            newControl = new AutocompleteFormControl(controlOptions);
            break;
          }
          newControl = new TextboxFormControl(controlOptions);
          break;
      }
      f.push(newControl);
    });
    f.sort((a, b) => a.order - b.order);
  };

  processRecursive(schema, controls);

  const formGroup = toFormGroup(controls);

  // Create formArray's for table parts of document
  Object.keys(formGroup.controls)
    .filter(property => formGroup.controls[property] instanceof FormArray)
    .forEach(property => {
      const sample = (formGroup.controls[property] as FormArray).controls[0] as FormGroup;
      sample.addControl('index', new FormControl(0));
      const formArray = formGroup.controls[property] as FormArray;
      if (isExists) {
        if (!model[property]) { model[property] = []; }
        for (let i = 0; i < model[property].length; i++) {
          const newFormGroup = cloneFormGroup(sample);
          newFormGroup.controls['index'].setValue(i, patchOptionsNoEvents);
          formArray.push(newFormGroup);
        }
      }
      formArray['sample'] = cloneFormGroup(formArray.at(0) as FormGroup);
      formArray.removeAt(0);
    });
  formGroup.patchValue(model, patchOptionsNoEvents);
  formGroup['schema'] = schema;

  controls = [
    ...controls.filter(el => el.order > 0 && el.controlType !== 'table' && !(el.key === 'f1' || el.key === 'f2' || el.key === 'f3')),
    ...controls.filter(el => el.order > 0 && el.controlType === 'table' && !(el.key === 'f1' || el.key === 'f2' || el.key === 'f3')),
    ...controls.filter(el => el.order <= 0 && !(el.key === 'f1' || el.key === 'f2' || el.key === 'f3'))
  ];
  const byKeyControls: { [s: string]: FormControlInfo } = {};
  controls.forEach(c => { byKeyControls[c.key] = c; });

  formGroup['orderedControls'] = controls;
  formGroup['byKeyControls'] = byKeyControls;
  return formGroup;
}

@Injectable()
export class DynamicFormService {

  constructor(public api: ApiService) { }

  getViewModel$(docType: string, docID = '', queryParams: { [key: string]: any } = {}) {
    return this.api.getViewModel(docType, docID, queryParams).pipe(
      map(response => {
        const form = getFormGroup(response.schema, response.model, docID !== 'new');
        form['metadata'] = response.metadata;
        return form;
      }));
  }

  getFormView$(type: FormTypes) {
    const form = createForm({ type: type });
    const view = form.Props();
    const result = getFormGroup(view, {}, false);
    result['metadata'] = form.Prop();
    return of(result);
  }

}
