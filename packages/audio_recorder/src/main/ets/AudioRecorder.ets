import native from 'libaudio_recorder.so'

/**
 * 录音器状态
 */
export enum RecorderState {
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
 * 录音配置选项
 */
export interface RecorderOptions {
  /**
   * 输出文件路径（完整路径包含后缀）
   * 后缀决定编码格式和采集参数：
   * - .pcm: 不编码，只产出PCM文件 (16kHz单声道)
   * - .aac: 产出PCM + AAC文件 (44.1kHz立体声)
   * - .amr: 产出PCM + AMR文件 (16kHz单声道)
   */
  outputFilePath: string
}

/**
 * 录音状态监听器
 */
export interface RecorderStateListener {
  onStateChange?: (state: RecorderState) => void
  onError?: (message: string) => void
}

/**
 * 音频录音器
 * 封装Native音频采集和编码，支持边录边编码
 *
 * 根据输出文件后缀自动选择采集参数和编码格式
 */
export class AudioRecorder {
  private outputFilePath: string = ''
  private listener: RecorderStateListener | undefined = undefined
  private _state: RecorderState = RecorderState.Idle

  /**
   * 当前录音状态
   */
  get state(): RecorderState {
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
  setListener(listener: RecorderStateListener) {
    this.listener = listener
  }

  /**
   * 初始化录音器
   * @param options 录音配置选项
   */
  init(options: RecorderOptions) {
    if (this._state !== RecorderState.Idle) {
      return
    }

    this.outputFilePath = options.outputFilePath

    const success = native.init(this.outputFilePath)
    if (success) {
      this.updateState(RecorderState.Prepared)
    } else {
      this.listener?.onError?.('初始化录音器失败')
    }
  }

  /**
   * 开始录音
   */
  start() {
    if (this._state !== RecorderState.Prepared &&
      this._state !== RecorderState.Paused &&
      this._state !== RecorderState.Stopped) {
      return
    }

    native.start()
    this.updateState(RecorderState.Running)
  }

  /**
   * 停止录音
   */
  stop() {
    if (this._state !== RecorderState.Running && this._state !== RecorderState.Paused) {
      return
    }

    native.stop()
    this.updateState(RecorderState.Stopped)
  }

  /**
   * 释放资源
   */
  release() {
    native.release()
    this.outputFilePath = ''
    this.updateState(RecorderState.Idle)
  }

  /**
   * 获取已录制PCM文件大小
   * @returns 文件大小（字节）
   */
  getFileSize(): number {
    return native.getFileSize()
  }

  private updateState(newState: RecorderState) {
    this._state = newState
    this.listener?.onStateChange?.(newState)
  }
}
