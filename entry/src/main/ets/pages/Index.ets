import { BrowserPage, BrowserPageParams } from './BrowserPage'

@Entry
@ComponentV2
struct Index {
  navPathStack: NavPathStack = new NavPathStack()
  @Local url: string = 'https://aoeiuv020.github.io/livekit_meeting/'
  @Local enableCors: boolean = true

  @Builder
  pageMap(name: string, param: ESObject) {
    if (name === 'BrowserPage') {
      BrowserPage({
        url: (param as BrowserPageParams).url,
        enableCors: (param as BrowserPageParams).enableCors,
      })
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

        Row() {
          Text('允许跨域')
            .fontSize(16)
          Toggle({ type: ToggleType.Switch, isOn: this.enableCors })
            .margin({ left: 10 })
            .onChange((isOn: boolean) => {
              this.enableCors = isOn
            })
        }
        .width('90%')
        .margin({ top: 20 })
        .justifyContent(FlexAlign.Start)

        Button('打开浏览器')
          .width('60%')
          .height(50)
          .margin({ top: 20 })
          .onClick(() => {
            const params: BrowserPageParams = { url: this.url, enableCors: this.enableCors }
            this.navPathStack.pushPath({ name: 'BrowserPage', param: params })
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