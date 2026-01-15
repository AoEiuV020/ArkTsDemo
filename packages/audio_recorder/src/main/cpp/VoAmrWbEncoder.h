/*
 * vo-amrwbenc 编码器实现
 * 基于 VisualOn AMR-WB 编码器库
 */
#ifndef VO_AMRWB_ENCODER_H
#define VO_AMRWB_ENCODER_H

#include "IAudioEncoder.h"
#include <cstdio>
#include <vector>

/**
 * AMR-WB 编码模式（码率）
 * 对应 vo-amrwbenc 的 mode 参数
 */
enum class AmrWbMode {
    MD66 = 0,   // 6.60 kbps
    MD885 = 1,  // 8.85 kbps
    MD1265 = 2, // 12.65 kbps
    MD1425 = 3, // 14.25 kbps
    MD1585 = 4, // 15.85 kbps
    MD1825 = 5, // 18.25 kbps
    MD1985 = 6, // 19.85 kbps
    MD2305 = 7, // 23.05 kbps
    MD2385 = 8, // 23.85 kbps (最高质量)
};

/**
 * vo-amrwbenc 编码器封装
 * 输入：16kHz、16bit、单声道 PCM
 * 输出：RFC3267 格式的 AMR-WB 文件
 */
class VoAmrWbEncoder : public IAudioEncoder {
public:
    VoAmrWbEncoder();
    ~VoAmrWbEncoder() override;

    /**
     * 设置编码码率模式
     * 必须在 init 之前调用
     * @param mode 码率模式，默认 MD2385 (23.85kbps)
     */
    void setMode(AmrWbMode mode);

    // IAudioEncoder 接口实现
    bool init(const char *outputPath, uint32_t sampleRate, uint32_t channelCount) override;
    bool start() override;
    void pushData(const void *data, int32_t size) override;
    void stop() override;
    void release() override;

private:
    /** 编码一帧数据 */
    void encodeFrame(const int16_t *samples);

    void *encoder_ = nullptr;
    FILE *outputFile_ = nullptr;
    AmrWbMode mode_ = AmrWbMode::MD2385;
    std::vector<int16_t> inputBuffer_;
    bool started_ = false;

    /** 每帧采样点数 (16kHz * 20ms = 320) */
    static constexpr int32_t kSamplesPerFrame = 320;
};

#endif // VO_AMRWB_ENCODER_H
