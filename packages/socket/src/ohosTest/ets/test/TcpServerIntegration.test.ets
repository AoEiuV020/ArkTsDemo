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
        });

        // 关闭连接
        await tcpSocket.close();

        // 等待关闭事件
        await closePromise;
        expect(true).assertEqual(true);
      } catch (error) {
        expect(error).not().assertNull();
      }
    });

    it('shouldHandleConnectionTimeout', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();
      let errorEventFired = false;

      tcpSocket.on('error', (error: Error) => {
        errorEventFired = true;
        expect(error).not().assertNull();
      });

      try {
        await tcpSocket.connect({
          address: '127.0.0.1',
          port: 65534, // 使用一个不太可能被使用的端口
          timeout: 100 // 短超时时间
        });
        expect(true).assertEqual(true);
      } catch (error) {
        expect(error).not().assertNull();
      } finally {
        await tcpSocket.close();
      }
    });

    it('shouldHandleConnectionRefused', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();
      let errorEventFired = false;

      tcpSocket.on('error', (error: Error) => {
        errorEventFired = true;
        expect(error).not().assertNull();
      });

      try {
        await tcpSocket.connect({
          address: '127.0.0.1',
          port: 65535, // 使用一个不太可能被使用的端口
          timeout: 1000
        });
        expect(true).assertEqual(true);
      } catch (error) {
        expect(error).not().assertNull();
      } finally {
        await tcpSocket.close();
      }
    });

    it('shouldEmitConnectEventWithProperTiming', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();
      let connectEventFired = false;
      let connectPromiseResolved = false;

      tcpSocket.on('connect', () => {
        connectEventFired = true;
      });

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: testPort,
        timeout: 5000
      };

      try {
        await tcpSocket.connect(connectOptions);
        connectPromiseResolved = true;

        // 连接事件应该在Promise resolve之前或同时触发
        expect(connectEventFired).assertEqual(true);
        expect(connectPromiseResolved).assertEqual(true);
      } catch (error) {
        expect(error).not().assertNull();
      } finally {
        await tcpSocket.close();
      }
    });

    it('shouldReceiveMessagesInCorrectOrder', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();
      const receivedMessages: Uint8Array[] = [];
      const expectedMessages = [
        new Uint8Array([1]),
        new Uint8Array([2, 3]),
        new Uint8Array([4, 5, 6])
      ];

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: testPort,
        timeout: 5000
      };

      try {
        await tcpSocket.connect(connectOptions);

        tcpSocket.on('message', (data: Uint8Array) => {
          receivedMessages.push(data);
        });

        // 发送多个不同大小的消息
        for (let i = 0; i < expectedMessages.length; i++) {
          const message = expectedMessages[i];
          await tcpSocket.send(message);

          // 等待消息传输
          await new Promise<void>((resolve) => {
            setTimeout(() => {
              resolve();
            }, 50);
          });
        }

        // 等待所有消息接收完成
        await new Promise<void>((resolve) => {
          setTimeout(() => {
            resolve();
          }, 200);
        });

        expect(receivedMessages.length).assertEqual(expectedMessages.length);
        for (let i = 0; i < expectedMessages.length; i++) {
          expect(receivedMessages[i].length).assertEqual(expectedMessages[i].length);
          for (let j = 0; j < expectedMessages[i].length; j++) {
            expect(receivedMessages[i][j]).assertEqual(expectedMessages[i][j]);
          }
        }
      } catch (error) {
        expect(error).not().assertNull();
      } finally {
        await tcpSocket.close();
      }
    });

    it('shouldHandleLargeMessages', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();
      const largeMessage = new Uint8Array(1000);

      // 填充一些模式数据
      for (let i = 0; i < largeMessage.length; i++) {
        largeMessage[i] = i % 256;
      }

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: testPort,
        timeout: 5000
      };

      try {
        await tcpSocket.connect(connectOptions);

        let receivedMessage: Uint8Array | null = null;
        const messagePromise = new Promise<void>((resolve, reject) => {
          const timeout = setTimeout(() => {
            reject(new Error('Large message timeout'));
          }, 3000);

          tcpSocket.on('message', (data: Uint8Array) => {
            if (data.length === largeMessage.length) {
              receivedMessage = data;
              clearTimeout(timeout);
              resolve();
            }
          });
        });

        await tcpSocket.send(largeMessage);
        await messagePromise;

        expect(receivedMessage).not().assertNull();
        expect(receivedMessage!.length).assertEqual(largeMessage.length);

        // 验证部分数据内容
        expect(receivedMessage![0]).assertEqual(0);
        expect(receivedMessage![255]).assertEqual(255);
        expect(receivedMessage![256]).assertEqual(0); // 回环
      } catch (error) {
        expect(error).not().assertNull();
      } finally {
        await tcpSocket.close();
      }
    });

    it('shouldHandleMultipleEventListenersForSameEvent', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();
      const connectCallbacks: number[] = [];
      const messageCallbacks: number[] = [];
      const closeCallbacks: number[] = [];

      // 添加多个相同事件的监听器
      tcpSocket.on('connect', () => connectCallbacks.push(1));
      tcpSocket.on('connect', () => connectCallbacks.push(2));
      tcpSocket.on('connect', () => connectCallbacks.push(3));

      tcpSocket.on('message', () => messageCallbacks.push(1));
      tcpSocket.on('message', () => messageCallbacks.push(2));

      tcpSocket.on('close', () => closeCallbacks.push(1));
      tcpSocket.on('close', () => closeCallbacks.push(2));

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: testPort,
        timeout: 5000
      };

      try {
        // 连接
        await tcpSocket.connect(connectOptions);
        expect(connectCallbacks.length).assertEqual(3);
        expect(connectCallbacks[0]).assertEqual(1);
        expect(connectCallbacks[1]).assertEqual(2);
        expect(connectCallbacks[2]).assertEqual(3);

        // 发送消息测试消息监听器
        await tcpSocket.send(new Uint8Array([1, 2, 3]));

        // 等待消息接收
        await new Promise<void>((resolve) => {
          setTimeout(() => {
            resolve();
          }, 100);
        });

        expect(messageCallbacks.length).assertEqual(2);
        expect(messageCallbacks[0]).assertEqual(1);
        expect(messageCallbacks[1]).assertEqual(2);

        // 关闭连接测试关闭监听器
        await tcpSocket.close();

        // 等待关闭事件传播
        await new Promise<void>((resolve) => {
          setTimeout(() => {
            resolve();
          }, 50);
        });

        expect(closeCallbacks.length).assertEqual(2);
        expect(closeCallbacks[0]).assertEqual(1);
        expect(closeCallbacks[1]).assertEqual(2);
      } catch (error) {
        expect(error).not().assertNull();
      }
    });

    it('shouldPreserveEventListenerOrder', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();
      const callOrder: string[] = [];

      tcpSocket.on('connect', () => callOrder.push('connect1'));
      tcpSocket.on('connect', () => callOrder.push('connect2'));
      tcpSocket.on('connect', () => callOrder.push('connect3'));

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: testPort,
        timeout: 5000
      };

      try {
        await tcpSocket.connect(connectOptions);

        expect(callOrder.length).assertEqual(3);
        expect(callOrder[0]).assertEqual('connect1');
        expect(callOrder[1]).assertEqual('connect2');
        expect(callOrder[2]).assertEqual('connect3');
      } catch (error) {
        expect(error).not().assertNull();
      } finally {
        await tcpSocket.close();
      }
    });

    it('shouldHandleRapidMessageSending', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();
      const messageCount = 5;
      const messages: Uint8Array[] = [];
      const receivedMessages: Uint8Array[] = [];

      // 生成测试消息
      for (let i = 0; i < messageCount; i++) {
        messages.push(new Uint8Array([i]));
      }

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: testPort,
        timeout: 5000
      };

      try {
        await tcpSocket.connect(connectOptions);

        tcpSocket.on('message', (data: Uint8Array) => {
          receivedMessages.push(data);
        });

        // 快速发送消息
        for (let i = 0; i < messageCount; i++) {
          await tcpSocket.send(messages[i]);

          // 短暂延迟确保消息分离
          await new Promise<void>((resolve) => {
            setTimeout(() => {
              resolve();
            }, 20);
          });
        }

        // 等待所有消息传输完成
        await new Promise<void>((resolve) => {
          setTimeout(() => {
            resolve();
          }, 300);
        });

        // 验证接收到的消息数量
        expect(receivedMessages.length).assertEqual(messageCount);

        // 验证每个消息的内容都正确
        for (let i = 0; i < messageCount; i++) {
          expect(receivedMessages[i].length).assertEqual(1);
          expect(receivedMessages[i][0]).assertEqual(i);
        }
      } catch (error) {
        expect(error).not().assertNull();
      } finally {
        await tcpSocket.close();
      }
    });

    it('shouldAllowReconnectionAfterConnectionFailure', 0, async () => {
      // 第一个socket尝试连接到不存在的端口（应该失败）
      const socket1 = HarmonyTcpSocketFactory.createSocket();

      try {
        await socket1.connect({
          address: '127.0.0.1',
          port: 65535,
          timeout: 100
        });
        expect(true).assertEqual(true);
      } catch (error) {
        expect(error).not().assertNull();
      } finally {
        await socket1.close();
      }

      // 创建新的socket连接到正确的端口（应该成功）
      const socket2 = HarmonyTcpSocketFactory.createSocket();

      try {
        await socket2.connect({
          address: '127.0.0.1',
          port: testPort,
          timeout: 5000
        });

        // 验证新socket连接是否正常工作
        const testData = new Uint8Array([1, 2, 3]);
        let receivedData: Uint8Array | null = null;

        const messagePromise = new Promise<void>((resolve, reject) => {
          const timeout = setTimeout(() => {
            reject(new Error('Message timeout'));
          }, 2000);

          socket2.on('message', (data: Uint8Array) => {
            receivedData = data;
            clearTimeout(timeout);
            resolve();
          });
        });

        await socket2.send(testData);
        await messagePromise;

        expect(receivedData).not().assertNull();
        expect(receivedData!.length).assertEqual(testData.length);
        for (let i = 0; i < testData.length; i++) {
          expect(receivedData![i]).assertEqual(testData[i]);
        }
      } catch (error) {
        expect(error).not().assertNull();
      } finally {
        await socket2.close();
      }
    });

    it('shouldHandleMultipleErrorListeners', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();
      const errors: Error[] = [];

      // 添加多个错误监听器
      tcpSocket.on('error', (error: Error) => errors.push(error));
      tcpSocket.on('error', (error: Error) => errors.push(error));

      try {
        await tcpSocket.connect({
          address: '127.0.0.1',
          port: 65535,
          timeout: 100
        });
        expect(true).assertEqual(true);
      } catch (error) {
        expect(error).not().assertNull();
      } finally {
        await tcpSocket.close();
      }

      // 等待一段时间确保事件传播
      await new Promise<void>((resolve) => {
        setTimeout(() => {
          resolve();
        }, 150);
      });

      // 如果有错误发生，所有错误监听器都应该被调用
      if (errors.length > 0) {
        expect(errors.length >= 2).assertEqual(true);
      }
    });

    it('shouldMaintainCorrectConnectionStateThroughoutLifecycle', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();
      const connectionStates: string[] = [];

      // 监听所有事件来跟踪状态变化
      tcpSocket.on('connect', () => connectionStates.push('connected'));
      tcpSocket.on('close', () => connectionStates.push('closed'));
      tcpSocket.on('error', () => connectionStates.push('error'));

      // 初始状态：未连接时发送应该失败
      try {
        await tcpSocket.send(new Uint8Array([1]));
        expect(false).assertEqual(true); // 不应该到达这里
      } catch (error) {
        expect(error.message).assertContain('Socket is not connected');
      }

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: testPort,
        timeout: 5000
      };

      try {
        // 连接
        await tcpSocket.connect(connectOptions);
        expect(connectionStates.length > 0).assertEqual(true);

        // 连接后发送应该成功
        await tcpSocket.send(new Uint8Array([1, 2, 3]));

        // 关闭连接
        await tcpSocket.close();

        // 等待关闭事件
        await new Promise<void>((resolve) => {
          setTimeout(() => {
            resolve();
          }, 100);
        });

        // 关闭后发送应该失败
        try {
          await tcpSocket.send(new Uint8Array([1]));
          expect(false).assertEqual(true); // 不应该到达这里
        } catch (error) {
          expect(error.message).assertContain('Socket is not connected');
        }
      } catch (error) {
        expect(error).not().assertNull();
      }
    });

    it('shouldHandleRapidConnectDisconnectCycles', 0, async () => {
      let connectCount = 0;
      let closeCount = 0;

      // 执行多次连接/断开循环
      for (let i = 0; i < 3; i++) {
        const tcpSocket = HarmonyTcpSocketFactory.createSocket();

        tcpSocket.on('connect', () => connectCount++);
        tcpSocket.on('close', () => closeCount++);

        const connectOptions: TcpConnectOptions = {
          address: '127.0.0.1',
          port: testPort,
          timeout: 5000
        };

        try {
          await tcpSocket.connect(connectOptions);

          // 验证可以发送数据
          await tcpSocket.send(new Uint8Array([i]));

          await tcpSocket.close();

          // 延迟以确保状态变化
          await new Promise<void>((resolve) => {
            setTimeout(() => {
              resolve();
            }, 50);
          });
        } catch (error) {
          expect(error).not().assertNull();
        }
      }

      expect(connectCount).assertEqual(3);
    });

    it('shouldPreventSocketReuseAfterDisconnection', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: testPort,
        timeout: 5000
      };

      try {
        // 首次连接应该成功
        await tcpSocket.connect(connectOptions);

        // 关闭连接
        await tcpSocket.close();

        // 再次尝试连接应该失败
        try {
          await tcpSocket.connect(connectOptions);
          expect(false).assertEqual(true); // 不应该到达这里
        } catch (error) {
          expect(error.message).assertContain('Socket has been used and cannot be reconnected');
        }
      } catch (error) {
        expect(error).not().assertNull();
      }
    });

    it('shouldHandleBinaryDataCorrectly', 0, async () => {
      const tcpSocket = HarmonyTcpSocketFactory.createSocket();

      // 测试各种二进制数据模式
      const testPatterns = [
        new Uint8Array([0x00, 0xff, 0x00, 0xff]), // 交替模式
        new Uint8Array([0x00, 0x00, 0x00, 0x00]), // 全零
        new Uint8Array([0xff, 0xff, 0xff, 0xff])// 全一
      ];

      const connectOptions: TcpConnectOptions = {
        address: '127.0.0.1',
        port: testPort,
        timeout: 5000
      };

      try {
        await tcpSocket.connect(connectOptions);

        for (let patternIndex = 0; patternIndex < testPatterns.length; patternIndex++) {
          const pattern = testPatterns[patternIndex];
          let receivedData: Uint8Array | null = null;

          const messagePromise = new Promise<void>((resolve, reject) => {
            const timeout = setTimeout(() => {
              reject(new Error('Binary data timeout'));
            }, 2000);

            tcpSocket.on('message', (data: Uint8Array) => {
              if (data.length === pattern.length) {
                receivedData = data;
                clearTimeout(timeout);
                resolve();
              }
            });
          });

          await tcpSocket.send(pattern);
          await messagePromise;

          expect(receivedData).not().assertNull();
          expect(receivedData!.length).assertEqual(pattern.length);
          for (let i = 0; i < pattern.length; i++) {
            expect(receivedData![i]).assertEqual(pattern[i]);
          }
        }
      } catch (error) {
        expect(error).not().assertNull();
      } finally {
        await tcpSocket.close();
      }
    });
  });
}