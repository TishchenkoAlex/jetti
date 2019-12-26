import { Type } from '@angular/core';
import { BaseDocListComponent } from '../common/datatable/base.list.component';
import { HomeComponent } from '../home/home.component';
import { BaseDocFormComponent } from './../common/form/base.form.component';
import { OperationFormComponent } from './Operation/operation.form.component';
import { OperationListComponent } from './Operation/operation.list.component';
import { SyncFormComponent } from './Forms/sync.form.component';
import { TaskListComponent } from './BusinessProcesses/tasks-list.component';
import { DocumentCashRequestComponent } from './Documents/Document.CashRequest';
import { CashRequestDesktopComponent } from './Forms/CashRequestDesktop.form.component';

const userForms: { [x: string]: { formComponent: Type<any>, listComponent: Type<any> } } = {
  'home': { formComponent: HomeComponent, listComponent: HomeComponent },
  'Document.Operation': { formComponent: OperationFormComponent, listComponent: OperationListComponent },
  'Form.PostAfterEchange': { formComponent: SyncFormComponent, listComponent: SyncFormComponent },
  'Form.BusinessProcessTasks': { formComponent: TaskListComponent, listComponent: TaskListComponent },
  'Form.CashRequestDesktop': { formComponent: CashRequestDesktopComponent, listComponent: CashRequestDesktopComponent },
  'Document.CashRequest': { formComponent: DocumentCashRequestComponent, listComponent: BaseDocListComponent },
  // add user's defined component for list- or doc-Form here
};

export function getListComponent(type: string) {
  return userForms[type] ? userForms[type].listComponent : BaseDocListComponent;
}

export function getFormComponent(type: string) {
  return userForms[type] ? userForms[type].formComponent : BaseDocFormComponent;
}
