import { afterAll, afterEach, beforeAll, beforeEach, describe, it } from '@ohos/hypium';
import { createClient } from './JsonRpcTest';

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
      const client = createClient((request) => {
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