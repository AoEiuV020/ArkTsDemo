import native from 'libaudio_recorder.so'

/**
 * 采集器状态
 */
export enum CapturerState {
  /** 未初始化 */
  Idle = -1,
  /** 新建 */
  New = 0,
  /** 已准备 */
  Prepared = 1,
  /** 运行中 */
  Running = 2,
  /** 已停止 */
  Stopped = 3,
  /** 已释放 */
  Released = 4,
  /** 已暂停 */
  Paused = 5,
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
}

/**
 * 音频采集工具类
 * 封装Native音频采集实现，提供简洁的业务接口
 * 采样参数对标AMR-WB (16000Hz, 单声道)
 */
export class AudioCapturer {
  /** 采集文件扩展名 (PCM原始数据) */
  private static readonly FILE_EXTENSION = '.pcm'
  private cacheDir: string
  private currentFilePath: string = ''
  private listener: CapturerStateListener | undefined = undefined

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
  init(options?: CapturerOptions) {
    if (this._state !== CapturerState.Idle) {
      return
    }

    const fileName = options?.fileName ?? `capture_${Date.now()}`
    this.currentFilePath = `${this.cacheDir}/${fileName}${AudioCapturer.FILE_EXTENSION}`

    const success = native.init(this.currentFilePath)
    if (success) {
      this.updateState(CapturerState.Prepared)
    } else {
      this.listener?.onError?.('初始化采集器失败')
    }
  }

  /**
   * 开始采集
   */
  start() {
    if (this._state !== CapturerState.Prepared &&
      this._state !== CapturerState.Paused &&
      this._state !== CapturerState.Stopped) {
      return
    }

    native.start()
    this.updateState(CapturerState.Running)
  }

  /**
   * 停止采集
   */
  stop() {
    if (this._state !== CapturerState.Running && this._state !== CapturerState.Paused) {
      return
    }

    native.stop()
    this.updateState(CapturerState.Stopped)
  }

  /**
   * 释放资源
   * @returns 采集文件路径
   */
  release(): string {
    const savedPath = this.currentFilePath

    native.release()

    this.currentFilePath = ''
    this.updateState(CapturerState.Idle)

    return savedPath
  }

  /**
   * 获取已采集文件大小
   * @returns 文件大小（字节）
   */
  getFileSize(): number {
    return native.getFileSize()
  }

  private updateState(newState: CapturerState) {
    this._state = newState
    this.listener?.onStateChange?.(newState)
  }
}
