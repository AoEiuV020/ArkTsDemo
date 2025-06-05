import { NodejsTcpSocketFactory } from '../src/NodejsTcpSocketFactory';

describe('NodejsTcpSocketFactory', () => {
  describe('createSocket', () => {
    it('should create a socket instance', () => {
      const socket = NodejsTcpSocketFactory.createSocket();
      expect(socket).toBeDefined();
      expect(typeof socket.connect).toBe('function');
      expect(typeof socket.send).toBe('function');
      expect(typeof socket.close).toBe('function');
      expect(typeof socket.on).toBe('function');
    });

    it('should create different socket instances each time', () => {
      const socket1 = NodejsTcpSocketFactory.createSocket();
      const socket2 = NodejsTcpSocketFactory.createSocket();
      expect(socket1).not.toBe(socket2);
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

    it('should create different socket instances from factory', () => {
      const factory = NodejsTcpSocketFactory.createSocketFactory();
      const socket1 = factory();
      const socket2 = factory();
      expect(socket1).not.toBe(socket2);
    });

    it('should create sockets with same interface as createSocket', () => {
      const directSocket = NodejsTcpSocketFactory.createSocket();
      const factory = NodejsTcpSocketFactory.createSocketFactory();
      const factorySocket = factory();

      // Both should have the same methods
      expect(typeof directSocket.connect).toBe(typeof factorySocket.connect);
      expect(typeof directSocket.send).toBe(typeof factorySocket.send);
      expect(typeof directSocket.close).toBe(typeof factorySocket.close);
      expect(typeof directSocket.on).toBe(typeof factorySocket.on);
    });
  });

  describe('Socket creation validation', () => {
    it('should create socket with proper event handling interface', () => {
      const socket = NodejsTcpSocketFactory.createSocket();

      // Should be able to add event listeners without throwing
      expect(() => {
        socket.on('connect', () => {});
        socket.on('message', () => {});
        socket.on('close', () => {});
        socket.on('error', () => {});
      }).not.toThrow();
    });

    it('should handle close when not connected', async () => {
      const socket = NodejsTcpSocketFactory.createSocket();
      // 未连接状态下关闭应该立即成功
      await expect(socket.close()).resolves.toBeUndefined();
    });

    it('should reject send when not connected', async () => {
      const socket = NodejsTcpSocketFactory.createSocket();
      const testData = new Uint8Array([1, 2, 3]);

      await expect(socket.send(testData)).rejects.toThrow(
        'Socket is not connected',
      );
    });
  });
});
