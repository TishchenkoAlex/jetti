import { AutosyncIIkoToJetty, AutosyncSMSQL, QueueSyncSMSQL } from '../exchange/iiko-to-jetti-autosync';
import { QueuePost } from '../exchange/queue-post';

export const RegisteredSyncFunctions = (): Map<string, Function> => {
  const res = new Map;
  [
    AutosyncIIkoToJetty,
    AutosyncSMSQL,
    QueuePost,
    QueueSyncSMSQL
  ].forEach(e => res.set(e.name, e));
  return res;
};
