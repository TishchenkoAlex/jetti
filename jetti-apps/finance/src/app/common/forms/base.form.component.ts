import { Component, ChangeDetectionStrategy, OnInit, OnDestroy, Input, ChangeDetectorRef } from '@angular/core';
import { _baseDocFormComponent } from '../form/_base.form.component';
import { Router, ActivatedRoute } from '@angular/router';
import { AuthService } from '../../auth/auth.service';
import { DocService } from '../doc.service';
import { TabsStore } from '../tabcontroller/tabs.store';
import { DynamicFormService } from '../dynamic-form/dynamic-form.service';
import { LoadingService } from '../loading.service';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-forms',
  templateUrl: './base.form.component.html'
})
export class BaseFormComponent extends _baseDocFormComponent implements OnInit, OnDestroy {

  @Input() id = Math.random().toString();

  constructor(
    public router: Router, public route: ActivatedRoute, public auth: AuthService,
    public ds: DocService, public tabStore: TabsStore, public dss: DynamicFormService,
    public lds: LoadingService, public cd: ChangeDetectorRef) {
    super(router, route, auth, ds, tabStore, dss, cd);
  }

  async Execute(): Promise<any> {
    const data = this.Form.value;
    return await this.ds.api.jobAdd({
      job: { id: 'post', description: 'Post documents' },
      type: data.type.id,
      company: data.company.id,
      StartDate: data.StartDate,
      EndDate: data.EndDate
    }).toPromise();
  }

}
