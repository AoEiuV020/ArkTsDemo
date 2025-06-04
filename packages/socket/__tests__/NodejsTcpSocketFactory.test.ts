import { NodejsTcpSocketFactory } from '../src/NodejsTcpSocketFactory';
import { ITcpSocket } from '../src/ITcpSocket';
import { createServer, Server } from 'net';

describe('NodejsTcpSocketFactory', () => {
  let testServer: Server;
  let testPort: number;

  beforeAll(done => {
    // 创建测试服务器
    testServer = createServer(socket => {
      // 回显服务器 - 收到数据后原样返回
      socket.on('data', data => {
        socket.write(data);
      });

      socket.on('error', error => {
        console.error('Server socket error:', error);
      });
    });

    // 监听随机端口
    testServer.listen(0, '127.0.0.1', () => {
      const address = testServer.address();
      if (address && typeof address === 'object') {
        testPort = address.port;
        done();
      } else {
        done(new Error('Failed to get server address'));
      }
    });
  });

  afterAll(done => {
    testServer.close(done);
  });

  describe('createSocket', () => {
    it('should create a socket instance', () => {
      const socket = NodejsTcpSocketFactory.createSocket();
      expect(socket).toBeDefined();
      expect(typeof socket.connect).toBe('function');
      expect(typeof socket.send).toBe('function');
      expect(typeof socket.close).toBe('function');
      expect(typeof socket.on).toBe('function');
    });
  });

  describe('createSocketFactory', () => {
    it('should create a socket factory function', () => {
      const factory = NodejsTcpSocketFactory.createSocketFactory();
      expect(typeof factory).toBe('function');

      const socket = factory();
      expect(socket).toBeDefined();
      expect(typeof socket.connect).toBe('function');
    });
  });

  describe('Socket functionality', () => {
    let socket: ITcpSocket;

    beforeEach(() => {
      socket = NodejsTcpSocketFactory.createSocket();
    });

    afterEach(async () => {
      try {
        await socket.close();
      } catch (error) {
        // 忽略关闭错误
      }
    });

    it('should connect to server successfully', async () => {
      await expect(
        socket.connect({
          address: '127.0.0.1',
          port: testPort,
          timeout: 5000,
        }),
      ).resolves.toBeUndefined();
    });

    it('should emit connect event', done => {
      socket.on('connect', () => {
        done();
      });

      socket
        .connect({
          address: '127.0.0.1',
          port: testPort,
        })
        .catch(done);
    });

    it('should send and receive data', async () => {
      const testData = new Uint8Array([1, 2, 3, 4, 5]);

      // 连接到服务器
      await socket.connect({
        address: '127.0.0.1',
        port: testPort,
      });

      // 设置消息监听器
      const messagePromise = new Promise<Uint8Array>(resolve => {
        socket.on('message', data => {
          resolve(data);
        });
      });

      // 发送数据
      await socket.send(testData);

      // 等待回显数据
      const receivedData = await messagePromise;

      expect(receivedData).toEqual(testData);
    });

    it('should reject send when not connected', async () => {
      const testData = new Uint8Array([1, 2, 3]);

      await expect(socket.send(testData)).rejects.toThrow(
        'Socket is not connected',
      );
    });

    it('should handle multiple connects gracefully', async () => {
      // 第一次连接
      await socket.connect({
        address: '127.0.0.1',
        port: testPort,
      });

      // 第二次连接应该立即成功（已经连接）
      await expect(
        socket.connect({
          address: '127.0.0.1',
          port: testPort,
        }),
      ).resolves.toBeUndefined();
    });

    it('should handle close when not connected', async () => {
      // 未连接状态下关闭应该立即成功
      await expect(socket.close()).resolves.toBeUndefined();
    });

    it('should emit close event when connection is closed', async () => {
      // 先连接
      await socket.connect({
        address: '127.0.0.1',
        port: testPort,
      });

      // 设置关闭事件监听器
      const closePromise = new Promise<void>(resolve => {
        socket.on('close', () => {
          resolve();
        });
      });

      // 关闭连接
      await socket.close();

      // 等待关闭事件
      await closePromise;
    });
  });

  describe('Integration test with echo server', () => {
    it('should work with multiple messages', async () => {
      const socket = NodejsTcpSocketFactory.createSocket();
      const messages: Uint8Array[] = [];

      // 收集所有消息
      socket.on('message', data => {
        messages.push(data);
      });

      try {
        // 连接
        await socket.connect({
          address: '127.0.0.1',
          port: testPort,
        });

        // 发送多个消息
        const testMessages = [
          new Uint8Array([1, 2, 3]),
          new Uint8Array([4, 5, 6]),
          new Uint8Array([7, 8, 9]),
        ];

        for (const msg of testMessages) {
          await socket.send(msg);
          // 稍微延迟以确保消息顺序
          await new Promise(resolve => setTimeout(resolve, 10));
        }

        // 等待所有消息返回
        await new Promise(resolve => setTimeout(resolve, 100));

        expect(messages).toHaveLength(3);
        expect(messages[0]).toEqual(testMessages[0]);
        expect(messages[1]).toEqual(testMessages[1]);
        expect(messages[2]).toEqual(testMessages[2]);
      } finally {
        await socket.close();
      }
    });
  });
});
