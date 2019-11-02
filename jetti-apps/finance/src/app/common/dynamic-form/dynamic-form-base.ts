export interface OwnerRef { dependsOn: string; filterBy: string; }

export type ControlTypes = 'string' | 'number' | 'boolean' | 'date' | 'datetime' | 'table' | 'enum';

export interface IFormControlInfo {
  type: string;
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
}

export class FormControlInfo {
  type: string;
  key: string;
  label: string;
  required: boolean;
  readOnly: boolean;
  hidden: boolean;
  disabled?: boolean;
  order: number;
  controlType: string;
  style: { [key: string]: any };
  headerStyle: { [key: string]: any };
  owner?: OwnerRef[];
  totals: number;
  showLabel: boolean;
  value: any;
  valuesOptions: { label: string, value: string | null }[];
  change: string;
  onChange?: ((doc: any, value: any) => Promise<any>) | string;
  onChangeServer?: boolean;

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
  value = '';
  controlType = 'string';
  type = 'string';
  constructor(options: IFormControlInfo) {
    super(options);
    if (options.style) this.style = options.style;
  }
}

export class EnumFormControl extends FormControlInfo {
  value = '';
  controlType = 'enum';
  type = 'string';
  constructor(options: IFormControlInfo) {
    super(options);
    if (options.style) this.style = options.style;
    this.valuesOptions = [
      { label: '', value: null },
      ...(options.value as string[])
        .map(el => ({ label: el, value: el }))
    ];
  }
}

export class TextareaFormControl extends FormControlInfo {
  value = '';
  controlType = 'textarea';
  type = 'string';
  style = { 'min-width': '100%' };
  constructor(options: IFormControlInfo) {
    super(options);
    if (options.style) this.style = options.style;
  }
}

export class BooleanFormControl extends FormControlInfo {
  value = false;
  controlType = 'boolean';
  type = 'boolean';
  style = { 'min-width': '24px', 'max-width': '24px', 'width': '90px', 'text-align': 'center', 'margin-top': '26px' };
  constructor(options: IFormControlInfo) {
    super(options);
    if (options.style) this.style = options.style;
  }
}

export class DateFormControl extends FormControlInfo {
  value = new Date();
  controlType = 'date';
  type = 'date';
  style = { 'min-width': '130px', 'max-width': '130px', 'width': '130px' };
  constructor(options: IFormControlInfo) {
    super(options);
    if (options.style) this.style = options.style;
  }
}

export class DateTimeFormControl extends FormControlInfo {
  value = new Date();
  controlType = 'datetime';
  type = 'datetime';
  style = { 'min-width': '195px', 'max-width': '195px', 'width': '195px' };
  constructor(options: IFormControlInfo) {
    super(options);
    if (options.style) this.style = options.style;
  }
}

export class NumberFormControl extends FormControlInfo {
  value = 0;
  controlType = 'number';
  type = 'number';
  style = { 'min-width': '100px', 'max-width': '100px', 'width': '100px', 'text-align': 'right' };
  constructor(options: IFormControlInfo) {
    super(options);
    if (options.style) this.style = options.style;
  }
}

export interface IComplexObject {
  id: string | null; value: string | null; code: string | null; type: string | null; data?: any | null;
}

export class AutocompleteFormControl extends FormControlInfo {
  controlType = 'autocomplete';
  style = { 'width': '250px', 'min-width': '250px', 'max-width': '250px' };
  value: IComplexObject = { id: null, code: null, type: this.type, value: null };
  constructor(options: IFormControlInfo) {
    super(options);
    if (options.style) this.style = options.style;
  }
}

export class TableDynamicControl extends FormControlInfo {
  controlType = 'table';
  type = 'table';
  controls: FormControlInfo[] = [];
}

export class ScriptFormControl extends FormControlInfo {
  value = '';
  controlType = 'script';
  type = 'javascipt';
  style = { 'width': '600px', 'min-width': '600px', 'max-width': '600px' };

  constructor(options: IFormControlInfo) {
    super(options);
    if (options.style) this.style = options.style;
    if (options.type) this.type = options.type;
  }
}

