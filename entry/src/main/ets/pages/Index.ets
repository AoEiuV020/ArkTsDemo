import router from '@ohos.router';

@Entry
@ComponentV2
struct Index {
  build() {
    Column() {
      Text('主页')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      Button('Simple')
        .width(200)
        .height(50)
        .margin({ bottom: 20 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/Simple'
          })
        })

      Button('ProviderTestPage')
        .width(200)
        .height(50)
        .margin({ bottom: 20 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/ProviderTestPage'
          })
        })

      Button('ItemChangeExample')
        .width(200)
        .height(50)
        .margin({ bottom: 20 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/ItemChangeExample'
          })
        })

      Button('进入列表测试页')
        .width(200)
        .height(50)
        .margin({ bottom: 20 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/ListTestPage'
          })
        })

      Button('LazyForEach 真懒加载')
        .width(200)
        .height(50)
        .margin({ bottom: 20 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/LazyForEachTestPage'
          })
        })

      Button('性能对比测试')
        .width(200)
        .height(50)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/PerformanceComparisonPage'
          })
        })

      Button('Repeat 虚拟滚动')
        .width(200)
        .height(50)
        .margin({ top: 20 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/RepeatVirtualScrollTestPage'
          })
        })
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .height('100%')
    .width('100%')
  }
}