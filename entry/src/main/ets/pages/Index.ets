import { hilog } from '@kit.PerformanceAnalysisKit'

const TAG = 'MonitorTest'

function log(msg: string) {
  hilog.info(0xFF00, TAG, '%{public}s', msg)
}

// 模拟跨单例的 @Trace Map 场景
@ObservedV2
class SharedModel {
  @Trace count: number = 0
  @Trace versionMap: Map<string, number> = new Map()

  static get instance(): SharedModel {
    return (SharedModel._instance ??= new SharedModel())
  }

  private static _instance?: SharedModel
}

// 测试1: @ObservedV2 类中 @Monitor 监控 @Computed
@ObservedV2
class ModelWithComputed {
  @Trace value: number = 0

  @Computed
  get doubled(): number {
    log('[Computed] doubled 重新求值: ' + this.value + ' * 2 = ' + (this.value * 2))
    return this.value * 2
  }

  @Monitor('doubled')
  onDoubledChange(m: IMonitor) {
    log('[测试1] @Monitor(@Computed) 触发: ' + m.value()?.before + ' -> ' + m.value()?.now)
  }
}

// 测试2: @ObservedV2 类中 @Computed 依赖 Map
@ObservedV2
class ModelWithMapComputed {
  @Trace dataMap: Map<string, number> = new Map()

  @Computed
  get mapValue(): number {
    const v = this.dataMap.get('key1') ?? -1
    log('[Computed] mapValue 重新求值: ' + v)
    return v
  }

  @Monitor('mapValue')
  onMapValueChange(m: IMonitor) {
    log('[测试2] @Monitor(@Computed依赖Map) 触发: ' + m.value()?.before + ' -> ' + m.value()?.now)
  }
}

// 测试3: @ObservedV2 类中 @Computed 依赖跨单例 Map
@ObservedV2
class ModelWithCrossComputed {
  @Computed
  get crossMapValue(): number {
    const v = SharedModel.instance.versionMap.get('avatar') ?? -1
    log('[Computed] crossMapValue 重新求值: ' + v)
    return v
  }

  @Monitor('crossMapValue')
  onCrossMapValueChange(m: IMonitor) {
    log('[测试3] @Monitor(@Computed依赖跨单例Map) 触发: ' + m.value()?.before + ' -> ' + m.value()?.now)
  }
}

// 子组件: 测试 @Monitor 监控 @Param 和 @Computed
@ComponentV2
struct ChildComp {
  @Require @Param paramDirect: number // 父组件的可观测值
  @Require @Param paramFromComputed: number // 父组件的 @Computed 值
  @Local localVal: number = 0

  @Computed
  get childComputed(): number {
    log('[Computed] childComputed 重新求值: paramDirect=' + this.paramDirect)
    return this.paramDirect * 10
  }

  // 测试4: @Monitor 监控 @Local（基线）
  @Monitor('localVal')
  onLocalChange(m: IMonitor) {
    log('[测试4] @Monitor(@Local) 触发: ' + m.value()?.before + ' -> ' + m.value()?.now)
  }

  // 测试5: @Monitor 监控 @Param（外部可观测值传入）
  @Monitor('paramDirect')
  onParamDirectChange(m: IMonitor) {
    log('[测试5] @Monitor(@Param<-observable) 触发: ' + m.value()?.before + ' -> ' + m.value()?.now)
  }

  // 测试6: @Monitor 监控 @Param（外部 @Computed 值传入）
  @Monitor('paramFromComputed')
  onParamComputedChange(m: IMonitor) {
    log('[测试6] @Monitor(@Param<-computed) 触发: ' + m.value()?.before + ' -> ' + m.value()?.now)
  }

  // 测试7: @Monitor 监控 @Computed（组件内）
  @Monitor('childComputed')
  onChildComputedChange(m: IMonitor) {
    log('[测试7] @Monitor(@Computed in Component) 触发: ' + m.value()?.before + ' -> ' + m.value()?.now)
  }

  build() {
    Column({ space: 4 }) {
      Text('--- 子组件 ---').fontWeight(FontWeight.Bold)
      Text('paramDirect: ' + this.paramDirect)
      Text('paramFromComputed: ' + this.paramFromComputed)
      Text('childComputed: ' + this.childComputed)
      Text('localVal: ' + this.localVal)
      Button('localVal++ [测试4]')
        .onClick(() => {
          this.localVal++
        })
    }
    .padding(8)
    .backgroundColor('#F0F0F0')
    .borderRadius(8)
    .width('100%')
  }
}

@Entry
@ComponentV2
struct Index {
  @Local model: ModelWithComputed = new ModelWithComputed()
  @Local mapModel: ModelWithMapComputed = new ModelWithMapComputed()
  @Local crossModel: ModelWithCrossComputed = new ModelWithCrossComputed()

  @Computed
  get parentComputed(): number {
    return this.model.value * 3
  }

  build() {
    Scroll() {
      Column({ space: 8 }) {
        Text('@Monitor 测试面板').fontSize(20).fontWeight(FontWeight.Bold)
        Text('HiLog tag: MonitorTest').fontSize(12).fontColor('#999')

        // 测试1: @Computed in @ObservedV2
        Column({ space: 4 }) {
          Text('测试1: @Monitor(@Computed)').fontWeight(FontWeight.Bold).fontSize(14)
          Button('value++ → doubled')
            .onClick(() => {
              this.model.value++
              log('--- value 改为 ' + this.model.value + ' ---')
            })
          Text('value=' + this.model.value + '  doubled=' + this.model.doubled)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        // 测试2: @Computed 依赖自身 Map
        Column({ space: 4 }) {
          Text('测试2: @Computed依赖Map').fontWeight(FontWeight.Bold).fontSize(14)
          Button('map.set(key1)')
            .onClick(() => {
              const newVal = (this.mapModel.dataMap.get('key1') ?? 0) + 1
              this.mapModel.dataMap.set('key1', newVal)
              log('--- dataMap.set key1=' + newVal + ' ---')
            })
          Text('mapValue=' + this.mapModel.mapValue)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        // 测试3: @Computed 依赖跨单例 Map
        Column({ space: 4 }) {
          Text('测试3: @Computed依赖跨单例Map').fontWeight(FontWeight.Bold).fontSize(14)
          Button('跨单例 map.set(avatar)')
            .onClick(() => {
              const newVal = (SharedModel.instance.versionMap.get('avatar') ?? 0) + 1
              SharedModel.instance.versionMap.set('avatar', newVal)
              log('--- SharedModel versionMap.set avatar=' + newVal + ' ---')
            })
          Text('crossMapValue=' + this.crossModel.crossMapValue)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        // 测试5/6/7: 子组件 @Param 和 @Computed
        Column({ space: 4 }) {
          Text('测试5/6/7: 子组件@Param和@Computed').fontWeight(FontWeight.Bold).fontSize(14)
          Button('model.value++ (传入子组件)')
            .onClick(() => {
              this.model.value++
              log('--- model.value 改为 ' + this.model.value + ' (传入子组件) ---')
            })
          Text('parentComputed=' + this.parentComputed)
        }
        .alignItems(HorizontalAlign.Start)
        .width('100%')

        ChildComp({
          paramDirect: this.model.value,
          paramFromComputed: this.parentComputed
        })
      }
      .padding(16)
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}