@Entry
@ComponentV2
struct Index {
  @Local flag: boolean = true;

  build() {
    Column() {
      Child({
        flag: this.flag,
        changeFactory: () => {
          this.flag = false;
        }
      }) {
        Text(`content`)
      }
    }
  }
}

@ComponentV2
struct Child {
  @Param flag: boolean = true;
  @Event changeFactory?: () => void = undefined;
  // 带上@Require就会崩溃，坑爹，
  // https://developer.huawei.com/consumer/cn/forum/topic/0203192451040831346
  // @Require
  @BuilderParam content: () => void

  build() {
    Column() {
      Text(`${this.flag}`)
      Button('change')
        .onClick(() => {
          this.changeFactory?.();
        })
      this.content();
    }
  }
}