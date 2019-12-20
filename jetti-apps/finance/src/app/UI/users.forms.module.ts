import { NgModule } from '@angular/core';
import { SyncFormComponent } from './Forms/sync.form.component';
import { DynamicFormsModule } from './dynamic.froms.module';

@NgModule({
  declarations: [
    SyncFormComponent,
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
  ]
})
export class UserFormsModule { }
