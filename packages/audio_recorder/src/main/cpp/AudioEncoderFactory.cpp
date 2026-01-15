/*
 * 音频编码器工厂实现
 * 根据编码配置创建对应的编码器实例
 */
#include "AudioEncoderFactory.h"
#include "VoAmrWbEncoder.h"
#include "SystemCodecEncoder.h"

std::unique_ptr<IAudioEncoder> CreateEncoder(const AudioEncoderConfig &config) {
    switch (config.codecType) {
    case AudioCodecType::AMR_WB:
        return std::make_unique<VoAmrWbEncoder>();
    case AudioCodecType::AAC:
    case AudioCodecType::MP3:
        return std::make_unique<SystemCodecEncoder>(config);
    default:
        return nullptr;
    }
}
