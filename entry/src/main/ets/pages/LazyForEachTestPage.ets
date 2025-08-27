import { ListItemModel } from '../models/ListItemModel';
import { TestDataFactory } from '../data/TestDataFactory';
import { LazyLoadList } from '../components/LazyLoadList';
import { CommonTitleBar } from '../components/CommonTitleBar';

@Entry
@ComponentV2
struct LazyForEachTestPage {
  // 模拟大数据量的异步加载
  loadMoreData = async (page: number): Promise<ListItemModel[]> => {
    // 模拟网络延迟
    await new Promise<number>(resolve => setTimeout(resolve, 800));

    // 使用测试数据工厂生成大量数据
    const data = TestDataFactory.generatePageData(page, 50); // 每页50条数据

    console.log(`LazyForEach: 加载第 ${page} 页数据，共 ${data.length} 条`);

    // 模拟最多只有20页数据（总共1000条数据）
    if (page > 20) {
      return [];
    }

    return data;
  }
  // 处理列表项点击
  handleItemClick = (item: ListItemModel) => {
    console.log(`LazyForEach 点击了: ${item.title} (ID: ${item.id})`);
  }

  build() {
    Column() {
      // 标题栏
      CommonTitleBar({
        title: 'LazyForEach 真懒加载',
        rightText: '重置',
        onRightClick: () => {
          console.log('重置 LazyForEach 数据');
          // 这里可以添加重置功能的引用
        }
      })

      // 说明文字
      Text('使用 LazyForEach + IDataSource 实现真正的懒加载\n只有滚动到的项目才会被创建和渲染')
        .fontSize(14)
        .fontColor('#666666')
        .textAlign(TextAlign.Center)
        .padding(16)
        .backgroundColor('#f8f8f8')

      // 真正的懒加载列表
      LazyLoadList({
        onLoadMore: this.loadMoreData,
        pageSize: 50,
        onItemClick: this.handleItemClick
      })
    }
    .height('100%')
    .width('100%')
  }
}
