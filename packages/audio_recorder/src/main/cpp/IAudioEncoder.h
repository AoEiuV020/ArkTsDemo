/*
 * 音频编码器抽象接口
 * 定义统一的编码器操作接口，支持多种编码实现
 */
#ifndef IAUDIO_ENCODER_H
#define IAUDIO_ENCODER_H

#include <cstdint>

/**
 * 音频编码器抽象接口
 * 所有编码器实现必须继承此接口
 */
class IAudioEncoder {
public:
    virtual ~IAudioEncoder() = default;

    /**
     * 初始化编码器
     * @param outputPath 编码输出文件路径
     * @param sampleRate 输入PCM采样率
     * @param channelCount 输入PCM声道数
     * @return 是否初始化成功
     */
    virtual bool init(const char *outputPath, uint32_t sampleRate, uint32_t channelCount) = 0;

    /**
     * 启动编码器
     * @return 是否成功
     */
    virtual bool start() = 0;

    /**
     * 推送PCM数据进行编码
     * 实现方应在内部缓存数据，凑够一帧后送入编码器
     * @param data PCM数据 (S16LE格式)
     * @param size 数据大小（字节数）
     */
    virtual void pushData(const void *data, int32_t size) = 0;

    /**
     * 停止编码器并刷新缓冲区
     */
    virtual void stop() = 0;

    /**
     * 释放编码器资源
     */
    virtual void release() = 0;
};

#endif // IAUDIO_ENCODER_H
