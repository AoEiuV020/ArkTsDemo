@Entry
@ComponentV2
struct RepeatExample {
  @Local dataArr: Array<string> = []; // 数据源

  aboutToAppear(): void {
    for (let i = 0; i < 50; i++) {
      this.dataArr.push(`data_${i}`); // 为数组添加一些数据
    }
  }

  build() {
    Column() {
      LoadMoreView({
        onLoadMore: async () => {
          const ms = 500
          await new Promise<number>(resolve => setTimeout(() => resolve(ms), ms))
          return false
        }
      }) {
        List() {
          Repeat<string>(this.dataArr)
            .each((ri: RepeatItem<string>) => {
              ListItem() {
                Text('each_' + ri.item).fontSize(30)
              }
            })
            .virtualScroll({ totalCount: this.dataArr.length }) // 打开懒加载，totalCount为期望加载的数据长度
        }
        .cachedCount(2) // 容器组件的预加载区域大小
        .height('70%')
        .border({ width: 1 }) // 边框
      }
    }
  }
}

@ComponentV2
export struct LoadMoreView {
  @Event onLoadMore?: () => Promise<boolean> | boolean = undefined
  @Local hasMore: boolean = true // 是否还有更多数据
  @Require @BuilderParam content: () => void // 直接包装的内容
  @Local isLoading: boolean = false

  build() {
    Refresh({
      refreshing: this.isLoading,
    }) {
      this.content()
    }
    .onRefreshing(() => {
      this.handleLoadMore()
    })
  }

  private async handleLoadMore() {
    if (this.isLoading) {
      return
    }
    this.isLoading = true
    if (!this.hasMore) {
      this.isLoading = false
      return
    }
    try {
      if (this.onLoadMore) {
        this.hasMore = await this.onLoadMore()
      }
    } finally {
      this.isLoading = false
    }
  }
}
