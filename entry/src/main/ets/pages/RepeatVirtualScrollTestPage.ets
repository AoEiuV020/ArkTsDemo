import { ItemInfo, RepeatTestViewModel } from './repeat';

// MVVM架构的 Repeat 列表 + virtualScroll + 复选框选择
@Entry
@ComponentV2
struct RepeatVirtualScrollTestPage {
  @Local viewModel: RepeatTestViewModel = new RepeatTestViewModel();

  build() {
    Column() {
      // 头部操作区域
      this.buildHeader()

      // 列表区域
      this.buildList()
    }
    .padding(12)
  }

  @Builder
  buildHeader() {
    Column() {
      // 第一行：复选框功能控制
      Row() {
        Text('列表操作')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)

        Blank()

        Button(this.viewModel.isCheckboxVisible ? '隐藏选择' : '启用选择')
          .fontSize(14)
          .padding({
            left: 12,
            right: 12,
            top: 6,
            bottom: 6
          })
          .backgroundColor(this.viewModel.isCheckboxVisible ? '#FF6B6B' : '#4ECDC4')
          .fontColor('#FFFFFF')
          .onClick(() => {
            this.viewModel.toggleCheckboxVisible();
          })
      }
      .width('100%')
      .margin({ bottom: 12 })

      // 第二行：选择操作（仅在复选框可见时显示）
      if (this.viewModel.isCheckboxVisible) {
        Row() {
          Text(`已选择: ${this.viewModel.getSelectedCount()} 项`)
            .fontSize(16)
            .fontColor('#666666')

          Blank()

          Button('全选')
            .fontSize(14)
            .padding({
              left: 12,
              right: 12,
              top: 6,
              bottom: 6
            })
            .onClick(() => {
              this.viewModel.selectAll(true);
            })

          Button('全不选')
            .fontSize(14)
            .padding({
              left: 12,
              right: 12,
              top: 6,
              bottom: 6
            })
            .margin({ left: 8 })
            .onClick(() => {
              this.viewModel.selectAll(false);
            })
        }
        .width('100%')
      }
    }
    .width('100%')
  }

  @Builder
  buildList() {
    List() {
      Repeat<ItemInfo>(this.viewModel.dataList)
        .each((ri: RepeatItem<ItemInfo>) => {
          ListItem() {
            this.buildListItem(ri)
          }
          .border({ width: 0.5, color: '#E0E0E0' })
        })
        .virtualScroll({ totalCount: this.viewModel.dataList.length })
    }
    .cachedCount(2)
    .height('75%')
    .border({ width: 1, color: '#CCCCCC' })
    .borderRadius(8)
  }

  @Builder
  buildListItem(ri: RepeatItem<ItemInfo>) {
    Row() {
      // 复选框（根据状态显示隐藏）
      if (this.viewModel.isCheckboxVisible) {
        Checkbox({ name: `checkbox_${ri.item.item.id}`, group: 'itemGroup' })
          .select(ri.item.isSelected)
          .selectedColor('#007AFF')
          .onChange((value: boolean) => {
            this.viewModel.onCheckboxChange(ri.index, value);
          })
          .margin({ right: 12 })
      }

      // 内容区域
      Column() {
        Text(`ID: ${ri.item.item.id}`)
          .fontSize(14)
          .fontColor('#999999')
          .alignSelf(ItemAlign.Start)

        Text(ri.item.item.name)
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .alignSelf(ItemAlign.Start)
          .margin({ top: 4 })
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      // 状态指示器（仅在复选框可见且选中时显示）
      if (this.viewModel.isCheckboxVisible && ri.item.isSelected) {
        Text('✓')
          .fontSize(20)
          .fontColor('#007AFF')
          .margin({ left: 12 })
      }
    }
    .width('100%')
    .padding({
      left: 16,
      right: 16,
      top: 12,
      bottom: 12
    })
    .backgroundColor(this.viewModel.isCheckboxVisible && ri.item.isSelected ? '#F0F8FF' : '#FFFFFF')
    .onClick(() => {
      this.viewModel.onItemClick(ri.index);
    })
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        // 添加点击反馈效果
      }
    })
  }
}
