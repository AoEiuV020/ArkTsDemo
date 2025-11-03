/**
 * 通用缩放视图模型
 */
@ObservedV2
export class ScalableViewModel {
  @Trace scale: number = 1
  @Trace offsetX: number = 0
  @Trace offsetY: number = 0
  minScale: number = 0.1
  maxScale: number = 20
  doubleClickScale: number = 2
  area?: Area
  // 手势开始时的状态快照
  private initialScale: number = 1
  private initialOffsetX: number = 0
  private initialOffsetY: number = 0
  private initialFocalPointX: number = 0
  private initialFocalPointY: number = 0

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
   * 手势开始 - 记录初始状态
   */
  onScaleStart(focalPointX: number, focalPointY: number): void {
    this.initialScale = this.scale
    this.initialOffsetX = this.offsetX
    this.initialOffsetY = this.offsetY
    this.initialFocalPointX = focalPointX
    this.initialFocalPointY = focalPointY
  }

  /**
   * 手势更新 - 直接计算新的缩放和偏移
   */
  onScaleUpdate(scaleRatio: number, focalPointX: number, focalPointY: number): void {
    if (!this.area) {
      return
    }
    // 计算新的缩放比例
    const newScale = this.initialScale * scaleRatio
    
    // 限制缩放范围
    if (newScale < this.minScale || newScale > this.maxScale) {
      return
    }

    const halfX = this.area.width as number / 2
    const halfY = this.area.height as number / 2

    const centerX = halfX + this.initialOffsetX
    const centerY = halfY + this.initialOffsetY

    // 计算偏移：从初始偏移 + 焦点移动距离 + 缩放中心偏移，
    this.offsetX =
      this.initialOffsetX + (focalPointX - this.initialFocalPointX) + (centerX - focalPointX) * (scaleRatio - 1)
    this.offsetY =
      this.initialOffsetY + (focalPointY - this.initialFocalPointY) + (centerY - focalPointY) * (scaleRatio - 1)

    this.scale = newScale

  }

  /**
   * 手势结束 - 重置 initialScale，为下次手势做准备
   */
  onScaleEnd(): void {
    // 重要：重置 initialScale 为 1.0，而不是当前 scale
    // 这样下次手势的 scaleRatio 是相对于 1.0 的增量
    this.initialScale = 1.0
    this.initialOffsetX = this.offsetX
    this.initialOffsetY = this.offsetY
  }

  /**
   * 拖动开始 - 记录初始偏移
   */
  onPanStart(x: number, y: number): void {
    this.initialOffsetX = this.offsetX
    this.initialOffsetY = this.offsetY
  }

  /**
   * 拖动更新 - 直接更新偏移
   */
  onPanUpdate(offsetX: number, offsetY: number): void {
    this.offsetX = this.initialOffsetX + offsetX
    this.offsetY = this.initialOffsetY + offsetY
  }

  /**
   * 拖动结束
   */
  onPanEnd(): void {
    this.initialOffsetX = this.offsetX
    this.initialOffsetY = this.offsetY
  }

  /**
   * 处理双击手势
   */
  handleDoubleTap(): void {
    if (this.scale !== 1) {
      this.resetTransform()
    } else {
      this.scale = this.doubleClickScale
      this.offsetX = 0
      this.offsetY = 0
    }
  }

  /**
   * 重置变换状态到初始缩放(1倍)
   */
  resetTransform(): void {
    this.scale = 1
    this.offsetX = 0
    this.offsetY = 0
  }
}
