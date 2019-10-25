import { Ref } from './../../document';

export interface RegisterAccount {
  debit: { account: Ref, subcounts: any[], qty?: number, currency?: Ref, sum?: number };
  kredit: { account: Ref, subcounts: any[], qty?: number, currency?: Ref, sum?: number };
  operation?: Ref;
  company?: Ref;
  sum: number;
}
