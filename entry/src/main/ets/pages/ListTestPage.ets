import router from '@ohos.router';

// 定义列表项数据结构
interface ListItem {
  id: number;
  title: string;
  description: string;
}

@Entry
@Component
struct ListTestPage {
  @State listData: ListItem[] = [
    { id: 1, title: '项目一', description: '这是第一个列表项的描述' },
    { id: 2, title: '项目二', description: '这是第二个列表项的描述' },
    { id: 3, title: '项目三', description: '这是第三个列表项的描述' },
    { id: 4, title: '项目四', description: '这是第四个列表项的描述' },
    { id: 5, title: '项目五', description: '这是第五个列表项的描述' },
    { id: 6, title: '项目六', description: '这是第六个列表项的描述' },
    { id: 7, title: '项目七', description: '这是第七个列表项的描述' },
    { id: 8, title: '项目八', description: '这是第八个列表项的描述' },
    { id: 9, title: '项目九', description: '这是第九个列表项的描述' },
    { id: 10, title: '项目十', description: '这是第十个列表项的描述' }
  ];

  build() {
    Column() {
      // 标题栏
      Row() {
        Button('返回')
          .width(60)
          .height(40)
          .onClick(() => {
            router.back();
          })

        Text('列表测试页')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Blank()
          .width(60)
      }
      .width('100%')
      .height(60)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#f5f5f5')

      // 列表内容
      List({ space: 8 }) {
        ForEach(this.listData, (item: ListItem) => {
          ListItem() {
            Row() {
              Column() {
                Text(item.title)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333')
                  .alignSelf(ItemAlign.Start)

                Text(item.description)
                  .fontSize(14)
                  .fontColor('#666666')
                  .margin({ top: 4 })
                  .alignSelf(ItemAlign.Start)
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)

              Text('>')
                .fontSize(16)
                .fontColor('#999999')
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(8)
          }
          .onClick(() => {
            console.log(`点击了项目: ${item.title}`);
          })
        }, (item: ListItem) => item.id.toString())
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
