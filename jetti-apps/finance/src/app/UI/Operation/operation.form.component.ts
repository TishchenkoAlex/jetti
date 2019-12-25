import { AfterViewInit, ChangeDetectionStrategy, Component, OnDestroy, ViewChild } from '@angular/core';
import { MenuItem } from 'primeng/components/common/menuitem';
import { Subscription } from 'rxjs';
import { CatalogOperation } from '../../../../../../jetti-api/server/models/Catalogs/Catalog.Operation';
import { DocumentOptions } from '../../../../../../jetti-api/server/models/document';
import { createDocument } from '../../../../../../jetti-api/server/models/documents.factory';
import { DocumentOperation } from '../../../../../../jetti-api/server/models/Documents/Document.Operation';
import { FormControlInfo } from '../../common/dynamic-form/dynamic-form-base';
import { getFormGroup } from '../../common/dynamic-form/dynamic-form.service';
import { BaseDocFormComponent } from '../../common/form/base.form.component';

@Component({
  changeDetection: ChangeDetectionStrategy.Default,
  template: `
  <j-form></j-form>`
})
export class OperationFormComponent implements AfterViewInit, OnDestroy {
  private _subscription$: Subscription = Subscription.EMPTY;

  get form() { return this.super.form; }
  set form(value) { this.super.form = value; }
  get Operation() { return this.form.get('Operation')!; }

  @ViewChild(BaseDocFormComponent, {static: false}) super: BaseDocFormComponent;

  async ngAfterViewInit() {
    this.form['metadata']['copyTo'] = [];
    const Operation = this.Operation && this.Operation.value && this.Operation.value.id ?
      await this.super.ds.api.byId<CatalogOperation>(this.Operation.value.id) : null;

    for (const o of ((Operation && Operation.CopyTo) || [])) {
      const item: MenuItem = {
        icon: '',
        label: (await this.super.ds.api.byId<CatalogOperation>(o.Operation)).description,
        command: () => this.super.baseOn(this.super.type, o.Operation)
      };
      this.form['metadata']['copyTo'].push(item);
    }

    this.form['metadata']['clientModule'] = {};
    if (Operation && Operation.module) {
      const func = new Function('', Operation.module);
      this.form['metadata']['clientModule'] = func.bind(this)() || {};
    }

    this.form['metadata']['commands'] = [];
    for (const o of ((Operation && Operation.commandsOnServer) || [])) {
      const item: MenuItem = {
        label: o.label, icon: o.icon,
        command: () => this.super.commandOnSever(o.method)
      };
      this.form['metadata']['commands'].push(item);
    }

    for (const o of ((Operation && Operation.commandsOnClient) || [])) {
      const item: MenuItem = {
        label: o.label, icon: o.icon,
        command: () => this.super.commandOnClient(o.method)
      };
      this.form['metadata']['commands'].push(item);
    }

    this._subscription$.unsubscribe();
    this._subscription$ = this.Operation.valueChanges
      .subscribe(v => this.update(v).then(() => this.super.cd.markForCheck()));
  }

  update = async (value) => {
    const oldValue = Object.assign({}, this.super.model);

    const Operation = value.id ? await this.super.ds.api.byId(value.id) : { doc: { Parameters: [] } };
    const view = {};
    const Parameters = Operation['Parameters'] || [];
    Parameters.sort((a, b) => a.order - b.order).forEach(c => view[c.parameter] = {
      label: c.label, type: c.type, required: !!c.required, change: c.change, order: c.order + 103,
      [c.parameter]: c.tableDef ? JSON.parse(c.tableDef) : null, ...JSON.parse(c.Props ? c.Props : '{}')
    });

    // restore original state of Operation
    const doc = createDocument<DocumentOperation>('Document.Operation');
    const docKeys = Object.keys(doc.Props());
    Object.keys(this.form.controls).forEach(c => {
      if (!docKeys.includes(c)) {
        this.form.removeControl(c);
        delete this.form['byKeyControls'][c];
        const index = (this.form['orderedControls'] as FormControlInfo[]).findIndex(el => el.key === c);
        (this.form['orderedControls'] as FormControlInfo[]).splice(index, 1);
      }
    });

    // add dynamic formControls to Operation
    const formOperation = getFormGroup(view, oldValue, true);
    const orderedControls = formOperation['orderedControls'] as FormControlInfo[];
    orderedControls.forEach(c => {
      this.form.addControl(c.key, formOperation.controls[c.key]);
      this.form['byKeyControls'][c.key] = formOperation['byKeyControls'][c.key];
    });
    (this.form['orderedControls'] as FormControlInfo[]).splice(7, 0, ...orderedControls);
    const Prop = doc.Prop() as DocumentOptions;
    this.form['metadata'] = { ...Prop };

    this.super.cd.markForCheck();
    this.ngAfterViewInit();
  }

  Close = () => this.super.Close();
  focus = () => this.super.focus();

  ngOnDestroy() {
    this._subscription$.unsubscribe();
  }
}
