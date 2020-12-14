import { Component, OnDestroy, OnInit, ViewChild } from '@angular/core';
import { DialogService, DynamicDialogConfig, DynamicDialogRef } from 'primeng/api';
import { ColumnDef } from '../../../../../jetti-api/server/models/column';
import { FormListColumnProps, IUserSettings } from '../../../../../jetti-api/server/models/user.settings';
import { UserSettingsService } from '../auth/settings/user.settings.service';
import { Table } from '../common/datatable/table';

@Component({
    templateUrl: './columns.settings.dialog.component.html',
})
export class ColumnsSettingsComponent implements OnInit {

    @ViewChild('tbl', { static: false }) tbl: Table;
    columns: ColumnDef[];
    settingsAll: IUserSettings[];
    selectedSettings: IUserSettings;
    defaults: FormListColumnProps;
    settingsService: UserSettingsService;
    private _ColorDialogRef: DynamicDialogRef;

    constructor(public ref: DynamicDialogRef, public config: DynamicDialogConfig, public dialog: DialogService) { }

    ngOnInit() {
        this.settingsService = this.config.data['settingsService'];
        this.columns = this.config.data['columns'];
        this.settingsAll = this.settingsService.allSettings;
        this.selectedSettings = this.settingsService.selectedSettings;
    }

    invertHidden(col: ColumnDef) {
        col.hidden = !col.hidden;
    }

    onOk() { this.ref.close(this.columns); }

    onCancel() { this.ref.close(null); }

    setDefaultSettings() {
        this.columns = [...this.defaults.order.map(field => this.columns.find(col => col.field === field))];
        this.columns.forEach(col => col.hidden = !this.defaults.visibility[col.field]);
        this.tbl.reset();
    }
}
