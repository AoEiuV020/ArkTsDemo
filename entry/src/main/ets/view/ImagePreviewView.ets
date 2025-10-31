/**
 * 图片预览视图
 * 支持缩放、拖动和双击缩放
 */
import { ScalableView } from './ScalableView'

@ComponentV2
export struct ImagePreviewView {
  @Consumer() pathStack?: NavPathStack
  @Consumer() imageUrl?: string

  build() {
    Stack({ alignContent: Alignment.Center }) {
      // 黑色背景，单击关闭预览
      Column()
        .width('100%')
        .height('100%')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .backgroundColor(Color.Black)
        .gesture(
          // 单击手势 - 关闭预览
          TapGesture({ count: 1 })
            .onAction(() => {
              this.pathStack!.pop()
            })
        )

      // 使用通用缩放组件包装图片
      ScalableView() {
        Image(this.imageUrl)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Contain)
      }
    }
    .width('100%')
    .height('100%')
  }
}
