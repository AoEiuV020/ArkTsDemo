import { afterEach, beforeEach, describe, expect, it } from '@ohos/hypium';
import { HarmonyTcpSocketFactory } from '../HarmonyTcpSocketFactory';
import { ITcpSocket } from '../ITcpSocket';
import util from '@ohos.util';

export default function harmonyTcpClientTest() {
  describe('harmonyTcpClientTest', () => {
    let tcpSocket: ITcpSocket;

    beforeEach(() => {
      tcpSocket = HarmonyTcpSocketFactory.createSocket();
    });

    afterEach(async () => {
      if (tcpSocket) {
        try {
          await tcpSocket.close();
        } catch (error) {
          // 忽略关闭时的错误
        }
      }
    });

    it('connect8888', 0, async () => {
      await tcpSocket.connect({
        address: 'localhost',
        port: 8888,
        timeout: 2000
      });

      console.log('✅ 成功连接到8888端口');

      // 如果连接成功，发送测试消息并等待回显
      const testMessage = 'Hello Server!';
      const messageBytes = new util.TextEncoder().encode(testMessage);

      // 创建Promise等待回显数据
      const echoPromise = new Promise<string>((resolve, reject) => {
        const timeout = setTimeout(() => {
          reject(new Error('等待回显超时'));
        }, 3000);

        tcpSocket.on('message', (data: Uint8Array) => {
          clearTimeout(timeout);
          const echoText = new util.TextDecoder().decode(data);
          console.log('📨 收到回显数据:', echoText);
          resolve(echoText);
        });
      });

      await tcpSocket.send(messageBytes);
      console.log('📤 发送消息:', testMessage);

      const echoText = await echoPromise;
      console.log('✅ 收到回显:', echoText);
      expect(echoText).assertEqual(testMessage);

      await tcpSocket.close();

    });
  });
}
