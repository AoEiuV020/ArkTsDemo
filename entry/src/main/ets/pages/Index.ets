import { router } from '@kit.ArkUI'
import { hilog } from '@kit.PerformanceAnalysisKit'
import type { SelectedLocation } from './MapSelectPage'

const DOMAIN = 0x0000

/**
 * 页面路由参数
 */
interface PageParams {
  selectedLocation?: SelectedLocation
}

@Entry
@ComponentV2
struct Index {
  @Local message: string = 'Hello World'
  /** 选中的地点信息 */
  @Local selectedLocation: SelectedLocation | null = null

  onPageShow(): void {
    // 获取从地图页面返回的参数
    const params = router.getParams() as PageParams | undefined
    if (params?.selectedLocation) {
      this.selectedLocation = params.selectedLocation
      hilog.info(DOMAIN, 'Index', '收到选中的地点: %{public}s', JSON.stringify(this.selectedLocation))
      this.message = `已选择: ${this.selectedLocation.name}`
    }
  }

  /**
   * 跳转到地图选择页面
   */
  private goToMapSelect(): void {
    router.pushUrl({
      url: 'pages/MapSelectPage'
    })
  }

  /**
   * 查看已选择的地点
   */
  private viewSelectedLocation(): void {
    if (!this.selectedLocation) return
    router.pushUrl({
      url: 'pages/MapSelectPage',
      params: {
        latitude: this.selectedLocation.latitude,
        longitude: this.selectedLocation.longitude,
        name: this.selectedLocation.name,
        viewOnly: true
      }
    })
  }

  build() {
    Column() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      // 选择地点按钮
      Button('选择地点')
        .fontSize(16)
        .width('80%')
        .height(50)
        .onClick(() => this.goToMapSelect())

      // 显示选中的地点信息
      if (this.selectedLocation) {
        Column() {
          Text('选中的地点信息')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 30, bottom: 10 })

          Text(`名称: ${this.selectedLocation.name}`)
            .fontSize(14)
            .fontColor('#333333')
            .margin({ top: 5 })

          Text(`地址: ${this.selectedLocation.address}`)
            .fontSize(14)
            .fontColor('#666666')
            .margin({ top: 5 })

          Text(`坐标: ${this.selectedLocation.latitude.toFixed(6)}, ${this.selectedLocation.longitude.toFixed(6)}`)
            .fontSize(14)
            .fontColor('#666666')
            .margin({ top: 5 })

          // 查看位置按钮
          Button('在地图上查看')
            .fontSize(14)
            .width('100%')
            .height(40)
            .margin({ top: 15 })
            .backgroundColor('#007AFF')
            .onClick(() => this.viewSelectedLocation())
        }
        .width('90%')
        .padding(16)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
        .alignItems(HorizontalAlign.Start)
      }
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}