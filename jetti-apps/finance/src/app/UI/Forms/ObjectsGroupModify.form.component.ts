import { Component, ChangeDetectionStrategy, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { _baseDocFormComponent } from 'src/app/common/form/_base.form.component';
import { Router, ActivatedRoute } from '@angular/router';
import { AuthService } from 'src/app/auth/auth.service';
import { DocService } from 'src/app/common/doc.service';
import { TabsStore } from 'src/app/common/tabcontroller/tabs.store';
import { DynamicFormService, getFormGroup } from 'src/app/common/dynamic-form/dynamic-form.service';
import { LoadingService } from 'src/app/common/loading.service';
import { FormBase } from '../../../../../../jetti-api/server/models/Forms/form';
import { take } from 'rxjs/operators';
import { FormTypes } from '../../../../../../jetti-api/server/models/Forms/form.types';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-objects-group-modify',
  templateUrl: './ObjectsGroupModify.form.component.html'
})
export class ObjectsGroupModifyComponent extends _baseDocFormComponent implements OnInit, OnDestroy {

  onlyViewMode = false;
  header = 'Objects group modify';

  constructor(
    public router: Router, public route: ActivatedRoute, public auth: AuthService,
    public ds: DocService, public tabStore: TabsStore, public dss: DynamicFormService,
    public lds: LoadingService, public cd: ChangeDetectorRef) {
    super(router, route, auth, ds, tabStore, dss, cd);
  }

  ngOnInit() {
    super.ngOnInit();
    const id = this.route.snapshot.params.id;
  }

  ngOnDestroy() {
    super.ngOnDestroy();
  }


  close() {
    this.form.markAsPristine();
    super.close();
  }

  PasteTable() {
    const pastedValue = this.form.get('Text').value as string;
    if (!pastedValue) this.throwError('!', 'Не задан текст');
    const sep = this.getSeparators();
    const rows = pastedValue.split(sep.rows);
    if (!rows.length) this.throwError('!', 'Не найден разделитель строк');
    const cols = rows[0].split(sep.columns);
    if (!cols.length) this.throwError('!', 'Не найден разделитель колонок');
  }

  getSeparators(): { rows: string, columns: string } {
    return { rows: this.form.get('RowsSeparator').value || '\n', columns: this.form.get('ColumnsSeparator').value || '\t' };
  }

  async getViewModel() {
    await this.ExecuteServerMethod('ReadRecieverStructure');
    return;
    const Operation = this.form.get('Operation');
    const queryParams: { [key: string]: any } = {};
    let type = '';
    if (Operation && Operation.value && Operation.value.value) {
      type = 'Document.Operation';
      queryParams.Operation = Operation.value.id;
    } else {
      const typeControl = this.form.get('Catalog');
      if (typeControl && typeControl.value && typeControl.value.id) type = typeControl.value.id;
    }
    if (!type) this.throwError('!', 'Не задан тип приемника');
    this.ds.api.getViewModel(type, '', queryParams).pipe(take(1)).subscribe(vm => {
      console.log(vm);
    });
  }

  async ExecuteServerMethod(methodName: string) {

    this.ds.api.execute(this.type as FormTypes, methodName, this.form.getRawValue() as FormBase).pipe(take(1))
      .subscribe(value => {
        const form = getFormGroup(value.schema, value.model, true);
        form['metadata'] = value.metadata;
        super.Next(form);
        this.form.markAsDirty();
      });
  }
}

