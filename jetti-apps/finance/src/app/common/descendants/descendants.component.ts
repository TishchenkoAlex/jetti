import { ChangeDetectionStrategy, Component, Input, OnInit, OnDestroy } from '@angular/core';
import { Subject, Subscription, merge } from 'rxjs';
import { take, filter } from 'rxjs/operators';
import { ApiService } from '../../services/api.service';
import { DocumentBase } from '../../../../../../jetti-api/server/models/document';
import { Router } from '@angular/router';
import { DocService } from '../doc.service';
import { LoadingService } from '../loading.service';

@Component({
  changeDetection: ChangeDetectionStrategy.OnPush,
  selector: 'j-descendants',
  templateUrl: './descendants.component.html',
})
export class DescendantsComponent implements OnInit, OnDestroy {

  @Input() doc: DocumentBase;

  get isDoc() { return this.doc.type.startsWith('Document.'); }
  get isForm() { return this.doc.type.startsWith('Form.'); }
  get isCatalog() { return this.doc.type.startsWith('Catalog.'); }

  selection: any;
  private _subscription$: Subscription = Subscription.EMPTY;
  descendantsListSub$ = new Subject<any[]>();
  infoText = '';

  dataSource = [];
  constructor(private apiService: ApiService, public router: Router, private ds: DocService, public lds: LoadingService) { }

  ngOnInit() {
    this.apiService.getDescedantsObjects(this.doc.id).pipe(take(1)).subscribe(data => { this.descendantsListSub$.next(data); });

    if (this.isCatalog) this._subscription$ = this.descendantsListSub$.subscribe(data => {
      this.infoText = '';
      if (data.length === 20) this.infoText = 'First 20 objects';
    });

  }

  search(searchedValue: string) {
    if (!searchedValue) return;
    this.descendantsListSub$.pipe(take(1)).subscribe(data => {
      searchedValue = searchedValue.toLowerCase();
      const dataSourceFiltred = data.filter(el => {
        for (const key of Object.keys(el)) {
          let curVal = el[key];
          if (curVal && curVal.type && curVal.type.includes('.')) curVal = curVal.value;
          if (curVal && curVal.toString().toLowerCase().includes(searchedValue)) return true;
        }
        return false;
      });
      this.descendantsListSub$.next(dataSourceFiltred);
    });
  }

  openOnClick() {
    this.openDescedant(this.selection);
  }

  openDescedant(descedantData: { type, id }) {
    this.router.navigate([descedantData.type, descedantData.id]);
  }

  ngOnDestroy() {
    this._subscription$.unsubscribe();
  }
}
