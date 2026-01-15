/*
 * 系统编码器实现
 * 基于 OH_AVCodec 实现多种格式编码 (AAC/MP3等)
 */
#include "SystemCodecEncoder.h"
#include <cstring>
#include <chrono>
#include <thread>
#include <multimedia/player_framework/native_avcodec_audiocodec.h>
#include <multimedia/player_framework/native_avformat.h>
#include <multimedia/player_framework/native_avbuffer.h>

SystemCodecEncoder::SystemCodecEncoder(const AudioEncoderConfig &config) : config_(config) {}

SystemCodecEncoder::~SystemCodecEncoder() { release(); }

void SystemCodecEncoder::onError(OH_AVCodec *codec, int32_t errorCode, void *userData) {
    (void)codec;
    (void)errorCode;
    (void)userData;
}

void SystemCodecEncoder::onOutputFormatChanged(OH_AVCodec *codec, OH_AVFormat *format, void *userData) {
    (void)codec;
    (void)format;
    (void)userData;
}

void SystemCodecEncoder::onInputBufferAvailable(OH_AVCodec *codec, uint32_t index, OH_AVBuffer *data, void *userData) {
    (void)codec;
    auto *self = static_cast<SystemCodecEncoder *>(userData);
    std::unique_lock<std::mutex> lock(self->inMutex_);
    self->inQueue_.push(index);
    self->inBufferQueue_.push(data);
    self->inCond_.notify_all();
}

void SystemCodecEncoder::onOutputBufferAvailable(OH_AVCodec *codec, uint32_t index, OH_AVBuffer *data, void *userData) {
    (void)codec;
    auto *self = static_cast<SystemCodecEncoder *>(userData);
    std::unique_lock<std::mutex> lock(self->outMutex_);
    self->outQueue_.push(index);
    self->outBufferQueue_.push(data);
}

bool SystemCodecEncoder::init(const char *outputPath, uint32_t sampleRate, uint32_t channelCount) {
    // init 参数覆盖配置（兼容接口）
    config_.sampleRate = sampleRate;
    config_.channelCount = channelCount;
    frameBytes_ = config_.samplesPerFrame * config_.channelCount * sizeof(int16_t);

    // 打开输出文件
    outputFile_ = fopen(outputPath, "wb");
    if (!outputFile_) {
        return false;
    }

    // 创建编码器
    const char *mimeType = GetCodecMimeType(config_.codecType);
    if (!mimeType) {
        fclose(outputFile_);
        outputFile_ = nullptr;
        return false;
    }
    encoder_ = OH_AudioCodec_CreateByMime(mimeType, true);
    if (!encoder_) {
        fclose(outputFile_);
        outputFile_ = nullptr;
        return false;
    }

    // 注册回调
    OH_AVCodecCallback callbacks = {onError, onOutputFormatChanged, onInputBufferAvailable, onOutputBufferAvailable};
    int32_t ret = OH_AudioCodec_RegisterCallback(encoder_, callbacks, this);
    if (ret != AV_ERR_OK) {
        OH_AudioCodec_Destroy(encoder_);
        encoder_ = nullptr;
        fclose(outputFile_);
        outputFile_ = nullptr;
        return false;
    }

    // 配置编码器参数
    OH_AVFormat *format = OH_AVFormat_Create();
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_AUD_CHANNEL_COUNT, config_.channelCount);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_AUD_SAMPLE_RATE, config_.sampleRate);
    OH_AVFormat_SetLongValue(format, OH_MD_KEY_BITRATE, config_.bitrate);
    OH_AVFormat_SetIntValue(format, OH_MD_KEY_AUDIO_SAMPLE_FORMAT, config_.sampleFormat);
    OH_AVFormat_SetLongValue(format, OH_MD_KEY_CHANNEL_LAYOUT, config_.channelLayout);
    // AAC 特有参数
    if (config_.codecType == AudioCodecType::AAC) {
        OH_AVFormat_SetIntValue(format, OH_MD_KEY_PROFILE, config_.aacProfile);
    }

    ret = OH_AudioCodec_Configure(encoder_, format);
    OH_AVFormat_Destroy(format);
    if (ret != AV_ERR_OK) {
        OH_AudioCodec_Destroy(encoder_);
        encoder_ = nullptr;
        fclose(outputFile_);
        outputFile_ = nullptr;
        return false;
    }

    // 准备编码器
    ret = OH_AudioCodec_Prepare(encoder_);
    if (ret != AV_ERR_OK) {
        OH_AudioCodec_Destroy(encoder_);
        encoder_ = nullptr;
        fclose(outputFile_);
        outputFile_ = nullptr;
        return false;
    }

    inputBuffer_.clear();
    return true;
}

bool SystemCodecEncoder::start() {
    if (!encoder_ || !outputFile_) {
        return false;
    }

    clearQueues();
    running_ = true;
    int32_t ret = OH_AudioCodec_Start(encoder_);
    return ret == AV_ERR_OK;
}

void SystemCodecEncoder::pushData(const void *data, int32_t size) {
    if (!running_ || !encoder_) {
        return;
    }

    // 追加到缓冲区
    const uint8_t *ptr = static_cast<const uint8_t *>(data);
    inputBuffer_.insert(inputBuffer_.end(), ptr, ptr + size);

    // 凑够一帧就送入编码器
    while (static_cast<int32_t>(inputBuffer_.size()) >= frameBytes_) {
        pushFrame(inputBuffer_.data(), frameBytes_, false);
        inputBuffer_.erase(inputBuffer_.begin(), inputBuffer_.begin() + frameBytes_);
    }
}

bool SystemCodecEncoder::pushFrame(const uint8_t *data, int32_t size, bool isEos) {
    std::unique_lock<std::mutex> lock(inMutex_);
    // 等待可用的输入缓冲区
    if (!inCond_.wait_for(lock, std::chrono::milliseconds(100), [this] { return !inQueue_.empty() || !running_; })) {
        return false;
    }

    if (inQueue_.empty()) {
        return false;
    }

    uint32_t index = inQueue_.front();
    OH_AVBuffer *buffer = inBufferQueue_.front();
    inQueue_.pop();
    inBufferQueue_.pop();
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

    int32_t ret = OH_AudioCodec_PushInputBuffer(encoder_, index);
    if (ret != AV_ERR_OK) {
        return false;
    }

    // 处理输出
    processOutput();
    return true;
}

void SystemCodecEncoder::processOutput() {
    std::unique_lock<std::mutex> lock(outMutex_);
    while (!outQueue_.empty()) {
        uint32_t index = outQueue_.front();
        OH_AVBuffer *buffer = outBufferQueue_.front();
        outQueue_.pop();
        outBufferQueue_.pop();
        lock.unlock();

        if (buffer && outputFile_) {
            OH_AVCodecBufferAttr attr = {0};
            OH_AVBuffer_GetBufferAttr(buffer, &attr);
            if (attr.size > 0) {
                fwrite(OH_AVBuffer_GetAddr(buffer), attr.size, 1, outputFile_);
            }
        }

        OH_AudioCodec_FreeOutputBuffer(encoder_, index);
        lock.lock();
    }
}

void SystemCodecEncoder::stop() {
    if (!running_) {
        return;
    }
    running_ = false;

    // 处理剩余数据（填充零）
    if (!inputBuffer_.empty()) {
        inputBuffer_.resize(frameBytes_, 0);
        pushFrame(inputBuffer_.data(), frameBytes_, false);
        inputBuffer_.clear();
    }

    // 发送结束标志
    pushFrame(nullptr, 0, true);

    // 处理剩余输出
    for (int i = 0; i < 10; ++i) {
        processOutput();
        std::this_thread::sleep_for(std::chrono::milliseconds(10));
    }

    OH_AudioCodec_Stop(encoder_);
}

void SystemCodecEncoder::release() {
    if (encoder_) {
        OH_AudioCodec_Destroy(encoder_);
        encoder_ = nullptr;
    }
    if (outputFile_) {
        fclose(outputFile_);
        outputFile_ = nullptr;
    }
    inputBuffer_.clear();
    clearQueues();
    running_ = false;
}

void SystemCodecEncoder::clearQueues() {
    std::unique_lock<std::mutex> inLock(inMutex_);
    while (!inQueue_.empty())
        inQueue_.pop();
    while (!inBufferQueue_.empty())
        inBufferQueue_.pop();
    inLock.unlock();

    std::unique_lock<std::mutex> outLock(outMutex_);
    while (!outQueue_.empty())
        outQueue_.pop();
    while (!outBufferQueue_.empty())
        outBufferQueue_.pop();
}
