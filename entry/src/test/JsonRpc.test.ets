import { afterAll, afterEach, beforeAll, beforeEach, describe, it } from '@ohos/hypium';
import { JSONRPCClient } from 'json_rpc_2';

export default function jsonRpcTest() {
  describe('jsonRpcTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });
    it('client', 0, () => {
      const client = new JSONRPCClient((request) => {
        try {
          console.log('send request: ' + JSON.stringify(request));
          return Promise.resolve();
        } catch (error) {
          return Promise.reject(error);
        }
      });
      client.request("foo", {
        key: 'name',
      })
    });
  });
}