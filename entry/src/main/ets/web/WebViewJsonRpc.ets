import {
  JSONRPCClient,
  JSONRPCParams,
  JSONRPCServer,
  JSONRPCServerAndClient,
  SendRequest,
  SimpleJSONRPCMethod,
} from '@aoeiuv020/json_rpc_2'
import { WebViewBridge } from './WebViewBridge'

const TAG = '[WebViewJsonRpc]'

/**
 * WebView JSON-RPC封装
 * 基于WebViewBridge实现JSON-RPC协议
 */
export class WebViewJsonRpc {
  private bridge: WebViewBridge
  private serverAndClient: JSONRPCServerAndClient

  constructor(bridge: WebViewBridge) {
    this.bridge = bridge

    const server = new JSONRPCServer()
    const sendRequest: SendRequest<void> = (payload: object) => {
      const message = JSON.stringify(payload)
      return this.bridge.send(message)
    }
    const client = new JSONRPCClient(sendRequest)

    this.serverAndClient = new JSONRPCServerAndClient(server, client)

    // 设置消息接收回调
    this.bridge.setMessageCallback((message) => this.onMessage(message))
  }

  /** 注册RPC方法 */
  registerMethod(
    name: string,
    handler: SimpleJSONRPCMethod,
  ): void {
    this.serverAndClient.addMethod(name, handler)
  }

  /** 取消注册RPC方法 */
  unregisterMethod(name: string): void {
    this.serverAndClient.removeMethod(name)
  }

  /** 发送RPC请求 */
  async sendRequest<T>(method: string, params?: JSONRPCParams): Promise<T> {
    return this.serverAndClient.request(method, params) as Promise<T>
  }

  /** 发送RPC通知 */
  sendNotification(method: string, params?: JSONRPCParams): void {
    this.serverAndClient.notify(method, params)
  }

  /** 销毁并拒绝所有等待中的请求 */
  destroy(): void {
    this.serverAndClient.rejectAllPendingRequests('连接已关闭')
  }

  private onMessage(message: string): void {
    try {
      const data: object = JSON.parse(message)
      if (data && typeof data === 'object') {
        this.serverAndClient.receiveAndSend(data)
      }
    } catch (error) {
      console.error(`${TAG} 无效的JSON RPC消息: ${message}`, error)
    }
  }
}
