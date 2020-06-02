import { Component, ChangeDetectionStrategy, OnInit, OnDestroy, ChangeDetectorRef } from '@angular/core';
import { _baseDocFormComponent } from 'src/app/common/form/_base.form.component';
import { Router, ActivatedRoute } from '@angular/router';
import { AuthService } from 'src/app/auth/auth.service';
import { DocService } from 'src/app/common/doc.service';
import { TabsStore } from 'src/app/common/tabcontroller/tabs.store';
import { DynamicFormService, getFormGroup } from 'src/app/common/dynamic-form/dynamic-form.service';
import { LoadingService } from 'src/app/common/loading.service';
import { take, filter } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import { MenuItem } from 'primeng/api';
import * as IO from 'socket.io-client';
import { IFormControlPlacing } from 'src/app/common/dynamic-form/dynamic-form-base';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-queue-manager',
  templateUrl: './queue-manager.form.component.html'
})
export class QueueManagerComponent extends _baseDocFormComponent implements OnInit, OnDestroy {

  splitCommands: {
    remove: MenuItem[],
    cancel: MenuItem[],
    queue: MenuItem[],
    add: MenuItem[]
  };

  get controlsPlacement() { return <IFormControlPlacing[]>this.form['controlsPlacement']; }

  IOData = [];
  constructor(
    public router: Router, public route: ActivatedRoute, public auth: AuthService,
    public ds: DocService, public tabStore: TabsStore, public dss: DynamicFormService,
    public lds: LoadingService, public cd: ChangeDetectorRef) {
    super(router, route, auth, ds, tabStore, dss, cd);
  }

  ngOnInit() {
    super.ngOnInit();
    this.form.get('Status').setValue('all');
    this.fillCommands();
    this.auth.userProfile$.pipe(filter(u => !!(u && u.account))).subscribe(u => {
      const wsUrl = `${environment.socket}?token=${u.token}`;

      const socket = IO(wsUrl, { transports: ['websocket'] });
      socket.on('sync', (data: any) => {
        if (data && data.data && data.data.message)
          this.IOData = [data.data.message, ...this.IOData];
        if (this.IOData.length > 1000) this.IOData.length = 1000;
        this.cd.detectChanges();
      });

      socket.on('customTask', (data: any) => {
        if (data && data.data && data.data.message)
          this.IOData = [data.data.message, ...this.IOData];
        if (this.IOData.length > 1000) this.IOData.length = 1000;
        this.cd.detectChanges();
      });

      socket.on('timeout', (data: any) => {
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

  fillCommands() {
    this.splitCommands = {
      queue: [{
        label: 'Остановить выполнение (PAUSE)', icon: 'pi pi-times', command: () => this.executeServerMethod('suspendJobs')
      }, {
        label: 'Запустить выполнение (RESUME)', icon: 'pi pi-fast-forward', command: () => this.executeServerMethod('processJobs')
      }
        // {
        //   label: 'Получить процецессы (get workers)', command: () => this.executeServerMethod('getWorkers')
        // }
      ],
      add: [ {
        label: 'Создать', command: () => this.executeServerMethod('addJobCustomTask')
      }],
      remove: [{
        label: 'Выделенные', command: () => this.executeServerMethod('removeJobsSelected')
      }, {
        label: 'ВСЕ', command: () => this.executeServerMethod('removeJobsAll')
      }],
      cancel: [{
        label: 'Выделенные', command: () => this.executeServerMethod('cancelJobsSelected')
      }, {
        label: 'ВСЕ', command: () => this.executeServerMethod('cancelJobsAll')
      }],
    };
  }

  async executeServerMethod(methodName: string) {

    this.ds.api.execute(this.type as any, methodName, this.form.getRawValue() as any).pipe(take(1))
      .subscribe(value => {
        const form = getFormGroup(value.schema, value.model, true);
        form['metadata'] = value.metadata;
        super.Next(form);
        this.form.markAsDirty();
      });
  }


  close() {
    this.form.markAsPristine();
    super.close();
  }

}

