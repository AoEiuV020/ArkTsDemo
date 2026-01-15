/*
 * 音频采集Native实现
 * 基于OHAudio实现音频采集功能
 * 输出PCM原始数据，支持边录边编码
 *
 * 根据输出文件后缀自动选择采集和编码配置：
 * - .pcm: 只产出PCM文件，使用AMR-WB参数采集
 * - .aac: 产出PCM + AAC文件，使用AAC参数采集
 * - .amr: 产出PCM + AMR文件，使用AMR-WB参数采集
 */
#include "AudioCapturer.h"
#include "AudioEncoderFactory.h"
#include "IAudioEncoder.h"
#include <cstring>
#include <memory>
#include <sys/stat.h>
#include "ohaudio/native_audiocapturer.h"
#include "ohaudio/native_audiostreambuilder.h"
#include "ohaudio/native_audiostream_base.h"

namespace {
// 采集器实例
std::string g_outputFilePath;
std::string g_pcmFilePath;
FILE *g_file = nullptr;
OH_AudioCapturer *g_audioCapturer = nullptr;
OH_AudioStreamBuilder *g_builder = nullptr;
AudioEncoderConfig g_config;              // 当前使用的配置
std::unique_ptr<IAudioEncoder> g_encoder; // 编码器实例

/**
 * 音频数据回调 - 将采集到的音频数据写入文件，并推送给编码器
 */
int32_t OnReadData(OH_AudioCapturer *capturer, void *userData, void *buffer, int32_t bufferLen) {
    // 写入PCM文件
    if (g_file != nullptr) {
        fwrite(buffer, bufferLen, 1, g_file);
    }
    // 边录边编码
    if (g_encoder) {
        g_encoder->pushData(buffer, bufferLen);
    }
    return 0;
}

/**
 * 释放采集器资源
 */
void ReleaseCapturer() {
    if (g_audioCapturer) {
        OH_AudioCapturer_Release(g_audioCapturer);
        g_audioCapturer = nullptr;
    }
    if (g_builder) {
        OH_AudioStreamBuilder_Destroy(g_builder);
        g_builder = nullptr;
    }
}

/**
 * 释放编码器资源
 */
void ReleaseEncoder() {
    if (g_encoder) {
        g_encoder->release();
        g_encoder.reset();
    }
}

/**
 * 关闭文件
 */
void CloseFile() {
    if (g_file) {
        fclose(g_file);
        g_file = nullptr;
    }
}

/**
 * 创建采集器Builder并配置参数
 */
bool CreateCapturerBuilder() {
    OH_AudioStream_Result result = OH_AudioStreamBuilder_Create(&g_builder, AUDIOSTREAM_TYPE_CAPTURER);
    if (result != AUDIOSTREAM_SUCCESS) {
        return false;
    }

    // 采样参数配置（根据后缀选择的配置）
    OH_AudioStreamBuilder_SetSamplingRate(g_builder, g_config.sampleRate);
    OH_AudioStreamBuilder_SetChannelCount(g_builder, g_config.channelCount);
    // 采样格式转换：OH_BitsPerSample -> OH_AudioStream_SampleFormat
    OH_AudioStream_SampleFormat sampleFormat = AUDIOSTREAM_SAMPLE_S16LE;
    if (g_config.sampleFormat == SAMPLE_S32LE) {
        sampleFormat = AUDIOSTREAM_SAMPLE_S32LE;
    }
    OH_AudioStreamBuilder_SetSampleFormat(g_builder, sampleFormat);
    OH_AudioStreamBuilder_SetEncodingType(g_builder, AUDIOSTREAM_ENCODING_TYPE_RAW);
    OH_AudioStreamBuilder_SetCapturerInfo(g_builder, AUDIOSTREAM_SOURCE_TYPE_MIC);
    OH_AudioStreamBuilder_SetLatencyMode(g_builder, AUDIOSTREAM_LATENCY_MODE_NORMAL);

    return true;
}

/**
 * 配置采集器回调
 */
void SetupCapturerCallbacks() {
    OH_AudioCapturer_Callbacks callbacks;
    callbacks.OH_AudioCapturer_OnReadData = OnReadData;
    callbacks.OH_AudioCapturer_OnStreamEvent = nullptr;
    callbacks.OH_AudioCapturer_OnInterruptEvent = nullptr;
    callbacks.OH_AudioCapturer_OnError = nullptr;
    OH_AudioStreamBuilder_SetCapturerCallback(g_builder, callbacks, nullptr);
}

/**
 * 生成采集器实例
 */
bool GenerateCapturer() {
    OH_AudioStream_Result result = OH_AudioStreamBuilder_GenerateCapturer(g_builder, &g_audioCapturer);
    return result == AUDIOSTREAM_SUCCESS;
}

/**
 * 根据文件后缀判断编码类型
 */
AudioCodecType GetCodecTypeFromPath(const std::string &path) {
    size_t dotPos = path.rfind('.');
    if (dotPos == std::string::npos) {
        return AudioCodecType::PCM;
    }
    std::string ext = path.substr(dotPos);
    // 转小写
    for (char &c : ext) {
        c = static_cast<char>(tolower(c));
    }
    if (ext == ".pcm") {
        return AudioCodecType::PCM;
    } else if (ext == ".aac") {
        return AudioCodecType::AAC;
    } else if (ext == ".amr") {
        return AudioCodecType::AMR_WB;
    }
    // 其他后缀默认AMR-WB
    return AudioCodecType::AMR_WB;
}

/**
 * 根据输出路径生成PCM文件路径
 * 如果输出是pcm，直接返回；否则将后缀改为.pcm
 */
std::string GeneratePcmFilePath(const std::string &outputPath) {
    size_t dotPos = outputPath.rfind('.');
    if (dotPos == std::string::npos) {
        return outputPath + ".pcm";
    }
    std::string ext = outputPath.substr(dotPos);
    for (char &c : ext) {
        c = static_cast<char>(tolower(c));
    }
    if (ext == ".pcm") {
        return outputPath;
    }
    return outputPath.substr(0, dotPos) + ".pcm";
}
} // namespace

bool AudioCapturerInit(const std::string &outputFilePath) {
    // 释放旧资源
    ReleaseCapturer();
    CloseFile();
    ReleaseEncoder();

    // 保存文件路径
    g_outputFilePath = outputFilePath;
    g_pcmFilePath = GeneratePcmFilePath(outputFilePath);

    // 根据后缀获取配置（采集和编码使用相同配置）
    AudioCodecType codecType = GetCodecTypeFromPath(outputFilePath);
    g_config = GetConfigByCodecType(codecType);

    // 打开PCM文件
    g_file = fopen(g_pcmFilePath.c_str(), "wb");
    if (g_file == nullptr) {
        return false;
    }

    // 创建编码器（非PCM模式才需要编码）
    if (codecType != AudioCodecType::PCM) {
        g_encoder = CreateEncoder(codecType);
        if (g_encoder) {
            if (!g_encoder->init(outputFilePath.c_str(), g_config.sampleRate, g_config.channelCount)) {
                CloseFile();
                ReleaseEncoder();
                return false;
            }
        }
    }

    // 创建采集器
    if (!CreateCapturerBuilder()) {
        CloseFile();
        ReleaseEncoder();
        return false;
    }

    SetupCapturerCallbacks();

    if (!GenerateCapturer()) {
        ReleaseCapturer();
        CloseFile();
        ReleaseEncoder();
        return false;
    }

    return true;
}

void AudioCapturerStart() {
    if (g_audioCapturer) {
        if (g_encoder) {
            g_encoder->start();
        }
        OH_AudioCapturer_Start(g_audioCapturer);
    }
}

void AudioCapturerStop() {
    if (g_audioCapturer) {
        OH_AudioCapturer_Stop(g_audioCapturer);
        if (g_encoder) {
            g_encoder->stop();
        }
    }
}

void AudioCapturerRelease() {
    ReleaseCapturer();
    CloseFile();
    ReleaseEncoder();
}

int AudioCapturerGetState() {
    if (g_audioCapturer) {
        OH_AudioStream_State state;
        OH_AudioCapturer_GetCurrentState(g_audioCapturer, &state);
        return static_cast<int>(state);
    }
    return -1;
}

int64_t AudioCapturerGetFileSize() {
    struct stat statbuf;
    if (stat(g_pcmFilePath.c_str(), &statbuf) == 0) {
        return statbuf.st_size;
    }
    return 0;
}

const char *AudioCapturerGetPcmFilePath() { return g_pcmFilePath.c_str();
}
