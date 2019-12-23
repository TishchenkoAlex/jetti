import { NgModule } from '@angular/core';
import { SyncFormComponent } from './Forms/sync.form.component';
import { DynamicFormsModule } from './dynamic.froms.module';
import { TaskListComponent } from './BusinessProcesses/tasks-list.component';
import { TaskComponent } from './BusinessProcesses/task.component';
import { DocumentCashRequestComponent } from './Documents/Document.CashRequest';

@NgModule({
  declarations: [
    SyncFormComponent,
    TaskListComponent,
    TaskComponent,
    DocumentCashRequestComponent
  ],
  imports: [
    DynamicFormsModule
  ],
  exports: [
  ],
  providers: [
  ],
  entryComponents: [
    SyncFormComponent,
    TaskListComponent,
    TaskComponent,
    DocumentCashRequestComponent
  ]
})
export class UserFormsModule { }
