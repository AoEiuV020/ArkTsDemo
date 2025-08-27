import { ListItemModel } from '../models/ListItemModel';
import { TestDataFactory } from '../data/TestDataFactory';
import { ListItemView } from '../components/ListItemView';
import { CommonTitleBar } from '../components/CommonTitleBar';

@Entry
@ComponentV2
struct ListTestPage {
  @Local listData: ListItemModel[] = [];

  aboutToAppear() {
    // 使用测试数据工厂生成数据
    this.listData = TestDataFactory.generateBasicTestData();
  }

  // 处理列表项点击
  handleItemClick = (item: ListItemModel) => {
    console.log(`点击了项目: ${item.title}`);
  }

  build() {
    Column() {
      // 使用通用标题栏
      CommonTitleBar({
        title: '列表测试页',
        rightText: '懒加载',
      })

      // 列表内容
      List({ space: 8 }) {
        ForEach(this.listData, (item: ListItemModel) => {
          ListItem() {
            ListItemView({
              item: item,
              onItemClick: this.handleItemClick
            })
          }
        }, (item: ListItemModel) => item.id.toString())
      }
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })
      .backgroundColor('#f0f0f0')
      .scrollBar(BarState.Off)
    }
    .height('100%')
    .width('100%')
  }
}
