import { describe, expect, it } from '@ohos/hypium';
import { AES, Base64, MD5 } from 'ts-secure-utils';

export default function secureTest() {
  describe('secureTest', () => {
    it('base64Test', 0, () => {
      console.log(Base64.decode('AAAA').toString());
    });
    it('aesTest', 0, () => {
      const password = '123456';
      const key = MD5.encryptString(password);
      const data = '你好，';
      const encrypted = AES.encryptBase64String(data, key);
      expect(AES.decryptStringFromBase64(encrypted, key)).assertEqual(data);
    });
  });
}