// Test exchange modules...

import { AutosincIkoToJetty } from './exchange/iiko-to-jetti-autosync';
import { IJettiProject, SMVProject } from './exchange/jetti-projects';

// ! временно. будeт задаваться в параметрах задания
const params: any = {
  project: SMVProject,
  syncSource: 'Russia'
};

/*
AutosincIkoToJetty(proj, source).then(
    () => console.log('Task Complete.'),
    () => console.log('Task Errored!')
);
*/

/*
Promise.all([
    AutosincIkoToJetty(proj, source)
  ]).then(
    () => console.log('All Task Complete.'),
    (error) => console.log('Task Errored: ', error.message)
);
*/

AutosincIkoToJetty(params).catch((error) => { console.log(error); });
