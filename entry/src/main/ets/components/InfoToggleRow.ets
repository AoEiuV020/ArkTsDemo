export type SwitchChangeHandler = (isOn: boolean) => void

/**
 * InfoList 中的开关行
 * 包含：左侧标题 + 右侧开关 + （可选）说明
 */
@ComponentV2
export struct InfoToggleRow {
  @Require @Param title: ResourceStr
  @Param description?: ResourceStr = undefined
  @Require @Param isOn: boolean
  @Param isUpdating: boolean = false
  @Event onChange?: SwitchChangeHandler

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize(16)
          .fontColor('#333333')

        Blank()

        Toggle({ type: ToggleType.Switch, isOn: this.isOn })
          .enabled(!this.isUpdating)
          .onChange((isOn: boolean) => {
            this.onChange?.(isOn)
          })
      }
      .width('100%')
      .padding({
        left: 16,
        right: 16,
        top: 12,
        bottom: 12,
      })

      if (this.description) {
        Text(this.description)
          .fontSize(12)
          .fontColor('#666666')
          .backgroundColor('#F5F5F5')
          .padding({
            left: 16,
            right: 16,
            top: 5,
            bottom: 5,
          })
          .width('100%')
          .maxLines(10)
          .wordBreak(WordBreak.BREAK_ALL)
      }
    }
    .width('100%')
  }
}
