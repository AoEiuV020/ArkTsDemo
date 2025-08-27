import { ListItemModel } from '../models/ListItemModel';
import { ListItemView } from './ListItemView';
import { LazyDataSource } from '../data/LazyDataSource';

// 真正的懒加载列表组件
@ComponentV2
export struct LazyLoadList {
  @Local dataSource: LazyDataSource = new LazyDataSource();
  @Param onLoadMore?: (page: number) => Promise<ListItemModel[]> = undefined;
  @Param pageSize: number = 20;
  @Param onItemClick?: (item: ListItemModel) => void = undefined;

  aboutToAppear() {
    // 初始化数据源
    this.dataSource = new LazyDataSource(this.onLoadMore, this.pageSize);
    this.dataSource.initData();
  }

  // 重置数据
  resetData() {
    this.dataSource.reset();
  }

  build() {
    Column() {
      List({ space: 8 }) {
        // 使用LazyForEach实现真正的懒加载
        LazyForEach(this.dataSource, (item: ListItemModel) => {
          ListItem() {
            ListItemView({
              item: item,
              onItemClick: this.onItemClick
            })
          }
        }, (item: ListItemModel) => item.id.toString())

        // 加载更多指示器
        if (this.dataSource.getIsLoading()) {
          ListItem() {
            Row() {
              LoadingProgress()
                .width(20)
                .height(20)
                .margin({ right: 8 })

              Text('加载中...')
                .fontSize(14)
                .fontColor('#666666')
            }
            .justifyContent(FlexAlign.Center)
            .width('100%')
            .height(50)
          }
        }

        // 没有更多数据的提示
        if (!this.dataSource.getHasMore() && this.dataSource.totalCount() > 0) {
          ListItem() {
            Text('没有更多数据了')
              .fontSize(14)
              .fontColor('#999999')
              .textAlign(TextAlign.Center)
              .width('100%')
              .height(50)
          }
        }
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
      .onReachEnd(() => {
        // 滚动到底部时加载更多
        this.dataSource.loadMore();
      })
    }
    .width('100%')
    .height('100%')
  }
}
