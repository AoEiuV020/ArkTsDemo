import { describe, it } from '@ohos/hypium';
import { HttpClient } from '../utils/http-client';

export default function httpTest() {
  describe('httpTest', () => {
    it('example', 0, async () => {

      // 使用示例
      const httpClient = new HttpClient();

      // GET 请求示例
      await httpClient.get<string>('https://example.com/')
        .then(content => console.log('content:', content))

    });
  });
}