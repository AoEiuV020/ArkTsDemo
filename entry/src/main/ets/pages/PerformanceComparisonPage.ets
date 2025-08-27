import { ListItemModel } from '../models/ListItemModel';
import { TestDataFactory } from '../data/TestDataFactory';
import { ListItemView } from '../components/ListItemView';
import { CommonTitleBar } from '../components/CommonTitleBar';
import { LazyDataSource } from '../data/LazyDataSource';

@Entry
@ComponentV2
struct PerformanceComparisonPage {
  @Local showLazyForEach: boolean = true;
  @Local forEachData: ListItemModel[] = [];
  @Local lazyDataSource: LazyDataSource = new LazyDataSource();

  aboutToAppear() {
    // 生成大量数据用于对比
    this.forEachData = TestDataFactory.generateLargeTestData(1, 1000);

    // 为LazyForEach准备数据源
    this.lazyDataSource = new LazyDataSource(async (page: number) => {
      // 模拟从大数据集中分页获取数据
      const startIndex = (page - 1) * 50;
      const endIndex = Math.min(startIndex + 50, 1000);
      return this.forEachData.slice(startIndex, endIndex);
    }, 50);

    this.lazyDataSource.initData();
  }

  handleItemClick = (item: ListItemModel) => {
    console.log(`${this.showLazyForEach ? 'LazyForEach' : 'ForEach'} 点击了: ${item.title}`);
  }

  @Builder
  ForEachList() {
    List({ space: 8 }) {
      ForEach(this.forEachData, (item: ListItemModel) => {
        ListItem() {
          ListItemView({
            item: item,
            onItemClick: this.handleItemClick
          })
        }
      }, (item: ListItemModel) => item.id.toString())
    }
    .layoutWeight(1)
    .padding({
      left: 16,
      right: 16,
      top: 16,
      bottom: 16
    })
    .backgroundColor('#f0f0f0')
    .scrollBar(BarState.Off)
  }

  @Builder
  LazyForEachList() {
    List({ space: 8 }) {
      LazyForEach(this.lazyDataSource, (item: ListItemModel) => {
        ListItem() {
          ListItemView({
            item: item,
            onItemClick: this.handleItemClick
          })
        }
      }, (item: ListItemModel) => item.id.toString())
    }
    .layoutWeight(1)
    .padding({
      left: 16,
      right: 16,
      top: 16,
      bottom: 16
    })
    .backgroundColor('#f0f0f0')
    .scrollBar(BarState.Off)
  }

  build() {
    Column() {
      // 标题栏
      CommonTitleBar({
        title: '性能对比测试',
        rightText: '切换',
        onRightClick: () => {
          this.showLazyForEach = !this.showLazyForEach;
          console.log(`切换到: ${this.showLazyForEach ? 'LazyForEach' : 'ForEach'}`);
        }
      })

      // 说明信息
      Column() {
        Text(`当前使用: ${this.showLazyForEach ? 'LazyForEach (真懒加载)' : 'ForEach (全量渲染)'}`)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.showLazyForEach ? '#007AFF' : '#FF3B30')

        Text(`数据量: 1000 条`)
          .fontSize(14)
          .fontColor('#666666')
          .margin({ top: 4 })

        Text(this.showLazyForEach ?
          '只渲染可见区域的列表项，滚动时动态创建' :
          '一次性创建所有1000个列表项组件')
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 4 })
          .textAlign(TextAlign.Center)
      }
      .padding(16)
      .backgroundColor('#f8f8f8')

      // 列表内容
      if (this.showLazyForEach) {
        this.LazyForEachList()
      } else {
        this.ForEachList()
      }
    }
    .height('100%')
    .width('100%')
  }
}
