/*
 * 音频编码配置参数
 * 定义编码器类型和参数配置
 *
 * 根据输出文件后缀自动选择配置：
 * - .pcm: 不编码，只产出PCM文件
 * - .aac: AAC编码 (44.1kHz, 立体声)
 * - .amr: AMR-WB编码 (16kHz, 单声道)
 * - .mp3: MP3编码 (44.1kHz, 立体声)
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
    /** AAC编码 (系统编码器) */
    AAC = 1,
    /** AMR-WB编码 (vo-amrwbenc) */
    AMR_WB = 2,
    /** MP3编码 (系统编码器) */
    MP3 = 3,
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
    /** 每帧采样点数 */
    int32_t samplesPerFrame = 1024;
};

/**
 * 获取AMR-WB编码配置
 * 16000Hz采样率、单声道、23850bps码率
 *
 * AMR-WB支持的码率: 6600, 8850, 12650, 14250, 15850, 18250, 19850, 23050, 23850
 * 23850为最高质量
 *
 * PCM文件大小计算：
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
    config.samplesPerFrame = 320; // 16000 * 0.02 = 320
    return config;
}

/**
 * 获取AAC编码配置 (网站示例参数)
 * 44100Hz采样率、2声道立体声、32000bps码率
 *
 * PCM文件大小计算：
 * 采样率(44100) * 声道数(2) * 位深(16bit=2byte) * 时长(秒) = 176400 bytes/秒
 * 即：1分钟录音约 10.1MB
 */
inline AudioEncoderConfig GetAacConfig() {
    AudioEncoderConfig config;
    config.codecType = AudioCodecType::AAC;
    config.sampleRate = 44100;
    config.channelCount = 2;
    config.bitrate = 32000;
    config.channelLayout = CH_LAYOUT_STEREO;
    config.sampleFormat = SAMPLE_S16LE;
    config.aacProfile = AAC_PROFILE_LC;
    config.samplesPerFrame = 1024;
    return config;
}

/**
 * 获取MP3编码配置
 * 44100Hz采样率、2声道立体声、128000bps码率
 */
inline AudioEncoderConfig GetMp3Config() {
    AudioEncoderConfig config;
    config.codecType = AudioCodecType::MP3;
    config.sampleRate = 44100;
    config.channelCount = 2;
    config.bitrate = 128000;
    config.channelLayout = CH_LAYOUT_STEREO;
    config.sampleFormat = SAMPLE_S16LE;
    config.samplesPerFrame = 1152; // MP3每帧采样点数
    return config;
}

/**
 * 根据编码类型获取配置
 */
inline AudioEncoderConfig GetConfigByCodecType(AudioCodecType type) {
    switch (type) {
    case AudioCodecType::AAC:
        return GetAacConfig();
    case AudioCodecType::AMR_WB:
        return GetAmrWbConfig();
    case AudioCodecType::MP3:
        return GetMp3Config();
    default: {
        // PCM使用AMR-WB的采样参数
        AudioEncoderConfig config = GetAmrWbConfig();
        config.codecType = AudioCodecType::PCM;
        return config;
    }
    }
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
    case AudioCodecType::MP3:
        return OH_AVCODEC_MIMETYPE_AUDIO_MPEG;
    default:
        return nullptr;
    }
}

#endif // AUDIO_ENCODER_CONFIG_H
