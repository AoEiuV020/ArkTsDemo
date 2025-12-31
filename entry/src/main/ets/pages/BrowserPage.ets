import { webview } from '@kit.ArkWeb'

@ComponentV2
export struct BrowserPage {
  @Require @Param url: string
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
