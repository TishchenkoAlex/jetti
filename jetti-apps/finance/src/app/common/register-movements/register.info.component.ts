import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { map, share } from 'rxjs/operators';
import { RegisterInfo } from '../../../../../../jetti-api/server/models/Registers/Info/RegisterInfo';
import { ApiService } from '../../services/api.service';
import { DocumentBase } from './../../../../../../jetti-api/server/models/document';
import { Router } from '@angular/router';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-register-info',
  templateUrl: './register.info.component.html',
})
export class RegisterInfoComponent implements OnInit {

  @Input() register: string;
  @Input() doc: DocumentBase;
  @Input() filter: { key: string, value: any }[];

  movements$: Observable<RegisterInfo[]>;
  additionalColumns$: Observable<string[]>;
  selection: RegisterInfo | null = null;

  constructor(private apiService: ApiService, private cd: ChangeDetectorRef, private router: Router) { }

  ngOnInit() {
    if (!this.filter) this.filter = [];
    if (this.doc) this.filter.push({ key: 'document', value: this.doc.id });
    this.movements$ = this.apiService.getRegisterInfoMovementsByFilter(this.register, this.filter).pipe(share());
    this.additionalColumns$ = this.movements$.pipe(
      map(data => Object.keys(data[0]).filter(el => ['date', 'kind', 'company', 'document', 'docId'].findIndex(e => e === el) === -1)), share());
  }
  open(rowData) {
    this.apiService.byId(rowData.docId).then(doc => {
      this.router.navigate([doc.type, doc.id]);
    })
  }
}
