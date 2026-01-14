import { media } from '@kit.MediaKit'
import { fileIo } from '@kit.CoreFileKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit'

@Entry
@Component
struct Index {
  atManager = abilityAccessCtrl.createAtManager()
  permissions: Array<Permissions> = [
    'ohos.permission.MICROPHONE',
  ]
  // 创建avRecorder对象。
  private avRecorder: media.AVRecorder | undefined = undefined
  private avProfile: media.AVRecorderProfile = {
    audioBitrate: 112000, // 音频比特率。
    audioChannels: 2, // 音频声道数。
    audioCodec: media.CodecMimeType.AUDIO_MP3, // 音频编码格式，当前支持AAC，MP3，G711MU。
    audioSampleRate: 48000, // 音频采样率。
    fileFormat: media.ContainerFormatType.CFT_MP3, // 封装格式，当前支持MP4，M4A，MP3，WAV，AMR，AAC。
  }
  private avConfig: media.AVRecorderConfig = {
    audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC, // 音频输入源，这里设置为麦克风。
    profile: this.avProfile,
    url: 'fd://35', // 参考应用文件访问与管理开发示例新建并读写一个文件。
  }
  // 创建文件以及设置avConfig.url。
  private audioFile: fileIo.File | undefined = undefined
  private AVplaer = new AVPlayerDemo()

  // 请求权限
  async requestPermissions(): Promise<boolean> {
    return await new Promise((resolve: Function) => {
      try {
        let context = getContext() as common.UIAbilityContext
        this.atManager.requestPermissionsFromUser(context, this.permissions)
          .then(async () => {
            console.log(`yl test info : ${JSON.stringify('权限请求成功')}`)
            resolve(true)
          }).catch(() => {
          console.error(`yl test info : ${JSON.stringify('权限请求异常')}`)
          resolve(false)
        })
      } catch (err) {
        console.error(`yl test info : ${JSON.stringify('权限请求err')}` + err)
        resolve(false)
      }
    })
  }

  async init() {
    try {
      this.avRecorder = await media.createAVRecorder()
    } catch (error) {
      let err = error as BusinessError
      console.error(`Failed to create avRecorder, error code: ${err.code}, message: ${err.message}`)
      return
    }
    // 注册avRecorder回调函数。
    try {
      // 状态机变化回调函数。
      this.avRecorder.on('stateChange', (state: media.AVRecorderState, reason: media.StateChangeReason) => {
        console.info(`AVRecorder state is changed to ${state}, reason: ${reason}`)
      })
      // 错误上报回调函数。
      this.avRecorder.on('error', (error: BusinessError) => {
        console.error(`Error occurred in avRecorder, error code: ${error.code}, message: ${error.message}`)
      })
    } catch (error) {
      let err = error as BusinessError
      console.error(`Failed to set avRecorder callback, error code: ${err.code}, message: ${err.message}`)
    }
    try {
      let path: string = this.getUIContext().getHostContext()?.filesDir + '/example.mp3' // 文件沙箱路径，文件后缀名应与封装格式对应。
      this.audioFile = fileIo.openSync(path, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE) // 打开文件。
    } catch (error) {
      let err = error as BusinessError
      console.error(`Failed to open file, error code: ${err.code}, message: ${err.message}`)
    }
    if (this.audioFile !== undefined) {
      this.avConfig.url = 'fd://' + this.audioFile.fd // 更新url。
    }
    // 配置录制参数完成准备工作。
    try {
      if (this.avRecorder.state === 'idle' ||
        this.avRecorder.state === 'stopped') { // 仅在idle或者stopped状态下调用prepare为合理状态切换。
        await this.avRecorder.prepare(this.avConfig)
      }
    } catch (error) {
      let err = error as BusinessError
      console.error(`Failed to prepare avRecorder, error code: ${err.code}, message: ${err.message}`)
    }
  }

  async start() {
    // 开始录制。
    try {
      if (this.avRecorder?.state === 'prepared') { // 仅在prepared状态下调用start为合理状态切换。
        await this.avRecorder.start()
      }
    } catch (error) {
      let err = error as BusinessError
      console.error(`Failed to start avRecorder, error code: ${err.code}, message: ${err.message}`)
    }
  }

  async pause() {
    // 暂停录制。
    try {
      if (this.avRecorder?.state === 'started') { // 仅在started状态下调用pause为合理状态切换。
        await this.avRecorder.pause()
      }
    } catch (error) {
      let err = error as BusinessError
      console.error(`Failed to pause avRecorder, error code: ${err.code}, message: ${err.message}`)
    }
  }

  async resume() {
    // 恢复录制。
    try {
      if (this.avRecorder?.state === 'paused') { // 仅在paused状态下调用resume为合理状态切换。
        await this.avRecorder.resume()
      }
    } catch (error) {
      let err = error as BusinessError
      console.error(`Failed to resume avRecorder, error code: ${err.code}, message: ${err.message}`)
    }
  }

  async stop() {
    // 停止录制。
    try {
      if (this.avRecorder?.state === 'started' ||
        this.avRecorder?.state === 'paused') { // 仅在started或者paused状态下调用stop为合理状态切换。
        await this.avRecorder.stop()
      }
    } catch (error) {
      let err = error as BusinessError
      console.error(`Failed to stop avRecorder, error code: ${err.code}, message: ${err.message}`)
    }
  }

  async reset() {
    // 重置。
    try {
      await this.avRecorder?.reset()
    } catch (error) {
      let err = error as BusinessError
      console.error(`Failed to reset avRecorder, error code: ${err.code}, message: ${err.message}`)
    }
    // 释放录制实例。
    try {
      await this.avRecorder?.release()
      this.avRecorder = undefined
    } catch (error) {
      let err = error as BusinessError
      console.error(`Failed to release avRecorder, error code: ${err.code}, message: ${err.message}`)
    }
    // 关闭录制文件fd。
    try {
      if (this.audioFile !== undefined) {
        await fileIo.close(this.audioFile.fd)
      }
    } catch (error) {
      let err = error as BusinessError
      console.error(`Failed to close fd, error code: ${err.code}, message: ${err.message}`)
    }
  }

  aboutToAppear(): void {
    this.requestPermissions()
  }


  build() {
    Column() {
      Button('init')
        .onClick(() => {
          this.init()
        })
      Button('start').onClick(() => {
        this.start()
      })
      Button('pause').onClick(() => {
        this.pause()
      })
      Button('resume').onClick(() => {
        this.resume()
      })
      Button('stop').onClick(() => {
        this.stop()
      })
      Button('reset')
        .onClick(() => {
          this.reset()
        })
      Button('播放音频')
        .onClick(() => {
          this.AVplaer.avPlayerUrlDemo()
        })
    }
    .height('100%')
    .width('100%')
  }
}

// 音频播放
export class AVPlayerDemo {
  public static avPlayerCom: media.AVPlayer
  public static avFileDescriptorCom: media.AVFileDescriptor
  public flag: number = 1
  public curAudioPath: string = ''
  public avFileDescriptor4: media.AVFileDescriptor | undefined = undefined
  private count: number = 0
  private isSeek: boolean = true // 用于区分模式是否支持seek操作
  private fileSize: number = -1
  private fd: number = 0

  // 注册avplayer回调函数
  setAVPlayerCallback(avPlayer: media.AVPlayer): void {
    // seek操作结果回调函数
    avPlayer.on('seekDone', (seekDoneTime: number) => {
      console.info(`AVPlayer seek succeeded, seek time is ${seekDoneTime}`)
    })
    // error回调监听函数,当avPlayer在操作过程中出现错误时调用 reset接口触发重置流程
    avPlayer.on('error', (err: BusinessError) => {
      console.error(`Invoke avPlayer failed, code is ${err.code}, message is ${err.message}`)
      avPlayer.reset() // 调用reset重置资源，触发idle状态
    })
    // 状态机变化回调函数
    avPlayer.on('stateChange', async (state: string, _: media.StateChangeReason) => {
      switch (state) {
        case 'idle': // 成功调用reset接口后触发该状态机上报
          console.info('AVPlayer state idle called.')
          avPlayer.release() // 调用release接口销毁实例对象
          break
        case 'initialized': // avplayer 设置播放源后触发该状态上报
          console.info('AVPlayer state initialized called.')
          avPlayer.prepare()
          break
        case 'prepared': // prepare调用成功后上报该状态机
          console.info('AVPlayer state prepared called.')
          avPlayer.play() // 调用播放接口开始播放
          break
        case 'playing': // play成功调用后触发该状态机上报
          console.info('AVPlayer state playing called.')
          this.count++
          break
        case 'paused': // pause成功调用后触发该状态机上报
          console.info('AVPlayer state paused called.')
          avPlayer.play() // 再次播放接口开始播放
          break
        case 'completed': // 播放结束后触发该状态机上报
          console.info('AVPlayer state completed called.')
          avPlayer.stop() //调用播放结束接口
          break
        case 'stopped': // stop接口成功调用后触发该状态机上报
          console.info('AVPlayer state stopped called.')
          avPlayer.reset() // 调用reset接口初始化avplayer状态
          break
        case 'released':
          console.info('AVPlayer state released called.')
          break
        default:
          console.info('AVPlayer state unknown called.')
          break
      }
    })
  }

  // 以下demo为使用fs文件系统打开沙箱地址获取媒体文件地址并通过url属性进行播放示例
  async avPlayerUrlDemo(): Promise<void> {
    // 创建avPlayer实例对象
    try {
      // 创建avPlayer实例对象
      const avPlayer: media.AVPlayer = await media.createAVPlayer()
      avPlayer.audioRendererInfo
      // 创建状态机变化回调函数
      await this.setAVPlayerCallback(avPlayer)
      // 通过UIAbilityContext获取沙箱地址filesDir，以Stage模型为例
      const context = getContext(this) as common.UIAbilityContext
      // 创建状态机变化回调函数
      this.setAVPlayerCallback(avPlayer)
      let fdPath = 'fd://'
      let pathDir = context.filesDir
      let path = pathDir + '/example.mp3'
      // 打开相应的资源文件地址获取fd，并为url赋值触发initialized状态机上报
      let file = await fileIo.open(path)
      fdPath = fdPath + '' + file.fd
      this.isSeek = true // 支持seek操作
      avPlayer.url = fdPath
    } catch (e) {
      console.error(e)
    }
  }
}