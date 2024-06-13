cmake_minimum_required(VERSION 2.8.4)
project(kevs_ffmpeg_stub)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")

add_custom_target(kevs_ffmpeg_stub COMMAND make -C ${kevs_ffmpeg_stub_SOURCE_DIR}
        CLION_EXE_DIR=${PROJECT_BINARY_DIR})