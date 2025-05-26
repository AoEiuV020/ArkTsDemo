import { HttpClient, UaResponse } from '../src/utils/http-client';

describe("http client", () => {
  it("should fetch user agent info", async () => {
    // 使用示例
    const httpClient = new HttpClient();

    // 调用UA API
    const response = await httpClient.getUserAgentInfo();
    console.log('UA信息:', response);
    
    // 验证响应格式
    expect(response).toBeDefined();
    expect(response.code).toBeDefined();
    expect(response.msg).toBeDefined();
    expect(response.data).toBeDefined();
    
    // 验证数据字段
    expect(response.data.address).toBeDefined();
    expect(response.data.browser).toBeDefined();
    expect(response.data.browserVersion).toBeDefined();
    expect(response.data.deviceType).toBeDefined();
    expect(response.data.ip).toBeDefined();
    expect(response.data.os).toBeDefined();
  });
});
