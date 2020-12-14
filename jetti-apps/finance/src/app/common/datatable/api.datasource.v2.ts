import { BehaviorSubject, Observable, of, Subject } from 'rxjs';
import { catchError, filter, map, share, switchMap, tap } from 'rxjs/operators';
import { Continuation, DocListResponse, DocListOptions } from '../../../../../../jetti-api/server/models/common-types';
import { DocTypes } from '../../../../../../jetti-api/server/models/documents.types';
import { FormListSettings } from '../../../../../../jetti-api/server/models/user.settings';
import { ApiService } from '../../services/api.service';
import { scrollIntoViewIfNeeded } from '../utils';
import { DocumentBase } from './../../../../../../jetti-api/server/models/document';

interface DatasourceCommand { command: string; data?: any; }

export class ApiDataSource {

  id = '';
  private paginator = new Subject<DatasourceCommand>();

  private readonly _formListSettings$ = new BehaviorSubject<FormListSettings>(new FormListSettings());
  set formListSettings(value) { this._formListSettings$.next(value); }
  get formListSettings() { return this._formListSettings$.value; }

  result$: Observable<DocumentBase[]>;
  renderedData: DocumentBase[] = [];
  renderedDataList = [];
  listOptions: DocListOptions = { withHierarchy: false, hierarchyDirectionUp: false };
  continuation: Continuation = { first: null, last: null };
  private EMPTY: DocListResponse = { data: [], continuation: { first: this.continuation.first, last: this.continuation.first } };

  constructor(public api: ApiService, public type: DocTypes, public pageSize = 10, direction = false) {

    this.result$ = this.paginator.pipe(
      filter(stream => !(
        (stream.command === 'prev' && !this.continuation.first) ||
        (stream.command === 'next' && !this.continuation.last))),
      switchMap(stream => {
        let offset = 0;
        let id = this.id;
        switch (stream.command) {
          case 'prev': id = this.continuation.first!.id as string; break;
          case 'next': id = this.continuation.last!.id as string; break;
          case 'refresh': case 'sort': case undefined:
            offset = this.renderedDataList.findIndex(r => r.id === id);
            if (offset === -1) offset = 0;
            else if (this.listOptions.withHierarchy) {
              const row = this.renderedDataList[offset];
              if (!row.isfolder) { offset = offset - this.renderedDataList.filter(e => e.isfolder).length; }
            }
            stream.command = 'sort';
            break;
        }
        return this.api.getDocList(this.type, id, stream.command, this.pageSize, offset,
          this.formListSettings.order, this.formListSettings.filter,
          this.listOptions).pipe(
            tap(data => {
              this.renderedData = data.data;
              this.renderedDataList = data.data;
              this.continuation = data.continuation;
              setTimeout(() => scrollIntoViewIfNeeded(type, 'ui-state-highlight', direction));
            }),
            catchError(err => {
              this.renderedData = this.EMPTY.data;
              this.continuation = this.EMPTY.continuation;
              return of(this.EMPTY);
            }));
      }),
      map(data => data.data), share());
  }

  refresh(id: string) { this.id = id; this.paginator.next({ command: 'refresh' }); }
  goto(id: string) { this.id = id; this.paginator.next({ command: 'goto' }); }
  sort() { this.paginator.next({ command: 'sort' }); }
  first() { this.paginator.next({ command: 'first' }); }
  last() { this.paginator.next({ command: 'last' }); }
  next() { this.paginator.next({ command: 'next' }); }
  prev() { this.paginator.next({ command: 'prev' }); }

}
