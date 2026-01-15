import { media } from '@kit.MediaKit'
import { fileIo } from '@kit.CoreFileKit'

/**
 * 播放器状态
 */
export enum PlayerState {
  /** 未初始化 */
  Idle,
  /** 已初始化 */
  Initialized,
  /** 已就绪 */
  Prepared,
  /** 播放中 */
  Playing,
  /** 暂停中 */
  Paused,
  /** 已完成 */
  Completed,
  /** 已停止 */
  Stopped,
}

/**
 * 播放器状态监听器
 */
export interface PlayerStateListener {
  onStateChange?: (state: PlayerState) => void
  onError?: (message: string) => void
  onSeekDone?: (seekTime: number) => void
}

/**
 * 音频播放工具类
 * 封装音频播放的所有技术细节，提供简洁的业务接口
 */
export class AudioPlayer {
  private avPlayer: media.AVPlayer | undefined = undefined
  private audioFile: fileIo.File | undefined = undefined
  private listener: PlayerStateListener | undefined = undefined
  private _state: PlayerState = PlayerState.Idle

  /**
   * 当前播放器状态
   */
  get state(): PlayerState {
    return this._state
  }

  /**
   * 设置状态监听器
   */
  setListener(listener: PlayerStateListener) {
    this.listener = listener
  }

  /**
   * 播放音频文件
   * @param filePath 音频文件路径
   */
  async play(filePath: string) {
    await this.release()

    this.avPlayer = await media.createAVPlayer()
    this.setupPlayerCallbacks()

    this.audioFile = await fileIo.open(filePath)
    this.avPlayer.url = `fd://${this.audioFile.fd}`
  }

  /**
   * 暂停播放
   */
  async pause() {
    if (this._state !== PlayerState.Playing) {
      return
    }
    await this.avPlayer?.pause()
  }

  /**
   * 恢复播放
   */
  async resume() {
    if (this._state !== PlayerState.Paused) {
      return
    }
    await this.avPlayer?.play()
  }

  /**
   * 停止播放
   */
  async stop() {
    if (this._state !== PlayerState.Playing && this._state !== PlayerState.Paused) {
      return
    }
    await this.avPlayer?.stop()
  }

  /**
   * 跳转到指定位置
   * @param timeMs 时间位置（毫秒）
   */
  async seek(timeMs: number) {
    if (this._state === PlayerState.Playing || this._state === PlayerState.Paused) {
      await this.avPlayer?.seek(timeMs)
    }
  }

  /**
   * 释放资源
   */
  async release() {
    if (this.avPlayer) {
      await this.avPlayer.reset()
      await this.avPlayer.release()
      this.avPlayer = undefined
    }
    if (this.audioFile) {
      fileIo.closeSync(this.audioFile)
      this.audioFile = undefined
    }
    this.updateState(PlayerState.Idle)
  }

  private setupPlayerCallbacks() {
    this.avPlayer?.on('seekDone', (seekDoneTime: number) => {
      console.info(`AudioPlayer seek完成: ${seekDoneTime}`)
      this.listener?.onSeekDone?.(seekDoneTime)
    })

    this.avPlayer?.on('error', (err) => {
      console.error(`AudioPlayer 错误: ${err.code}, ${err.message}`)
      this.listener?.onError?.(`播放错误: ${err.message}`)
      this.avPlayer?.reset()
    })

    this.avPlayer?.on('stateChange', async (state: string) => {
      console.info(`AudioPlayer 状态变化: ${state}`)
      switch (state) {
        case 'idle':
          this.updateState(PlayerState.Idle)
          this.avPlayer?.release()
          break
        case 'initialized':
          this.updateState(PlayerState.Initialized)
          this.avPlayer?.prepare()
          break
        case 'prepared':
          this.updateState(PlayerState.Prepared)
          this.avPlayer?.play()
          break
        case 'playing':
          this.updateState(PlayerState.Playing)
          break
        case 'paused':
          this.updateState(PlayerState.Paused)
          break
        case 'completed':
          this.updateState(PlayerState.Completed)
          this.avPlayer?.stop()
          break
        case 'stopped':
          this.updateState(PlayerState.Stopped)
          this.avPlayer?.reset()
          break
        case 'released':
          this.updateState(PlayerState.Idle)
          this.avPlayer = undefined
          break
      }
    })
  }

  private updateState(newState: PlayerState) {
    this._state = newState
    this.listener?.onStateChange?.(newState)
  }
}
