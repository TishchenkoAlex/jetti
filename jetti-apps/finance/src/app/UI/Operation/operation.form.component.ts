import { AfterViewInit, ChangeDetectionStrategy, Component, ViewChild, Input } from '@angular/core';
import { MenuItem } from 'primeng/components/common/menuitem';
import { CatalogOperation } from '../../../../../../jetti-api/server/models/Catalogs/Catalog.Operation';
import { DocumentOptions } from '../../../../../../jetti-api/server/models/document';
import { createDocument } from '../../../../../../jetti-api/server/models/documents.factory';
import { DocumentOperation } from '../../../../../../jetti-api/server/models/Documents/Document.Operation';
import { FormControlInfo } from '../../common/dynamic-form/dynamic-form-base';
import { getFormGroup } from '../../common/dynamic-form/dynamic-form.service';
import { BaseDocFormComponent } from '../../common/form/base.form.component';
import { take } from 'rxjs/operators';
import { FormGroup } from '@angular/forms';
import { DocTypes } from '../../../../../../jetti-api/server/models/documents.types';

@Component({
  changeDetection: ChangeDetectionStrategy.Default,
  template: `
  <j-form [id]="this.id" [type]="this.type" [data]="this.data"></j-form>`
})
export class OperationFormComponent implements AfterViewInit {
  @Input() id: string;
  @Input() type: DocTypes;
  @Input() data: FormGroup;

  get Form() { return this.super.data; }
  get Operation() { return this.Form.get('Operation')!; }

  @ViewChild(BaseDocFormComponent, { static: false }) super: BaseDocFormComponent;

  async ngAfterViewInit() {
    this.Form['metadata']['copyTo'] = [];
    const Operation = this.Operation && this.Operation.value && this.Operation.value.id ?
      await this.super.ds.api.byId<CatalogOperation>(this.Operation.value.id) : null;

    for (const o of ((Operation && Operation.CopyTo) || [])) {
      const item: MenuItem = {
        icon: '',
        label: (await this.super.ds.api.byId<CatalogOperation>(o.Operation)).description,
        command: () => this.super.baseOn(this.super.type, o.Operation)
      };
      this.Form['metadata']['copyTo'].push(item);
    }

    this.Form['metadata']['clientModule'] = {};
    if (Operation && Operation.module) {
      const func = new Function('', Operation.module);
      this.Form['metadata']['clientModule'] = func.bind(this)() || {};
    }

    this.Form['metadata']['commands'] = [];
    for (const o of ((Operation && Operation.commandsOnServer) || [])) {
      const item: MenuItem = {
        label: o.label, icon: o.icon,
        command: () => this.super.commandOnSever(o.method)
      };
      this.Form['metadata']['commands'].push(item);
    }

    for (const o of ((Operation && Operation.commandsOnClient) || [])) {
      const item: MenuItem = {
        label: o.label, icon: o.icon,
        command: () => this.super.commandOnClient(o.method)
      };
      this.Form['metadata']['commands'].push(item);
    }

    this.Operation.valueChanges.pipe(take(1)).subscribe(async v => {
      await this.update(v);
      this.super.data = this.Form;
      setTimeout(() => this.super.cd.detectChanges());
    });
  }

  update = async (value) => {
    const oldValue = Object.assign({}, this.super.data.getRawValue());

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
    Object.keys(this.Form.controls).forEach(c => {
      if (!docKeys.includes(c)) {
        this.Form.removeControl(c);
        delete this.Form['byKeyControls'][c];
        const index = (this.Form['orderedControls'] as FormControlInfo[]).findIndex(el => el.key === c);
        (this.Form['orderedControls'] as FormControlInfo[]).splice(index, 1);
      }
    });

    // add dynamic formControls to Operation
    const formOperation = getFormGroup(view, oldValue, true);
    const orderedControls = formOperation['orderedControls'] as FormControlInfo[];
    orderedControls.forEach(c => {
      this.Form.addControl(c.key, formOperation.controls[c.key]);
      this.Form['byKeyControls'][c.key] = formOperation['byKeyControls'][c.key];
    });
    (this.Form['orderedControls'] as FormControlInfo[]).splice(7, 0, ...orderedControls);
    const Prop = doc.Prop() as DocumentOptions;
    this.Form['metadata'] = { ...Prop };
    await this.ngAfterViewInit();
  }

  close = () => this.super.close();
  focus = () => this.super.focus();

}
