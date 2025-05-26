import { describe, it, expect } from '@ohos/hypium';
import { HttpClient } from '../utils/http-client';

export default function httpTest() {
  describe('httpTest', () => {
    it('should_fetch_user_agent_info', 0, async () => {
      // 使用示例
      const httpClient = new HttpClient();

      // 调用UA API获取用户代理信息
      const response = await httpClient.getUserAgentInfo();
      console.log('UA信息:', JSON.stringify(response));
      
      // 验证响应
      expect(response !== null).assertTrue();
      expect(response.code !== undefined).assertTrue();
      expect(response.msg !== undefined).assertTrue();
      expect(response.data !== undefined).assertTrue();
      
      // 验证数据字段
      const data = response.data;
      expect(data.address !== undefined).assertTrue();
      expect(data.browser !== undefined).assertTrue();
      expect(data.browserVersion !== undefined).assertTrue();
      expect(data.deviceType !== undefined).assertTrue();
      expect(data.ip !== undefined).assertTrue();
      expect(data.os !== undefined).assertTrue();
    });
  });
}