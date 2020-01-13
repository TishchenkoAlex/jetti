import { StorageType } from '../../../../../../jetti-api/server/models/document';
import { AllTypes } from '../../../../../../jetti-api/server/models/documents.types';

export interface OwnerRef { dependsOn: string; filterBy: string; }

export type ControlTypes =
  'string' | 'number' | 'boolean' | 'date' | 'datetime' | 'table' |
  'enum' | 'link' | 'textarea' | 'autocomplete' | 'script';

export interface IFormControlInfo {
  type: AllTypes;
  key: string;
  label: string;
  required: boolean;
  readOnly: boolean;
  hidden: boolean;
  disabled: boolean;
  order: number;
  style: any;
  owner?: OwnerRef[];
  totals: number;
  change: string;
  onChange?: ((doc: any, value: any) => Promise<any>) | string;
  onChangeServer?: boolean;
  value: any;
  storageType: StorageType;
  controlType: ControlTypes;
  headerStyle: { [key: string]: any };
  showLabel: boolean;
  valuesOptions: { label: string, value: string | null }[];
}

export class FormControlInfo {
  type: AllTypes;
  key: string;
  label: string;
  required: boolean;
  readOnly: boolean;
  hidden: boolean;
  disabled?: boolean;
  order: number;
  style: { [key: string]: any };
  owner?: OwnerRef[];
  totals: number;
  change: string;
  onChange?: ((doc: any, value: any) => Promise<any>) | string;
  onChangeServer?: boolean;
  value: any;
  storageType: StorageType;
  controlType: ControlTypes;
  headerStyle: { [key: string]: any };
  showLabel: boolean;
  valuesOptions: { label: string, value: string | null }[];

  constructor(options: IFormControlInfo) {
    this.type = options.type;
    this.key = options.key;
    this.label = options.label || options.key;
    this.required = !!options.required;
    this.readOnly = !!options.readOnly;
    this.hidden = !!options.hidden;
    this.disabled = !!options.disabled;
    this.order = options.order === undefined ? 9999999 : options.order;
    this.style = options.style || { 'width': '200px', 'min-width': '200px', 'max-width': '200px' };
    this.totals = options.totals;
    this.owner = options.owner;
    this.showLabel = true;
    this.storageType = options.storageType;
    this.value = options.value;
    this.valuesOptions = [];
    this.onChange = options.onChange;
    this.onChangeServer = options.onChangeServer;
    this.change = options.change;
    if (this.change && !this.onChange) {
      this.onChange = new Function('doc', 'value', 'api', this.change) as any;
    }
  }
}

export class TextboxFormControl extends FormControlInfo {
  constructor(options: IFormControlInfo) {
    super(options);
    this.type = 'string';
    this.controlType = 'string';
    if (options.style) this.style = { ...this.style, ...options.style };
    if (this.value === undefined) this.value = '';
  }
}

export class LinkFormControl extends FormControlInfo {
  constructor(options: IFormControlInfo) {
    super(options);
    this.type = 'string';
    this.controlType = 'link';
    if (options.style) this.style = { ...this.style, ...options.style };
    if (this.value === undefined) this.value = '';
  }
}

export class EnumFormControl extends FormControlInfo {
  constructor(options: IFormControlInfo) {
    super(options);
    this.controlType = 'enum';
    this.type = 'string';

    if (options.style) this.style = { ...this.style, ...options.style };
    this.valuesOptions = [
      ...(options.value as string[])
        .map(el => ({ label: el, value: el }))
    ];
    // if (this.valuesOptions.length) this.value = this.valuesOptions[0].value;
    if (this.value === undefined) this.value = '';
  }
}

export class TextareaFormControl extends FormControlInfo {
  constructor(options: IFormControlInfo) {
    super(options);
    this.type = 'string';
    this.controlType = 'textarea';
    this.style = { 'min-width': '100%', 'height': '54px' };
    if (options.style) this.style = { ...this.style, ...options.style };
    if (this.value === undefined) this.value = '';
  }
}

export class BooleanFormControl extends FormControlInfo {
  constructor(options: IFormControlInfo) {
    super(options);
    this.controlType = 'boolean';
    this.type = 'boolean';
    this.style = { 'min-width': '24px', 'max-width': '24px', 'width': '90px', 'text-align': 'center', 'margin-top': '26px' };
    if (options.style) this.style = { ...this.style, ...options.style };
    if (this.value === undefined) this.value = false;
  }
}

export class DateFormControl extends FormControlInfo {
  constructor(options: IFormControlInfo) {
    super(options);
    this.type = 'date';
    this.controlType = 'date';
    this.style = { 'min-width': '130px', 'max-width': '130px', 'width': '130px' };
    if (options.style) this.style = { ...this.style, ...options.style };
  }
}

export class DateTimeFormControl extends FormControlInfo {
  constructor(options: IFormControlInfo) {
    super(options);
    this.controlType = 'datetime';
    this.type = 'datetime';
    this.style = { 'min-width': '195px', 'max-width': '195px', 'width': '195px' };
    if (options.style) this.style = { ...this.style, ...options.style };
  }
}

export class NumberFormControl extends FormControlInfo {
  constructor(options: IFormControlInfo) {
    super(options);
    this.controlType = 'number';
    this.type = 'number';
    this.style = { 'min-width': '100px', 'max-width': '100px', 'width': '100px', 'text-align': 'right' };
    if (options.style) this.style = { ...this.style, ...options.style };
    if (this.value === undefined) this.value = 0;
  }
}

export interface IComplexObject {
  id: string | null; value: string | null; code: string | null; type: AllTypes | null; data?: any | null;
}

export class AutocompleteFormControl extends FormControlInfo {
  value: IComplexObject;
  constructor(options: IFormControlInfo) {
    super(options);
    this.controlType = 'autocomplete';
    this.style = { 'width': '250px', 'min-width': '250px', 'max-width': '250px' };
    if (options.style) this.style = { ...this.style, ...options.style };
    this.value = { id: null, code: null, type: this.type, value: null };
  }
}

export class TableDynamicControl extends FormControlInfo {
  controls: FormControlInfo[] = [];
  constructor(options: IFormControlInfo) {
    super(options);
    this.controlType = 'table';
  }
}

export class ScriptFormControl extends FormControlInfo {
  constructor(options: IFormControlInfo) {
    super(options);
    this.type = 'javascript';
    this.style = { 'width': '568px', 'min-width': '568px', 'max-width': '568px' };
    this.controlType = 'script';
    if (options.style) this.style = { ...this.style, ...options.style };
    if (options.type) this.type = options.type;
    if (this.value === undefined) this.value = '';
  }
}

