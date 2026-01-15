import { common } from '@kit.AbilityKit'
import { RecorderState } from 'audio_recorder'
import { PlayerState } from '../audio/AudioPlayer'
import { RecorderViewModel } from './RecorderViewModel'
import { PlayerViewModel } from './PlayerViewModel'

@Entry
@Component
struct Index {
  private recorder: RecorderViewModel = new RecorderViewModel()
  private player: PlayerViewModel = new PlayerViewModel()

  aboutToAppear() {
    const context = getContext() as common.UIAbilityContext
    this.recorder.requestPermissions(context)
  }

  build() {
    Scroll() {
      Column() {
        Text(`录音状态: ${RecorderState[this.recorder.state]}`)
          .fontSize(16)
          .margin(10)

        Text(`播放状态: ${PlayerState[this.player.state]}`)
          .fontSize(16)
          .margin(10)

        if (this.recorder.lastPcmFile) {
          Text(`PCM文件: ${this.recorder.lastPcmFile}`)
            .fontSize(12)
            .margin(10)
        }

        if (this.recorder.lastEncodedFile) {
          Text(`编码文件: ${this.recorder.lastEncodedFile}`)
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
          .onClick(async () => {
            const cacheDir = (getContext() as common.UIAbilityContext).cacheDir
            await this.recorder.init(cacheDir)
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
          .onClick(async () => {
            await this.recorder.release()
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
            if (this.recorder.lastEncodedFile) {
              await this.player.play(this.recorder.lastEncodedFile)
            }
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
            await this.player.release()
            this.recorder.deleteFiles()
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