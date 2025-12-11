class Model {
  cache: Map<string, string> = new Map()
  private listeners: Array<(key?: string) => void> = []

  constructor() {
    this.initData()
    // 注册外部回调
    onSomethingChanged = (key: string, value: string) => {
      this.cache.set(key, value)
      this.notifyListeners(key)
    }
  }

  getValue(key: string): string {
    return this.cache.get(key) ?? ''
  }

  onChanged(callback: (key?: string) => void) {
    this.listeners.push(callback)
  }

  private async initData() {
    this.cache = await getInitialData()
    this.notifyListeners()
  }

  private notifyListeners(key?: string) {
    this.listeners.forEach(callback => callback(key))
  }
}

@ObservedV2
class ViewModel {
  @Trace cache: Map<string, string> = new Map()
  private model: Model = new Model()

  constructor() {
    this.model.onChanged((key?: string) => {
      if (!key) {
        // 参数为空，更新整个Map
        this.cache = this.model.cache
      } else {
        // 有参数，只更新这一个key
        // TODO: 这里是否有任何办法只更新这一个值？由于model中的数据源已经改变了， 这里set无效，
        // this.cache.set(key, this.model.getValue(key))
        this.cache = this.model.cache
      }
    })
  }

  getValue(key: string): string {
    return this.cache.get(key) ?? ''
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
  const data = new Map<string, string>()
  data.set('greeting', 'Hello World')
  return data
}
