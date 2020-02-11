import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, OnDestroy, OnInit, Output, EventEmitter } from '@angular/core';
import { FormGroup } from '@angular/forms';
import { Subscription } from 'rxjs';
import { ApiService } from '../../services/api.service';
import { FormControlInfo } from './dynamic-form-base';
import { DocService } from '../doc.service';
import { getFormGroup, patchOptionsNoEvents } from './dynamic-form.service';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-control',
  templateUrl: 'dynamic-form-control.component.html'
})
export class DynamicFormControlComponent implements OnInit, OnDestroy {
  @Input() control: FormControlInfo;
  @Input() form: FormGroup;
  @Input() appendTo;
  @Output() change = new EventEmitter();
  get formControl() { return this.form.get(this.control.key); }

  valueChanges$: Subscription = Subscription.EMPTY;

  _dateTimeValue: Date | null | string;
  get dateTimeValue() { return this._dateTimeValue instanceof Date ? this._dateTimeValue : null; }
  set dateTimeValue(value: null | string | Date) { this._dateTimeValue = value instanceof Date ? value : null; }

  parseDate(dateString: string) {
    const date = dateString ? new Date(dateString) : null;
    if (date instanceof Date) this.formControl.setValue(date);
    else if (!date && this.control.required) this.formControl.setErrors({ 'invalid date': true });
    else if (!date && !this.control.required) this.formControl.setValue(date);
  }

  constructor(public api: ApiService, private cd: ChangeDetectorRef, private ds: DocService) { }

  ngOnInit() {

    this.dateTimeValue = this.formControl.value;

    this.valueChanges$ = this.formControl.valueChanges.subscribe(async value => {
      this.change.emit(value);
      if (this.form.root['metadata'].module) {
        const func = new Function('', this.form.root['metadata'].module).bind(this)();
        const method = func[this.control.key + '_OnChange'];
        if (method) await method();
      }
      if (this.formControl && (this.control.onChange || this.control.onChangeServer)) {
        if (this.control.onChange) {
          const funcBody = ((this.control.onChange.toString().match(/function[^{]+\{([\s\S]*)\}$/)) || [])[1]
            .replace(/\api\./g, 'await api.');
          const func = new Function('doc, value, api, body', `
            var AsyncFunction = Object.getPrototypeOf(async function(){}).constructor;
            var func = new AsyncFunction('doc, value, api', body);
            return func(doc, value, api, body);
            `);
          const patch = await func(this.form.getRawValue(), value, this.api, funcBody);
          this.form.patchValue(patch || {});
          this.cd.markForCheck();
        }

        if (this.control.onChangeServer) {
          this.api.valueChanges((this.form.root as FormGroup).getRawValue(), this.control.key, value)
            .then(patch => {
              const form = getFormGroup(patch.schema, patch.model, true);
              form['metadata'] = patch.metadata;
              this.ds.form(form);
            });
        }
      }
    });
  }

  marginTop() {
    if (!this.control.showLabel) return;
    if (this.control.type === 'datetime' || this.control.type === 'date') return '24px'; else return '24px';
  }

  ngOnDestroy() {
    this.valueChanges$.unsubscribe();
  }

}
