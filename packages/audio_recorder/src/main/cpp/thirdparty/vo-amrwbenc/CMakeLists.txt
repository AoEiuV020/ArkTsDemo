# vo-amrwbenc 静态库
# VisualOn AMR-WB 编码器实现

cmake_minimum_required(VERSION 3.5.0)

set(VO_AMRWBENC_DIR ${CMAKE_CURRENT_SOURCE_DIR})

# 源文件列表（参考 Android.mk）
set(VO_AMRWBENC_SOURCES
    ${VO_AMRWBENC_DIR}/wrapper.c
    ${VO_AMRWBENC_DIR}/common/cmnMemory.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/autocorr.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/az_isp.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/bits.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/c2t64fx.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/c4t64fx.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/convolve.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/cor_h_x.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/decim54.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/deemph.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/dtx.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/g_pitch.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/gpclip.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/homing.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/hp400.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/hp50.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/hp6k.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/hp_wsp.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/int_lpc.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/isp_az.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/isp_isf.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/lag_wind.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/levinson.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/log2.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/lp_dec2.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/math_op.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/mem_align.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/oper_32b.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/p_med_ol.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/pit_shrp.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/pitch_f4.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/pred_lt4.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/preemph.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/q_gain2.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/q_pulse.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/qisf_ns.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/qpisf_2s.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/random.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/residu.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/scale.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/stream.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/syn_filt.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/updt_tar.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/util.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/voAMRWBEnc.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/voicefac.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/wb_vad.c
    ${VO_AMRWBENC_DIR}/amrwbenc/src/weight_a.c
)

add_library(vo-amrwbenc STATIC ${VO_AMRWBENC_SOURCES})

# 头文件目录（PUBLIC 让链接者也能访问）
target_include_directories(vo-amrwbenc PUBLIC
    ${VO_AMRWBENC_DIR}
)

# 内部头文件目录（PRIVATE 仅编译本库使用）
target_include_directories(vo-amrwbenc PRIVATE
    ${VO_AMRWBENC_DIR}/amrwbenc/inc
    ${VO_AMRWBENC_DIR}/common/include
)
