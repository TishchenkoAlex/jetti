import { registerLocaleData } from '@angular/common';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import localeRUExtra from '@angular/common/locales/extra/ru';
import localeRU from '@angular/common/locales/ru';
import { LOCALE_ID, NgModule } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { ServiceWorkerModule } from '@angular/service-worker';
import { MsalModule } from '@azure/msal-angular';
import 'reflect-metadata';
import { take } from 'rxjs/operators';
import { environment, OAuthSettings } from '../environments/environment';
import { ApiInterceptor } from './api.interceptor';
import { AppComponent } from './app.component';
import { AppMenuComponent, AppSubMenuComponent } from './app.menu.component';
import { RoutingModule } from './app.routing.module';
import { AppTopBarComponent } from './app.topbar.component';
import { AppProfileComponent } from './auth/app.profile.component';
import { AuthService } from './auth/auth.service';
import { MaterialModule } from './material.module';
import { PrimeNGModule } from './primeNG.module';
import { DynamicFormsModule } from './UI/dynamic.froms.module';

export function getJwtToken(): string {
  return localStorage.getItem('access_token') || '';
}

@NgModule({
  declarations: [
    AppComponent,
    AppMenuComponent,
    AppSubMenuComponent,
    AppTopBarComponent,
    AppProfileComponent,
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    MaterialModule,
    PrimeNGModule,
    DynamicFormsModule,
    RoutingModule,
    MsalModule.forRoot(OAuthSettings),
    ServiceWorkerModule.register('/ngsw-worker.js', { enabled: environment.production }),
  ],
  providers: [
    { provide: LOCALE_ID, useValue: 'ru-RU' },
    AuthService,
    { provide: HTTP_INTERCEPTORS, useClass: ApiInterceptor, multi: true }
  ],
  entryComponents: [],
  bootstrap: [AppComponent]
})
export class AppModule {

  constructor(private auth: AuthService) {
    registerLocaleData(localeRU, localeRUExtra);
    auth.getAccount().pipe(take(1)).subscribe();
  }
}
