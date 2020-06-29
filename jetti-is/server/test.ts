// Test exchange modules...

import { AutosincIkoToJetty } from "./exchange/iiko-to-jetti-autosync";
import { IJettiProject, SMVProject } from "./exchange/jetti-projects";

//! временно. будeт задаваться в параметрах задания
const proj: IJettiProject = SMVProject; 
const source: string = 'Russia';

/*
AutosincIkoToJetty(proj, source).then(
    () => console.log('Task Complete.'),
    () => console.log('Task Errored!')
);
*/

// AutosincIkoToJetty(proj, source).catch(() => { });

Promise.all([
    AutosincIkoToJetty(proj, source)
  ]).then(
    () => console.log('All Task Complete.'),
    () => console.log('Task Errored!')
);