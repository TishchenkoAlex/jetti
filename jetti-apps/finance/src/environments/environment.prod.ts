// ng build --prod --aot && firebase deploy --only hosting:x100
import { Configuration } from 'msal';
import { MsalAngularConfiguration } from '@azure/msal-angular';

const domain = 'https://sm.jetti-app.com';
const BPAPI = 'https://bp.x100-group.com/JettiProcesses/hs';

export const environment = {
  production: true,
  api: `${domain}/api/`,
  auth: `${domain}/auth/`,
  socket: domain,
  host: domain,
  title: 'Jetti',
  path: '',
  BPAPI
};

const isIE = window.navigator.userAgent.indexOf('MSIE ') > -1 || window.navigator.userAgent.indexOf('Trident/') > -1;
export const protectedResourceMap: [string, string[]][] = [
  ['https://graph.microsoft.com/v1.0/me', ['user.read']]
];

export const MsalConfiguration: Configuration = {
  auth: {
    clientId: '8497b6af-a0c3-4b55-9e60-11bc8ff237e4',
    authority: 'https://login.microsoftonline.com/b91c98b1-d543-428b-9469-f5f8f25bc37b',
    validateAuthority: true,
    navigateToLoginRequestUrl: true,
  },
  cache: {
    cacheLocation: 'localStorage',
    storeAuthStateInCookie: isIE, // set to true for IE 11
  },
};

export const MsalAngularConfig: MsalAngularConfiguration = {
  popUp: !isIE,
  consentScopes: [
    'user.read',
    'openid',
    'profile',
    'https://sm.jetti-app.com/access_as_user'
  ],
  unprotectedResources: ['https://www.microsoft.com/en-us/'],
  protectedResourceMap,
  extraQueryParameters: {}
};

