import { Calc, StringUtils } from 'library';
import { Counter } from 'library1';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  private counter = new Counter();
  @State count: number = 0;

  build() {
    Column() {
      Text(this.message)
        .id('HelloWorld')
        .fontSize($r('app.float.page_text_font_size'))
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })
        .onClick(() => {
          this.message = StringUtils.capitalize('welcome');
        })

      Text(`计数: ${this.count}`)
        .fontSize(20)
        .margin({ bottom: 20 })

      Row() {
        Button('+1')
          .onClick(() => {
            this.count = this.counter.increment();
          })
          .margin({ right: 20 })

        Button('-1')
          .onClick(() => {
            this.count = Calc.minus(this.count, 1)
          })

        Button('重置')
          .onClick(() => {
            this.counter.reset();
            this.count = this.counter.getCurrentCount();
          })
          .margin({ left: 20 })
      }

      Text(StringUtils.reverse(this.message))
        .fontSize(16)
        .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}