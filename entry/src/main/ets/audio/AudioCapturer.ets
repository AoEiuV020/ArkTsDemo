import { audio } from '@kit.AudioKit'
import { fileIo as fs } from '@kit.CoreFileKit'

/**
 * 采集器状态
 */
export enum CapturerState {
  /** 未初始化 */
  Idle,
  /** 已就绪 */
  Ready,
  /** 采集中 */
  Running,
  /** 已暂停 */
  Paused,
  /** 已停止 */
  Stopped,
}

/**
 * 采集配置选项
 */
export interface CapturerOptions {
  /** 文件保存路径（不含扩展名），默认使用时间戳命名 */
  fileName?: string
}

/**
 * 采集状态监听器
 */
export interface CapturerStateListener {
  onStateChange?: (state: CapturerState) => void
  onError?: (message: string) => void
  /** 接收采集到的音频数据 */
  onData?: (buffer: ArrayBuffer) => void
}

/**
 * 音频采集工具类
 * 封装 AudioCapturer 的所有技术细节，提供简洁的业务接口
 */
export class AudioCapturer {
  /** 采集文件扩展名 */
  private static readonly FILE_EXTENSION = '.pcm'
  private capturer: audio.AudioCapturer | undefined = undefined
  private file: fs.File | undefined = undefined
  private bufferSize: number = 0
  private cacheDir: string
  private currentFilePath: string = ''
  private listener: CapturerStateListener | undefined = undefined
  private readonly streamInfo: audio.AudioStreamInfo = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_48000,
    channels: audio.AudioChannel.CHANNEL_2,
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW,
  }
  private readonly capturerInfo: audio.AudioCapturerInfo = {
    source: audio.SourceType.SOURCE_TYPE_MIC,
    capturerFlags: 0,
  }

  /**
   * 构造音频采集工具
   * @param cacheDir 缓存目录，通常传入 context.cacheDir
   */
  constructor(cacheDir: string) {
    this.cacheDir = cacheDir
  }

  private _state: CapturerState = CapturerState.Idle

  /**
   * 当前采集状态
   */
  get state(): CapturerState {
    return this._state
  }

  /**
   * 当前采集文件路径
   */
  get filePath(): string {
    return this.currentFilePath
  }

  /**
   * 设置状态监听器
   */
  setListener(listener: CapturerStateListener) {
    this.listener = listener
  }

  /**
   * 初始化采集器
   * @param options 采集配置选项
   */
  async init(options?: CapturerOptions) {
    if (this._state !== CapturerState.Idle) {
      return
    }

    const fileName = options?.fileName ?? `capture_${Date.now()}`
    this.currentFilePath = `${this.cacheDir}/${fileName}${AudioCapturer.FILE_EXTENSION}`
    this.bufferSize = 0

    this.file = fs.openSync(this.currentFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE)

    const capturerOptions: audio.AudioCapturerOptions = {
      streamInfo: this.streamInfo,
      capturerInfo: this.capturerInfo,
    }

    this.capturer = await audio.createAudioCapturer(capturerOptions)
    this.capturer.on('readData', (buffer: ArrayBuffer) => {
      this.handleReadData(buffer)
    })

    this.updateState(CapturerState.Ready)
  }

  /**
   * 开始采集
   */
  async start() {
    if (this._state !== CapturerState.Ready &&
      this._state !== CapturerState.Paused &&
      this._state !== CapturerState.Stopped) {
      return
    }

    await this.capturer?.start()
    this.updateState(CapturerState.Running)
  }

  /**
   * 停止采集
   */
  async stop() {
    if (this._state !== CapturerState.Running && this._state !== CapturerState.Paused) {
      return
    }

    await this.capturer?.stop()
    this.updateState(CapturerState.Stopped)
  }

  /**
   * 释放资源
   * @returns 采集文件路径
   */
  async release(): Promise<string> {
    const savedPath = this.currentFilePath

    if (this.capturer) {
      await this.capturer.release()
      this.capturer = undefined
    }

    if (this.file !== undefined) {
      fs.closeSync(this.file)
      this.file = undefined
    }

    this.currentFilePath = ''
    this.bufferSize = 0
    this.updateState(CapturerState.Idle)

    return savedPath
  }

  private handleReadData(buffer: ArrayBuffer) {
    if (this.file !== undefined) {
      fs.writeSync(this.file.fd, buffer, {
        offset: this.bufferSize,
        length: buffer.byteLength,
      })
      this.bufferSize += buffer.byteLength
    }

    this.listener?.onData?.(buffer)
  }

  private updateState(newState: CapturerState) {
    this._state = newState
    this.listener?.onStateChange?.(newState)
  }
}
