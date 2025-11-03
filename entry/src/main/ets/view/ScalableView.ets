/**
 * 通用缩放视图组件
 * 支持缩放、拖动和双击缩放
 * 将内容作为子组件传入
 *
 * 多层结构设计（参考 Flutter）：
 * 1. 手势层 - 处理所有手势事件
 * 2. 偏移层 - Transform.translate 处理位移
 * 3. 缩放层 - Transform.scale 处理缩放
 */
import { ScalableViewModel } from '../viewmodel/ScalableViewModel'

@ComponentV2
export struct ScalableView {
  vm: ScalableViewModel = new ScalableViewModel()
  @Param enableDoubleTap: boolean = true
  @BuilderParam content: () => void
  scaling: boolean = false

  build() {
    // 手势层 - 处理事件
    Stack() {
      // 偏移层 - 处理位移
      Stack() {
        // 缩放层 - 处理缩放
        Stack() {
          this.content()
        }
        .width('100%')
        .height('100%')
        .scale({
          x: this.vm.scale,
          y: this.vm.scale,
        })
      }
      .width('100%')
      .height('100%')
      .translate({ x: this.vm.offsetX, y: this.vm.offsetY })
    }
    .width('100%')
    .height('100%')
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.vm.area = newValue
    })
    .gesture(
      // 并行手势组合：捏合和拖动可同时进行
      GestureGroup(GestureMode.Parallel,
        // 捏合手势 - 缩放
        PinchGesture({ fingers: 2, distance: 0.1 })
          .onActionStart((event: GestureEvent) => {
            this.scaling = true
            if (event.pinchCenterX !== undefined && event.pinchCenterY !== undefined) {
              this.vm.onScaleStart(event.pinchCenterX, event.pinchCenterY)
            }
          })
          .onActionUpdate((event: GestureEvent) => {
            if (event.scale && event.pinchCenterX !== undefined && event.pinchCenterY !== undefined) {
              this.vm.onScaleUpdate(event.scale, event.pinchCenterX, event.pinchCenterY)
            }
          })
          .onActionEnd((event: GestureEvent) => {
            this.scaling = false
            this.vm.onScaleEnd()
          }),
        // 拖动手势 - 移动
        PanGesture({ fingers: 1 })
          .onActionStart((event: GestureEvent) => {
            if (this.scaling) {
              return;
            }
            // 使用专门的拖动接口
            this.vm.onPanStart(0, 0)
          })
          .onActionUpdate((event: GestureEvent) => {
            if (this.scaling) {
              return;
            }
            if (event.offsetX !== undefined && event.offsetY !== undefined) {
              // 使用拖动专用的更新方法
              this.vm.onPanUpdate(event.offsetX, event.offsetY)
            }
          })
          .onActionEnd((event: GestureEvent) => {
            if (this.scaling) {
              return;
            }
            this.vm.onPanEnd()
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
