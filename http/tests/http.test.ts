import { HttpClient } from '../src';
describe("http client", () => {
  it("example", async () => {
    
      // 使用示例
      const httpClient = new HttpClient();

      // GET 请求示例
      await httpClient.get<string>('https://example.com/')
        .then(content => console.log('content:', content))

  });
});
