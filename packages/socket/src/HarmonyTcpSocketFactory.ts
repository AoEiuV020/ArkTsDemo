import { Emitter } from '@yyz116/emitter';
import socket from '@ohos.net.socket';
import { ITcpSocket } from './ITcpSocket';
import { TcpConnectOptions } from './TcpConnectOptions';

// 定义事件类型
interface SocketEvents {
  connect: () => void;
  message: (data: Uint8Array) => void;
  close: () => void;
  error: (error: Error) => void;
}

/**
 * 鸿蒙 TCP Socket 适配器
 * 将鸿蒙的 socket API 适配为 ITcpSocket 接口
 */
export class HarmonyTcpSocketAdapter
  extends Emitter<SocketEvents, SocketEvents>
implements ITcpSocket {
  private socket: socket.TCPSocket;
  private isConnected: boolean = false;

  constructor() {
    super();
    this.socket = socket.constructTCPSocketInstance();
    this.setupEventHandlers();
  }

  /**
   * 封装 once 方法，因为鸿蒙 socket 没有 once 方法
   * 需要根据具体事件类型进行处理
   */
  private socketOnce(event: 'connect', callback: () => void): void;

  private socketOnce(
    event: 'message',
    callback: (value: socket.SocketMessageInfo) => void,
  ): void;

  private socketOnce(event: 'close', callback: () => void): void;

  private socketOnce(event: 'error', callback: (error: any) => void): void;

  private socketOnce(event: string, callback: Function): void {
    switch (event) {
      case 'connect': {
        const onceWrapper = () => {
          this.socket.off('connect', onceWrapper);
          callback();
        };
        this.socket.on('connect', onceWrapper);
        break;
      }
      case 'message': {
        const onceWrapper = (value: socket.SocketMessageInfo) => {
          this.socket.off('message', onceWrapper);
          callback(value);
        };
        this.socket.on('message', onceWrapper);
        break;
      }
      case 'close': {
        const onceWrapper = () => {
          this.socket.off('close', onceWrapper);
          callback();
        };
        this.socket.on('close', onceWrapper);
        break;
      }
      case 'error': {
        const onceWrapper = (error: any) => {
          this.socket.off('error', onceWrapper);
          callback(error);
        };
        this.socket.on('error', onceWrapper);
        break;
      }
      default:
        throw new Error(`Unsupported event type: ${event}`);
    }
  }

  private setupEventHandlers(): void {
    this.socket.on('connect', () => {
      this.isConnected = true;
      super.emit('connect');
    });

    this.socket.on('message', (value: socket.SocketMessageInfo) => {
      // 将接收到的数据转换为 Uint8Array
      const uint8Array = new Uint8Array(value.message as ArrayBuffer);
      super.emit('message', uint8Array);
    });

    this.socket.on('close', () => {
      this.isConnected = false;
      super.emit('close');
    });

    this.socket.on('error', (error: any) => {
      super.emit('error', new Error(error.message || 'Socket error'));
    });
  }

  async connect(options: TcpConnectOptions): Promise<void> {
    if (this.isConnected) {
      return;
    }

    const connectOptions: socket.TCPConnectOptions = {
      address: {
        address: options.address,
        port: options.port,
      },
      timeout: options.timeout,
    };

    await this.socket.connect(connectOptions);
    this.isConnected = true;
    super.emit('connect');

  }

  async send(data: Uint8Array): Promise<void> {
    return new Promise((resolve, reject) => {
      if (!this.isConnected) {
        reject(new Error('Socket is not connected'));
        return;
      }

      const sendOptions: socket.TCPSendOptions = {
        data: data.buffer,
      };

      this.socket.send(sendOptions, (error?: any) => {
        if (error) {
          reject(new Error(error.message || 'Send failed'));
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

      this.socketOnce('close', () => {
        resolve();
      });

      this.socket.close();
    });
  }
}

/**
 * 鸿蒙 TCP Socket 工厂
 * 提供创建鸿蒙 socket 实例的工厂方法
 */
export class HarmonyTcpSocketFactory {
  /**
   * 创建鸿蒙 TCP Socket 实例
   * @returns 鸿蒙 TCP Socket 实例
   */
  public static createSocket(): ITcpSocket {
    return new HarmonyTcpSocketAdapter();
  }

  /**
   * 创建适配器工厂函数
   * 返回一个工厂函数，用于 TcpConnection 构造函数
   * @returns Socket 工厂函数
   */
  public static createSocketFactory(): () => ITcpSocket {
    return () => HarmonyTcpSocketFactory.createSocket();
  }
}
