import { Type } from '@angular/core';
import { BaseDocListComponent } from '../common/datatable/base.list.component';
import { BaseFormComponent } from '../common/forms/base.form.component';
import { HomeComponent } from '../home/home.component';
import { BaseDocFormComponent } from './../common/form/base.form.component';
import { OperationFormComponent } from './Operation/operation.form.component';
import { OperationListComponent } from './Operation/operation.list.component';
import { BatchFormComponent } from './Forms/batch.form.component';

const userForms: { [x: string]: { formComponent: Type<any>, listComponent: Type<any> } } = {
  'home': { formComponent: HomeComponent, listComponent: HomeComponent },
  'Document.Operation': { formComponent: OperationFormComponent, listComponent: OperationListComponent },
  'Form.Post': { formComponent: BaseFormComponent, listComponent: BaseFormComponent },
  'Form.Batch': { formComponent: BatchFormComponent, listComponent: BatchFormComponent },
  // add user's defined component for list- or doc-Form here
};

export function getListComponent(type: string) {
  return userForms[type] ? userForms[type].listComponent : BaseDocListComponent;
}

export function getFormComponent(type: string) {
  return userForms[type] ? userForms[type].formComponent : BaseDocFormComponent;
}
