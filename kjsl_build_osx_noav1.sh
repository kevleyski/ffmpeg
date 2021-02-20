#!/bin/bash

# KJSL: script to build FFmpeg on OSX

# build FFmpeg 4 (with AV1)
 PKG_CONFIG_PATH="/usr/local/lib/pkgconfig" ./configure  --prefix=/usr/local --enable-gpl --enable-nonfree \
 --enable-libass --enable-libfdk-aac --enable-libfreetype \
 --enable-libopus --enable-libtheora --enable-libvorbis \
 --enable-libopenjpeg --enable-avfilter \
 --enable-libvpx --enable-libx264 --enable-libx265 --enable-libxvid --enable-ffplay --enable-sdl2 \
 --enable-libmp3lame \
 --enable-libsrt --enable-librtmp \
 --extra-ldflags="-L/usr/local/opt/lame/lib \
 -L/usr/local/opt/libogg/lib \
 -L/usr/local/opt/theora/lib \
 -L../srt \
 -L/usr/local/opt/libvorbis/lib \
 -L/usr/local/opt/xvid/lib \
 -I/usr/local/opt/openssl/lib \
 -L/usr/lib" \
 --extra-cflags="-I/usr/local/opt/lame/include \
 -I/usr/local/opt/libogg/include \
 -I/usr/local/opt/theora/include \
 -I../srt/srtcore \
 -I/usr/local/opt/libvorbis/include \
 -I/usr/local/opt/xvid/include \
 -I/usr/local/opt/sdl/include \
 -I/usr/local/opt/openssl/include \
 -I/usr/include"

make -j5
sudo make install
