import * as IO from 'socket.io-client';
import { Component, ChangeDetectionStrategy, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { _baseDocFormComponent } from 'src/app/common/form/_base.form.component';
import { Router, ActivatedRoute } from '@angular/router';
import { AuthService } from 'src/app/auth/auth.service';
import { DocService } from 'src/app/common/doc.service';
import { TabsStore } from 'src/app/common/tabcontroller/tabs.store';
import { DynamicFormService } from 'src/app/common/dynamic-form/dynamic-form.service';
import { LoadingService } from 'src/app/common/loading.service';
import { environment } from 'src/environments/environment';
import { FormBase } from '../../../../../../jetti-api/server/models/Forms/form';
import { take, filter } from 'rxjs/operators';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-sync-form',
  templateUrl: './sync.form.component.html'
})
export class SyncFormComponent extends _baseDocFormComponent implements OnInit, OnDestroy {

  IOData = [];
  constructor(
    public router: Router, public route: ActivatedRoute, public auth: AuthService,
    public ds: DocService, public tabStore: TabsStore, public dss: DynamicFormService,
    public lds: LoadingService, public cd: ChangeDetectorRef) {
    super(router, route, auth, ds, tabStore, dss, cd);
  }

  ngOnInit() {
    super.ngOnInit();
    this.auth.userProfile$.pipe(filter(u => !!(u && u.account))).subscribe(u => {
      const wsUrl = `${environment.socket}?token=${u.token}`;

      const socket = IO(wsUrl, { transports: ['websocket'] });
      socket.on('sync', (data: any) => {
        if (data && data.data && data.data.message)
          this.IOData = [data.data.message, ...this.IOData];
          if (this.IOData.length > 1000) this.IOData.length = 1000;
          this.cd.detectChanges();
      });
    });
  }

  ngOnDestroy() {
    super.ngOnDestroy();
  }

  async Execute(): Promise<any> {
    this.ds.api.execute('Form.PostAfterEchange', 'Execute', this.viewModel as FormBase).pipe(take(1))
      .subscribe(data => {
        // this.form.patchValue(data);
      });
  }

}

