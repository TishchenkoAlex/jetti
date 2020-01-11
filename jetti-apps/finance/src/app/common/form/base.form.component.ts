import { _baseDocFormComponent } from './_base.form.component';
import { Component, ChangeDetectionStrategy, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { Router, ActivatedRoute } from '@angular/router';
import { LoadingService } from '../loading.service';
import { AuthService } from '../../auth/auth.service';
import { DocService } from '../doc.service';
import { TabsStore } from '../tabcontroller/tabs.store';
import { DynamicFormService } from '../dynamic-form/dynamic-form.service';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-form',
  templateUrl: './base.form.component.html'
})
export class BaseDocFormComponent extends _baseDocFormComponent implements OnInit, OnDestroy {

  constructor(
    public router: Router, public route: ActivatedRoute, public auth: AuthService,
    public ds: DocService, public tabStore: TabsStore, public dss: DynamicFormService,
    public lds: LoadingService, public cd: ChangeDetectorRef) {
    super(router, route, auth, ds, tabStore, dss, cd);
  }

  ngOnInit() {
    super.ngOnInit();
  }

  ngOnDestroy() {
    super.ngOnDestroy();
  }
}
