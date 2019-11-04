import { CdkTrapFocus } from '@angular/cdk/a11y';
import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, QueryList, ViewChildren } from '@angular/core';
import { MediaObserver } from '@angular/flex-layout';
import { FormControl, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { FormBase, FormOptions } from '../../../../../../jetti-api/server/models/Forms/form';
import { AuthService } from '../../auth/auth.service';
import { DocService } from '../../common/doc.service';
import { FormControlInfo } from 'src/app/common/dynamic-form/dynamic-form-base';
import { TabsStore } from 'src/app/common/tabcontroller/tabs.store';
import { take } from 'rxjs/operators';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-batch-form',
  templateUrl: './batch.form.component.html'
})
export class BatchFormComponent {

  @Input() id = Math.random().toString();
  @Input() type = this.route.snapshot.params.type as string;
  @Input() form: FormGroup = this.route.snapshot.data.detail;
  @ViewChildren(CdkTrapFocus) cdkTrapFocus: QueryList<CdkTrapFocus>;

  get model() { return this.form.getRawValue() as FormBase; }

  isDoc = this.type.startsWith('Document.');
  isCopy = this.route.snapshot.queryParams.command === 'copy';
  get docDescription() { return <string>this.form['metadata'].description; }
  get metadata() { return <FormOptions>this.form['metadata']; }
  get relations() { return this.form['metadata'].relations || []; }
  get v() { return <FormControlInfo[]>this.form['orderedControls']; }
  get vk() { return <{ [key: string]: FormControlInfo }>this.form['byKeyControls']; }
  get viewModel() { return this.form.getRawValue(); }
  get hasTables() { return !!(<FormControlInfo[]>this.form['orderedControls']).find(t => t.type === 'table'); }
  get tables() { return (<FormControlInfo[]>this.form['orderedControls']).filter(t => t.type === 'table'); }
  get description() { return <FormControl>this.form.get('description'); }

  constructor(public router: Router, public route: ActivatedRoute, public media: MediaObserver,
    public cd: ChangeDetectorRef, public ds: DocService, private auth: AuthService, public tabStore: TabsStore) { }

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

  async Execute(): Promise<any> {
    console.log(this.model);
    this.ds.api.execute('Form.Batch', this.model).pipe(take(1))
      .subscribe(data => {
        console.log('Execute: ', data);
      });
  }

}
