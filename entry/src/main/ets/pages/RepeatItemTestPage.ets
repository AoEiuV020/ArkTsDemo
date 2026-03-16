// 测试：Repeat + virtualScroll 下，自定义组件传 ri.item 是否能正常复用更新

@ObservedV2
class TestItem {
  @Trace name: string
  @Trace count: number

  constructor(name: string, count: number) {
    this.name = name
    this.count = count
  }
}

@ComponentV2
struct ItemWithRi {
  @Require @Param ri: RepeatItem<TestItem>

  build() {
    Text(`[组件-ri] ${this.ri.item.name} count=${this.ri.item.count}`)
      .fontSize(14)
      .fontColor(Color.Green)
  }
}

@ComponentV2
struct ItemWithData {
  @Require @Param item: TestItem

  build() {
    Text(`[组件-item] ${this.item.name} count=${this.item.count}`)
      .fontSize(14)
      .fontColor(Color.Blue)
  }
}

@Entry
@ComponentV2
struct RepeatItemTestPage {
  @Local dataArr: Array<TestItem> = []

  aboutToAppear(): void {
    for (let i = 0; i < 100; i++) {
      this.dataArr.push(new TestItem(`data_${i}`, 0))
    }
  }

  @Builder
  builderWithRi(ri: RepeatItem<TestItem>) {
    Text(`[@Builder-ri] ${ri.item.name} count=${ri.item.count}`)
      .fontSize(14)
      .fontColor('#008800')
  }

  @Builder
  builderWithData(item: TestItem) {
    Text(`[@Builder-item] ${item.name} count=${item.count}`)
      .fontSize(14)
      .fontColor(Color.Red)
  }

  build() {
    Column() {
      Text('滚动后观察复用是否正确；点按钮观察count更新')
        .fontSize(12).margin(8)
      Button('所有 count+1')
        .onClick(() => {
          for (let item of this.dataArr) {
            item.count++
          }
        })
        .margin(4)

      List() {
        Repeat<TestItem>(this.dataArr)
          .each((ri: RepeatItem<TestItem>) => {
            ListItem() {
              Column({ space: 2 }) {
                Text(`--- index=${ri.index} ---`)
                  .fontSize(12).fontColor(Color.Gray)
                this.builderWithRi(ri)
                this.builderWithData(ri.item)
                ItemWithRi({ ri: ri })
                ItemWithData({ item: ri.item })
              }
              .padding(4)
              .borderWidth({ bottom: 1 })
              .borderColor('#EEEEEE')
            }
          })
          .key((item: TestItem) => item.name)
          .virtualScroll({ totalCount: this.dataArr.length })
      }
      .cachedCount(2)
      .layoutWeight(1)
      .border({ width: 1 })
    }
  }
}
