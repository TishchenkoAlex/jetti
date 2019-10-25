import { Injectable } from '@angular/core';
import { ConfirmationService } from 'primeng/components/common/confirmationservice';
import { MessageService } from 'primeng/components/common/messageservice';
import { Subject } from 'rxjs';
import { ApiService } from '../services/api.service';
import { DocumentBase } from './../../../../../jetti-api/server/models/document';

@Injectable()
export class DocService {

  private readonly _save$ = new Subject<DocumentBase>();
  save$ = this._save$.asObservable();

  private readonly _post$ = new Subject<boolean>();
  post$ = this._post$.asObservable();

  private readonly _unpost$ = new Subject<boolean>();
  unpost$ = this._unpost$.asObservable();

  private readonly _delete$ = new Subject<DocumentBase>();
  delete$ = this._delete$.asObservable();

  private readonly _close$ = new Subject<{ url: string, skip?: boolean }>();
  close$ = this._close$.asObservable();

  private readonly _saveClose$ = new Subject<DocumentBase>();
  saveClose$ = this._saveClose$.asObservable();

  private readonly _goto$ = new Subject<DocumentBase>();
  goto$ = this._goto$.asObservable();

  private readonly _do$ = new Subject<DocumentBase>();
  do$ = this._do$.asObservable();

  constructor(public api: ApiService, private messageService: MessageService, public confirmationService: ConfirmationService) { }

  save(doc: DocumentBase, close: boolean = false, mode: 'post' | 'save' = 'save') {
    return this.api.postDoc(doc, mode).toPromise()
      .then(savedDoc => {
        this.openSnackBar('success', savedDoc.description, savedDoc.posted ? 'posted' : 'unposted');
        const subject$ = close ? this._saveClose$ : this._save$;
        subject$.next(savedDoc);
        return true;
      });
  }

  delete(id: string) {
    return this.api.deleteDoc(id).toPromise()
      .then(deletedDoc => {
        this._delete$.next(deletedDoc);
        this.openSnackBar('success', deletedDoc.description, deletedDoc.deleted ? 'deleted' : 'undeleted');
        return true;
      });
  }

  post(id: string) {
    return this.api.postDocById(id).toPromise()
      .then(result => {
        this._post$.next(result);
        return true;
      });
  }

  unpost(id: string) {
    return this.api.unpostDocById(id).toPromise()
      .then(result => {
        this._unpost$.next(result);
        return true;
      });
  }

  openSnackBar(severity: string, summary: string, detail: string) {
    this.messageService.add({ severity, summary, detail, key: '1' });
  }

}
