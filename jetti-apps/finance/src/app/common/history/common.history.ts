import { ChangeDetectionStrategy, Component, Input, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { map, share } from 'rxjs/operators';
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
  historyList$: Observable<IHistory[]>;
  // additionalColumns$: Observable<string[]>;
  selection: IHistory | null = null;

  constructor(private apiService: ApiService) { }

  ngOnInit() {
    this.historyList$ = this.apiService.getHistoryById(this.doc.id);
  }

  isNumbert(value): boolean {
    return Number.parseInt(value, 0) * 0 === 0;
  }

}

export interface IHistory {
  data: Date;
  UserName: string;
  Posted: boolean;
  Deleted: boolean;
  user: string;
  info: string;
  timestamp: Date;
}
