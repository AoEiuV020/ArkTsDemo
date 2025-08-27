import router from '@ohos.router';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Text('主页')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      Button('进入列表测试页')
        .width(200)
        .height(50)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/ListTestPage'
          })
        })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .height('100%')
    .width('100%')
  }
}