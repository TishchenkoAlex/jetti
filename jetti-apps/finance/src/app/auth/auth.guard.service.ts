import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, CanActivate, RouterStateSnapshot } from '@angular/router';
import { AuthService } from '../auth/auth.service';
import { ApiService } from './../services/api.service';

@Injectable()
export class AuthGuardService implements CanActivate {

  constructor(private auth: AuthService, private api: ApiService) { }

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    if (route.params.type === 'home') { return true; }
    return true;
  }
}
