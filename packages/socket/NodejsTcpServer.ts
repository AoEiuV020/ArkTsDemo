import * as net from 'net';
import { EventEmitter } from 'events';

export class NodejsTcpServer extends EventEmitter {
  private server: net.Server;
  private isListening: boolean = false;
  private port: number;

  constructor(port: number = 8888) {
    super();
    this.port = port;
    this.server = net.createServer();
    this.setupServerEventHandlers();
  }

  private setupServerEventHandlers(): void {
    this.server.on('connection', (socket: net.Socket) => {
      console.log(`客户端连接: ${socket.remoteAddress}:${socket.remotePort}`);
      this.emit('connection', socket);

      // 设置客户端socket事件处理
      socket.on('data', (data: Buffer) => {
        console.log(`收到数据: ${data.toString()}`);
        // 直接回显收到的数据
        socket.write(data);
        this.emit('message', data, socket);
      });

      socket.on('error', (error: Error) => {
        console.error(`客户端socket错误: ${error.message}`);
        this.emit('clientError', error, socket);
      });

      socket.on('close', (hadError: boolean) => {
        console.log(`客户端断开连接，错误: ${hadError}`);
        this.emit('clientDisconnect', socket);
      });

      socket.on('timeout', () => {
        console.log('客户端连接超时');
        socket.destroy();
      });
    });

    this.server.on('error', (error: Error) => {
      console.error(`服务器错误: ${error.message}`);
      this.emit('error', error);
    });

    this.server.on('close', () => {
      console.log('服务器已关闭');
      this.isListening = false;
      this.emit('close');
    });

    this.server.on('listening', () => {
      console.log(`TCP服务器监听端口: ${this.port}`);
      this.isListening = true;
      this.emit('listening');
    });
  }

  /**
   * 启动服务器
   */
  public start(): Promise<void> {
    return new Promise((resolve, reject) => {
      if (this.isListening) {
        resolve();
        return;
      }

      this.server.listen(this.port, () => {
        resolve();
      });

      this.server.on('error', (error: Error) => {
        reject(error);
      });
    });
  }

  /**
   * 停止服务器
   */
  public stop(): Promise<void> {
    return new Promise(resolve => {
      if (!this.isListening) {
        resolve();
        return;
      }

      this.server.close(() => {
        resolve();
      });
    });
  }

  /**
   * 获取服务器状态
   */
  public getStatus(): {
    isListening: boolean;
    port: number;
    address?: string;
  } {
    const address = this.server.address();
    return {
      isListening: this.isListening,
      port: this.port,
      address: typeof address === 'string' ? address : address?.address,
    };
  }

  /**
   * 获取当前连接数
   */
  public getConnectionCount(): Promise<number> {
    return new Promise((resolve, reject) => {
      this.server.getConnections((error, count) => {
        if (error) {
          reject(error);
        } else {
          resolve(count);
        }
      });
    });
  }
}

// 创建服务器实例的工厂函数
export function createTcpServer(port: number = 8888): NodejsTcpServer {
  return new NodejsTcpServer(port);
}

// 如果直接运行此文件，启动服务器
if (require.main === module) {
  const server = createTcpServer(8888);

  server.on('listening', () => {
    console.log('TCP回显服务器启动成功');
  });

  server.on('message', (data: Buffer, socket: net.Socket) => {
    console.log(
      `收到来自 ${socket.remoteAddress}:${socket.remotePort} 的消息: ${data.toString()}`,
    );
  });

  server.on('error', (error: Error) => {
    console.error('服务器启动失败:', error.message);
    process.exit(1);
  });

  server.start().catch(error => {
    console.error('无法启动服务器:', error.message);
    process.exit(1);
  });

  // 优雅关闭
  process.on('SIGINT', async () => {
    console.log('\n正在关闭服务器...');
    await server.stop();
    console.log('服务器已关闭');
    process.exit(0);
  });

  process.on('SIGTERM', async () => {
    console.log('\n正在关闭服务器...');
    await server.stop();
    console.log('服务器已关闭');
    process.exit(0);
  });
}
