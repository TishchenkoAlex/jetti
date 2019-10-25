// The file contents for the current environment will overwrite these during build.
// The build system defaults to the dev environment which uses `environment.ts`, but if you do
// `ng build --env=prod` then `environment.prod.ts` will be used instead.
// The list of which env maps to which file can be found in `.angular-cli.json`.
const domain = 'http://localhost:3000';

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
