import { UIUtils } from '@kit.ArkUI';

interface Item {
  name: string;
}
@Entry
@ComponentV2
struct ItemChangeExample {
  @Local dataArr: Array<Item> = []; // 数据源
  @Local hasMore: boolean = true

  aboutToAppear(): void {
    for (let i = 0; i < 50; i++) {
      this.dataArr.push(UIUtils.makeObserved({ name: `data_${i}` })); // 为数组添加一些数据
    }
  }

  build() {
    Column() {
      List() {
        Repeat<Item>(this.dataArr)
          .each((ri: RepeatItem<Item>) => {
            ListItem() {
              Text('each_' + ri.item.name).fontSize(30)
            }
            .onClick(() => {
              ri.item.name += '!'
            })
          })
          .virtualScroll()
      }
    }
  }
}
