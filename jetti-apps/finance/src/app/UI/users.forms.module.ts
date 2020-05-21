import { QueueManagerComponent } from './Forms/queue-manager.form.component';
import { NgModule } from '@angular/core';
import { SyncFormComponent } from './Forms/sync.form.component';
import { DynamicFormsModule } from './dynamic.froms.module';
import { TaskListComponent } from './BusinessProcesses/tasks-list.component';
import { TaskComponent } from './BusinessProcesses/task.component';
import { DocumentCashRequestComponent } from './Documents/Document.CashRequest';
import { SearchAndReplaceComponent } from './Forms/search-and-replace.component';
import { ObjectsGroupModifyComponent } from './Forms/ObjectsGroupModify.form.component';

@NgModule({
  declarations: [
    SearchAndReplaceComponent,
    ObjectsGroupModifyComponent,
    SyncFormComponent,
    TaskListComponent,
    TaskComponent,
    DocumentCashRequestComponent,
    QueueManagerComponent
  ],
  imports: [
    DynamicFormsModule
  ],
  exports: [
  ],
  providers: [
  ],
  entryComponents: [
    SearchAndReplaceComponent,
    ObjectsGroupModifyComponent,
    SyncFormComponent,
    TaskListComponent,
    TaskComponent,
    DocumentCashRequestComponent,
    QueueManagerComponent
  ]
})
export class UserFormsModule { }
