import { ImagePreviewView } from '../view/ImagePreviewView';

@Entry
@ComponentV2
struct Index {
  @Provider() pathStack: NavPathStack = new NavPathStack()
  @Provider() imageUrl: string = 'https://avatar.exlb.net/avatar/ohos_scale'

  build() {
    RelativeContainer() {
      ImagePreviewView()
    }
    .height('100%')
    .width('100%')
  }
}