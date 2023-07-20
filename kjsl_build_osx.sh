#!/bin/bash

# KJSL: script to build FFmpeg on OSX

if [ ! -d /usr/local/Cellar/theora ]; then
  brew install automake fdk-aac git lame libass libtool libvorbis libvpx opus sdl shtool texi2html theora wget x264 x265 xvid nasm yasm
fi

LIBFFI_CFLAGS=-I/usr/include/ffi LIBFFI_LIBS=-lffi ./configure;make && sudo make install
GLIB_CFLAGS="-I/usr/local/include/glib-2.0 -I/usr/local/lib/glib-2.0/include" GLIB_LIBS="-lglib-2.0 -lgio-2.0" ./configure --with-pc-path="/usr/X11/lib/pkgconfig:/usr/X11/share/pkgconfig:/usr/lib/pkgconfig:/usr/local/lib/pkgconfig"

# build FFmpeg (with AV1, srt, tesseract and)
 export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"
 ./configure  --prefix=/usr/local --enable-gpl --enable-nonfree \
 --enable-libfdk-aac --enable-libfreetype \
 --enable-libopus --enable-libtheora --enable-libvorbis \
 --enable-libopenjpeg --enable-avfilter \
 --enable-libvpx --enable-libx264 --enable-libx265 --enable-libxvid --enable-ffplay \
 --enable-libtesseract \
 --enable-libsrt \
 --enable-librtmp \
 --enable-libflite \
 --extra-ldflags="-L/usr/local/Cellar/lame/3.99.5/lib \
 -L/usr/local/Cellar/libogg/1.3.2/lib \
 -L/usr/local/Cellar/theora/1.1.1/lib \
 -L/usr/local/Cellar/libvorbis/1.3.5/lib \
 -L/usr/local/Cellar/libvorbis/1.3.5/lib \
 -L/usr/local/Cellar/xvid/1.3.4/lib \
 -L/usr/local/lib -L/usr/lib" \
 --extra-cflags="-I/usr/local/Cellar/lame/3.99.5/include \
 -I/usr/local/Cellar/libogg/1.3.2/include \
 -I/usr/local/Cellar/theora/1.1.1/include \
 -I/usr/local/Cellar/libvorbis/1.3.5/include \
 -I/usr/local/Cellar/xvid/1.3.4/include \
 -I/usr/local/Cellar/sdl/1.2.15/include \
 -I/usr/local/include \
 -I/usr/include"


make -j$(($(nproc)+1))
sudo make install
