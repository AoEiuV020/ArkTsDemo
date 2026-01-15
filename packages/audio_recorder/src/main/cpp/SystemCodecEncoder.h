/*
 * 系统编码器实现
 * 基于 OH_AVCodec 实现多种格式编码 (AAC/MP3等)
 */
#ifndef SYSTEM_CODEC_ENCODER_H
#define SYSTEM_CODEC_ENCODER_H

#include "IAudioEncoder.h"
#include "AudioEncoderConfig.h"
#include <cstdio>
#include <vector>
#include <queue>
#include <mutex>
#include <condition_variable>

struct OH_AVCodec;
struct OH_AVBuffer;

/**
 * 系统编码器封装
 * 使用 HarmonyOS OH_AVCodec API
 * 支持 AAC、MP3 等系统支持的编码格式
 */
class SystemCodecEncoder : public IAudioEncoder {
public:
    /**
     * 创建系统编码器
     * @param config 编码配置
     */
    explicit SystemCodecEncoder(const AudioEncoderConfig &config);
    ~SystemCodecEncoder() override;

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

    AudioEncoderConfig config_;
    OH_AVCodec *encoder_ = nullptr;
    FILE *outputFile_ = nullptr;
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
};

#endif // SYSTEM_CODEC_ENCODER_H
