import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit'
import { AudioRecorder, RecorderState } from 'audio_recorder'
import { fileIo } from '@kit.CoreFileKit'

const TAG = 'RecorderViewModel'

/**
 * 打印日志
 */
function log(message: string) {
  console.info(`[${TAG}] ${message}`)
}

/**
 * 录音 ViewModel
 */
@ObservedV2
export class RecorderViewModel {
  @Trace state: RecorderState = RecorderState.Idle
  @Trace lastPcmFile: string = ''
  @Trace lastEncodedFile: string = ''
  private recorder: AudioRecorder = new AudioRecorder()

  constructor() {
    this.recorder.setListener({
      onStateChange: (state) => {
        log(`录音状态变更: ${RecorderState[state]}`)
        this.state = state
      },
      onError: (message) => {
        log(`录音错误: ${message}`)
        console.error(message)
      },
    })
  }

  /**
   * 打印/proc/self/fd目录下的已打开文件描述符列表
   */
  async printOpenFdList() {
    log('--- 已打开的fd列表 ---')
    try {
      const fdDir = '/proc/self/fd'
      const entries = await fileIo.listFile(fdDir)
      for (const entry of entries) {
        log(`  fd ${entry}`)
      }
      log(`  共 ${entries.length} 个fd`)
    } catch (error) {
      const e = error as Error
      log(`读取fd列表失败: ${e.message}`)
    }
    log('--- fd列表结束 ---')
  }

  /**
   * 请求麦克风权限
   */
  async requestPermissions(context: common.UIAbilityContext) {
    log('请求麦克风权限开始')
    try {
      const permissions: Permissions[] = ['ohos.permission.MICROPHONE']
      const atManager = abilityAccessCtrl.createAtManager()
      await atManager.requestPermissionsFromUser(context, permissions)
      log('请求麦克风权限结束')
    } catch (error) {
      const e = error as Error
      log(`请求麦克风权限失败: ${e.message}`)
    }
  }

  /**
   * 初始化录音器
   */
  async init(cacheDir: string) {
    log('初始化录音器开始')
    await this.printOpenFdList()
    try {
      this.recorder.init({ outputFilePath: `${cacheDir}/capture_${Date.now()}.amr` })
      log('初始化录音器结束')
    } catch (error) {
      const e = error as Error
      log(`初始化录音器失败: ${e.message}`)
    }
  }

  /**
   * 开始录音
   */
  start() {
    log('开始录音')
    try {
      this.recorder.start()
      log('开始录音完成')
    } catch (error) {
      const e = error as Error
      log(`开始录音失败: ${e.message}`)
    }
  }

  /**
   * 停止录音
   */
  stop() {
    log('停止录音')
    try {
      this.recorder.stop()
      log('停止录音完成')
    } catch (error) {
      const e = error as Error
      log(`停止录音失败: ${e.message}`)
    }
  }

  /**
   * 释放录音器资源
   */
  async release() {
    log('释放录音器资源开始')
    try {
      this.lastPcmFile = this.recorder.pcmFilePath
      this.lastEncodedFile = this.recorder.outputPath
      this.recorder.release()
      log('释放录音器资源结束')
      await this.printOpenFdList()
    } catch (error) {
      const e = error as Error
      log(`释放录音器资源失败: ${e.message}`)
    }
  }

  /**
   * 删除缓存文件
   */
  deleteFiles() {
    log('删除缓存开始')
    try {
      if (this.lastEncodedFile) {
        AudioRecorder.deleteFiles(this.lastEncodedFile)
        this.lastPcmFile = ''
        this.lastEncodedFile = ''
      }
      log('删除缓存结束')
    } catch (error) {
      const e = error as Error
      log(`删除缓存失败: ${e.message}`)
    }
  }
}
