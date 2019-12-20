import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { MsalService } from '@azure/msal-angular';
import * as jwt_decode from 'jwt-decode';
import { BehaviorSubject } from 'rxjs';
import { filter, map, shareReplay, tap } from 'rxjs/operators';
import { IAccount, ILoginResponse } from '../../../../../jetti-api/server/models/common-types';
import { environment, OAuthSettings } /*  */ from '../../environments/environment';
export const ANONYMOUS_USER: ILoginResponse = { account: undefined, token: '' };

@Injectable()
export class AuthService {

  private readonly _userProfile$ = new BehaviorSubject<ILoginResponse | undefined>(undefined);
  userProfile$ = this._userProfile$.asObservable().pipe(filter((u: ILoginResponse) => !!u));
  isLoggedIn$ = this.userProfile$.pipe(map(p => p.account !== undefined));
  isLoggedOut$ = this.isLoggedIn$.pipe(map(isLoggedIn => !isLoggedIn));

  isAdmin$ = this.userProfile$.pipe(map(u => u.account.isAdmin));
  userRoles$ = this.userProfile$.pipe(map(u => u.account.roles));
  get userProfile() { return this._userProfile$.value; }

  get token() { return localStorage.getItem('jetti_token') || ''; }
  set token(value) { localStorage.setItem('jetti_token', value); }
  get tokenPayload() { return jwt_decode(this.token); }

  constructor(private router: Router, private http: HttpClient, private msalService: MsalService) { }

  public async login() {
    await this.msalService.loginPopup(OAuthSettings.scopes);
    const user = this.msalService.getUser().displayableId;
    const acquireTokenSilentResult = await this.msalService.acquireTokenSilent(OAuthSettings.scopes);

    return this.http.post<ILoginResponse>(`${environment.auth}login`,
      { email: user, password: null, token: acquireTokenSilentResult }).pipe(
        shareReplay(),
        tap(loginResponse => this.init(loginResponse))
      );
  }

  public logout() {
    localStorage.removeItem('jetti_token');
    this._userProfile$.next({ ...ANONYMOUS_USER });
    return this.router.navigate([''], { queryParams: {} });
  }

  public getAccount() {
    return this.http.get<IAccount>(`${environment.auth}account`).pipe(
      tap(account => {
        const LoginResponse: ILoginResponse = { account, token: this.token };
        this.init(LoginResponse);
      }));
  }

  private init(loginResponse: ILoginResponse) {
    if (loginResponse.token && loginResponse.account) {
      this.token = loginResponse.token;
      this._userProfile$.next(loginResponse);
    }
  }
}
