#!/bin/bash

# KJSL: script to build FFmpeg debug on MacOS

if [ ! -d /usr/local/Cellar/theora ]; then
  brew install automake fdk-aac git lame libass libtool libvorbis libvpx opus sdl shtool texi2html theora wget x264 x265 xvid nasm yasm openssl rtmpdump freetype graphite2 harfbuzz fontconfig fribidi
fi

# build FFmpeg (with AV1, srt, tesseract and)
./configure  --prefix=/usr/local --enable-gpl --enable-nonfree \
--enable-libfdk-aac --enable-libfreetype \
--enable-libopus --enable-libtheora --enable-libvorbis \
--enable-libopenjpeg --enable-avfilter \
--enable-libvpx --enable-libx264 --enable-libx265 --enable-libxvid --enable-ffplay \
--enable-libtesseract \
--enable-libsrt \
--enable-librtmp \
--enable-libflite \
--disable-stripping

make -j$(($(nproc)+1))
sudo make install
