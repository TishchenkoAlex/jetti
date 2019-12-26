import { IO } from './index';
import { IJWTPayload } from './models/common-types';

export function userSocketsEmit(user: IJWTPayload | null, event: string, payload: any) {
  try {
    IO.emit(event, payload);
/*     if (!(user && user.email)) {
      // IO.emit(event, payload);
    } else {
      Object.keys(IO.sockets.connected).forEach(k => {
        const socket = IO.sockets.connected[k];
        if (socket.connected && socket.handshake.query.user === user.email) socket.emit(event, payload);
      });
    }*/
  } catch (err) { console.error('socket err', err); }
}
