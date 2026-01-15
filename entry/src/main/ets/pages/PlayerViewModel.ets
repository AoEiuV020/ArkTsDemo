import { AudioPlayer, PlayerState } from '../audio/AudioPlayer'

const TAG = 'PlayerViewModel'

/**
 * 打印日志
 */
function log(message: string) {
  console.info(`[${TAG}] ${message}`)
}

/**
 * 播放 ViewModel
 */
@ObservedV2
export class PlayerViewModel {
  @Trace state: PlayerState = PlayerState.Idle
  private player: AudioPlayer = new AudioPlayer()

  constructor() {
    this.player.setListener({
      onStateChange: (state) => {
        log(`播放状态变更: ${PlayerState[state]}`)
        this.state = state
      },
      onError: (message) => {
        log(`播放错误: ${message}`)
        console.error(message)
      },
    })
  }

  /**
   * 播放音频文件
   */
  async play(filePath: string) {
    log(`播放开始: ${filePath}`)
    try {
      await this.player.play(filePath)
      log('播放结束')
    } catch (error) {
      const e = error as Error
      log(`播放失败: ${e.message}`)
    }
  }

  /**
   * 释放资源
   */
  async release() {
    log('释放播放器资源开始')
    try {
      await this.player.release()
      log('释放播放器资源结束')
    } catch (error) {
      const e = error as Error
      log(`释放播放器资源失败: ${e.message}`)
    }
  }
}
