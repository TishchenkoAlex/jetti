import { ChangeDetectionStrategy, Component, Input, OnInit } from '@angular/core';
import { Observable } from 'rxjs';
import { map, share } from 'rxjs/operators';
import { RegisterAccumulation } from '../../../../../../jetti-api/server/models/Registers/Accumulation/RegisterAccumulation';
import { ApiService } from '../../services/api.service';
import { DocumentBase } from './../../../../../../jetti-api/server/models/document';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-register-accumulation',
  templateUrl: './register.accumulation.component.html',
  styleUrls: ['./register.accumulation.component.scss']
})
export class RegisterAccumulationComponent implements OnInit {

  @Input() register: string;
  @Input() doc: DocumentBase;
  movements$: Observable<RegisterAccumulation[]>;
  additionalColumns$: Observable<string[]>;
  selection: RegisterAccumulation | null = null;

  constructor(private apiService: ApiService) { }

  ngOnInit() {
    this.movements$ = this.apiService.getDocAccumulationMovements(this.register, this.doc.id).pipe(share());
    this.additionalColumns$ = this.movements$.pipe(
      map(data =>  Object.keys(data[0])
        .filter(el => ['date', 'kind', 'company', 'document', 'calculated', 'id', 'parent', 'exchangeRate']
        .findIndex(e => e === el) === -1)), share());
  }

  isNumbert(value): boolean {
    return Number.parseInt(value, 0) * 0 === 0;
  }

}
