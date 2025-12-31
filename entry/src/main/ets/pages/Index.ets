import { BrowserPage } from './BrowserPage'

@Entry
@ComponentV2
struct Index {
  navPathStack: NavPathStack = new NavPathStack()
  @Local url: string = 'https://aoeiuv020.github.io/livekit_meeting/'

  @Builder
  pageMap(name: string, param: ESObject) {
    if (name === 'BrowserPage') {
      BrowserPage({ url: param as string })
    }
  }

  build() {
    Navigation(this.navPathStack) {
      Column() {
        TextInput({ text: this.url, placeholder: '请输入网址' })
          .width('90%')
          .height(50)
          .margin({ top: 100 })
          .onChange((value: string) => {
            this.url = value
          })

        Button('打开浏览器')
          .width('60%')
          .height(50)
          .margin({ top: 20 })
          .onClick(() => {
            this.navPathStack.pushPath({ name: 'BrowserPage', param: this.url })
          })
      }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Start)
    }
    .navDestination(this.pageMap)
    .hideTitleBar(true)
  }
}