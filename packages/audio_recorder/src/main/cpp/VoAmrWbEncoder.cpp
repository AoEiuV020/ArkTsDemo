/*
 * vo-amrwbenc 编码器实现
 * 基于 VisualOn AMR-WB 编码器库
 */
#include "VoAmrWbEncoder.h"
#include <cstring>
#include <enc_if.h>

// AMR-WB 文件头 (RFC3267)
static const uint8_t kAmrWbHeader[] = {'#', '!', 'A', 'M', 'R', '-', 'W', 'B', '\n'};

VoAmrWbEncoder::VoAmrWbEncoder() = default;

VoAmrWbEncoder::~VoAmrWbEncoder() { release(); }

void VoAmrWbEncoder::setMode(AmrWbMode mode) { mode_ = mode; }

bool VoAmrWbEncoder::init(const char *outputPath, uint32_t sampleRate, uint32_t channelCount) {
    // AMR-WB 只支持 16kHz 单声道
    if (sampleRate != 16000 || channelCount != 1) {
        return false;
    }

    // 打开输出文件
    outputFile_ = fopen(outputPath, "wb");
    if (!outputFile_) {
        return false;
    }

    // 写入 AMR-WB 文件头
    fwrite(kAmrWbHeader, sizeof(kAmrWbHeader), 1, outputFile_);

    // 初始化编码器
    encoder_ = E_IF_init();
    if (!encoder_) {
        fclose(outputFile_);
        outputFile_ = nullptr;
        return false;
    }

    inputBuffer_.clear();
    return true;
}

bool VoAmrWbEncoder::start() {
    if (!encoder_ || !outputFile_) {
        return false;
    }
    started_ = true;
    return true;
}

void VoAmrWbEncoder::pushData(const void *data, int32_t size) {
    if (!started_ || !encoder_) {
        return;
    }

    // 追加到缓冲区
    const int16_t *samples = static_cast<const int16_t *>(data);
    int32_t sampleCount = size / sizeof(int16_t);
    inputBuffer_.insert(inputBuffer_.end(), samples, samples + sampleCount);

    // 凑够一帧就编码
    while (static_cast<int32_t>(inputBuffer_.size()) >= kSamplesPerFrame) {
        encodeFrame(inputBuffer_.data());
        inputBuffer_.erase(inputBuffer_.begin(), inputBuffer_.begin() + kSamplesPerFrame);
    }
}

void VoAmrWbEncoder::encodeFrame(const int16_t *samples) {
    if (!encoder_ || !outputFile_) {
        return;
    }

    // 编码输出缓冲区 (最大帧大小约61字节)
    uint8_t outBuffer[128];
    int outLen = E_IF_encode(encoder_, static_cast<int>(mode_), samples, outBuffer, 0);
    if (outLen > 0) {
        fwrite(outBuffer, outLen, 1, outputFile_);
    }
}

void VoAmrWbEncoder::stop() {
    if (!started_) {
        return;
    }
    started_ = false;

    // 处理剩余数据（填充零到完整帧）
    if (!inputBuffer_.empty()) {
        inputBuffer_.resize(kSamplesPerFrame, 0);
        encodeFrame(inputBuffer_.data());
        inputBuffer_.clear();
    }

    // 刷新输出文件
    if (outputFile_) {
        fflush(outputFile_);
    }
}

void VoAmrWbEncoder::release() {
    if (encoder_) {
        E_IF_exit(encoder_);
        encoder_ = nullptr;
    }
    if (outputFile_) {
        fclose(outputFile_);
        outputFile_ = nullptr;
    }
    inputBuffer_.clear();
    started_ = false;
}
