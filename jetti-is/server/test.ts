// Test exchange modules...

import { AutosincIkoToJetty } from "./exchange/iiko-to-jetti-autosync";
import { IJettiProject, SMVProject } from "./exchange/jetti-projects";

//! временно. будeт задаваться в параметрах задания
const proj: IJettiProject = SMVProject; 
const source: string = 'Russia';

AutosincIkoToJetty(proj, source).catch(() => { });
