import { describe, it } from '@ohos/hypium';
import { Base64 } from 'ts-secure-utils';

export default function secureTest() {
  describe('secureTest', () => {
    it('base64Test', 0, () => {
      console.log(Base64.decode('AAAA').toString());
    });
  });
}