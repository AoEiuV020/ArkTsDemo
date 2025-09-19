
interface Item {
  name: string;
}

@ObservedV2
class WrapItem<T> {
  @Trace item: T
  @Trace notifyCount: number = 0

  constructor(item: T) {
    this.item = item
  }

  notify() {
    this.notifyCount++
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
              Text(ri.item.notifyCount + 'each_' + ri.item.item.name).fontSize(30)
            }
            .onClick(() => {
              this.staticItem.name += '!'
              this.dataArr[ri.index].item = this.staticItem
              this.dataArr[ri.index].notify()
            })
          })
          .virtualScroll()
      }
    }
  }
}
