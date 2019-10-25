import { A11yModule } from '@angular/cdk/a11y';
import { NgModule } from '@angular/core';
import { FlexLayoutModule } from '@angular/flex-layout';

@NgModule({
  exports: [
    FlexLayoutModule,
    A11yModule,
  ]
})
export class MaterialModule { }
