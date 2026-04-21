const BOX_SIZE = 100
const BOX_RADIUS = 16
const PAGE_PADDING = 24
const SECTION_SPACING = 24
const KEYFRAME_DURATION = 400
const SCALE_NORMAL = 1
const SCALE_HIGHLIGHT = 1.12

@Entry
@ComponentV2
struct Index {
  @Local colorBoxColor: ResourceColor = Color.Gray
  @Local scaleValue: number = SCALE_NORMAL
  @Local opacityValue: number = 0
  @Local eventTrace: string = '未触发'

  build() {
    Column() {
      Text('keyframeAnimateTo 简单复现')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)

      Text(this.eventTrace)
        .fontSize(16)
        .margin({ top: 8 })

      Column() {
        Text('颜色字段')
          .fontSize(20)

        Row() {
        }
        .width(BOX_SIZE)
        .height(BOX_SIZE)
        .borderRadius(BOX_RADIUS)
        .backgroundColor(this.colorBoxColor)
        .margin({ top: 12 })

        Button('触发颜色关键帧')
          .margin({ top: 12 })
          .onClick(() => {
            this.playColorKeyframe()
          })
      }
      .margin({ top: SECTION_SPACING })

      Column() {
        Text('数值字段（缩放 + 透明度）')
          .fontSize(20)

        Stack() {
          Row() {
          }
          .width(BOX_SIZE)
          .height(BOX_SIZE)
          .borderRadius(BOX_RADIUS)
          .backgroundColor(Color.Gray)
          .scale({
            x: this.scaleValue,
            y: this.scaleValue,
          })

          Row() {
          }
          .width(BOX_SIZE)
          .height(BOX_SIZE)
          .borderRadius(BOX_RADIUS)
          .backgroundColor(Color.Yellow)
          .opacity(this.opacityValue)
          .scale({
            x: this.scaleValue,
            y: this.scaleValue,
          })
        }
        .width(BOX_SIZE)
        .height(BOX_SIZE)
        .margin({ top: 12 })

        Button('触发数值关键帧')
          .margin({ top: 12 })
          .onClick(() => {
            this.playNumericKeyframe()
          })
      }
      .margin({ top: SECTION_SPACING })
    }
    .width('100%')
    .height('100%')
    .padding(PAGE_PADDING)
    .alignItems(HorizontalAlign.Start)
  }

  private playColorKeyframe() {
    this.eventTrace = '颜色测试开始'
    this.colorBoxColor = Color.Gray
    this.getUIContext().keyframeAnimateTo({
      iterations: 1,
      onFinish: () => {
        this.eventTrace = `${this.eventTrace} | 完成`
      },
    }, [
      {
        duration: KEYFRAME_DURATION,
        curve: Curve.Linear,
        event: () => {
          this.eventTrace = `${this.eventTrace} -> 红`
          this.colorBoxColor = Color.Red
        },
      },
      {
        duration: KEYFRAME_DURATION,
        curve: Curve.Linear,
        event: () => {
          this.eventTrace = `${this.eventTrace} -> 绿`
          this.colorBoxColor = Color.Green
        },
      },
      {
        duration: KEYFRAME_DURATION,
        curve: Curve.Linear,
        event: () => {
          this.eventTrace = `${this.eventTrace} -> 蓝`
          this.colorBoxColor = Color.Blue
        },
      },
    ])
  }

  private playNumericKeyframe() {
    this.eventTrace = '数值测试开始'
    this.scaleValue = SCALE_NORMAL
    this.opacityValue = 0
    this.getUIContext().keyframeAnimateTo({
      iterations: 1,
      onFinish: () => {
        this.eventTrace = `${this.eventTrace} | 完成`
        this.scaleValue = SCALE_NORMAL
        this.opacityValue = 0
      },
    }, [
      {
        duration: KEYFRAME_DURATION,
        curve: Curve.Linear,
        event: () => {
          this.eventTrace = `${this.eventTrace} -> 放大`
          this.scaleValue = SCALE_HIGHLIGHT
          this.opacityValue = 1
        },
      },
      {
        duration: KEYFRAME_DURATION,
        curve: Curve.Linear,
        event: () => {
          this.eventTrace = `${this.eventTrace} -> 保持`
          this.scaleValue = SCALE_HIGHLIGHT
          this.opacityValue = 1
        },
      },
      {
        duration: KEYFRAME_DURATION,
        curve: Curve.Linear,
        event: () => {
          this.eventTrace = `${this.eventTrace} -> 恢复`
          this.scaleValue = SCALE_NORMAL
          this.opacityValue = 0
        },
      },
    ])
  }
}
