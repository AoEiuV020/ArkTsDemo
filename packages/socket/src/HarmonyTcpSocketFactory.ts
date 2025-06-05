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
class HarmonyTcpSocketAdapter
  extends Emitter<SocketEvents, SocketEvents>
  implements ITcpSocket
{
  private socket: socket.TCPSocket;
  private isConnected: boolean = false;

  constructor() {
    super();
    this.socket = socket.constructTCPSocketInstance();
    this.setupEventHandlers();
  }

  private setupEventHandlers(): void {
    this.socket.on('message', (value: socket.SocketMessageInfo) => {
      // 将接收到的数据转换为 Uint8Array
      const uint8Array = new Uint8Array(value.message);
      super.emit('message', uint8Array);
    });

    this.socket.on('close', () => {
      if (this.isConnected) {
        this.isConnected = false;
        super.emit('close');
      }
    });

    this.socket.on('error', (error: any) => {
      super.emit('error', new Error(error.message || 'Socket error'));
    });
  }

  async connect(options: TcpConnectOptions): Promise<void> {
    if (this.isConnected) {
      throw new Error('Socket is already connected. Cannot connect again.');
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
    if (!this.isConnected) {
      throw new Error('Socket is not connected');
    }

    const sendOptions: socket.TCPSendOptions = {
      data: data.buffer,
    };

    await this.socket.send(sendOptions);
  }

  async close(): Promise<void> {
    if (!this.isConnected) {
      return;
    }
    await this.socket.close();
    if (this.isConnected) {
      this.isConnected = false;
      super.emit('close');
    }
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
