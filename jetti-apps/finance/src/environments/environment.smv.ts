// ng build --configuration smv && firebase deploy --only hosting:smv
import { Configuration } from 'msal';
import { MsalAngularConfiguration } from '@azure/msal-angular';

const domain = 'https://smv.jetti-app.com';
const BPAPI = 'https://bp.x100-group.com/JettiProcesses/hs';

export const environment = {
  production: true,
  api: `${domain}/api/`,
  auth: `${domain}/auth/`,
  socket: domain,
  host: domain,
  PowerBIURL: 'https://app.powerbi.com/groups/38bc78d2-f2a8-413e-a387-ec5a8623a308/list/dashboards',
  title: 'Jetti [SMV]',
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
    'https://smv.jetti-app.com/access_as_user'
  ],
  unprotectedResources: ['https://www.microsoft.com/en-us/'],
  protectedResourceMap,
  extraQueryParameters: {}
};

