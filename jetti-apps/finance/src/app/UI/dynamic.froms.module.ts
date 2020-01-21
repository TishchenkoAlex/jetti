import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { BaseTreeListComponent } from '../common/datatable/base.tree-list.component';
import { BaseTreeListToolbarComponent } from '../common/datatable/base.tree-list.toolbar.component';
import { PipesModule } from '../common/pipes';
import { RegisterAccumulationComponent } from '../common/register-movements/register.accumulation.component';
import { RegisterAccumulationListComponent } from '../common/register-movements/register.accumulation.list.component';
import { RegisterInfoComponent } from '../common/register-movements/register.info.component';
import { TabsStore } from '../common/tabcontroller/tabs.store';
import { PrimeNGModule } from '../primeNG.module';
import { AutocompleteComponent } from './../common/autocomplete/autocomplete.png.component';
import { BaseDocListComponent } from './../common/datatable/base.list.component';
import { TablePartsComponent } from './../common/datatable/table-parts.png.component';
import { DocService } from './../common/doc.service';
import { DynamicComponent, DynamicComponentDirective } from './../common/dynamic-component/dynamic-component';
import { DynamicFormControlComponent } from './../common/dynamic-form/dynamic-form-control.component';
import { DynamicFormService } from './../common/dynamic-form/dynamic-form.service';
import { BaseDocFormComponent } from './../common/form/base.form.component';
import { BaseFormComponent } from './../common/forms/base.form.component';
import { RegisterMovementComponent } from './../common/register-movements/register-movement.component';
import { TabControllerComponent } from './../common/tabcontroller/tabcontroller.component';
import { SuggestDialogComponent } from './../dialog/suggest.dialog.component';
import { HomeComponent } from './../home/home.component';
import { MaterialModule } from './../material.module';
import { CatalogListComponent } from './../UI/Catalog/calatog-list.component';
import { OperationFormComponent } from './Operation/operation.form.component';
import { OperationListComponent } from './Operation/operation.list.component';
import { DisableControlDirective } from '../common/directives/disabled-control';
import { HistoryComponent } from '../common/history/common.history';

@NgModule({
  declarations: [
    HomeComponent,
    TabControllerComponent,

    DynamicComponentDirective,
    DynamicComponent,
    DynamicFormControlComponent,
    AutocompleteComponent,

    DisableControlDirective,

    BaseDocListComponent,
    BaseDocFormComponent,
    BaseFormComponent,
    BaseTreeListComponent,
    BaseTreeListToolbarComponent,
    CatalogListComponent,

    TablePartsComponent,
    SuggestDialogComponent,

    RegisterMovementComponent,
    RegisterAccumulationComponent,
    RegisterAccumulationListComponent,
    RegisterInfoComponent,

    OperationFormComponent,
    OperationListComponent,

    HistoryComponent,

  ],
  imports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule,
    PipesModule,
    PrimeNGModule,
  ],
  exports: [
    CommonModule,
    FormsModule,
    ReactiveFormsModule,
    MaterialModule,
    PipesModule,
    PrimeNGModule,
    HomeComponent,
    TabControllerComponent,

    DynamicComponentDirective,
    DynamicComponent,
    DynamicFormControlComponent,
    AutocompleteComponent,

    DisableControlDirective,

    BaseDocListComponent,
    BaseDocFormComponent,
    BaseFormComponent,
    BaseTreeListComponent,
    BaseTreeListToolbarComponent,
    CatalogListComponent,

    TablePartsComponent,
    SuggestDialogComponent,

    RegisterMovementComponent,
    RegisterAccumulationComponent,
    RegisterAccumulationListComponent,
    RegisterInfoComponent,

    OperationFormComponent,
    OperationListComponent,

    HistoryComponent,
  ],
  providers: [
    DynamicFormService,
    DocService,
    TabsStore,
  ],
  entryComponents: [
    SuggestDialogComponent,
    HomeComponent,
    BaseDocListComponent,
    BaseDocFormComponent,
    BaseFormComponent,
    BaseTreeListComponent,
    BaseTreeListToolbarComponent,
    CatalogListComponent,

    OperationFormComponent,
    OperationListComponent,
  ]
})
export class DynamicFormsModule { }
