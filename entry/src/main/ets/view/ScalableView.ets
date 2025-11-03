/**
 * 通用缩放视图组件
 * 支持缩放、拖动和双击缩放
 * 将内容作为子组件传入
 *
 * 两层结构设计：
 * 1. 手势层(外层Stack) - 处理所有手势事件
 *    独立手势层的原因：当控件拖动离开屏幕时，仍能保持识别触摸事件的范围
 *    手势层始终保持在视口内(width/height='100%')，确保手势不会失效
 * 2. 变换层(内层Stack) - 同时处理缩放(scale)和位移(translate)
 *    将缩放和偏移应用在同一层，简化变换逻辑
 */
import { ScalableViewModel } from '../viewmodel/ScalableViewModel'

@ComponentV2
export struct ScalableView {
  vm: ScalableViewModel = new ScalableViewModel()
  @Param enableDoubleTap: boolean = true
  @BuilderParam content: () => void
  scaling: boolean = false

  build() {
    // 手势层 - 处理事件，固定在视口内保证手势不失效
    Stack() {
      // 变换层 - 同时应用缩放和位移变换
      Stack() {
        this.content()
      }
      .width('100%')
      .height('100%')
      .scale({
        x: this.vm.scale,
        y: this.vm.scale,
      })
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
