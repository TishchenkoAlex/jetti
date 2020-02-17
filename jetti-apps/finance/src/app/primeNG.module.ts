import locale from '@angular/common/locales/ru';
import { NgModule } from '@angular/core';
import { CovalentCodeEditorModule } from '@covalent/code-editor';
import { ConfirmationService } from 'primeng/api';
import { AutoCompleteModule } from 'primeng/autocomplete';
import { ButtonModule } from 'primeng/button';
import { CalendarModule } from 'primeng/calendar';
import { CheckboxModule } from 'primeng/checkbox';
import { MessageService } from 'primeng/components/common/messageservice';
import { ConfirmDialogModule } from 'primeng/confirmdialog';
import { ContextMenuModule } from 'primeng/contextmenu';
import { DialogModule } from 'primeng/dialog';
import { DropdownModule } from 'primeng/dropdown';
import { FieldsetModule } from 'primeng/fieldset';
import { InputTextModule } from 'primeng/inputtext';
import { InputTextareaModule } from 'primeng/inputtextarea';
import { PaginatorModule } from 'primeng/paginator';
import { PanelModule } from 'primeng/panel';
import { ProgressBarModule } from 'primeng/progressbar';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
import { ScrollPanelModule } from 'primeng/scrollpanel';
import { SelectButtonModule } from 'primeng/selectbutton';
import { SpinnerModule } from 'primeng/spinner';
import { SplitButtonModule } from 'primeng/splitbutton';
import { TabViewModule } from 'primeng/tabview';
import { ToastModule } from 'primeng/toast';
import { ToolbarModule } from 'primeng/toolbar';
import { AccordionModule } from 'primeng/accordion';
import { TooltipModule } from 'primeng/tooltip';
import { TreeTableModule } from 'primeng/treetable';
import { TriStateCheckboxModule } from 'primeng/tristatecheckbox';
import { TableModule } from './common/datatable/table';

@NgModule({
  exports: [
    // SharedModule,
    // DataTableModule,
    AutoCompleteModule,
    CalendarModule,
    ButtonModule,
    SplitButtonModule,
    SpinnerModule,
    ConfirmDialogModule,
    DialogModule,
    // SidebarModule,
    TooltipModule,
    AccordionModule,
    FieldsetModule,
    // MessagesModule,
    // MessageModule,
    TreeTableModule,
    SelectButtonModule,
    InputTextModule,
    // ChipsModule,
    DropdownModule,
    InputTextareaModule,
    // InputMaskModule,
    // PasswordModule,
    // ToggleButtonModule,
    CheckboxModule,
    TriStateCheckboxModule,
    // RadioButtonModule,
    PaginatorModule,
    ToolbarModule,
    PanelModule,
    // MenuModule,
    ContextMenuModule,
    // PanelMenuModule,
    // TabMenuModule,
    // MegaMenuModule,
    // SlideMenuModule,
    // BreadcrumbModule,
    // TieredMenuModule,
    // StepsModule,
    // DragDropModule,
    ProgressBarModule,
    ProgressSpinnerModule,
    // MultiSelectModule,
    // InplaceModule,
    // BlockUIModule,
    ToastModule,
    ScrollPanelModule,
    TableModule,
    TabViewModule,

    CovalentCodeEditorModule
  ],
    providers: [ConfirmationService, MessageService]
})
export class PrimeNGModule { }

export const calendarLocale = {
  firstDayOfWeek: 1,
  dayNames: locale[3]![2],
  dayNamesShort: locale[3]![0],
  dayNamesMin: locale[3]![0],
  monthNames: locale[5]![2],
  monthNamesShort: locale[5]![1],
  today: 'Today',
  clear: 'Clear'
};

export const dateFormat = 'dd.mm.yy';
