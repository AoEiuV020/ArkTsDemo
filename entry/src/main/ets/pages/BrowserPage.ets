import { webview } from '@kit.ArkWeb'
import { buffer } from '@kit.ArkTS'
import { CorsInterceptor } from '../web'

const TAG = '[BrowserPage]'

/** 原生宿主注入到JS的对象名称 */
const HOST_BRIDGE_NAME = 'WebViewHostBridge'

/** 从 URL 中提取 origin */
function extractOrigin(url: string): string {
  const match = url.match(/^(https?:\/\/[^/]+)/)
  return match ? match[1] : url
}

/** 浏览器页面参数 */
export interface BrowserPageParams {
  url: string
  enableCors?: boolean
  /** 需要代理的路径匹配模式，如 /api/ */
  corsPattern?: string
}

/** JS注入对象，用于接收Web消息 */
class NativeBridgeObject {
  controller: webview.WebviewController

  constructor(controller: webview.WebviewController) {
    this.controller = controller
  }

  /** Web调用此方法向原生发送消息 */
  postMessage(message: string): void {
    console.info(`${TAG} [NativeBridge] 收到Web消息: ${message}`)
  }
}

@ComponentV2
export struct BrowserPage {
  @Require @Param url: string
  /** 是否启用 CORS 代理 */
  @Param enableCors: boolean = false
  /** 需要代理的路径匹配模式 */
  @Param corsPattern: string = '/api/'
  controller: webview.WebviewController = new webview.WebviewController()
  navPathStack: NavPathStack = new NavPathStack()
  private corsInterceptor?: CorsInterceptor
  private nativeBridgeObject?: NativeBridgeObject

  aboutToAppear(): void {
    console.info(`${TAG} aboutToAppear url=${this.url} enableCors=${this.enableCors}`)
  }

  aboutToDisappear(): void {
    console.info(`${TAG} aboutToDisappear`)
    this.corsInterceptor?.disable()
    // 取消注册JS代理对象
    if (this.nativeBridgeObject) {
      this.controller.deleteJavaScriptRegister(HOST_BRIDGE_NAME)
      console.info(`${TAG} 已取消注册 ${HOST_BRIDGE_NAME} 对象`)
    }
  }

  build() {
    NavDestination() {
      RelativeContainer() {
        Web({ src: this.url, controller: this.controller })
          .width('100%')
          .height('100%')
          .javaScriptAccess(true)
          .domStorageAccess(true)
          .fileAccess(true)
          .imageAccess(true)
          .onlineImageAccess(true)
          .mediaPlayGestureAccess(true)
          .mixedMode(MixedMode.All)
          .zoomAccess(true)
          .geolocationAccess(true)
          .onControllerAttached(() => {
            console.info(`${TAG} onControllerAttached`)
            // 注入WebView宿主桥接对象
            this.nativeBridgeObject = new NativeBridgeObject(this.controller)
            this.controller.registerJavaScriptProxy(this.nativeBridgeObject, HOST_BRIDGE_NAME, ['postMessage'])
            console.info(`${TAG} 已注入 ${HOST_BRIDGE_NAME} 对象`)
            if (this.enableCors) {
              const origin = extractOrigin(this.url)
              console.info(`${TAG} 启用 CORS 拦截，origin=${origin} pattern=${this.corsPattern}`)
              this.corsInterceptor = new CorsInterceptor(this.controller, origin, this.corsPattern)
              this.corsInterceptor.enable()
            }
          })
          .onPageBegin((event) => {
            console.info(`${TAG} onPageBegin url=${event.url}`)
          })
          .onPageEnd((event) => {
            console.info(`${TAG} onPageEnd url=${event.url}`)
          })
          .onProgressChange((event) => {
            console.info(`${TAG} onProgressChange progress=${event.newProgress}`)
          })
          .onErrorReceive((event) => {
            console.error(`${TAG} onErrorReceive code=${event.error.getErrorCode()} msg=${event.error.getErrorInfo()} url=${event.request.getRequestUrl()}`)
          })
          .onHttpErrorReceive((event) => {
            console.error(`${TAG} onHttpErrorReceive code=${event.response.getResponseCode()} url=${event.request.getRequestUrl()}`)
          })
          .onConsole((event) => {
            console.info(`${TAG} onConsole [${event.message.getMessageLevel()}] ${event.message.getMessage()}`)
            return false
          })

        Button('←')
          .id('backBtn')
          .width(40)
          .height(40)
          .fontSize(20)
          .backgroundColor('#80000000')
          .fontColor('#FFFFFF')
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })
          .margin({ top: 20, left: 20 })
          .onClick(() => {
            this.navPathStack.pop()
          })

        Button('⟳')
          .id('refreshBtn')
          .width(40)
          .height(40)
          .fontSize(20)
          .backgroundColor('#80000000')
          .fontColor('#FFFFFF')
          .alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            right: { anchor: '__container__', align: HorizontalAlign.End }
          })
          .margin({ bottom: 40, right: 20 })
          .onClick(() => {
            this.controller.refresh()
          })

        Button('挂断')
          .id('hangUpBtn')
          .width(60)
          .height(40)
          .fontSize(14)
          .backgroundColor('#80FF0000')
          .fontColor('#FFFFFF')
          .alignRules({
            bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
            left: { anchor: '__container__', align: HorizontalAlign.Start },
          })
          .margin({ bottom: 40, left: 20 })
          .onClick(() => {
            this.sendHangUpRequest()
          })
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .onReady((context) => {
      this.navPathStack = context.pathStack
    })
  }

  /** 发送挂断请求到Web */
  private sendHangUpRequest(): void {
    const jsonRpcRequest = '{"jsonrpc":"2.0","method":"hangUp","id":1}'
    console.info(`${TAG} 发送挂断请求: ${jsonRpcRequest}`)
    this.sendMessageToWeb(jsonRpcRequest)
  }

  /** 发送消息到Web（使用base64编码避免特殊字符问题） */
  private sendMessageToWeb(message: string): void {
    // 使用base64编码保证安全传输
    const base64Message = buffer.from(message).toString('base64')
    // JS端使用atob()解码
    this.controller.runJavaScript(`window.WebViewClientBridge && window.WebViewClientBridge.onHostMessageBase64('${base64Message}')`)
      .then((result) => {
        console.info(`${TAG} 挂断请求已发送, result=${result}`)
      })
      .catch((error: Error) => {
        console.error(`${TAG} 发送挂断请求失败: ${error.message}`)
      })
  }
}

