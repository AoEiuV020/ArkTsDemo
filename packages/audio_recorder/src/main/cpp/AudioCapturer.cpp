/*
 * 音频采集Native实现
 * 基于OHAudio实现音频采集功能
 * 输出PCM原始数据，采样参数对标AMR-WB
 *
 * 录音文件大小计算：
 * 采样率(16000) * 声道数(1) * 位深(16bit=2byte) * 时长(秒) = 32000 bytes/秒
 * 即：1分钟录音约 1.83MB
 */
#include "AudioCapturer.h"
#include <sys/stat.h>
#include "ohaudio/native_audiocapturer.h"
#include "ohaudio/native_audiostreambuilder.h"
#include "ohaudio/native_audiostream_base.h"

namespace {
// 采集器实例
std::string g_filePath;
FILE *g_file = nullptr;
OH_AudioCapturer *g_audioCapturer = nullptr;
OH_AudioStreamBuilder *g_builder = nullptr;

// 采样参数配置 (对标AMR-WB)
constexpr int32_t SAMPLING_RATE = 16000;                                        // 采样率
constexpr int32_t CHANNEL_COUNT = 1;                                            // 单声道
constexpr OH_AudioStream_SampleFormat SAMPLE_FORMAT = AUDIOSTREAM_SAMPLE_S16LE; // 16位有符号小端

/**
 * 音频数据回调 - 将采集到的音频数据写入文件
 */
int32_t OnReadData(OH_AudioCapturer *capturer, void *userData, void *buffer, int32_t bufferLen) {
    if (g_file != nullptr) {
        fwrite(buffer, bufferLen, 1, g_file);
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

    // 采样参数配置
    OH_AudioStreamBuilder_SetSamplingRate(g_builder, SAMPLING_RATE);
    OH_AudioStreamBuilder_SetChannelCount(g_builder, CHANNEL_COUNT);
    OH_AudioStreamBuilder_SetSampleFormat(g_builder, SAMPLE_FORMAT);
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
} // namespace

bool AudioCapturerInit(const std::string &filePath) {
    // 释放旧资源
    ReleaseCapturer();
    CloseFile();

    // 保存文件路径
    g_filePath = filePath;

    // 打开文件
    g_file = fopen(g_filePath.c_str(), "wb");
    if (g_file == nullptr) {
        return false;
    }

    // 创建采集器
    if (!CreateCapturerBuilder()) {
        CloseFile();
        return false;
    }

    SetupCapturerCallbacks();

    if (!GenerateCapturer()) {
        ReleaseCapturer();
        CloseFile();
        return false;
    }

    return true;
}

void AudioCapturerStart() {
    if (g_audioCapturer) {
        OH_AudioCapturer_Start(g_audioCapturer);
    }
}

void AudioCapturerStop() {
    if (g_audioCapturer) {
        OH_AudioCapturer_Stop(g_audioCapturer);
    }
}

void AudioCapturerRelease() {
    ReleaseCapturer();
    CloseFile();
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
    if (stat(g_filePath.c_str(), &statbuf) == 0) {
        return statbuf.st_size;
    }
    return 0;
}
