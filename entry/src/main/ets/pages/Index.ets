import { common } from '@kit.AbilityKit'
import { AudioCapturer, CapturerState } from 'audio_recorder'

@Entry
@Component
struct Index {
  private capturer: AudioCapturer = new AudioCapturer()
  @State private capturerState: CapturerState = CapturerState.Idle
  @State private lastPcmFile: string = ''
  @State private lastEncodedFile: string = ''

  aboutToAppear() {
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

        if (this.lastPcmFile) {
          Text(`PCM文件: ${this.lastPcmFile}`)
            .fontSize(12)
            .margin(10)
        }

        if (this.lastEncodedFile) {
          Text(`编码文件: ${this.lastEncodedFile}`)
            .fontSize(12)
            .margin(10)
        }

        Row() {
          Column() {
            Text('初始化(AMR)').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('25%')
          .margin({ right: 12, bottom: 12 })
          .onClick(() => {
            const cacheDir = (getContext() as common.UIAbilityContext).cacheDir
            // 使用.amr后缀，触发AMR-WB编码，同时产出.pcm文件
            this.capturer.init({ outputFilePath: `${cacheDir}/capture_${Date.now()}.amr` })
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
            this.capturer.start()
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
            this.capturer.stop()
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
            this.lastPcmFile = this.capturer.pcmFilePath
            this.lastEncodedFile = this.capturer.outputPath
            this.capturer.release()
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