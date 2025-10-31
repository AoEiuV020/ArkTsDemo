/**
 * 通用缩放视图模型
 * 支持捏合缩放、拖动、双击缩放等手势
 */
@ObservedV2
export class ScalableViewModel {
  @Trace scale: number = 1
  @Trace offsetX: number = 0
  @Trace offsetY: number = 0
  @Trace scaleCenterX?: number
  @Trace scaleCenterY?: number
  minScale: number = 0.1
  maxScale: number = 20
  doubleClickScale: number = 2
  private pinchScale: number = 1
  private panStartX: number = 0
  private panStartY: number = 0

  constructor(
    minScale?: number,
    maxScale?: number,
    doubleClickScale?: number
  ) {
    if (minScale !== undefined) {
      this.minScale = minScale
    }
    if (maxScale !== undefined) {
      this.maxScale = maxScale
    }
    if (doubleClickScale !== undefined) {
      this.doubleClickScale = doubleClickScale
    }
  }

  /**
   * 处理捏合缩放手势开始
   */
  handlePinchStart(): void {
    this.pinchScale = this.scale
    this.panStartX = this.offsetX
    this.panStartY = this.offsetY
  }

  /**
   * 处理捏合缩放手势
   * 以捏合中心为基准进行缩放，保持触摸位置不变
   *
   * @param scale 缩放倍数（相对于手势开始时）
   * @param pinchCenterX 捏合中心X坐标（相对于图片组件，非屏幕坐标）
   * @param pinchCenterY 捏合中心Y坐标（相对于图片组件，非屏幕坐标）
   * @param deltaX 双指缩放过程中的平移偏移X（暂未使用）
   * @param deltaY 双指缩放过程中的平移偏移Y（暂未使用）
   */
  handlePinchScale(scale: number, pinchCenterX: number, pinchCenterY: number, deltaX: number, deltaY: number): void {
    const newScale = this.pinchScale * scale

    // 限制缩放范围
    if (newScale < this.minScale || newScale > this.maxScale) {
      return
    }

    // 当缩放中心点发生变化时，需要调整偏移量以保持视觉连续性
    if (this.scaleCenterX !== pinchCenterX || this.scaleCenterY !== pinchCenterY) {
      // 只有在已经设置过缩放中心时才需要调整偏移
      if (this.scaleCenterX !== undefined && this.scaleCenterY !== undefined) {
        // 计算缩放中心的变化量
        const centerDeltaX = pinchCenterX - this.scaleCenterX
        const centerDeltaY = pinchCenterY - this.scaleCenterY

        // 根据当前缩放比例调整偏移量
        // 缩放中心移动时，已缩放的图片需要相应移动以保持视觉连续
        this.offsetX = this.offsetX + centerDeltaX * (this.scale - 1)
        this.offsetY = this.offsetY + centerDeltaY * (this.scale - 1)
      }

      // 更新缩放中心
      this.scaleCenterX = pinchCenterX
      this.scaleCenterY = pinchCenterY
    }

    // 应用新的缩放比例
    this.scale = newScale
  }

  /**
   * 处理捏合手势结束
   */
  handlePinchEnd(): void {
    // 不做任何限制，支持任意缩放
  }

  /**
   * 处理拖动手势开始
   */
  handlePanStart(): void {
    this.panStartX = this.offsetX
    this.panStartY = this.offsetY
  }

  /**
   * 处理拖动手势
   * 自由拖动，不限制边界
   */
  handlePan(deltaX: number, deltaY: number): void {
    // deltaX/deltaY是从手势开始的累积偏移量
    // 乘以scale使拖动速度随缩放比例调整
    this.offsetX = this.panStartX + deltaX * this.scale
    this.offsetY = this.panStartY + deltaY * this.scale
  }

  /**
   * 处理双击手势
   */
  handleDoubleTap(): void {
    // 如果已放大，则重置；否则放大到指定倍数
    if (this.scale > 1) {
      this.resetTransform()
    } else {
      this.scale = this.doubleClickScale
      this.offsetX = 0
      this.offsetY = 0
      this.scaleCenterX = 0
      this.scaleCenterY = 0
    }
  }

  /**
   * 重置变换状态到初始缩放(1倍)
   */
  resetTransform(): void {
    this.scale = 1
    this.offsetX = 0
    this.offsetY = 0
    this.scaleCenterX = 0
    this.scaleCenterY = 0
  }
}
