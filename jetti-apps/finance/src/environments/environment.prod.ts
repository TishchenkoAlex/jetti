const domain = 'https://sm.jetti-app.com';
const BPAPI = 'https://bp.x100-group.com/JettiProcesses/hs';

export const environment = {
  production: true,
  api: `${domain}/api/`,
  auth: `${domain}/auth/`,
  socket: domain,
  host: domain,
  path: '',
  BPAPI
};

export const OAuthSettings = {
  clientID: '8497b6af-a0c3-4b55-9e60-11bc8ff237e4',
  authority: 'https://login.microsoftonline.com/b91c98b1-d543-428b-9469-f5f8f25bc37b',
  redirectUri: `https://x100-jetti.web.app/`,
  validateAuthority : true,
  scopes: [
    'user.read'
  ]
};
