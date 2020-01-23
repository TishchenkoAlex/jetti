import { ChangeDetectionStrategy, Component, Input, OnInit, OnDestroy } from '@angular/core';
import { Subject, Subscription, merge } from 'rxjs';
import { take, filter } from 'rxjs/operators';
import { ApiService } from '../../services/api.service';
import { DocumentBase } from '../../../../../../jetti-api/server/models/document';
import { Router } from '@angular/router';
import { DocService } from '../doc.service';
import { LoadingService } from '../loading.service';
import { getFormGroup } from '../dynamic-form/dynamic-form.service';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-history',
  templateUrl: './history.component.html',
})
export class HistoryComponent implements OnInit, OnDestroy {

  @Input() doc: DocumentBase;
  selection: any;
  private _subscription$: Subscription = Subscription.EMPTY;
  historyListSub$ = new Subject<any[]>();
  constructor(private apiService: ApiService, public router: Router, private ds: DocService, public lds: LoadingService) { }

  ngOnInit() {
    this._subscription$ = merge(...[this.ds.save$, this.ds.delete$, this.ds.post$, this.ds.unpost$]).pipe(
      filter(document => document.id === this.doc.id))
      .subscribe(document => {
        this.apiService.getHistoryById(this.doc.id).pipe(take(1)).subscribe(data => { this.historyListSub$.next(data); });
      });
    this.apiService.getHistoryById(this.doc.id).pipe(take(1)).subscribe(data => { this.historyListSub$.next(data); });
  }

  openOnClick() {
    this.openHistory(this.selection);
    // this.selection.forEach(el => {this.openHistory(el); });
  }

  openHistory(histData) {
    // console.log(histData);
    this.router.navigate([this.doc.type, histData.id], { queryParams: { history: histData.id } });
  }

  restore() {
    this.apiService.restoreObjectFromHistory(this.selection.id, this.doc.type).subscribe(data => {
      const form = getFormGroup(data.schema, data.model, true);
      form['metadata'] = data.metadata;
      form.markAsDirty();
      this.ds.openSnackBar('success', 'Restored', 'Restored');
      this.ds.form(form);
    });
  }

  ngOnDestroy() {
    this._subscription$.unsubscribe();
  }
}
