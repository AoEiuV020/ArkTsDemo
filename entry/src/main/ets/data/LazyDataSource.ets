import { ListItemModel } from '../models/ListItemModel';

// 懒加载数据源类
export class LazyDataSource implements IDataSource {
  private dataArray: ListItemModel[] = [];
  private listeners: DataChangeListener[] = [];
  private onLoadMore?: (page: number) => Promise<ListItemModel[]>;
  private currentPage: number = 1;
  private pageSize: number = 20;
  private isLoading: boolean = false;
  private hasMore: boolean = true;

  constructor(onLoadMore?: (page: number) => Promise<ListItemModel[]>, pageSize: number = 20) {
    this.onLoadMore = onLoadMore;
    this.pageSize = pageSize;
  }

  // 初始化加载数据
  async initData() {
    if (this.dataArray.length === 0) {
      await this.loadMore();
    }
  }

  // 获取数据总数
  totalCount(): number {
    return this.dataArray.length;
  }

  // 获取指定索引的数据
  getData(index: number): ListItemModel {
    // 当访问接近末尾的数据时，触发预加载
    if (index >= this.dataArray.length - 5 && this.hasMore && !this.isLoading) {
      this.loadMore();
    }
    return this.dataArray[index];
  }

  // 注册数据变化监听器
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  // 注销数据变化监听器
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  // 加载更多数据
  async loadMore(): Promise<void> {
    if (this.isLoading || !this.hasMore || !this.onLoadMore) {
      return;
    }

    this.isLoading = true;

    try {
      const newData = await this.onLoadMore(this.currentPage);
      if (newData.length > 0) {
        const startIndex = this.dataArray.length;
        this.dataArray.push(...newData);
        this.currentPage++;

        // 通知数据变化
        this.notifyDataAdd(startIndex, newData.length);

        // 如果返回的数据少于页面大小，说明没有更多数据了
        if (newData.length < this.pageSize) {
          this.hasMore = false;
        }
      } else {
        this.hasMore = false;
      }
    } catch (error) {
      console.error('加载数据失败:', error);
    } finally {
      this.isLoading = false;
    }
  }

  // 重置数据
  reset(): void {
    const oldLength = this.dataArray.length;
    this.dataArray = [];
    this.currentPage = 1;
    this.hasMore = true;
    this.isLoading = false;

    if (oldLength > 0) {
      this.notifyDataDelete(0, oldLength);
    }

    // 重新加载数据
    this.initData();
  }

  // 获取加载状态
  getIsLoading(): boolean {
    return this.isLoading;
  }

  // 获取是否还有更多数据
  getHasMore(): boolean {
    return this.hasMore;
  }

  // 通知数据添加
  private notifyDataAdd(index: number, count: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    });
  }

  // 通知数据删除
  private notifyDataDelete(index: number, count: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    });
  }

  // 通知数据变化
  private notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    });
  }

  // 通知数据移动
  private notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    });
  }
}
