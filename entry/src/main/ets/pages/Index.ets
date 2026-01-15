import { common } from '@kit.AbilityKit'
import { AudioCapturer, CapturerState } from 'audio_recorder'

@Entry
@Component
struct Index {
  private capturer: AudioCapturer | undefined = undefined
  @State private capturerState: CapturerState = CapturerState.Idle
  @State private lastCapturedFile: string = ''

  aboutToAppear() {
    const cacheDir = (getContext() as common.UIAbilityContext).cacheDir
    this.capturer = new AudioCapturer(cacheDir)
    this.capturer.setListener({
      onStateChange: (state) => {
        this.capturerState = state
      },
      onError: (message) => {
        console.error(message)
      },
    })
  }

  build() {
    Scroll() {
      Column() {
        Text(`采集状态: ${CapturerState[this.capturerState]}`)
          .fontSize(16)
          .margin(10)

        if (this.lastCapturedFile) {
          Text(`最后采集: ${this.lastCapturedFile}`)
            .fontSize(12)
            .margin(10)
        }

        Row() {
          Column() {
            Text('初始化').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('25%')
          .margin({ right: 12, bottom: 12 })
          .onClick(() => {
            try {
              this.capturer?.init({ fileName: 'capture_example' })
            } catch (err) {
              console.error(`初始化采集器失败: ${err}`)
            }
          })

          Column() {
            Text('开始录制').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('25%')
          .margin({ bottom: 12 })
          .onClick(() => {
            try {
              this.capturer?.start()
            } catch (err) {
              console.error(`开始采集失败: ${err}`)
            }
          })
        }

        Row() {
          Column() {
            Text('停止录制').fontSize(16).margin({ top: 12 })
          }
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('25%')
          .margin({ right: 12, bottom: 12 })
          .onClick(() => {
            try {
              this.capturer?.stop()
            } catch (err) {
              console.error(`停止采集失败: ${err}`)
            }
          })

          Column() {
            Text('释放资源').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('25%')
          .margin({ bottom: 12 })
          .onClick(() => {
            try {
              const filePath = this.capturer?.release()
              if (filePath) {
                this.lastCapturedFile = filePath
              }
            } catch (err) {
              console.error(`释放资源失败: ${err}`)
            }
          })
        }
        .padding(12)
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
    }
  }
}