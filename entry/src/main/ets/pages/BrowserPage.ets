import { webview } from '@kit.ArkWeb'
import { CorsInterceptor, WebViewBridge, WebViewJsonRpc } from '../web'

const TAG = '[BrowserPage]'

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
  private webViewBridge?: WebViewBridge
  private jsonRpc?: WebViewJsonRpc

  aboutToAppear(): void {
    console.info(`${TAG} aboutToAppear url=${this.url} enableCors=${this.enableCors}`)
  }

  aboutToDisappear(): void {
    console.info(`${TAG} aboutToDisappear`)
    this.corsInterceptor?.disable()
    this.jsonRpc?.destroy()
    this.webViewBridge?.unregister()
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
            // 初始化WebView桥接和JSON-RPC
            this.webViewBridge = new WebViewBridge(this.controller)
            this.webViewBridge.register()
            this.jsonRpc = new WebViewJsonRpc(this.webViewBridge)
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
    console.info(`${TAG} 发送挂断通知`)
    this.jsonRpc?.sendNotification('hangUp')
  }
}

