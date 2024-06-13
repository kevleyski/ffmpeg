#!/bin/bash

# KJSL: script to build FFmpeg debug on MacOS

if [ ! -d /opt/homebrew/Cellar/x264 ]; then
  brew install automake fdk-aac git lame libass libtool libvorbis libvpx opus sdl shtool texi2html wget x264 x265 xvid nasm yasm openssl rtmpdump freetype graphite2 harfbuzz fontconfig coreutils tesseract libvmaf
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
--enable-libharfbuzz \
--enable-libsvtav1 \
--enable-libopus --enable-libvorbis \
--enable-libopenjpeg --enable-avfilter \
--enable-libvpx --enable-libx264 --enable-libx265 --enable-ffplay \
--enable-libtesseract \
--enable-libsrt \
--enable-librtmp

# --enable-shared --enable-pthreads --enable-version3 --cc=clang --host-cflags= --host-ldflags='-Wl,-ld_classic' --enable-ffplay --enable-gnutls --enable-gpl --enable-libaom --enable-libaribb24 --enable-libbluray --enable-libdav1d --enable-libharfbuzz --enable-libjxl --enable-libmp3lame --enable-libopus --enable-librav1e --enable-librist --enable-librubberband --enable-libsnappy --enable-libsrt --enable-libssh --enable-libsvtav1 --enable-libtesseract --enable-libtheora --enable-libvidstab --enable-libvmaf --enable-libvorbis --enable-libvpx --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxml2 --enable-libxvid --enable-lzma --enable-libfontconfig --enable-libfreetype --enable-frei0r --enable-libass --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg --enable-libspeex --enable-libsoxr --enable-libzmq --enable-libzimg --disable-libjack --disable-indev=jack --enable-videotoolbox --enable-audiotoolbox --enable-neon

make -j$(($(nproc)+1))
sudo make install
