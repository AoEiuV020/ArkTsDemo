# the minimum version of CMake.
cmake_minimum_required(VERSION 3.5.0)
project(audio_recorder)

set(NATIVERENDER_ROOT_PATH ${CMAKE_CURRENT_SOURCE_DIR})

if(DEFINED PACKAGE_FIND_FILE)
    include(${PACKAGE_FIND_FILE})
endif()

# vo-amrwbenc 库
add_subdirectory(thirdparty/vo-amrwbenc)

include_directories(${NATIVERENDER_ROOT_PATH}
                    ${NATIVERENDER_ROOT_PATH}/include)

add_library(audio_recorder SHARED
    napi_init.cpp
    AudioCapturer.cpp
    AudioEncoderFactory.cpp
    VoAmrWbEncoder.cpp
    SystemAacEncoder.cpp
)
target_link_libraries(audio_recorder PUBLIC
    libace_napi.z.so
    libohaudio.so
    libnative_media_codecbase.so
    libnative_media_core.so
    libnative_media_acodec.so
)
target_link_libraries(audio_recorder PRIVATE vo-amrwbenc)
