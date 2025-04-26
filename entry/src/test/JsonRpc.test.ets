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
      const client = createClient();
      client.request("foo", {
        key: 'name',
      })
    });
  });
}