/*
 * 音频编码器封装实现
 * 基于OH_AVCodec实现音频编码功能
 * 支持边录边编码，内部维护缓冲区凑帧
 */
#include "AudioEncoder.h"
#include <cstring>
#include <queue>
#include <mutex>
#include <condition_variable>
#include <thread>
#include <multimedia/player_framework/native_avcodec_audiocodec.h>
#include <multimedia/player_framework/native_avformat.h>
#include <multimedia/player_framework/native_avbuffer.h>

namespace {
// 编码器实例
OH_AVCodec *g_encoder = nullptr;
AudioEncoderConfig g_config;
FILE *g_outputFile = nullptr;
bool g_enabled = false;

// 缓冲区管理
std::vector<uint8_t> g_inputBuffer;
int32_t g_frameBytes = 0;

// 输入/输出队列
std::mutex g_inMutex;
std::mutex g_outMutex;
std::condition_variable g_inCond;
std::condition_variable g_outCond;
std::queue<uint32_t> g_inQueue;
std::queue<uint32_t> g_outQueue;
std::queue<OH_AVBuffer *> g_inBufferQueue;
std::queue<OH_AVBuffer *> g_outBufferQueue;

// 编码状态
bool g_isRunning = false;

/**
 * 错误回调
 */
void OnError(OH_AVCodec *codec, int32_t errorCode, void *userData) {
    (void)codec;
    (void)errorCode;
    (void)userData;
}

/**
 * 格式变化回调（音频编码器不支持）
 */
void OnOutputFormatChanged(OH_AVCodec *codec, OH_AVFormat *format, void *userData) {
    (void)codec;
    (void)format;
    (void)userData;
}

/**
 * 输入缓冲区可用回调
 */
void OnInputBufferAvailable(OH_AVCodec *codec, uint32_t index, OH_AVBuffer *data, void *userData) {
    (void)codec;
    (void)userData;
    std::unique_lock<std::mutex> lock(g_inMutex);
    g_inQueue.push(index);
    g_inBufferQueue.push(data);
    g_inCond.notify_all();
}

/**
 * 输出缓冲区可用回调
 */
void OnOutputBufferAvailable(OH_AVCodec *codec, uint32_t index, OH_AVBuffer *data, void *userData) {
    (void)codec;
    (void)userData;
    std::unique_lock<std::mutex> lock(g_outMutex);
    g_outQueue.push(index);
    g_outBufferQueue.push(data);
    g_outCond.notify_all();
}

/**
 * 处理输出数据
 */
void ProcessOutputBuffer() {
    std::unique_lock<std::mutex> lock(g_outMutex);
    while (!g_outQueue.empty()) {
        uint32_t index = g_outQueue.front();
        OH_AVBuffer *buffer = g_outBufferQueue.front();
        g_outQueue.pop();
        g_outBufferQueue.pop();
        lock.unlock();

        if (buffer && g_outputFile) {
            OH_AVCodecBufferAttr attr = {0};
            OH_AVBuffer_GetBufferAttr(buffer, &attr);
            if (attr.size > 0) {
                fwrite(OH_AVBuffer_GetAddr(buffer), attr.size, 1, g_outputFile);
            }
        }

        OH_AudioCodec_FreeOutputBuffer(g_encoder, index);
        lock.lock();
    }
}

/**
 * 推送一帧数据到编码器
 */
bool PushFrame(const uint8_t *data, int32_t size, bool isEos) {
    std::unique_lock<std::mutex> lock(g_inMutex);
    // 等待可用的输入缓冲区
    if (!g_inCond.wait_for(lock, std::chrono::milliseconds(100), [] { return !g_inQueue.empty() || !g_isRunning; })) {
        return false;
    }

    if (g_inQueue.empty()) {
        return false;
    }

    uint32_t index = g_inQueue.front();
    OH_AVBuffer *buffer = g_inBufferQueue.front();
    g_inQueue.pop();
    g_inBufferQueue.pop();
    lock.unlock();

    OH_AVCodecBufferAttr attr = {0};
    if (isEos) {
        attr.size = 0;
        attr.flags = AVCODEC_BUFFER_FLAGS_EOS;
    } else {
        memcpy(OH_AVBuffer_GetAddr(buffer), data, size);
        attr.size = size;
        attr.flags = AVCODEC_BUFFER_FLAGS_NONE;
    }
    OH_AVBuffer_SetBufferAttr(buffer, &attr);

    int32_t ret = OH_AudioCodec_PushInputBuffer(g_encoder, index);
    if (ret != AV_ERR_OK) {
        return false;
    }

    // 处理输出
    ProcessOutputBuffer();
    return true;
}

/**
 * 清空队列
 */
void ClearQueues() {
    std::unique_lock<std::mutex> inLock(g_inMutex);
    while (!g_inQueue.empty())
        g_inQueue.pop();
    while (!g_inBufferQueue.empty())
        g_inBufferQueue.pop();
    inLock.unlock();

    std::unique_lock<std::mutex> outLock(g_outMutex);
    while (!g_outQueue.empty())
        g_outQueue.pop();
    while (!g_outBufferQueue.empty())
        g_outBufferQueue.pop();
}
} // namespace

bool AudioEncoderInit(const char *outputPath, const AudioEncoderConfig &config) {
    // PCM模式不需要编码器
    if (config.codecType == AudioCodecType::PCM) {
        g_enabled = false;
        return true;
    }

    g_config = config;
    g_frameBytes = GetInputFrameBytes(config);
    if (g_frameBytes == 0) {
        return false;
    }

    // 打开输出文件
    g_outputFile = fopen(outputPath, "wb");
    if (!g_outputFile) {
        return false;
    }

    // 创建编码器
    const char *mimeType = GetCodecMimeType(config.codecType);
    g_encoder = OH_AudioCodec_CreateByMime(mimeType, true);
    if (!g_encoder) {
        fclose(g_outputFile);
        g_outputFile = nullptr;
        return false;
    }

    // 注册回调
    OH_AVCodecCallback callbacks = {OnError, OnOutputFormatChanged, OnInputBufferAvailable, OnOutputBufferAvailable};
    int32_t ret = OH_AudioCodec_RegisterCallback(g_encoder, callbacks, nullptr);
    if (ret != AV_ERR_OK) {
        OH_AudioCodec_Destroy(g_encoder);
        g_encoder = nullptr;
        fclose(g_outputFile);
        g_outputFile = nullptr;
        return false;
    }

    // 配置编码器参数
    OH_AVFormat *format = OH_AVFormat_Create();
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_AUD_CHANNEL_COUNT, config.channelCount);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_AUD_SAMPLE_RATE, config.sampleRate);
    OH_AVFormat_SetLongValue(format, OH_MD_KEY_BITRATE, config.bitrate);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_AUDIO_SAMPLE_FORMAT, config.sampleFormat);
    OH_AVFormat_SetLongValue(format, OH_MD_KEY_CHANNEL_LAYOUT, config.channelLayout);
    if (config.codecType == AudioCodecType::AAC) {
        OH_AVFormat_SetIntValue(format, OH_MD_KEY_PROFILE, config.aacProfile);
    }

    ret = OH_AudioCodec_Configure(g_encoder, format);
    OH_AVFormat_Destroy(format);
    if (ret != AV_ERR_OK) {
        OH_AudioCodec_Destroy(g_encoder);
        g_encoder = nullptr;
        fclose(g_outputFile);
        g_outputFile = nullptr;
        return false;
    }

    // 准备编码器
    ret = OH_AudioCodec_Prepare(g_encoder);
    if (ret != AV_ERR_OK) {
        OH_AudioCodec_Destroy(g_encoder);
        g_encoder = nullptr;
        fclose(g_outputFile);
        g_outputFile = nullptr;
        return false;
    }

    g_inputBuffer.clear();
    g_enabled = true;
    return true;
}

bool AudioEncoderStart() {
    if (!g_enabled || !g_encoder) {
        return true; // PCM模式直接返回成功
    }

    ClearQueues();
    g_isRunning = true;
    int32_t ret = OH_AudioCodec_Start(g_encoder);
    return ret == AV_ERR_OK;
}

void AudioEncoderPushData(const void *data, int32_t size) {
    if (!g_enabled || !g_encoder || !g_isRunning) {
        return;
    }

    // 追加到缓冲区
    const uint8_t *ptr = static_cast<const uint8_t *>(data);
    g_inputBuffer.insert(g_inputBuffer.end(), ptr, ptr + size);

    // 凑够一帧就送入编码器
    while (static_cast<int32_t>(g_inputBuffer.size()) >= g_frameBytes) {
        PushFrame(g_inputBuffer.data(), g_frameBytes, false);
        g_inputBuffer.erase(g_inputBuffer.begin(), g_inputBuffer.begin() + g_frameBytes);
    }
}

void AudioEncoderStop() {
    if (!g_enabled || !g_encoder) {
        return;
    }

    g_isRunning = false;

    // 处理剩余数据（填充零）
    if (!g_inputBuffer.empty()) {
        g_inputBuffer.resize(g_frameBytes, 0);
        PushFrame(g_inputBuffer.data(), g_frameBytes, false);
        g_inputBuffer.clear();
    }

    // 发送结束标志
    PushFrame(nullptr, 0, true);

    // 处理剩余输出
    for (int i = 0; i < 10; ++i) {
        ProcessOutputBuffer();
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
    }

    OH_AudioCodec_Stop(g_encoder);
}

void AudioEncoderRelease() {
    if (g_encoder) {
        OH_AudioCodec_Destroy(g_encoder);
        g_encoder = nullptr;
    }
    if (g_outputFile) {
        fclose(g_outputFile);
        g_outputFile = nullptr;
    }
    g_inputBuffer.clear();
    ClearQueues();
    g_enabled = false;
    g_isRunning = false;
}

bool AudioEncoderIsEnabled() { return g_enabled; }
