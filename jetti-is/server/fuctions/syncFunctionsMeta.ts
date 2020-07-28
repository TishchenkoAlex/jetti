import {
	AutosyncIIkoToJetty,
	AutosyncSMSQL,
	QueueSyncSMSQL,
} from '../exchange/iiko-to-jetti-autosync';
import { QueuePost } from '../exchange/queue-post';

export const RegisteredSyncFunctions = (): Map<string, Function> => {
	const res = new Map();
	[AutosyncIIkoToJetty, AutosyncSMSQL, QueuePost, QueueSyncSMSQL, QueueTesting].forEach((e) =>
		res.set(e.name, e),
	);
	return res;
};

const QueueTesting = (params) => {
	setTimeout(() => {
		if (params.error) throw new Error(params.errorText || 'Some custom ERROR!');
	}, params.timeout || 10000);
};
