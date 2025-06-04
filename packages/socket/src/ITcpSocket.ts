import { TcpConnectOptions } from './TcpConnectOptions';

/**
 * TCP Socket抽象接口
 * 封装底层socket操作，便于测试和平台适配
 */
export interface ITcpSocket {
  /**
   * 连接到指定地址
   * @param options 连接选项
   */
  connect(options: TcpConnectOptions): Promise<void>;
  /**
   * 发送数据
   * @param data 要发送的数据
   */
  send(data: Uint8Array): Promise<void>;

  /**
   * 关闭连接
   */
  close(): Promise<void>;

  /**
   * 监听连接事件
   * @param event 事件名
   * @param callback 回调函数
   */
  on(event: 'connect', callback: () => void): void;

  /**
   * 监听消息事件
   * @param event 事件名
   * @param callback 回调函数
   */
  on(event: 'message', callback: (data: Uint8Array) => void): void;

  /**
   * 监听关闭事件
   * @param event 事件名
   * @param callback 回调函数
   */
  on(event: 'close', callback: () => void): void;

  /**
   * 监听错误事件
   * @param event 事件名
   * @param callback 回调函数
   */
  on(event: 'error', callback: (error: Error) => void): void;
}
