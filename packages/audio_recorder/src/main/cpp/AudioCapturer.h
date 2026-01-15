#ifndef AUDIO_CAPTURER_H
#define AUDIO_CAPTURER_H

#include <string>

/**
 * 初始化采集器
 * @param outputFilePath 输出文件路径
 *   - 后缀.pcm: 只产出PCM文件
 *   - 其他后缀: 产出PCM文件 + 编码后文件
 * @return 是否初始化成功
 */
bool AudioCapturerInit(const std::string &outputFilePath);

/**
 * 开始采集
 */
void AudioCapturerStart();

/**
 * 停止采集
 */
void AudioCapturerStop();

/**
 * 释放资源
 */
void AudioCapturerRelease();

/**
 * 获取采集器状态
 * @return 状态值：-1-未初始化 0-新建 1-已准备 2-运行中 3-已停止 4-已释放 5-已暂停
 */
int AudioCapturerGetState();

/**
 * 获取已采集PCM文件大小
 * @return 文件大小（字节）
 */
int64_t AudioCapturerGetFileSize();

/**
 * 获取PCM文件路径
 */
const char *AudioCapturerGetPcmFilePath();

#endif // AUDIO_CAPTURER_H
