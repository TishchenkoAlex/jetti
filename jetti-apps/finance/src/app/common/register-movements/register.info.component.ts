import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Input, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { map, share } from 'rxjs/operators';
import { RegisterInfo } from '../../../../../../jetti-api/server/models/Registers/Info/RegisterInfo';
import { ApiService } from '../../services/api.service';
import { DocumentBase } from './../../../../../../jetti-api/server/models/document';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-register-info',
  templateUrl: './register.info.component.html',
})
export class RegisterInfoComponent implements OnInit {

  @Input() register: string;
  @Input() doc: DocumentBase;
  movements$: Observable<RegisterInfo[]>;
  additionalColumns$: Observable<string[]>;
  selection: RegisterInfo | null = null;

  constructor(private apiService: ApiService, private cd: ChangeDetectorRef) { }

  ngOnInit() {
    this.movements$ = this.apiService.getDocInfoMovements(this.register, this.doc.id).pipe(share());
    this.additionalColumns$ = this.movements$.pipe(
      map(data => Object.keys(data[0]).filter(el => ['date', 'kind', 'company', 'document'].findIndex(e => e === el) === -1)), share());
  }
}
