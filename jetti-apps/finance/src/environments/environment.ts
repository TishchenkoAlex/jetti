const domain = 'https://smaz.jetti-app.com';
// const domain = 'http://localhost:3000';

export const environment = {
  production: false,
  api: `${domain}/api/`,
  auth: `${domain}/auth/`,
  socket: domain,
  host: domain,
  path: '',
};

export const OAuthSettings = {
  clientID: '8497b6af-a0c3-4b55-9e60-11bc8ff237e4',
  authority: 'https://login.microsoftonline.com/b91c98b1-d543-428b-9469-f5f8f25bc37b',
  redirectUri: 'http://localhost:4200/',
  validateAuthority : true,
  scopes: [
    'user.read'
  ]
};
