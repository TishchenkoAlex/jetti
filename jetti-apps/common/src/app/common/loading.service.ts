import { Injectable } from '@angular/core';
import { BehaviorSubject, combineLatest } from 'rxjs';
import { map } from 'rxjs/operators';

@Injectable({ providedIn: 'root' })
export class LoadingService {
  history = {};

  private _loading = new BehaviorSubject<{ req: string, loading: boolean } | undefined>(undefined);
  loading$ = this._loading.asObservable();
  set loading(value: { req: string, loading: boolean }) {
    if (history[value.req] && (value.loading !== true)) delete history[value.req];
    else if ((value.loading === true) && value.req) history[value.req] = value.req;
    if (Object.keys(history).length === 0) this._loading.next(undefined); else this._loading.next(value);
  }
  get loading() { return this._loading.value!; }

  private _counter = new BehaviorSubject<number | undefined>(undefined);
  counter$ = this._counter.asObservable();
  set counter(value) { if (value !== this._counter.value) this._counter.next(value); }
  get counter() { return this._counter.value; }

  private _color = new BehaviorSubject<'primary' | 'accent' | 'warn'>('accent');
  color$ = this._color.asObservable();
  set color(value) { if (value !== this._color.value) this._color.next(value); }
  get color() { return this._color.value; }

  busy$ = combineLatest(this.loading$, this.color$).pipe(map(r => r[0] && r[1] === 'accent'));

}
