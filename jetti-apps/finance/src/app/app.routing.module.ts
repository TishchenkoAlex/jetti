import { Injectable, NgModule } from '@angular/core';
import { FormGroup } from '@angular/forms';
// tslint:disable-next-line:max-line-length
import { ActivatedRouteSnapshot, DetachedRouteHandle, Resolve, RouteReuseStrategy, RouterModule, RouterStateSnapshot, Routes } from '@angular/router';
import { IViewModel } from '../../../../jetti-api/server/models/common-types';
import { AuthGuardService } from './auth/auth.guard.service';
import { DynamicFormService } from './common/dynamic-form/dynamic-form.service';
import { TabControllerComponent } from './common/tabcontroller/tabcontroller.component';
import { TabsStore } from './common/tabcontroller/tabs.store';
import { ApiService } from './services/api.service';

export class AppRouteReuseStrategy extends RouteReuseStrategy {
  shouldDetach(route: ActivatedRouteSnapshot): boolean { return false; }
  store(route: ActivatedRouteSnapshot, detachedTree: DetachedRouteHandle): void { }
  shouldAttach(route: ActivatedRouteSnapshot): boolean { return false; }
  retrieve(route: ActivatedRouteSnapshot): DetachedRouteHandle | null { return null; }
  shouldReuseRoute(future: ActivatedRouteSnapshot, curr: ActivatedRouteSnapshot): boolean {
    // console.log('curr', curr.component);
    // console.log('future', future.component);
    return true;
/*     return (typeof future.component  === typeof TabControllerComponent) &&
      (typeof curr.component  === typeof TabControllerComponent) &&
      (future.component === curr.component); */
  }
}

@Injectable()
export class TabResolver implements Resolve<FormGroup | IViewModel | null> {
  constructor(private dfs: DynamicFormService, private api: ApiService, private tabStore: TabsStore) { }

  public resolve(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    const id = route.params.id || '';
    const type = route.params.type;
    if (type === 'home') return null;
    if (type.startsWith('Form.')) { return this.dfs.getFormView$(type); }
    if (this.tabStore.state.tabs.findIndex(i => i.docType === type && i.docID === id) === -1) {
      return id ?
        this.dfs.getViewModel$(type, id, route.queryParams) :
        this.api.getView(type);
    }
    return null;
  }
}

// tslint:disable:max-line-length
export const routes: Routes = [
  { path: ':type/:id', component: TabControllerComponent, resolve: { detail: TabResolver }, canActivate: [AuthGuardService] },
  { path: ':type', component: TabControllerComponent, resolve: { detail: TabResolver }, canActivate: [AuthGuardService] },
  { path: '', redirectTo: 'home', pathMatch: 'full' },
  { path: '**', redirectTo: 'home' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
  providers: [
    { provide: RouteReuseStrategy, useClass: AppRouteReuseStrategy },
    AuthGuardService,
    TabResolver,
  ]
})
export class RoutingModule { }
