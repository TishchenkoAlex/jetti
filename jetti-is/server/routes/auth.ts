import * as express from 'express';
import axios from 'axios';
import * as jwt from 'jsonwebtoken';
import { JTW_KEY } from '../env/environment';
import { IJWTPayload } from '../interfaces/JTW';

export const router = express.Router();

router.post('/login', async (req, res, next) => {
  try {
    const instance = axios.create({ baseURL: 'https://graph.microsoft.com' });
    instance.defaults.headers.common['Authorization'] = `Bearer ${req.body.token}`;
    const me = (await instance.get('/v1.0/me/')).data;

    let photo;
    try {
      const photoArraybuffer = (await instance.get('/v1.0/me/photos/48x48/$value', { responseType: 'arraybuffer' })).data;
      photo = Buffer.from(photoArraybuffer, 'binary').toString('base64');
    } catch { }

    const payload: IJWTPayload = {
      email: me.userPrincipalName,
      description: me.displayName,
      isAdmin: true,
      roles: []
    };

    const token = jwt.sign(payload, JTW_KEY, { expiresIn: '72h' });

    return res.json({ account: { ...payload, photo }, token });
  } catch (err) { next(err); }
});


router.post('/token', async (req, res, next) => {
  try {
    const { password } = req.body;
    if (password !== process.env.EXCHANGE_ACCESS_KEY)
      return res.status(401).json({ message: 'Auth failed: wrong API key' });

    const payload: IJWTPayload = {
      email: 'apiService@x100-group.com',
      description: 'apiService account',
      isAdmin: true,
      roles: [],
    };
    const token = jwt.sign(payload, JTW_KEY, { expiresIn: '24h' });
    return res.json({ account: payload, token });
  } catch (err) { next(err); }
});
