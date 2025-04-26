import { JSONRPCClient } from 'json_rpc_2/src';

export function createClient(): JSONRPCClient {
  return new JSONRPCClient((request) => {
    try {
      console.log('send request: ' + JSON.stringify(request));
      return Promise.resolve();
    } catch (error) {
      return Promise.reject(error);
    }
  });
}