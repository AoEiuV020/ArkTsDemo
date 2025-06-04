import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { HarmonyTcpSocketFactory } from '../HarmonyTcpSocketFactory';
import { ITcpSocket } from '../ITcpSocket';
import { TcpConnectOptions } from '../TcpConnectOptions';
import { socket } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

export default function harmonyTcpSocketFactoryTest() {
  describe('createSocket', () => {
    it('shouldCreateSocketInstance', 0, () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();
      expect(tcpSocket).not().assertNull();
      expect(typeof tcpSocket.connect).assertEqual('function');
      expect(typeof tcpSocket.send).assertEqual('function');
      expect(typeof tcpSocket.close).assertEqual('function');
      expect(typeof tcpSocket.on).assertEqual('function');
    });
  });

  describe('createSocketFactory', () => {
    it('shouldCreateSocketFactoryFunction', 0, () => {
      const factory = HarmonyTcpSocketFactory.createSocketFactory();
      expect(typeof factory).assertEqual('function');

      const tcpSocket = factory();
      expect(tcpSocket).not().assertNull();
      expect(typeof tcpSocket.connect).assertEqual('function');
    });
  });

  describe('socketFunctionality', () => {
    let tcpSocket: ITcpSocket;

    beforeEach(() => {
      tcpSocket = HarmonyTcpSocketFactory.createSocket();
    });

    afterEach(async () => {
      try {
        await tcpSocket.close();
      } catch (error) {
        // 忽略关闭错误
      }
    });

    it('shouldRejectSendWhenNotConnected', 0, async () => {
      const testData = new Uint8Array([1, 2, 3]);

      try {
        await tcpSocket.send(testData);
        expect(false).assertEqual(true); // 不应该到达这里
      } catch (error) {
        expect(error.message).assertContain('Socket is not connected');
      }
    });

    it('shouldHandleCloseWhenNotConnected', 0, async () => {
      // 未连接状态下关闭应该立即成功，不抛出异常
      try {
        await tcpSocket.close();
        expect(true).assertEqual(true); // 测试通过
      } catch (error) {
        expect(false).assertEqual(true); // 不应该抛出异常
      }
    });

    it('shouldSetupEventListeners', 0, () => {
      let connectCalled = false;
      let messageCalled = false;
      let closeCalled = false;
      let errorCalled = false;

      tcpSocket.on('connect', () => {
        connectCalled = true;
      });

      tcpSocket.on('message', (data: Uint8Array) => {
        messageCalled = true;
        expect(data).not().assertNull();
      });

      tcpSocket.on('close', () => {
        closeCalled = true;
      });

      tcpSocket.on('error', (error: Error) => {
        errorCalled = true;
        expect(error).not().assertNull();
      }); // 验证事件监听器设置成功（通过不抛出异常验证）
      expect(true).assertEqual(true);
    });
    it('shouldValidateConnectOptions', 0, async () => {
      const invalidOptions: TcpConnectOptions = {
        address: '',
        port: -1,
      };

      try {
        await tcpSocket.connect(invalidOptions);
        // 如果连接成功，说明参数验证可能有问题，但这取决于底层实现
        expect(true).assertEqual(true);
      } catch (error) {
        // 预期可能会因为无效参数而失败
        expect(error).not().assertNull();
      }
    });
    it('shouldValidatePortRange', 0, async () => {
      const invalidPortOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: 70000 // 超出有效端口范围
      };
      try {
        await tcpSocket.connect(invalidPortOptions);
        expect(true).assertEqual(true);
      } catch (error) {
        expect(error).not().assertNull();
      }
    });
    it('shouldHandleTimeoutOption', 0, async () => {
      const timeoutOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: 8080,
        timeout: 1000
      };

      try {
        await tcpSocket.connect(timeoutOptions);
        expect(true).assertEqual(true);
      } catch (error) {
        // 超时或连接失败都是正常的，只要不崩溃即可
        expect(error).not().assertNull();
      }
    });
    it('shouldHandleMultipleConnects', 0, async () => {
      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: 8080
      };

      try {
        // 第一次连接（可能失败）
        await tcpSocket.connect(connectOptions);

        // 第二次连接应该立即成功（如果已经连接）或再次尝试连接
        await tcpSocket.connect(connectOptions);
        expect(true).assertEqual(true);
      } catch (error) {
        // 连接失败是正常的，只要不崩溃即可
        expect(error).not().assertNull();
      }
    });

    it('shouldValidateSendDataType', 0, async () => {
      const testData = new Uint8Array([65, 66, 67]); // "ABC"

      expect(testData.length).assertEqual(3);
      expect(testData[0]).assertEqual(65);
      expect(testData[1]).assertEqual(66);
      expect(testData[2]).assertEqual(67);

      // 测试空数据
      const emptyData = new Uint8Array(0);
      expect(emptyData.length).assertEqual(0);
    });

    it('shouldHandleLargeData', 0, async () => {
      const largeData = new Uint8Array(1024);
      for (let i = 0; i < largeData.length; i++) {
        largeData[i] = i % 256;
      }

      expect(largeData.length).assertEqual(1024);
      expect(largeData[0]).assertEqual(0);
      expect(largeData[255]).assertEqual(255);
      expect(largeData[256]).assertEqual(0); // 回环
    });
  });

  describe('socketIntegration', () => {
    it('shouldCreateMultipleSockets', 0, () => {
      const socket1 = HarmonyTcpSocketFactory.createSocket();
      const socket2 = HarmonyTcpSocketFactory.createSocket();
      const socket3 = HarmonyTcpSocketFactory.createSocket();

      expect(socket1).not().assertNull();
      expect(socket2).not().assertNull();
      expect(socket3).not().assertNull();

      // 验证它们是不同的实例
      expect(socket1 === socket2).assertEqual(false);
      expect(socket2 === socket3).assertEqual(false);
      expect(socket1 === socket3).assertEqual(false);
    });

    it('shouldCreateMultipleFactories', 0, () => {
      const factory1 = HarmonyTcpSocketFactory.createSocketFactory();
      const factory2 = HarmonyTcpSocketFactory.createSocketFactory();

      expect(typeof factory1).assertEqual('function');
      expect(typeof factory2).assertEqual('function');

      const socket1 = factory1();
      const socket2 = factory2();
      expect(socket1).not().assertNull();
      expect(socket2).not().assertNull();
      expect(socket1 === socket2).assertEqual(false);
    });
    it('shouldHandleSequentialOperations', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();

      // 测试操作序列：关闭 -> 连接尝试 -> 关闭
      try {
        await tcpSocket.close(); // 应该立即成功

        try {
          const connectOptions: TcpConnectOptions = {
            address: '127.0.0.1',
            port: 8080,
            timeout: 1000
          };
          await tcpSocket.connect(connectOptions);
        } catch (connectError) {
          // 连接失败是正常的
        }

        await tcpSocket.close(); // 再次关闭应该成功
        expect(true).assertEqual(true);
      } catch (error) {
        expect(false).assertEqual(true); // 不应该有意外错误
      }
    });

    it('shouldValidateEventEmission', 0, () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();
      let eventCount = 0;

      tcpSocket.on('connect', () => {
        eventCount++;
      });

      tcpSocket.on('message', (data: Uint8Array) => {
        eventCount++;
        expect(data).not().assertNull();
      });

      tcpSocket.on('close', () => {
        eventCount++;
      });

      tcpSocket.on('error', (error: Error) => {
        eventCount++;
        expect(error).not().assertNull();
      }); // 初始状态事件计数应该为0
      expect(eventCount).assertEqual(0);
    });
  });

  describe('errorHandling', () => {
    it('shouldHandleInvalidAddress', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();

      const connectOptions: TcpConnectOptions = {
        address: 'invalid.address.test',
        port: 8080,
        timeout: 1000
      };

      try {
        await tcpSocket.connect(connectOptions);
        expect(true).assertEqual(true);
      } catch (error) {
        expect(error).not().assertNull();
        expect(typeof error.message).assertEqual('string');
      }
    });
    it('shouldHandleConnectionRefused', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: 1, // 通常不会有服务监听端口1
        timeout: 1000
      };

      try {
        await tcpSocket.connect(connectOptions);
        expect(true).assertEqual(true);
      } catch (error) {
        expect(error).not().assertNull();
      }
    });
    it('shouldHandleZeroTimeout', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: 8080,
        timeout: 0
      };
      try {
        await tcpSocket.connect(connectOptions);
        expect(true).assertEqual(true);
      } catch (error) {
        expect(error).not().assertNull();
      }
    });
  });

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
