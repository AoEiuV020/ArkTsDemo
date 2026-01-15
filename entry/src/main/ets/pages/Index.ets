import { common } from '@kit.AbilityKit'
import { RecorderState } from 'audio_recorder'
import { PlayerState } from '../audio/AudioPlayer'
import { RecordingViewModel } from './RecordingViewModel'

@Entry
@Component
struct Index {
  private vm: RecordingViewModel = new RecordingViewModel()

  aboutToAppear() {
    const context = getContext() as common.UIAbilityContext
    this.vm.requestPermissions(context)
  }

  build() {
    Scroll() {
      Column() {
        Text(`录音状态: ${RecorderState[this.vm.recorderState]}`)
          .fontSize(16)
          .margin(10)

        Text(`播放状态: ${PlayerState[this.vm.playerState]}`)
          .fontSize(16)
          .margin(10)

        if (this.vm.lastPcmFile) {
          Text(`PCM文件: ${this.vm.lastPcmFile}`)
            .fontSize(12)
            .margin(10)
        }

        if (this.vm.lastEncodedFile) {
          Text(`编码文件: ${this.vm.lastEncodedFile}`)
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
            this.vm.initRecorder(cacheDir)
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
            this.vm.startRecording()
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
            this.vm.stopRecording()
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
            this.vm.releaseRecorder()
          })
        }

        Row() {
          Column() {
            Text('播放录音').fontColor(Color.Black).fontSize(16).margin({ top: 12 })
          }
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('25%')
          .margin({ right: 12, bottom: 12 })
          .onClick(async () => {
            await this.vm.playRecording()
          })

          Column() {
            Text('删除缓存').fontColor(Color.Red).fontSize(16).margin({ top: 12 })
          }
          .backgroundColor(Color.White)
          .borderRadius(30)
          .width('45%')
          .height('25%')
          .margin({ bottom: 12 })
          .onClick(async () => {
            await this.vm.deleteCache()
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