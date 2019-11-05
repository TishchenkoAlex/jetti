import { Injectable, OnDestroy } from '@angular/core';
import { Subject } from 'rxjs';
import { filter, map, sampleTime, take } from 'rxjs/operators';
import * as IO from 'socket.io-client';
import { IJob, IJobs } from '../../../../../jetti-api/server/models/common-types';
import { AuthService } from '../auth/auth.service';
import { ApiService } from '../services/api.service';
import { environment } from './../../environments/environment';

@Injectable({ providedIn: 'root' })
export class EventsService implements OnDestroy {

  private _latestJobs$ = new Subject<IJobs>();
  latestJobs$ = this._latestJobs$.asObservable().pipe(map(j => {
    return [
      ...((j.Active || []).map(el => ({ ...el, status: 'Active' }))),
      ...((j.Completed || []).map(el => ({ ...el, status: 'Completed' }))),
      ...((j.Failed || []).map(el => ({ ...el, status: 'Failed' }))),
      ...((j.Waiting || []).map(el => ({ ...el, status: 'Waiting' })))]
      .sort((a, b) => b.timestamp - a.timestamp);
  }));
  latestJobsAll$ = this._latestJobs$.asObservable().pipe(map(j => j.Active.length));
  private debonce$ = new Subject<IJob>();

  constructor(private auth: AuthService, private api: ApiService) {
    this.debonce$.pipe(sampleTime(1000)).subscribe(job => this.update(job));

    this.auth.userProfile$.pipe(filter(u => !!(u && u.account))).subscribe(u => {
      const wsUrl = `${environment.socket}?token=${u.token}`;

      const wsAuto = (url: string, onmessage: (data: any) => void) => {
        const socket = IO(url, {transports: ['websocket']});
        socket.on('batch', (data: any) => {
          onmessage(data);
        });
      };

      wsAuto(wsUrl, data => this.debonce$.next(data));
      this.debonce$.next();
    });
  }

  private update(job?: IJob) {
    this.api.jobs().pipe(take(1)).subscribe(jobs => this._latestJobs$.next(jobs));
  }

  ngOnDestroy() {
    this.debonce$.complete();
    this.debonce$.unsubscribe();
  }
}

