@ObservedV2
class Model {
  @Trace cache: Map<string, string> = new Map()

  constructor() {
    this.initData()
    // 注册外部回调
    onSomethingChanged = (key: string, value: string) => {
      this.cache.set(key, value)
    }
  }

  private async initData() {
    this.cache = await getInitialData()
  }

}

@ObservedV2
class ViewModel {
  @Trace model: Model = new Model()

  getValue(key: string): string {
    return this.model.cache.get(key) ?? ''
  }

  doSomething() {
    doSomething()
  }
}

@Entry
@ComponentV2
struct Index {
  @Local viewModel: ViewModel = new ViewModel()

  build() {
    Column() {
      Text(this.viewModel.getValue('greeting'))

      Button('Update Model')
        .onClick(() => {
          this.viewModel.doSomething()
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

// 模拟外部复杂系统
let onSomethingChanged: (key: string, value: string) => void = () => {
}

async function doSomething() {
  await changeSomething()
}

let count = 0

async function changeSomething() {
  // 模拟复杂的业务处理
  count++
  onSomethingChanged('greeting', 'Hello MVVM! ' + count)
}

async function getInitialData(): Promise<Map<string, string>> {
  // 模拟异步获取初始数据
  await new Promise<number>(resolve => setTimeout(resolve, 100))
  return new Map([
    ['greeting', 'Hello World'],
  ])
}
