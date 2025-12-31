import { webview } from '@kit.ArkWeb'
import { CorsInterceptor } from '../web'

/** 从 URL 中提取 origin */
function extractOrigin(url: string): string {
  const match = url.match(/^(https?:\/\/[^/]+)/)
  return match ? match[1] : url
}

/** 浏览器页面参数 */
export interface BrowserPageParams {
  url: string
  enableCors?: boolean
}

@ComponentV2
export struct BrowserPage {
  @Require @Param url: string
  /** 是否启用 CORS 代理 */
  @Param enableCors: boolean = false
  controller: webview.WebviewController = new webview.WebviewController()
  navPathStack: NavPathStack = new NavPathStack()

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
            if (this.enableCors) {
              const origin = extractOrigin(this.url)
              new CorsInterceptor(this.controller, origin).enable()
            }
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
      }
      .width('100%')
      .height('100%')
    }
    .hideTitleBar(true)
    .onReady((context) => {
      this.navPathStack = context.pathStack
    })
  }
}

