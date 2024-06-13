#!/bin/bash

# KJSL: script to build FFmpeg debug on MacOS

if [ ! -d /opt/homebrew/Cellar/theora ]; then
  brew install automake fdk-aac git lame libass libtool libvorbis libvpx opus sdl shtool texi2html wget x264 x265 xvid nasm yasm openssl rtmpdump freetype graphite2 harfbuzz fontconfig fribidi coreutils
fi

export PKG_CONFIG_PATH=/opt/homebrew/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig:$PKG_CONFIG_PATH

# build FFmpeg (with AV1, srt, tesseract and)
LDFLAGS="-Wl,-ld_classic,-framework,CoreFoundation -Wl,-framework,Security -Wl,-framework,VideoToolbox -Wl,-framework,CoreMedia -Wl,-framework,CoreVideo" LIBFFI_CFLAGS=-I/usr/include/ffi LIBFFI_LIBS=-lffi ./configure  --prefix=/usr/local --enable-gpl --enable-nonfree \
--enable-postproc \
--enable-shared \
--enable-pthreads \
--enable-version3 \
--enable-videotoolbox --enable-audiotoolbox \
--enable-libfdk-aac \
--enable-libfreetype \
--enable-libfontconfig \
--enable-libfreetype \
--enable-libfribidi \
--enable-libharfbuzz \
--enable-libsvtav1 \
--enable-libopus --enable-libvorbis \
--enable-libopenjpeg --enable-avfilter \
--enable-libvpx --enable-libx264 --enable-libx265 --enable-ffplay \
--enable-libtesseract \
--enable-libsrt \
--enable-librtmp

make -j$(($(nproc)+1))
sudo make install
