import { IO } from './index';

export function userSocketsEmit(user: string | null, event: string, payload: any) {
  try {
    if (!user) IO.emit(event, payload);
    else {
      Object.keys(IO.sockets.connected).forEach(k => {
        const socket = IO.sockets.connected[k];
        if (socket.connected && socket.handshake.query.user === user) socket.emit(event, payload);
      });
    }
  } catch (err) { console.log('socket err', err); }
}
