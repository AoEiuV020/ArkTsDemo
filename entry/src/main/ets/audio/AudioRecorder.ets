import { media } from '@kit.MediaKit'
import { fileIo } from '@kit.CoreFileKit'

/**
 * 录音状态
 */
export enum RecorderState {
  /** 未初始化 */
  Idle,
  /** 已就绪，可以开始录音 */
  Ready,
  /** 录音中 */
  Recording,
  /** 暂停中 */
  Paused,
}

/**
 * 录音配置选项
 */
export interface RecorderOptions {
  /** 文件保存路径（不含扩展名），默认使用时间戳命名 */
  fileName?: string
}

/**
 * 录音状态变化监听器
 */
export interface RecorderStateListener {
  onStateChange?: (state: RecorderState) => void
  onError?: (message: string) => void
}

/**
 * 录音工具类
 * 封装音频录制的所有技术细节，提供简洁的业务接口
 */
export class AudioRecorder {
  private avRecorder: media.AVRecorder | undefined = undefined
  private audioFile: fileIo.File | undefined = undefined
  private currentFilePath: string = ''
  private filesDir: string
  private listener: RecorderStateListener | undefined = undefined
  /** 录音文件扩展名 */
  private static readonly FILE_EXTENSION = '.amr'

  private readonly avProfile: media.AVRecorderProfile = {
    audioBitrate: 23850,
    audioChannels: 1,
    audioCodec: media.CodecMimeType.AUDIO_AMR_WB,
    audioSampleRate: 16000,
    fileFormat: media.ContainerFormatType.CFT_AMR,
  }

  /**
   * 构造录音工具
   * @param filesDir 文件存储目录，通常传入 context.filesDir
   */
  constructor(filesDir: string) {
    this.filesDir = filesDir
  }

  private _state: RecorderState = RecorderState.Idle

  /**
   * 当前录音状态
   */
  get state(): RecorderState {
    return this._state
  }

  /**
   * 当前录音文件路径
   */
  get filePath(): string {
    return this.currentFilePath
  }

  /**
   * 设置状态监听器
   */
  setListener(listener: RecorderStateListener) {
    this.listener = listener
  }

  /**
   * 准备录音
   * @param options 录音配置选项
   */
  async prepare(options?: RecorderOptions) {
    if (this._state !== RecorderState.Idle) {
      return
    }

    this.avRecorder = await media.createAVRecorder()
    this.setupRecorderCallbacks()

    const fileName = options?.fileName ?? `recording_${Date.now()}`
    this.currentFilePath = `${this.filesDir}/${fileName}${AudioRecorder.FILE_EXTENSION}`

    this.audioFile = fileIo.openSync(this.currentFilePath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)

    const avConfig: media.AVRecorderConfig = {
      audioSourceType: media.AudioSourceType.AUDIO_SOURCE_TYPE_MIC,
      profile: this.avProfile,
      url: `fd://${this.audioFile.fd}`,
    }

    await this.avRecorder.prepare(avConfig)
    this.updateState(RecorderState.Ready)
  }

  /**
   * 开始录音
   */
  async start() {
    if (this._state !== RecorderState.Ready) {
      return
    }
    await this.avRecorder?.start()
    this.updateState(RecorderState.Recording)
  }

  /**
   * 暂停录音
   */
  async pause() {
    if (this._state !== RecorderState.Recording) {
      return
    }
    await this.avRecorder?.pause()
    this.updateState(RecorderState.Paused)
  }

  /**
   * 恢复录音
   */
  async resume() {
    if (this._state !== RecorderState.Paused) {
      return
    }
    await this.avRecorder?.resume()
    this.updateState(RecorderState.Recording)
  }

  /**
   * 停止录音并保存文件
   * @returns 录音文件路径
   */
  async stop(): Promise<string> {
    if (this._state !== RecorderState.Recording && this._state !== RecorderState.Paused) {
      return ''
    }

    await this.avRecorder?.stop()
    const savedPath = this.currentFilePath
    await this.cleanup()
    return savedPath
  }

  /**
   * 取消录音，删除文件
   */
  async cancel() {
    const pathToDelete = this.currentFilePath
    await this.cleanup()

    if (pathToDelete) {
      try {
        await fileIo.unlink(pathToDelete)
      } catch {
        // 文件可能不存在，忽略错误
      }
    }
  }

  /**
   * 释放资源
   */
  async release() {
    await this.cleanup()
  }

  private async cleanup() {
    if (this.avRecorder) {
      await this.avRecorder.reset()
      await this.avRecorder.release()
      this.avRecorder = undefined
    }

    if (this.audioFile !== undefined) {
      await fileIo.close(this.audioFile.fd)
      this.audioFile = undefined
    }

    this.currentFilePath = ''
    this.updateState(RecorderState.Idle)
  }

  private setupRecorderCallbacks() {
    this.avRecorder?.on('stateChange', (state: media.AVRecorderState, reason: media.StateChangeReason) => {
      console.info(`AudioRecorder 状态变化: ${state}, 原因: ${reason}`)
    })

    this.avRecorder?.on('error', (error) => {
      console.error(`AudioRecorder 错误: ${error.code}, ${error.message}`)
      this.listener?.onError?.(`录音错误: ${error.message}`)
    })
  }

  private updateState(newState: RecorderState) {
    this._state = newState
    this.listener?.onStateChange?.(newState)
  }
}
