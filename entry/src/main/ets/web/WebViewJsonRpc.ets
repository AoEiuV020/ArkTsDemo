import { webview } from '@kit.ArkWeb'
import { buffer } from '@kit.ArkTS'
import { JSONRPCClient, JSONRPCServer, JSONRPCServerAndClient, SendRequest } from '@aoeiuv020/json_rpc_2'

const TAG = '[WebViewBridge]'

/** JS注入对象名称 */
const HOST_BRIDGE_NAME = 'WebViewHostBridge'

/** 消息接收回调类型 */
export type MessageCallback = (message: string) => void

/** JS注入对象，用于接收Web消息 */
class HostBridgeObject {
  private onMessage: MessageCallback

  constructor(onMessage: MessageCallback) {
    this.onMessage = onMessage
  }

  /** Web调用此方法向原生发送消息 */
  postMessage(message: string): void {
    console.info(`${TAG} 收到Web消息: ${message}`)
    this.onMessage(message)
  }
}

/**
 * WebView桥接器
 * 封装WebView与Web端的双向通信
 */
export class WebViewBridge {
  private controller: webview.WebviewController
  private bridgeObject: HostBridgeObject
  private messageCallback?: MessageCallback
  private registered: boolean = false

  constructor(controller: webview.WebviewController) {
    this.controller = controller
    this.bridgeObject = new HostBridgeObject((message) => {
      this.messageCallback?.(message)
    })
  }

  /** 注册JS代理对象 */
  register(): void {
    if (this.registered) {
      return
    }
    this.controller.registerJavaScriptProxy(this.bridgeObject, HOST_BRIDGE_NAME, ['postMessage'])
    this.registered = true
    console.info(`${TAG} 已注册 ${HOST_BRIDGE_NAME} 对象`)
  }

  /** 取消注册JS代理对象 */
  unregister(): void {
    if (!this.registered) {
      return
    }
    this.controller.deleteJavaScriptRegister(HOST_BRIDGE_NAME)
    this.registered = false
    console.info(`${TAG} 已取消注册 ${HOST_BRIDGE_NAME} 对象`)
  }

  /** 设置消息接收回调 */
  setMessageCallback(callback: MessageCallback): void {
    this.messageCallback = callback
  }

  /** 发送消息到Web（使用base64编码避免特殊字符问题） */
  async send(message: string): Promise<void> {
    const base64Message = buffer.from(message).toString('base64')
    await this.controller.runJavaScript(
      `window.WebViewClientBridge && window.WebViewClientBridge.onHostMessageBase64('${base64Message}')`,
    )
  }
}

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
  registerMethod<TParams, TResult>(
    name: string,
    handler: (params?: TParams) => TResult | Promise<TResult>,
  ): void {
    this.serverAndClient.addMethod(name, handler as (params: object) => object)
  }

  /** 取消注册RPC方法 */
  unregisterMethod(name: string): void {
    this.serverAndClient.removeMethod(name)
  }

  /** 发送RPC请求 */
  async sendRequest<T>(method: string, params?: object): Promise<T> {
    return this.serverAndClient.request(method, params) as Promise<T>
  }

  /** 发送RPC通知 */
  sendNotification(method: string, params?: object): void {
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
