import { Request, Response, NextFunction, Router } from 'express';
import * as jwt from 'jsonwebtoken';
import { JTW_KEY } from '../env/environment';
import { IJWTPayload } from '../models/common-types';
import { authHTTP } from './middleware/check-auth';
import { User } from './user.settings';

export const router = Router();

router.post('/login', async (req, res, next) => {
  // setka.service.account@sushi-master.net
  try {
    const { email, password } = req.body;
    console.log(req.body, process.env.EXCHANGE_ACCESS_KEY);
    if (!email) { return res.status(401).json({ message: 'Auth failed: user name required' }); }
    if (!password) { return res.status(401).json({ message: 'Auth failed: password required' }); }
    if (!(email === 'setka.service.account@sushi-master.net')) {
      return res.status(401).json({ message: 'Auth failed: wrong user name' });
    }
    if (password !== process.env.EXCHANGE_ACCESS_KEY) { return res.status(401).json({ message: 'Auth failed: wrong password' }); }

    const payload: IJWTPayload = {
      email,
      description: 'setka service account',
      isAdmin: true,
      roles: [],
      env: {},
    };
    const token = jwt.sign(payload, JTW_KEY, { expiresIn: '24h' });
    return res.json({ account: payload, token });
  } catch (err) { next(err); }
});


router.get('/v1.0/hello', authHTTP, async (req: Request, res: Response, next: NextFunction) => {
  try {
    // const user = User(req);
    return res.json('hello');
  } catch (err) { next(err); }
});

router.post('/v1.0/hello', authHTTP, async (req: Request, res: Response, next: NextFunction) => {
  try {
    // const user = User(req);
    return res.json('hello');
  } catch (err) { next(err); }
});

