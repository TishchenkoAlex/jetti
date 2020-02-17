import { ChangeDetectionStrategy, Component, Input, OnInit } from '@angular/core';
import { merge, Observable } from 'rxjs';
import { filter, startWith, switchMap } from 'rxjs/operators';
import { ApiService } from '../../services/api.service';
import { DocService } from '../doc.service';
import { DocumentBase } from '../../../../../../jetti-api/server/models/document';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-register-movements-list',
  templateUrl: './register.movements.list.component.html',
})
export class RegisterMovementsListComponent implements OnInit {

  movementsList$: Observable<any[]>;

  @Input() doc: DocumentBase;

  constructor(private api: ApiService, private ds: DocService) { }

  ngOnInit() {

    this.movementsList$ = merge(...[
      this.ds.save$,
      this.ds.delete$,
      this.ds.post$,
      this.ds.do$]
    ).pipe(
      startWith(this.doc),
      filter(doc => doc.id === this.doc.id),
      switchMap(doc => this.api.getDocRegisterMovementsList(this.doc.id)));
  }
}
