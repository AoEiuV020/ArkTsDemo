import router from '@ohos.router';

// 通用标题栏组件
@ComponentV2
export struct CommonTitleBar {
  @Param @Require title: string;
  @Param showBackButton: boolean = true;
  @Param onBackClick?: () => void = undefined;
  @Param rightText?: string = undefined;
  @Param onRightClick?: () => void = undefined;

  build() {
    Row() {
      if (this.showBackButton) {
        Button('返回')
          .width(60)
          .height(40)
          .onClick(() => {
            if (this.onBackClick) {
              this.onBackClick();
            } else {
              router.back();
            }
          })
      } else {
        Blank()
          .width(60)
      }

      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      if (this.rightText) {
        Text(this.rightText)
          .fontSize(16)
          .fontColor('#007AFF')
          .width(60)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            if (this.onRightClick) {
              this.onRightClick();
            }
          })
      } else {
        Blank()
          .width(60)
      }
    }
    .width('100%')
    .height(60)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#f5f5f5')
  }
}
