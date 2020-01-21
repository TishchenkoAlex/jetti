import { ChangeDetectionStrategy, Component, Input, OnInit } from '@angular/core';
import { Observable, Subject } from 'rxjs';
import { map, share, take } from 'rxjs/operators';
import { ApiService } from '../../services/api.service';
import { DocumentBase } from '../../../../../../jetti-api/server/models/document';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-history',
  templateUrl: './common.history.html',
  // styleUrls: ['./register.accumulation.component.scss']
})

export class HistoryComponent implements OnInit {

  @Input() doc: DocumentBase;

  historyListSub$ = new Subject<any[]>();
  constructor(private apiService: ApiService) { }

  ngOnInit() {
    this.apiService.getHistoryById(this.doc.id).pipe(take(1)).subscribe(data => {this.historyListSub$.next(data)});
  }
}
