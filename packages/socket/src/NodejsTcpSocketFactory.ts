import { Socket } from 'net';
import { EventEmitter } from 'events';
import { ITcpSocket } from './ITcpSocket';

/**
 * Node.js TCP Socket 适配器
 * 将 Node.js 的 net.Socket 适配为 ITcpSocket 接口
 */
class NodejsTcpSocketAdapter extends EventEmitter implements ITcpSocket {
  private socket: Socket;
  private isConnected: boolean = false;

  constructor() {
    super();
    this.socket = new Socket();
    this.setupEventHandlers();
  }

  private setupEventHandlers(): void {
    this.socket.on('connect', () => {
      this.isConnected = true;
      this.emit('connect');
    });

    this.socket.on('data', (data: Buffer) => {
      // 将 Buffer 转换为 Uint8Array
      const uint8Array = new Uint8Array(data);
      this.emit('message', uint8Array);
    });

    this.socket.on('close', () => {
      this.isConnected = false;
      this.emit('close');
    });

    this.socket.on('error', (error: Error) => {
      this.emit('error', error);
    });

    this.socket.on('timeout', () => {
      this.emit('error', new Error('Connection timeout'));
    });
  }

  async connect(options: {
    address: string;
    port: number;
    timeout?: number;
  }): Promise<void> {
    return new Promise((resolve, reject) => {
      if (this.isConnected) {
        resolve();
        return;
      }

      // 设置超时
      if (options.timeout) {
        this.socket.setTimeout(options.timeout);
      }

      // 连接错误处理
      const onError = (error: Error) => {
        this.socket.removeAllListeners('connect');
        reject(error);
      };

      // 连接成功处理
      const onConnect = () => {
        this.socket.removeListener('error', onError);
        resolve();
      };

      this.socket.once('error', onError);
      this.socket.once('connect', onConnect);

      this.socket.connect(options.port, options.address);
    });
  }

  async send(data: Uint8Array): Promise<void> {
    return new Promise((resolve, reject) => {
      if (!this.isConnected) {
        reject(new Error('Socket is not connected'));
        return;
      }

      // 将 Uint8Array 转换为 Buffer
      const buffer = Buffer.from(data);

      this.socket.write(buffer, error => {
        if (error) {
          reject(error);
        } else {
          resolve();
        }
      });
    });
  }

  async close(): Promise<void> {
    return new Promise(resolve => {
      if (!this.isConnected) {
        resolve();
        return;
      }

      this.socket.once('close', () => {
        resolve();
      });

      this.socket.end();
    });
  }

  // EventEmitter 的 on 方法已经继承，满足接口要求
}

/**
 * Node.js TCP Socket 工厂
 * 提供创建 Node.js socket 实例的工厂方法
 */
export class NodejsTcpSocketFactory {
  /**
   * 创建 Node.js TCP Socket 实例
   * @returns Node.js TCP Socket 实例
   */
  public static createSocket(): ITcpSocket {
    return new NodejsTcpSocketAdapter();
  }

  /**
   * 创建适配器工厂函数
   * 返回一个工厂函数，用于 TcpConnection 构造函数
   * @returns Socket 工厂函数
   */
  public static createSocketFactory(): () => ITcpSocket {
    return () => NodejsTcpSocketFactory.createSocket();
  }
}
