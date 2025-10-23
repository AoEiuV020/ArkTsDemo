@Entry
@ComponentV2
struct ProviderTestPage {
  @Local dataArr: Array<Item> = []; // 数据源

  aboutToAppear(): void {
    for (let i = 0; i < 50; i++) {
      this.dataArr.push(new Item(i)); // 为数组添加一些数据
    }
  }

  build() {
    Column() {
      List() {
        Repeat<Item>(this.dataArr)
          .each((ri: RepeatItem<Item>) => {
            ListItem() {
              ItemComponent({ ri: ri })
            }
          })
          .virtualScroll({ totalCount: this.dataArr.length }) // 打开懒加载，totalCount为期望加载的数据长度
      }
      .cachedCount(2) // 容器组件的预加载区域大小
      .width('100%')
      .height('100%')
      .border({ width: 1 }) // 边框
    }
  }
}

@ComponentV2
struct ItemComponent {
  @Param @Require ri: RepeatItem<Item>
  @Provider() item: Item = this.ri.item

  build() {
    Row() {
      Text(`${this.ri.index}/${this.ri.item.index}/${this.item.index}/`).fontSize(30)
      ChildComponent()
    }
    .onClick(() => {
      console.log(`click ${this.item.name}`);
      this.item.click++
    })
  }
}

@ComponentV2
struct ChildComponent {
  @Consumer() item?: Item

  build() {
    Text(`${this.item!.index}/${this.item!.click}`).fontSize(30)
  }
}

@ObservedV2
class Item {
  @Trace index: number
  @Trace name: string
  @Trace click: number = 0

  constructor(
    index: number,
  ) {
    this.index = index
    this.name = `item_${index}`
  }
}