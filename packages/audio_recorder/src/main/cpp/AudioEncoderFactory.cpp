/*
 * 音频编码器工厂实现
 * 根据编码类型创建对应的编码器实例
 */
#include "AudioEncoderFactory.h"
#include "VoAmrWbEncoder.h"
#include "SystemAacEncoder.h"

std::unique_ptr<IAudioEncoder> CreateEncoder(AudioCodecType codecType) {
    switch (codecType) {
    case AudioCodecType::AMR_WB:
        return std::make_unique<VoAmrWbEncoder>();
    case AudioCodecType::AAC:
        return std::make_unique<SystemAacEncoder>();
    default:
        return nullptr;
    }
}
