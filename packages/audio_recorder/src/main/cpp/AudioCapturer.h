#ifndef AUDIO_CAPTURER_H
#define AUDIO_CAPTURER_H

#include <string>

/**
 * 初始化采集器
 * @param filePath 文件保存路径
 * @return 是否初始化成功
 */
bool AudioCapturerInit(const std::string &filePath);

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
 * 获取已采集文件大小
 * @return 文件大小（字节）
 */
int64_t AudioCapturerGetFileSize();

#endif // AUDIO_CAPTURER_H
