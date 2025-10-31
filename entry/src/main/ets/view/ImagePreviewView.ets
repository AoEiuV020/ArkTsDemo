/**
 * 图片预览视图
 * 支持缩放、拖动和双击缩放
 */
import { ImagePreviewViewModel } from '../viewmodel/ImagePreviewViewModel'

@ComponentV2
export struct ImagePreviewView {
  @Consumer() pathStack?: NavPathStack
  @Consumer() imageUrl?: string
  @Local vm: ImagePreviewViewModel = new ImagePreviewViewModel(this.imageUrl!)

  build() {
    Stack({ alignContent: Alignment.Center }) {
      // 黑色背景，单击关闭预览
      Column()
        .width('100%')
        .height('100%')
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .backgroundColor(Color.Black)
        .onClick(() => {
          // 任何状态都可以关闭
          this.pathStack!.pop()
        })

      // 图片内容
      Image(this.vm.imageUrl)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Contain)
        .scale({
          x: this.vm.scale,
          y: this.vm.scale,
          centerX: this.vm.scaleCenterX,
          centerY: this.vm.scaleCenterY,
        })
        .translate({ x: this.vm.offsetX, y: this.vm.offsetY })
        .gesture(
          // 并行手势组合：捏合和拖动可同时进行
          GestureGroup(GestureMode.Parallel,
            // 捏合手势 - 缩放
            PinchGesture({ fingers: 2, distance: 0.1 })
              .onActionStart(() => {
                this.vm.handlePinchStart()
              })
              .onActionUpdate((event: GestureEvent) => {
                if (event.scale && event.pinchCenterX !== undefined && event.pinchCenterY !== undefined) {
                  this.vm.handlePinchScale(event.scale, event.pinchCenterX, event.pinchCenterY, event.offsetX,
                    event.offsetY)
                }
              })
              .onActionEnd(() => {
                this.vm.handlePinchEnd()
              }),
            // 拖动手势 - 移动
            PanGesture({ fingers: 1 })
              .onActionStart(() => {
                this.vm.handlePanStart()
              })
              .onActionUpdate((event: GestureEvent) => {
                if (event.offsetX !== undefined && event.offsetY !== undefined) {
                  this.vm.handlePan(event.offsetX, event.offsetY)
                }
              })
          )
        )
        .gesture(
          // 双击手势 - 放大/还原
          TapGesture({ count: 2 })
            .onAction(() => {
              this.vm.handleDoubleTap()
            })
        )
        .gesture(
          // 单击手势 - 关闭预览
          TapGesture({ count: 1 })
            .onAction(() => {
              this.pathStack!.pop()
            })
        )
    }
    .width('100%')
    .height('100%')
  }
}
