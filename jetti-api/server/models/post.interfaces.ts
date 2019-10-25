import { RegisterAccount } from './Registers/Account/Register.Account';
import { RegisterAccumulation } from './Registers/Accumulation/RegisterAccumulation';
import { RegisterInfo } from './Registers/Info/RegisterInfo';

export interface PostResult {
  Account: RegisterAccount[];
  Accumulation: RegisterAccumulation[];
  Info: RegisterInfo[];
}
