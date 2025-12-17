import { InfoToggleRow } from '../components/InfoToggleRow'

@Entry
@ComponentV2
struct Index {
  @Local message: string = 'Hello World'

  // 简化真实数据处理，
  @Local data?: Map<string, boolean>
  @Local updatingMap: Map<string, boolean> = new Map()
  count = 0

  build() {
    RelativeContainer() {
      InfoToggleRow({
        title: '标题',
        description: '说明',
        isOn: this.getSwitchValue('key'),
        isUpdating: this.isUpdating('key'),
        onChange: (isOn: boolean) => {
          this.handleSwitchChange('key', isOn)
        },
      })
    }
    .height('100%')
    .width('100%')
  }

  async handleSwitchChange(key: string, isOn: boolean) {
    if (this.isUpdating(key)) {
      return
    }
    const oldValue = this.getSwitchValue(key)

    this.data?.set(key, isOn)
    this.updatingMap.set(key, true)

    try {
      await this.updateSwitch(key, isOn)
    } catch (error) {
      console.log('收到错误，回滚')
      this.data?.set(key, oldValue)
    } finally {
      this.updatingMap.delete(key)
    }
  }

  aboutToAppear(): void {
    this.data = new Map([
      ['key', true],
    ])
  }

  async updateSwitch(key: string, isOn: boolean) {
    await new Promise<number>(resolve => setTimeout(() => resolve(100), 100))
    this.count++
    if (this.count % 3 == 0) {
      throw Error('模拟随机错误')
    }
  }

  isUpdating(key: string): boolean {
    return this.updatingMap.get(key) === true
  }

  getSwitchValue(key: string): boolean {
    return this.data?.get(key) ?? false
  }
}

