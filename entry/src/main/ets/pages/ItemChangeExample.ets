
interface Item {
  name: string;
}

@ObservedV2
class WrapItem<T extends object> {
  @Trace item: T

  constructor(item: T) {
    this.item = item
  }

}
@Entry
@ComponentV2
struct ItemChangeExample {
  @Local dataArr: Array<WrapItem<Item>> = []; // 数据源
  @Local hasMore: boolean = true
  staticItem: Item = { name: 'static' }

  aboutToAppear(): void {
    for (let i = 0; i < 50; i++) {
      this.dataArr.push((new WrapItem<Item>({ name: `data_${i}` }))); // 为数组添加一些数据
    }
  }

  build() {
    Column() {
      List() {
        Repeat<WrapItem<Item>>(this.dataArr)
          .each((ri: RepeatItem<WrapItem<Item>>) => {
            ListItem() {
              CustomItemVIew({ wi: ri.item })
            }
            .onClick(() => {
              this.staticItem.name += '!'
              this.dataArr[ri.index] = new WrapItem<Item>(this.staticItem)
            })
          })
          .virtualScroll()
      }
    }
  }
}

@ComponentV2
export struct CustomItemVIew {
  @Param @Require wi: WrapItem<Item>

  build() {
    Text('each_' + this.wi.item.name).fontSize(30)
  }
}