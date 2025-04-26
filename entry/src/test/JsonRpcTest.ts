import { JSONRPCClient } from 'json_rpc_2/src';

export function createClient(foo: (obj: object) => Promise<void>): JSONRPCClient {
  return new JSONRPCClient((request) => {
    return foo(request);
  });
}