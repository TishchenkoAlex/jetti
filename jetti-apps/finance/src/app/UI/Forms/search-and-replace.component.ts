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
  selector: 'j-search-and-replace',
  templateUrl: './search-and-replace.component.html'
})
export class SearchAndReplaceComponent extends _baseDocFormComponent implements OnInit, OnDestroy {

  onlyViewMode = false;
  header = 'Search and replace'

  constructor(
    public router: Router, public route: ActivatedRoute, public auth: AuthService,
    public ds: DocService, public tabStore: TabsStore, public dss: DynamicFormService,
    public lds: LoadingService, public cd: ChangeDetectorRef) {
    super(router, route, auth, ds, tabStore, dss, cd);
  }

  ngOnInit() {
    super.ngOnInit();
    const id = this.route.snapshot.params.id;
    if (id) {
      this.ds.api.byId(id).then(val => {
        if (!val) return;
        this.onlyViewMode = true;
        this.form.get('OldValue').setValue({ id: val.id, code: val.code, type: val.type, value: val.description });
        this.fillHeader();
        this.ExecuteServerMethod('Search').then();
      });
    }
  }

  ngOnDestroy() {
    super.ngOnDestroy();
  }

  fillHeader() {
    const oldval = this.form.get('OldValue').value;
    console.log(oldval);
    this.header = this.onlyViewMode ? `${oldval ? oldval.value : ''} used in` : `Search and replace`;
  }

  close() {
    this.form.markAsPristine();
    super.close();
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

