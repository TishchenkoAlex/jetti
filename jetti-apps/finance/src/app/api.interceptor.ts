import { HttpErrorResponse, HttpEvent, HttpHandler, HttpInterceptor, HttpRequest, HttpResponse } from '@angular/common/http';
import { Injectable, isDevMode } from '@angular/core';
import { MessageService } from 'primeng/components/common/messageservice';
import { Observable, of as observableOf, throwError } from 'rxjs';
import { catchError, map, finalize } from 'rxjs/operators';
import { dateReviver, dateReviverLocal } from '../../../../jetti-api/server/fuctions/dateReviver';
import { AuthService } from './auth/auth.service';
import { LoadingService } from './common/loading.service';

@Injectable()
export class ApiInterceptor implements HttpInterceptor {

  constructor(private lds: LoadingService, private auth: AuthService, private messageService: MessageService) { }

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
    req = req.clone({
      setHeaders: { Authorization: `Bearer ${this.auth.token}` }, responseType: 'text',
      body: req.body ? JSON.parse(JSON.stringify(req.body), dateReviverLocal) : req.body
    });

    const showLoading = !(
      req.url.includes('user/settings') ||
      req.url.includes('/jobs') ||
      req.url.includes('/byId') ||
      req.url.includes('/suggest') ||
      req.url.includes('/formControlRef'));

    if (isDevMode()) console.log('http', req.url);
    if (showLoading) { this.lds.color = 'accent'; this.lds.loading = { req: req.url, loading: true }; }
    return next.handle(req).pipe(
      finalize(() => this.lds.loading = { req: req.url, loading: false }),
      map(data => data instanceof HttpResponse ? data.clone({ body: JSON.parse(data.body, dateReviver) }) : data),
      catchError((err: HttpErrorResponse) => {
        if (err.status === 401) {
          this.auth.logout();
          return observableOf<any>();
        }
        this.messageService.add({
          severity: 'error', summary: err.statusText, key: '-1',
          detail: err.status === 500 ? err.error : err.message, life: 10000
        });
        return throwError(err);
      }));
  }
}
