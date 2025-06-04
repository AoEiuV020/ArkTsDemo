/**
 * TCP Socket 连接选项接口
 */
export interface TcpConnectOptions {
  address: string;
  port: number;
  timeout?: number;
}
