import { CdkTrapFocus } from '@angular/cdk/a11y';
import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, QueryList, ViewChildren, OnDestroy, OnInit } from '@angular/core';
import { MediaObserver } from '@angular/flex-layout';
import { FormControl, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { FormBase } from '../../../../../../jetti-api/server/models/Forms/form';
import { AuthService } from '../../auth/auth.service';
import { DocService } from '../../common/doc.service';
import { FormControlInfo } from 'src/app/common/dynamic-form/dynamic-form-base';
import { TabsStore } from 'src/app/common/tabcontroller/tabs.store';
import { take, filter, sampleTime, shareReplay } from 'rxjs/operators';
import { environment } from 'src/environments/environment';
import * as IO from 'socket.io-client';
import { Subject } from 'rxjs';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-batch-form',
  templateUrl: './batch.form.component.html'
})
export class BatchFormComponent implements OnDestroy, OnInit {

  @Input() id = Math.random().toString();
  @Input() type = this.route.snapshot.params.type as string;
  @Input() form: FormGroup = this.route.snapshot.data.detail;
  @ViewChildren(CdkTrapFocus) cdkTrapFocus: QueryList<CdkTrapFocus>;

  get model() { return this.form.getRawValue() as FormBase; }

  get docDescription() { return <string>this.form['metadata'].description; }
  get v() { return <FormControlInfo[]>this.form['orderedControls']; }
  get vk() { return <{ [key: string]: FormControlInfo }>this.form['byKeyControls']; }
  get hasTables() { return !!(<FormControlInfo[]>this.form['orderedControls']).find(t => t.type === 'table'); }
  get tables() { return (<FormControlInfo[]>this.form['orderedControls']).filter(t => t.type === 'table'); }
  get description() { return <FormControl>this.form.get('description'); }

  data = [];
  private readonly _batchActual$ = new Subject<any[]>();
  batchActual$ = this._batchActual$.asObservable();
  socket: SocketIOClient.Socket;

  private readonly _bacthLog$ = new Subject<any[]>();
  bacthLog$ = this._bacthLog$.asObservable();

  constructor(public router: Router, public route: ActivatedRoute, public media: MediaObserver,
    public cd: ChangeDetectorRef, public ds: DocService, private auth: AuthService, public tabStore: TabsStore) {

    this.auth.userProfile$.pipe(filter(u => !!(u && u.account))).subscribe(u => {
      const wsUrl = `${environment.socket}?token=${u.token}`;
      this.socket = IO(wsUrl, { transports: ['websocket'] });
    });
  }

  ngOnDestroy() {
    this._batchActual$.complete();
    this._batchActual$.unsubscribe();
    this._bacthLog$.complete();
    this._bacthLog$.unsubscribe();
  }

  ngOnInit() {
    this.batchActualRefesh();
  }

  public async batchActualRefesh() {
    this.ds.api.batchActual().pipe(take(1)).subscribe(data => this._batchActual$.next(data));
  }

  private _close() {
    this.tabStore.close(this.tabStore.state.tabs[this.tabStore.selectedIndex]);
    const returnTab = this.tabStore.state.tabs[this.tabStore.selectedIndex];
    this.router.navigate([returnTab.docType, returnTab.docID]);
  }

  Close() {
    if (this.form.pristine) { this._close(); return; }
    this.ds.confirmationService.confirm({
      header: 'Discard changes and close?',
      message: '',
      icon: 'fa fa-question-circle',
      accept: this._close.bind(this),
      reject: this.focus.bind(this),
      key: this.id
    });
    this.cd.detectChanges();
  }

  focus() {
    const autoCapture = this.cdkTrapFocus.find(el => el.autoCapture);
    if (autoCapture) autoCapture.focusTrap.focusFirstTabbableElementWhenReady();
  }

  async Execute(row: any): Promise<any> {
    this.data = [];
    this.form.patchValue({ company: { id: row.company.id, type: 'Catalog.Company', value: row.company.description } });
    this.socket.on(`batch_${row.company.id}`, (data: any) => {
      if (data && data.data && data.data.message)
        this.data.unshift(data);
      if (this.data.length > 1000) this.data.length = 1000;
      this._bacthLog$.next(this.data);
    });

    this.ds.api.execute('Form.Batch', this.model).pipe(take(1)).subscribe();
  }

}

