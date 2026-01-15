/*
 * 系统 AAC 编码器实现
 * 基于 OH_AVCodec 实现 AAC 编码
 */
#ifndef SYSTEM_AAC_ENCODER_H
#define SYSTEM_AAC_ENCODER_H

#include "IAudioEncoder.h"
#include <cstdio>
#include <vector>
#include <queue>
#include <mutex>
#include <condition_variable>

struct OH_AVCodec;
struct OH_AVBuffer;

/**
 * 系统 AAC 编码器封装
 * 使用 HarmonyOS OH_AVCodec API
 * 输入：44.1kHz、16bit、立体声 PCM
 * 输出：原始 AAC 流
 */
class SystemAacEncoder : public IAudioEncoder {
public:
    SystemAacEncoder();
    ~SystemAacEncoder() override;

    /**
     * 设置码率
     * 必须在 init 之前调用
     * @param bitrate 码率 (bps)，默认 32000
     */
    void setBitrate(uint64_t bitrate);

    // IAudioEncoder 接口实现
    bool init(const char *outputPath, uint32_t sampleRate, uint32_t channelCount) override;
    bool start() override;
    void pushData(const void *data, int32_t size) override;
    void stop() override;
    void release() override;

private:
    /** 推送一帧到编码器 */
    bool pushFrame(const uint8_t *data, int32_t size, bool isEos);
    /** 处理输出缓冲区 */
    void processOutput();
    /** 清空队列 */
    void clearQueues();

    // 回调函数
    static void onError(OH_AVCodec *codec, int32_t errorCode, void *userData);
    static void onOutputFormatChanged(OH_AVCodec *codec, struct OH_AVFormat *format, void *userData);
    static void onInputBufferAvailable(OH_AVCodec *codec, uint32_t index, struct OH_AVBuffer *data, void *userData);
    static void onOutputBufferAvailable(OH_AVCodec *codec, uint32_t index, struct OH_AVBuffer *data, void *userData);

    OH_AVCodec *encoder_ = nullptr;
    FILE *outputFile_ = nullptr;
    uint64_t bitrate_ = 32000;
    uint32_t sampleRate_ = 44100;
    uint32_t channelCount_ = 2;
    std::vector<uint8_t> inputBuffer_;
    int32_t frameBytes_ = 0;
    bool running_ = false;

    // 缓冲区队列
    std::mutex inMutex_;
    std::mutex outMutex_;
    std::condition_variable inCond_;
    std::queue<uint32_t> inQueue_;
    std::queue<OH_AVBuffer *> inBufferQueue_;
    std::queue<uint32_t> outQueue_;
    std::queue<OH_AVBuffer *> outBufferQueue_;

    /** AAC-LC 每帧采样点数 */
    static constexpr int32_t kSamplesPerFrame = 1024;
};

#endif // SYSTEM_AAC_ENCODER_H
