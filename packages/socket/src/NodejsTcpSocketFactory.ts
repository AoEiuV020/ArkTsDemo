import { Socket } from 'net';
import { Emitter } from '@socket.io/component-emitter';
import { ITcpSocket } from './ITcpSocket';

// 定义事件类型
interface SocketEvents {
  connect: () => void;
  message: (data: Uint8Array) => void;
  close: () => void;
  error: (error: Error) => void;
}

/**
 * Node.js TCP Socket 适配器
 * 将 Node.js 的 net.Socket 适配为 ITcpSocket 接口
 */
class NodejsTcpSocketAdapter
  extends Emitter<SocketEvents, SocketEvents>
  implements ITcpSocket
{
  private socket: Socket;
  private isConnected: boolean = false;
  private hasBeenUsed: boolean = false; // 标记是否已经被使用过

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
    this.socket.on('close', (hadError: boolean) => {
      this.isConnected = false;
      this.hasBeenUsed = true; // 标记为已使用，禁止重新连接
      this.emit('close');
    });
    this.socket.on('end', () => {
      // 当远程端结束连接时更新状态，但不重复触发close事件
      // close事件会在socket实际关闭时触发
      this.isConnected = false;
      this.hasBeenUsed = true; // 标记为已使用，禁止重新连接
    });

    this.socket.on('error', (error: Error) => {
      // 当发生错误时也要更新状态
      this.isConnected = false;
      this.hasBeenUsed = true; // 标记为已使用，禁止重新连接
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
      // 如果已经连接，直接返回
      if (this.isConnected) {
        resolve();
        return;
      }

      // 如果socket已经被使用过（连接过并断开），禁止重新连接
      if (this.hasBeenUsed) {
        reject(
          new Error(
            'Socket has been used and cannot be reconnected. Create a new socket instance.',
          ),
        );
        return;
      }

      // 标记socket开始使用
      this.hasBeenUsed = true;

      // 设置超时
      if (options.timeout) {
        this.socket.setTimeout(options.timeout);
      }

      // 连接错误处理
      const onError = (error: Error) => {
        this.socket.removeAllListeners('connect');
        this.isConnected = false;
        reject(error);
      };

      // 连接成功处理
      const onConnect = () => {
        this.socket.removeListener('error', onError);
        this.isConnected = true;
        resolve();
      };

      this.socket.once('error', onError);
      this.socket.once('connect', onConnect);

      this.socket.connect(options.port, options.address);
    });
  }
  async send(data: Uint8Array): Promise<void> {
    return new Promise((resolve, reject) => {
      if (!this.isConnected || this.socket.destroyed || !this.socket.writable) {
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
