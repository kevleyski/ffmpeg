#!/bin/bash
# KJSL build everything on Linux...

HERE=$PWD

# git clone https://github.com/kevleyski/FFmpeg.git $HERE/deps

if [ ! -d $HERE/deps ]; then
mkdir $HERE/deps
fi

##nasm
#if [ ! -d $HERE/deps/nasm ]; then
#cd $HERE/deps || exit
#git clone --depth 1 https://github.com/kevleyski/nasm.git
#cd nasm || exit
#./autogen.sh
#./configure --prefix="$HERE/deps" --bindir="$HERE/bin"
#make -j $(nproc)
#make install
#fi
#
#Yasm
#An assembler used by some libraries. Highly recommended or your resulting build may be very slow.

if [ ! -d $HERE/deps/yasm ]; then
cd $HERE/deps || exit
curl -O -L http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
mv yasm-1.3.0 yasm
cd yasm-1.3.0
./configure --prefix="$HERE/deps" --bindir="$HERE/bin"
make -j $(nproc)
make install
libx264
fi

# H.264 video encoder. See the H.264 Encoding Guide for more information and usage examples.

#Requires ffmpeg to be configured with --enable-gpl --enable-libx264.

if [ ! -d $HERE/deps/x264 ]; then
cd $HERE/deps || exit
git clone --depth 1 https://github.com/kevleyski/x264.git
cd x264
PKG_CONFIG_PATH="$HERE/deps/lib/pkgconfig" ./configure --prefix="$HERE/deps" --bindir="$HERE/bin" --enable-static
make -j $(nproc)
make install
#Warning: If you get Found no assembler. Minimum version is nasm-2.13 or similar after running ./configure then the outdated nasm package from the repo is installed. Run yum remove nasm && hash -r and x264 will then use your newly compiled nasm instead. Ensure environment is able to resolve path to nasm binary.
fi

#libx265
#H.265/HEVC video encoder. See the H.265 Encoding Guide for more information and usage examples.

#Requires ffmpeg to be configured with --enable-gpl --enable-libx265.

if [ ! -d $HERE/deps/x265 ]; then
cd $HERE/deps || exit
git clone https://github.com/kevleyski/x265.git
cd $HERE/deps || exit/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HERE/deps" -DENABLE_SHARED:bool=off ../../source
make -j $(nproc)
make install
fi

#libfdk_aac
#AAC audio encoder. See the AAC Audio Encoding Guide for more information and usage examples.

#Requires ffmpeg to be configured with --enable-libfdk_aac (and --enable-nonfree if you also included --enable-gpl).

if [ ! -d $HERE/deps/fdk-aac ]; then
cd $HERE/deps || exit
git clone --depth 1 https://github.com/mstorsjo/fdk-aac
cd fdk-aac || exit
autoreconf -fiv
./configure --prefix="$HERE/deps" --disable-shared
make -j $(nproc)
make install
libmp3lame
MP3 audio encoder.
fi

#Requires ffmpeg to be configured with --enable-libmp3lame.

if [ ! -d $HERE/deps/lame ]; then
cd $HERE/deps || exit
curl -O -L http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xzvf lame-3.100.tar.gz
mv lame-3.100 lame
cd lame || exit
./configure --prefix="$HERE/deps" --bindir="$HERE/bin" --disable-shared --enable-nasm
make -j $(nproc)
make install
fi

#libopus
#Opus audio decoder and encoder.

#Requires ffmpeg to be configured with --enable-libopus.

if [ ! -d $HERE/deps/opus ]; then
cd $HERE/deps || exit
curl -O -L https://archive.mozilla.org/pub/opus/opus-1.2.1.tar.gz
tar xzvf opus-1.2.1.tar.gz
mv opus-1.2.1 opus
cd opus || exit
./configure --prefix="$HERE/deps" --disable-shared
make -j $(nproc)
make install
fi

#libogg
#Ogg bitstream library. Required by libtheora and libvorbis.

if [ ! -d $HERE/deps/libogg ]; then
cd $HERE/deps || exit
curl -O -L http://downloads.xiph.org/releases/ogg/libogg-1.3.3.tar.gz
tar xzvf libogg-1.3.3.tar.gz
mv libogg-1.3.3 libogg
cd libogg || exit
./configure --prefix="$HERE/deps" --disable-shared
make -j $(nproc)
make install
fi

#libvorbis
#Vorbis audio encoder. Requires libogg.

#Requires ffmpeg to be configured with --enable-libvorbis.

if [ ! -d $HERE/deps/libvorbis ]; then
cd $HERE/deps || exit
curl -O -L http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz
tar xzvf libvorbis-1.3.5.tar.gz
mv libvorbis-1.3.5 libvorbis
cd libvorbis || exit
./configure --prefix="$HERE/deps" --with-ogg="$HERE/deps" --disable-shared
make -j $(nproc)
make install
fi

#libvpx
#VP8/VP9 video encoder and decoder. See the VP9 Video Encoding Guide for more information and usage examples.

#Requires ffmpeg to be configured with --enable-libvpx.

if [ ! -d $HERE/deps/libvpx ]; then
cd $HERE/deps || exit
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx || exit
./configure --prefix="$HERE/deps" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm
make -j $(nproc)
make install
fi

#libaom (AV1 for x86)
if [ ! -d $HERE/deps/aom-master ]; then
cd $HERE/deps || exit
curl -O -L https://github.com/kevleyski/aom/archive/master.zip
unzip master.zip
cd aom-master || exit
./configure --prefix="$HERE/deps" --enable-av1 --disable-shared
make -j $(nproc)
make install
cd ..
fi

#libdav1d (AV1 decoder)
#if [ ! -d $HERE/deps/dav1d ]; then
#cd $HERE/deps || exit
#rm -rf dav1d-KJSL_v1.4.2*
#curl -O -L https://github.com/kevleyski/dav1d/archive/refs/tags/KJSL_v1.4.2.zip
#unzip KJSL_v1.4.2.zip
#mv dav1d-KJSL_v1.4.2 dav1d
#cd dav1d || exit
#rm -rf build
#mkdir -p build
#cd build || exit
#meson --prefix="$HERE/deps" setup ..
#ninja
#fi


if [ ! -d $HERE/deps/SVT-AV1 ]; then
cd $HERE/deps || exit
git clone https://github.com/kevleyski/SVT-AV1.git
cd SVT-AV1
cd Build/linux
./build.sh
fi




#librtmp
if [ ! -d $HERE/deps/librtmp ]; then
cd $HERE/deps || exit
git clone --depth 1 https://github.com/kevleyski/librtmp.git
cd librtmp
make
fi

# FFmpeg
echo "Building FFmpeg..."
cd $HERE || exit
time PATH="$HERE/bin:$PATH" PKG_CONFIG_PATH="$HERE/deps/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig:$PKG_CONFIG_PATH" ./configure \
  --prefix="/usr/local" \
  --pkg-config-flags="--static" \
  --extra-libs=-lpthread \
  --extra-libs=-lm \
  --bindir="$HERE/bin" \
  --enable-gpl \
  --enable-libass \
  --enable-libfdk_aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libsvtav1 \
  --enable-openssl \
  --enable-nonfree \
  --enable-libxvid --enable-ffplay \
  --enable-libsrt \
  --enable-librtmp \
  --enable-libmp3lame

make -j $(nproc)
make install
hash -r
