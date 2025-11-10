@Entry
@Component
struct Index {
  build() {
    Column() {
      Text('[文件]3ac761f97bc9432fb5f3c1ab8583832a.amr')
        .height('100%')
        .width('100%')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .height('80%')
    .width('80%')
  }
}