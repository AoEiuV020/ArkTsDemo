/*
 * 音频编码器工厂
 * 根据编码配置创建对应的编码器实例
 */
#ifndef AUDIO_ENCODER_FACTORY_H
#define AUDIO_ENCODER_FACTORY_H

#include "IAudioEncoder.h"
#include "AudioEncoderConfig.h"
#include <memory>

/**
 * 创建编码器实例
 * @param config 编码配置
 * @return 编码器实例指针，PCM 类型返回 nullptr
 */
std::unique_ptr<IAudioEncoder> CreateEncoder(const AudioEncoderConfig &config);

#endif // AUDIO_ENCODER_FACTORY_H
