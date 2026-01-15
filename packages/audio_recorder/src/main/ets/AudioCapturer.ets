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
  /**
   * 输出文件路径（完整路径包含后缀）
   * 后缀决定编码格式：
   * - .pcm: 不编码，只产出PCM文件
   * - .aac: 产出PCM文件 + AAC编码文件
   * - .amr: 产出PCM文件 + AMR-WB编码文件
   * - 其他后缀: 产出PCM文件 + AMR-WB编码文件
   */
  outputFilePath: string
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
 * 封装Native音频采集实现，支持边录边编码
 * 采样参数对标AMR-WB (16000Hz, 单声道)
 *
 * 输出文件说明：
 * - 后缀.pcm时只产出PCM文件
 * - 其他后缀时产出PCM文件（路径为输出路径后缀改为.pcm）+ 编码文件
 */
export class AudioCapturer {
  private outputFilePath: string = ''
  private listener: CapturerStateListener | undefined = undefined

  private _state: CapturerState = CapturerState.Idle

  /**
   * 当前采集状态
   */
  get state(): CapturerState {
    return this._state
  }

  /**
   * PCM文件路径
   */
  get pcmFilePath(): string {
    return native.getPcmFilePath()
  }

  /**
   * 输出文件路径（传入的路径）
   */
  get outputPath(): string {
    return this.outputFilePath
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
  init(options: CapturerOptions) {
    if (this._state !== CapturerState.Idle) {
      return
    }

    this.outputFilePath = options.outputFilePath

    const success = native.init(this.outputFilePath)
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
   */
  release() {
    native.release()
    this.outputFilePath = ''
    this.updateState(CapturerState.Idle)
  }

  /**
   * 获取已采集PCM文件大小
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
