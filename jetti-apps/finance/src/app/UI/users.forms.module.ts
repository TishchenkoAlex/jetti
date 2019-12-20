import { NgModule } from '@angular/core';
import { BatchFormComponent } from './Forms/batch.form.component';
import { SyncFormComponent } from './Forms/sync.form.component';
import { DynamicFormsModule } from './dynamic.froms.module';

@NgModule({
  declarations: [
    SyncFormComponent,
    BatchFormComponent,
  ],
  imports: [
    DynamicFormsModule
  ],
  exports: [
  ],
  providers: [
  ],
  entryComponents: [
    BatchFormComponent,
    SyncFormComponent,
  ]
})
export class UserFormsModule { }
