import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit'
import { AudioPlayer, AudioRecorder, PlayerState, RecorderState } from '../audio'

@Entry
@Component
struct Index {
  private atManager = abilityAccessCtrl.createAtManager()
  private permissions: Array<Permissions> = ['ohos.permission.MICROPHONE']
  private recorder: AudioRecorder | undefined = undefined
  private player: AudioPlayer = new AudioPlayer()
  @State private recorderState: RecorderState = RecorderState.Idle
  @State private playerState: PlayerState = PlayerState.Idle
  @State private lastRecordedFile: string = ''

  async requestPermissions(): Promise<boolean> {
    const context = getContext() as common.UIAbilityContext
    try {
      await this.atManager.requestPermissionsFromUser(context, this.permissions)
      console.info('麦克风权限请求成功')
      return true
    } catch (err) {
      console.error(`麦克风权限请求失败: ${err}`)
      return false
    }
  }

  aboutToAppear() {
    this.requestPermissions()
    const filesDir = (getContext() as common.UIAbilityContext).filesDir
    this.recorder = new AudioRecorder(filesDir)
    this.recorder.setListener({
      onStateChange: (state) => {
        this.recorderState = state
      },
      onError: (message) => {
        console.error(message)
      },
    })
    this.player.setListener({
      onStateChange: (state) => {
        this.playerState = state
      },
      onError: (message) => {
        console.error(message)
      },
    })
  }

  build() {
    Column() {
      Text(`录音状态: ${RecorderState[this.recorderState]}`)
        .fontSize(16)
        .margin(10)

      Text(`播放状态: ${PlayerState[this.playerState]}`)
        .fontSize(16)
        .margin(10)

      if (this.lastRecordedFile) {
        Text(`最后录音: ${this.lastRecordedFile}`)
          .fontSize(12)
          .margin(10)
      }

      Button('准备录音')
        .onClick(async () => {
          try {
            await this.recorder?.prepare({ fileName: 'example' })
          } catch (err) {
            console.error(`准备录音失败: ${err}`)
          }
        })

      Button('开始录音')
        .onClick(async () => {
          try {
            await this.recorder?.start()
          } catch (err) {
            console.error(`开始录音失败: ${err}`)
          }
        })

      Button('暂停')
        .onClick(async () => {
          try {
            await this.recorder?.pause()
          } catch (err) {
            console.error(`暂停录音失败: ${err}`)
          }
        })

      Button('继续')
        .onClick(async () => {
          try {
            await this.recorder?.resume()
          } catch (err) {
            console.error(`恢复录音失败: ${err}`)
          }
        })

      Button('停止并保存')
        .onClick(async () => {
          try {
            const filePath = await this.recorder?.stop()
            if (filePath) {
              this.lastRecordedFile = filePath
            }
          } catch (err) {
            console.error(`停止录音失败: ${err}`)
          }
        })

      Button('取消录音')
        .onClick(async () => {
          try {
            await this.recorder?.cancel()
          } catch (err) {
            console.error(`取消录音失败: ${err}`)
          }
        })

      Button('播放音频')
        .onClick(async () => {
          try {
            if (this.lastRecordedFile) {
              await this.player.play(this.lastRecordedFile)
            }
          } catch (err) {
            console.error(`播放音频失败: ${err}`)
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}