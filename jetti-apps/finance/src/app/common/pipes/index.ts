import { NgModule } from '@angular/core';
import { EllipsisPipe } from './ellipsis';
import { NumericPipe } from './numeric';

export const PIPES = [EllipsisPipe, NumericPipe];

@NgModule({
  declarations: PIPES,
  exports: PIPES,
})
export class PipesModule {}

