import { NextFunction, Request, Response } from 'express';
import * as jwt from 'jsonwebtoken';
import { JTW_KEY } from '../../env/environment';
import { IJWTPayload } from '../../interfaces/JTW';

export function checkAuth(req: Request, res: Response, next: NextFunction) {
  const token = ((req.headers.authorization as string) || '').split(' ')[1];
  jwt.verify(token, JTW_KEY as string, undefined, (error, decoded) => {
    if (error) return res.status(401).json({ message: error.message });
    req['user'] = decoded;
    next();
  });
}

export function authIO(socket: SocketIO.Socket, next) {
  const token = socket.handshake.query.token;
  jwt.verify(token, JTW_KEY as string, undefined, (error, decoded: IJWTPayload) => {
    if (!error) socket.handshake.query.user = decoded.email;
    next();
  });
}
