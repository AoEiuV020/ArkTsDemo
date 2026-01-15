/*
 * 音频编码器封装
 * 基于OH_AVCodec实现音频编码功能
 */
#ifndef AUDIO_ENCODER_H
#define AUDIO_ENCODER_H

#include "AudioEncoderConfig.h"
#include <cstdio>

/**
 * 初始化编码器
 * @param outputPath 编码输出文件路径
 * @param config 编码配置
 * @return 是否初始化成功
 */
bool AudioEncoderInit(const char *outputPath, const AudioEncoderConfig &config);

/**
 * 启动编码器
 * @return 是否成功
 */
bool AudioEncoderStart();

/**
 * 推送PCM数据进行编码
 * 内部会缓存数据，凑够一帧后送入编码器
 * @param data PCM数据
 * @param size 数据大小
 */
void AudioEncoderPushData(const void *data, int32_t size);

/**
 * 停止编码器并刷新缓冲区
 */
void AudioEncoderStop();

/**
 * 释放编码器资源
 */
void AudioEncoderRelease();

/**
 * 检查编码器是否启用（非PCM模式）
 */
bool AudioEncoderIsEnabled();

#endif // AUDIO_ENCODER_H
