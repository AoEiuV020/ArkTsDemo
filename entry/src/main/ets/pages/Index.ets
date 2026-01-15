import { common } from '@kit.AbilityKit'
import { AudioRecorder, RecorderState } from 'audio_recorder'

@Entry
@Component
struct Index {
  private recorder: AudioRecorder = new AudioRecorder()
  @State private recorderState: RecorderState = RecorderState.Idle
  @State private lastPcmFile: string = ''
  @State private lastEncodedFile: string = ''

  aboutToAppear() {
    this.recorder.setListener({
      onStateChange: (state) => {
        this.recorderState = state
      },
      onError: (message) => {
        console.error(message)
      },
    })
  }

  build() {
    Scroll() {
      Column() {
        Text(`录音状态: ${RecorderState[this.recorderState]}`)
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
            this.recorder.init({ outputFilePath: `${cacheDir}/capture_${Date.now()}.mp3` })
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
            this.recorder.start()
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
            this.recorder.stop()
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
            this.lastPcmFile = this.recorder.pcmFilePath
            this.lastEncodedFile = this.recorder.outputPath
            this.recorder.release()
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