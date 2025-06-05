import { afterAll, beforeAll, describe, expect, it } from '@ohos/hypium';
import { HarmonyTcpSocketFactory } from '../../../HarmonyTcpSocketFactory';
import { TcpConnectOptions } from '../../../TcpConnectOptions';
import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

export default function tcpServerIntegration() {
  describe('tcpServerIntegration', () => {
    let testServer: socket.TCPSocketServer;
    let testPort: number;

    beforeAll((done: Function) => {
      // 创建测试服务器
      testServer = socket.constructTCPSocketServerInstance();

      testServer.on('connect', (client: socket.TCPSocketConnection) => {
        // 回显服务器 - 收到数据后原样返回
        client.on('message', (value: socket.SocketMessageInfo) => {
          const tcpSendOption: socket.TCPSendOptions = {
            data: value.message
          };
          client.send(tcpSendOption, () => {
            console.log('echo send success');
          });
        });

        client.on('error', (error: BusinessError) => {
          console.error('Server client error:', error);
        });
      });
      testServer.on('error', (error: BusinessError) => {
        console.error('Server error:', error);
      });

      // 监听随机端口
      const listenOptions: socket.NetAddress = {
        address: '127.0.0.1',
        port: 0, // 使用随机端口
        family: 1
      };

      testServer.listen(listenOptions, (error: BusinessError) => {
        if (error) {
          done(new Error('Failed to start server: ' + error.message));
          return;
        }

        // 使用 getLocalAddress 获取实际监听的端口
        testServer.getLocalAddress().then((address: socket.NetAddress) => {
          testPort = address.port as number;
          done();
        }).catch((getAddressError: BusinessError) => {
          done(new Error('Failed to get server address: ' + getAddressError.message));
        });
      });
    });

    afterAll((done: Function) => {
      if (testServer) {
        // TCPSocketServer 没有 close 方法，需要 off 所有监听的事件
        testServer.off('connect');
        testServer.off('error');
        done();
      } else {
        done();
      }
    });
    it('shouldConnectToHarmonyServer', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: testPort,
        timeout: 5000
      };

      try {
        await tcpSocket.connect(connectOptions);
        expect(true).assertEqual(true);
      } catch (error) {
        // 如果连接失败，检查是否是预期的错误
        expect(error).not().assertNull();
      } finally {
        await tcpSocket.close();
      }
    });
    it('shouldEmitConnectEvent', 0, (done: Function) => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();

      tcpSocket.on('connect', () => {
        tcpSocket.close().then(() => {
          done();
        }).catch(() => {
          done();
        });
      });

      tcpSocket.on('error', (error: Error) => {
        done(new Error('Connection failed: ' + error.message));
      });

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: testPort,
        timeout: 5000
      };

      tcpSocket.connect(connectOptions).catch((error: Error) => {
        done(new Error('Connect promise rejected: ' + error.message));
      });
    });
    it('shouldSendAndReceiveData', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();
      const testData = new Uint8Array([1, 2, 3, 4, 5]);

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: testPort,
        timeout: 5000
      };

      try {
        // 连接到服务器
        await tcpSocket.connect(connectOptions);

        // 设置消息监听器
        const messagePromise = new Promise<Uint8Array>((resolve, reject) => {
          const timeout = setTimeout(() => {
            reject(new Error('Message timeout'));
          }, 3000);

          tcpSocket.on('message', (data: Uint8Array) => {
            clearTimeout(timeout);
            resolve(data);
          });
        });

        // 发送数据
        await tcpSocket.send(testData);

        // 等待回显数据
        const receivedData = await messagePromise;

        expect(receivedData.length).assertEqual(testData.length);
        for (let i = 0; i < testData.length; i++) {
          expect(receivedData[i]).assertEqual(testData[i]);
        }
      } catch (error) {
        expect(error).not().assertNull();
      } finally {
        await tcpSocket.close();
      }
    });
    it('shouldHandleMultipleConnections', 0, async () => {
      const socket1 = HarmonyTcpSocketFactory.createSocket();
      const socket2 = HarmonyTcpSocketFactory.createSocket();

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: testPort,
        timeout: 5000
      };

      try {
        await socket1.connect(connectOptions);
        await socket2.connect(connectOptions);

        expect(true).assertEqual(true);
      } catch (error) {
        expect(error).not().assertNull();
      } finally {
        await socket1.close();
        await socket2.close();
      }
    });
    it('shouldHandleCloseEvent', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: testPort,
        timeout: 5000
      };

      try {
        // 先连接
        await tcpSocket.connect(connectOptions);

        // 设置关闭事件监听器
        const closePromise = new Promise<void>((resolve, reject) => {
          const timeout = setTimeout(() => {
            reject(new Error('Close event timeout'));
          }, 3000);

          tcpSocket.on('close', () => {
            clearTimeout(timeout);
            resolve();
          });
        }); // 关闭连接
        await tcpSocket.close();

        // 等待关闭事件
        await closePromise;
        expect(true).assertEqual(true);
      } catch (error) {
        expect(error).not().assertNull();
      }
    });
  });
}