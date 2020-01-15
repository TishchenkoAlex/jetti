// tslint:disable:max-line-length
import { ChangeDetectionStrategy, ChangeDetectorRef, Component, EventEmitter, forwardRef, Input, Output, ViewChild, OnInit, OnDestroy } from '@angular/core';
import { AbstractControl, ControlValueAccessor, FormControl, FormGroup, NG_VALIDATORS, NG_VALUE_ACCESSOR, ValidationErrors, Validator, ValidatorFn } from '@angular/forms';
import { Router } from '@angular/router';
import { AutoComplete } from 'primeng/components/autocomplete/autocomplete';
import { Observable, Subscription, of } from 'rxjs';
import { ISuggest } from '../../../../../../jetti-api/server/models/common-types';
import { OwnerRef, StorageType } from '../../../../../../jetti-api/server/models/document';
import { FormListSettings } from '../../../../../../jetti-api/server/models/user.settings';
import { ApiService } from '../../services/api.service';
import { IComplexObject } from '../dynamic-form/dynamic-form-base';
import { calendarLocale, dateFormat } from './../../primeNG.module';
import { createDocument } from '../../../../../../jetti-api/server/models/documents.factory';
import { v1 } from 'uuid';
import { DocService } from '../doc.service';
import { filter } from 'rxjs/operators';
import { AllTypes } from '../../../../../../jetti-api/server/models/documents.types';
import { patchOptionsNoEvents } from '../dynamic-form/dynamic-form.service';
import { Hotkeys } from 'src/app/services/hotkeys.service';

function AutocompleteValidator(component: AutocompleteComponent): ValidatorFn {
  return (c: AbstractControl) => {
    if (!component.required || (c.value && c.value.value)) return null;
    return { 'required': true };
  };
}

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-autocomplete-png',
  templateUrl: './autocomplete.png.component.html',
  providers: [
    { provide: NG_VALUE_ACCESSOR, useExisting: forwardRef(() => AutocompleteComponent), multi: true },
    { provide: NG_VALIDATORS, useExisting: forwardRef(() => AutocompleteComponent), multi: true, },
  ]
})
export class AutocompleteComponent implements ControlValueAccessor, Validator, OnInit, OnDestroy {
  locale = calendarLocale; dateFormat = dateFormat;

  @Input() readOnly = false;
  @Input() owner: OwnerRef[];
  @Input() placeholder = '';
  @Input() required = false;
  @Input() hidden = false;
  @Input() storageType: StorageType;
  @Input() tabIndex = -1;
  @Input() showOpen = true;
  @Input() showFind = true;
  @Input() showClear = true;
  @Input() showLabel = true;
  @Input() type: AllTypes;
  @Input() inputStyle: { [x: string]: any };
  @Input() checkValue = true;
  @Input() openButton = true;
  @Output() change = new EventEmitter();
  @Output() focus = new EventEmitter();
  @ViewChild('ac', { static: false }) input: AutoComplete;
  @Input() id: string;
  @Input() formControl: FormControl;
  @Input() appendTo;

  form: FormGroup = new FormGroup({
    suggest: new FormControl({ value: this.value }, AutocompleteValidator(this))
  });
  suggest = this.form.controls['suggest'] as FormControl;
  Suggests$: Observable<ISuggest[]>;

  private NO_EVENT = false;
  private _docSubscription$: Subscription = Subscription.EMPTY;

  showDialog = false;
  filters = new FormListSettings();
  uuid = v1();

  get isComplexValue() { return this.value && this.value.type && this.value.type.includes('.'); }
  get isTypeControl() { return this.type && this.type.startsWith('Types.'); }
  get isComplexControl() { return this.type && this.type.includes('.'); }
  get isTypeValue() { return this.value && this.value.type && this.value.type.startsWith('Types.'); }
  get EMPTY() { return { id: null, code: null, type: this.type, value: null }; }
  get isEMPTY() { return this.isComplexControl && !(this.value && this.value.value); }
  get isCatalogParent() { return this.type.startsWith('Catalog.') && this.id === 'parent'; }
  get hierarchy() { return (createDocument(this.type as any).Props()).hierarchy; }

  private _value: IComplexObject;
  @Input() set value(obj) {
    if (this.isTypeControl && this.placeholder) {
      this.placeholder = this.placeholder.split('[')[0] + '[' + (obj && obj.type ? obj.type : '') + ']';
    }
    if (this._value && (this._value.id === obj.id)) {
      this._value = obj;
      this.suggest.patchValue(this._value, patchOptionsNoEvents);
      this.NO_EVENT = false;
      return;
    }
    this._value = obj;
    this.suggest.patchValue(this._value);
    if (!this.NO_EVENT) { this.onChange(this._value); this.change.emit(this._value); }
    this.NO_EVENT = false;
  }
  get value() { return this._value; }

  // implement ControlValueAccessor interface
  onChange = (value: any) => { };
  registerOnChange(fn: any): void { this.onChange = fn; }
  onTouched = () => { };
  registerOnTouched(fn: any): void { this.onTouched = fn; }
  setDisabledState?(isDisabled: boolean): void { if (isDisabled) this.suggest.disable(); }

  writeValue(obj: any): void {
    this.NO_EVENT = true;
    if (!obj) obj = this.EMPTY;
    if (!this.type) this.type = obj.type;
    if (this.isComplexControl && (typeof obj === 'number' || typeof obj === 'boolean' || typeof obj === 'string') ||
      (obj && obj.type && obj.type !== this.type && !this.isTypeControl)) obj = this.EMPTY;
    this.value = obj;
    this.suggest.markAsDirty({ onlySelf: true });
    this.cd.markForCheck();

  }
  // end of implementation ControlValueAccessor interface

  // implement Validator interface
  validate(c: AbstractControl): ValidationErrors | null {
    if (!this.required || (c.value && c.value.value)) return null;
    return { 'required': true };
  }
  // end of implementation Validator interface

  constructor(private api: ApiService, private router: Router, private cd: ChangeDetectorRef, private ds: DocService, private hotkeys: Hotkeys) { }

  ngOnInit() {
    this._value = this.EMPTY;
    this._docSubscription$ = this.ds.showDialog$.pipe(
      filter(uuid => this.uuid === uuid.uuid)).
      subscribe(uuid => {
        if (uuid.doc && uuid.doc.timestamp) {
          this.value = { id: uuid.doc.id, code: uuid.doc.code, type: uuid.doc.type, value: uuid.doc.description };
        }
        this.handleSearch(undefined);
        this.cd.markForCheck();
      });

      this.hotkeys.addShortcut({ keys: 'Shift.F4', description: 'Clear' }).subscribe( () => {this.handleReset(new Event('keypress')); });
      this.hotkeys.addShortcut({ keys: 'F4', description: 'Choise' }).subscribe( () => {this.handleSearch(new Event('keypress')); });
      this.hotkeys.addShortcut({ keys: 'F2', description: 'Open' }).subscribe( () => {this.handleOpen(new Event('keypress')); });
  }

  getSuggests(text: string) {
    if (this.isTypeValue) { this.Suggests$ = of([]); this.value = this.EMPTY; return; }
    this.filters = this.calcFilters();
    this.Suggests$ = this.api.getSuggests(this.value.type || this.type, text, this.filters.filter);
  }

  handleReset = (event: Event) => this.value = this.EMPTY;
  handleOpen = (event: Event) => this.router.navigate([this.value.type || this.type, this.value.id]);
  handleSearch = (event: Event) => {
    if (!this.isTypeValue) this.filters = this.calcFilters(); else this.filters = new FormListSettings();
    this.showDialog = true;
  }

  select = () => setTimeout(() => {
    if (this.input && this.input.inputEL && this.input.inputEL.nativeElement) {
      this.input.inputEL.nativeElement.select();
      this.input.inputEL.nativeElement.focus();
    }
  })
  onBlur = (event: Event) => {
    if (this.value && this.suggest.value && (this.value.id !== this.suggest.value.id)) { this.value = this.value; }
  }

  searchComplete(row: ISuggest) {
    this.showDialog = false;
    this.select();
    if (!row) return;
    this.value = { id: this.isTypeValue ? null : row.id, code: row.code, type: row.type, value: this.isTypeValue ? null : row.value };
  }

  calcFilters(data?: any) {
    const result = new FormListSettings();
    if (this.owner && this.owner.length) {
      for (const row of this.owner) {
        const fc = this.formControl.parent.get(row.dependsOn) || this.formControl.root.get(row.dependsOn);
        if (fc && fc.value)
          result.filter.push({ left: row.filterBy, center: '=', right: fc!.value });
      }
    }
    if (this.storageType === 'folders') { result.filter.push({ left: 'isfolder', center: '=', right: true }); }
    if (this.storageType === 'elements') { result.filter.push({ left: 'isfolder', center: '=', right: false }); }
    if (this.storageType === 'all') { result.filter.push({ left: 'isfolder', center: '=', right: undefined }); }
    if (this.type.startsWith('Document.')) {
      const doc = this.formControl && this.formControl.root.value;
      if (doc && doc.company.id) {
        result.filter.push({ left: 'company', center: '=', right: doc.company });
      }
    }
    return result;
  }

  calcDialogWidth() {
    return Math.max(Math.floor(window.innerWidth / 2.5), 400);
  }

  parseDate(dateString: string) {
    const date = dateString ? new Date(dateString) : null;
    if (date instanceof Date) this.formControl.setValue(date);
    else if (!date && this.required) this.formControl.setErrors({ 'invalid date': true });
    else if (!date && !this.required) this.formControl.setValue(date);
  }

  isDate(value) {
    return value instanceof Date;
  }

  ngOnDestroy() {
    this._docSubscription$.unsubscribe();
  }

}
