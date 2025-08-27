import { ListItemModel } from '../models/ListItemModel';

// 列表项视图组件
@ComponentV2
export struct ListItemView {
  @Param @Require item: ListItemModel;
  @Param showArrow: boolean = true;
  @Param bgColor: string = '#FFFFFF';
  @Param onItemClick?: (item: ListItemModel) => void = undefined;

  build() {
    Row() {
      Column() {
        Text(this.item.title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .alignSelf(ItemAlign.Start)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.item.description)
          .fontSize(14)
          .fontColor('#666666')
          .margin({ top: 4 })
          .alignSelf(ItemAlign.Start)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      if (this.showArrow) {
        Text('>')
          .fontSize(16)
          .fontColor('#999999')
      }
    }
    .width('100%')
    .padding(16)
    .backgroundColor(this.bgColor)
    .borderRadius(8)
    .onClick(() => {
      if (this.onItemClick) {
        this.onItemClick(this.item);
      }
    })
  }
}

// 简化版列表项视图
@ComponentV2
export struct SimpleListItemView {
  @Param @Require item: ListItemModel;
  @Param onItemClick?: (item: ListItemModel) => void = undefined;

  build() {
    Row() {
      Text(this.item.title)
        .fontSize(16)
        .fontColor('#333333')
        .layoutWeight(1)

      Text(`ID: ${this.item.id}`)
        .fontSize(12)
        .fontColor('#999999')
    }
    .width('100%')
    .padding({
      left: 16,
      right: 16,
      top: 12,
      bottom: 12
    })
    .backgroundColor(Color.White)
    .onClick(() => {
      if (this.onItemClick) {
        this.onItemClick(this.item);
      }
    })
  }
}
