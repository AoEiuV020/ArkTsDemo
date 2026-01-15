/*
 * NAPI胶水层
 * 负责ArkTS与Native C++的交互
 */
#include "napi/native_api.h"
#include "AudioCapturer.h"

namespace {
/**
 * 从NAPI参数中获取字符串
 */
std::string GetStringFromArgs(napi_env env, napi_callback_info info) {
    size_t argc = 1;
    napi_value args[1] = {nullptr};
    napi_get_cb_info(env, info, &argc, args, nullptr, nullptr);

    size_t strLen = 0;
    napi_get_value_string_utf8(env, args[0], nullptr, 0, &strLen);
    std::string result(strLen, '\0');
    napi_get_value_string_utf8(env, args[0], &result[0], strLen + 1, &strLen);
    return result;
}
} // namespace

/**
 * 初始化采集器
 * @param outputFilePath 输出文件路径（后缀决定是否编码）
 * @returns 是否初始化成功
 */
static napi_value NapiInit(napi_env env, napi_callback_info info) {
    std::string outputFilePath = GetStringFromArgs(env, info);
    bool success = AudioCapturerInit(outputFilePath);

    napi_value result;
    napi_get_boolean(env, success, &result);
    return result;
}

/**
 * 开始采集
 */
static napi_value NapiStart(napi_env env, napi_callback_info info) {
    AudioCapturerStart();
    return nullptr;
}

/**
 * 停止采集
 */
static napi_value NapiStop(napi_env env, napi_callback_info info) {
    AudioCapturerStop();
    return nullptr;
}

/**
 * 释放资源
 */
static napi_value NapiRelease(napi_env env, napi_callback_info info) {
    AudioCapturerRelease();
    return nullptr;
}

/**
 * 获取采集器状态
 */
static napi_value NapiGetState(napi_env env, napi_callback_info info) {
    int state = AudioCapturerGetState();

    napi_value result;
    napi_create_int32(env, state, &result);
    return result;
}

/**
 * 获取已采集文件大小
 */
static napi_value NapiGetFileSize(napi_env env, napi_callback_info info) {
    int64_t fileSize = AudioCapturerGetFileSize();

    napi_value result;
    napi_create_int64(env, fileSize, &result);
    return result;
}

/**
 * 获取PCM文件路径
 */
static napi_value NapiGetPcmFilePath(napi_env env, napi_callback_info info) {
    const char *path = AudioCapturerGetPcmFilePath();

    napi_value result;
    napi_create_string_utf8(env, path, NAPI_AUTO_LENGTH, &result);
    return result;
}

EXTERN_C_START
static napi_value ModuleInit(napi_env env, napi_value exports) {
    napi_property_descriptor desc[] = {
        {"init", nullptr, NapiInit, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"start", nullptr, NapiStart, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"stop", nullptr, NapiStop, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"release", nullptr, NapiRelease, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getState", nullptr, NapiGetState, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getFileSize", nullptr, NapiGetFileSize, nullptr, nullptr, nullptr, napi_default, nullptr},
        {"getPcmFilePath", nullptr, NapiGetPcmFilePath, nullptr, nullptr, nullptr, napi_default, nullptr},
    };
    napi_define_properties(env, exports, sizeof(desc) / sizeof(desc[0]), desc);
    return exports;
}
EXTERN_C_END

static napi_module audioRecorderModule = {
    .nm_version = 1,
    .nm_flags = 0,
    .nm_filename = nullptr,
    .nm_register_func = ModuleInit,
    .nm_modname = "audio_recorder",
    .nm_priv = nullptr,
    .reserved = {0},
};

extern "C" __attribute__((constructor)) void RegisterAudioRecorderModule() {
    napi_module_register(&audioRecorderModule);
}
