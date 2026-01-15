/*
 * 音频编码配置参数
 * 定义编码器类型和参数配置
 */
#ifndef AUDIO_ENCODER_CONFIG_H
#define AUDIO_ENCODER_CONFIG_H

#include <cstdint>
#include <multimedia/player_framework/native_avcodec_base.h>
#include <multimedia/native_audio_channel_layout.h>

/**
 * 编码器类型枚举
 */
enum class AudioCodecType {
    /** 不编码，直接输出PCM */
    PCM = 0,
    /** AAC编码 (默认示例参数) */
    AAC = 1,
    /** AMR-WB编码 (16kHz单声道) */
    AMR_WB = 2,
};

/**
 * 音频编码配置
 */
struct AudioEncoderConfig {
    /** 编码类型 */
    AudioCodecType codecType = AudioCodecType::PCM;
    /** 采样率 (Hz) */
    uint32_t sampleRate = 16000;
    /** 声道数 */
    uint32_t channelCount = 1;
    /** 码率 (bps) */
    uint64_t bitrate = 23850;
    /** 声道布局 */
    OH_AudioChannelLayout channelLayout = CH_LAYOUT_MONO;
    /** 采样格式 */
    OH_BitsPerSample sampleFormat = SAMPLE_S16LE;
    /** AAC Profile (仅AAC有效) */
    OH_AACProfile aacProfile = AAC_PROFILE_LC;
};

/**
 * 获取AMR-WB编码配置（基础配置，其他配置基于此扩展）
 * 16000Hz采样率、单声道、23850bps码率
 *
 * AMR-WB支持的码率: 6600, 8850, 12650, 14250, 15850, 18250, 19850, 23050, 23850
 * 23850为最高质量
 *
 * 录音文件大小计算：
 * 采样率(16000) * 声道数(1) * 位深(16bit=2byte) * 时长(秒) = 32000 bytes/秒
 * 即：1分钟录音约 1.83MB
 */
inline AudioEncoderConfig GetAmrWbConfig() {
    AudioEncoderConfig config;
    config.codecType = AudioCodecType::AMR_WB;
    config.sampleRate = 16000;
    config.channelCount = 1;
    config.bitrate = 23850;
    config.channelLayout = CH_LAYOUT_MONO;
    config.sampleFormat = SAMPLE_S16LE;
    return config;
}

/**
 * 获取PCM配置 (不编码)
 * 复用AMR-WB的采样参数，仅编码类型不同
 */
inline AudioEncoderConfig GetPcmConfig() {
    AudioEncoderConfig config = GetAmrWbConfig();
    config.codecType = AudioCodecType::PCM;
    return config;
}

/**
 * 获取默认AAC编码配置 (网站示例参数)
 * 44100Hz采样率、2声道立体声、32000bps码率
 */
inline AudioEncoderConfig GetDefaultAacConfig() {
    AudioEncoderConfig config;
    config.codecType = AudioCodecType::AAC;
    config.sampleRate = 44100;
    config.channelCount = 2;
    config.bitrate = 32000;
    config.channelLayout = CH_LAYOUT_STEREO;
    config.sampleFormat = SAMPLE_S16LE;
    config.aacProfile = AAC_PROFILE_LC;
    return config;
}

/**
 * 获取编码器MIME类型字符串
 */
inline const char *GetCodecMimeType(AudioCodecType type) {
    switch (type) {
    case AudioCodecType::AAC:
        return OH_AVCODEC_MIMETYPE_AUDIO_AAC;
    case AudioCodecType::AMR_WB:
        return OH_AVCODEC_MIMETYPE_AUDIO_AMR_WB;
    default:
        return nullptr;
    }
}

/**
 * 获取每帧采样点数
 * AAC-LC: 1024
 * AMR-WB: 320 (20ms @ 16kHz)
 */
inline int32_t GetSamplesPerFrame(AudioCodecType type) {
    switch (type) {
    case AudioCodecType::AAC:
        return 1024;
    case AudioCodecType::AMR_WB:
        return 320; // 16000 * 0.02 = 320
    default:
        return 0;
    }
}

/**
 * 计算每帧输入字节数
 * 采样点数 * 声道数 * 每样本字节数(S16LE=2)
 */
inline int32_t GetInputFrameBytes(const AudioEncoderConfig &config) {
    int32_t samplesPerFrame = GetSamplesPerFrame(config.codecType);
    if (samplesPerFrame == 0) {
        return 0;
    }
    return samplesPerFrame * config.channelCount * sizeof(int16_t);
}

/**
 * ========== 采集器使用的配置 ==========
 * 修改此函数可一行代码切换采集参数
 */
inline AudioEncoderConfig GetCapturerConfig() {
    // 当前使用AMR-WB参数采集（16kHz单声道）
//    return GetAmrWbConfig();

    // 切换到AAC参数采集（44.1kHz立体声），取消下行注释：
    return GetDefaultAacConfig();
}

#endif // AUDIO_ENCODER_CONFIG_H
