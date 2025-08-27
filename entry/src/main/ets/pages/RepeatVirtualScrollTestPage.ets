// 简单 Repeat 列表 + virtualScroll + 点击修改文字
@Entry
@ComponentV2
struct RepeatVirtualScrollTestPage {
  @Local dataArr: Array<string> = [];

  aboutToAppear(): void {
    if (this.dataArr.length === 0) {
      for (let i = 0; i < 50; i++) {
        this.dataArr.push(`data_${i}`);
      }
    }
  }

  build() {
    Column() {
      List() {
        Repeat<string>(this.dataArr)
          .each((ri: RepeatItem<string>) => {
            ListItem() {
              // 展示 & 点击
              Text(ri.item)
                .fontSize(26)
                .padding({ left: 12, top: 8, bottom: 8 })
                .onClick(() => this.onItemClick(ri.index))
            }
            .border({ width: 0.5 })
          })
          .virtualScroll({ totalCount: this.dataArr.length })
      }
      .cachedCount(2)
      .height('70%')
      .border({ width: 1 })
      .margin(12)
    }
  }

  private onItemClick(index: number) {
    // 修改该项文字，演示局部更新；重新赋值触发更新
    this.dataArr[index] = this.dataArr[index] + '_clicked';
    // 保障刷新（如果运行环境需要），可解开下一行：
    // this.dataArr = [...this.dataArr];
  }
}
