import { AttachmentsComponent } from './../common/attachment/attachments.component';
import { BaseHierarchyListComponent } from './../common/datatable/base.hierarchy-list.component';
import { CommonModule } from '@angular/common';
import { NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { BaseTreeListComponent } from '../common/datatable/base.tree-list.component';
import { PipesModule } from '../common/pipes';
import { RegisterAccumulationComponent } from '../common/register-movements/register.accumulation.component';
import { RegisterMovementsListComponent } from '../common/register-movements/register.movements.list.component';
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
import { RegisterAccountMovementsComponent } from '../common/register-movements/register-account.component';
import { TabControllerComponent } from './../common/tabcontroller/tabcontroller.component';
import { SuggestDialogComponent } from './../dialog/suggest.dialog.component';
import { SuggestDialogHierarchyComponent } from './../dialog/suggest.dialog.hierarchy.component';
import { HomeComponent } from './../home/home.component';
import { MaterialModule } from './../material.module';
import { OperationListComponent } from './Operation/operation.list.component';
import { DisableControlDirective } from '../common/directives/disabled-control';
import { HistoryComponent } from '../common/history/history.component';
import { DescendantsComponent } from '../common/descendants/descendants.component';

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
    BaseHierarchyListComponent,

    TablePartsComponent,
    SuggestDialogComponent,
    SuggestDialogHierarchyComponent,

    RegisterAccountMovementsComponent,
    RegisterAccumulationComponent,
    RegisterMovementsListComponent,
    RegisterInfoComponent,

    OperationListComponent,

    HistoryComponent,
    AttachmentsComponent,
    DescendantsComponent

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
    BaseHierarchyListComponent,

    TablePartsComponent,
    SuggestDialogComponent,
    SuggestDialogHierarchyComponent,

    RegisterAccountMovementsComponent,
    RegisterAccumulationComponent,
    RegisterMovementsListComponent,
    RegisterInfoComponent,

    OperationListComponent,

    HistoryComponent,
    AttachmentsComponent,
    DescendantsComponent
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
    BaseHierarchyListComponent,
    OperationListComponent,
  ]
})
export class DynamicFormsModule { }
