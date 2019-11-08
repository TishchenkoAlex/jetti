import { JQueue } from './tasks';
import { IJWTPayload } from '../common-types';
import PostAfterEchangeServer from '../Forms/Form.PostAfterEchange.server';

export async function startSheduledTasks() {

  const user: IJWTPayload = {
    description: 'user for task sheduler',
    email: '',
    isAdmin: true,
    env: {},
    roles: ['Admin']
  };

  const PostAfterEchangeServerForm = new PostAfterEchangeServer(user);
  // await PostAfterEchangeServerForm.Execute();
}
