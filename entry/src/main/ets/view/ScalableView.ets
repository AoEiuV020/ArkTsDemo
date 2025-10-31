/**
 * 通用缩放视图组件
 * 支持缩放、拖动和双击缩放
 * 将内容作为子组件传入
 */
import { ScalableViewModel } from '../viewmodel/ScalableViewModel'

@ComponentV2
export struct ScalableView {
  vm: ScalableViewModel = new ScalableViewModel()
  @Param enableDoubleTap: boolean = true
  @Param enablePinch: boolean = true
  @Param enablePan: boolean = true
  @BuilderParam content: () => void

  build() {
    Stack() {
      this.content()
    }
    .width('100%')
    .height('100%')
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
            if (this.enablePinch) {
              this.vm.handlePinchStart()
            }
          })
          .onActionUpdate((event: GestureEvent) => {
            if (this.enablePinch && event.scale && event.pinchCenterX !== undefined &&
              event.pinchCenterY !== undefined) {
              this.vm.handlePinchScale(event.scale, event.pinchCenterX, event.pinchCenterY, event.offsetX,
                event.offsetY)
            }
          })
          .onActionEnd(() => {
            if (this.enablePinch) {
              this.vm.handlePinchEnd()
            }
          }),
        // 拖动手势 - 移动
        PanGesture({ fingers: 1 })
          .onActionStart(() => {
            if (this.enablePan) {
              this.vm.handlePanStart()
            }
          })
          .onActionUpdate((event: GestureEvent) => {
            if (this.enablePan && event.offsetX !== undefined && event.offsetY !== undefined) {
              this.vm.handlePan(event.offsetX, event.offsetY)
            }
          })
      )
    )
    .gesture(
      // 双击手势 - 放大/还原
      TapGesture({ count: 2 })
        .onAction(() => {
          if (this.enableDoubleTap) {
            this.vm.handleDoubleTap()
          }
        })
    )
  }
}
