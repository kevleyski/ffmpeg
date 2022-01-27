# cross compile build native FFmpeg static with SRT

FROM ubuntu:18.04 AS kjsl_ubuntu18_baseline
MAINTAINER kevleyski

# Pull in build cross compiler tool dependencies using Advanced Package Tool
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Australia/Sydney

RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --fix-missing -y install tzdata wget curl autoconf automake build-essential libass-dev libfreetype6-dev \
                                            libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
                                            libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev gettext tcl libssl-dev cmake mercurial unzip git \
                                            libdrm-dev valgrind libpciaccess-dev libxslt1-dev geoip-bin libgeoip-dev zlib1g-dev libpcre3 libpcre3-dev \
                                            libbz2-dev ca-certificates libssl-dev nasm strace vim \
    && mkdir ~/kjsl \
    && apt-get -y install yasm \
    && cd ~/kjsl \
    && wget http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz \
    && tar xzvf yasm-1.3.0.tar.gz \
    && rm -f yasm-1.3.0.tar.gz \
    && cd yasm-1.3.0 \
    && ./configure --prefix="$HOME/kjsl" --bindir="$HOME/bin" \
    && make -j$(cat /proc/cpuinfo | grep processor | wc -l) \
    && make install \
    && make distclean

# Intel VAAPI
RUN set -x \
    && cd ~/kjsl \
    && git clone https://github.com/kevleyski/libva libva \
    && cd libva \
    && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/kjsl/lib/pkgconfig" ./autogen.sh \
    && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/kjsl/lib/pkgconfig" ./configure --prefix="$HOME/kjsl" \
    && PATH="$HOME/bin:$PATH" make -j$(cat /proc/cpuinfo | grep processor | wc -l) \
    && make install \
    && make clean

RUN set -x \
    && cd ~/kjsl \
    && git clone https://github.com/kevleyski/ffmpeg_vaapi_cmrt cmrt \
    && cd cmrt \
    && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/kjsl/lib/pkgconfig" ./autogen.sh \
    && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/kjsl/lib/pkgconfig" ./configure --prefix="$HOME/kjsl" \
    && PATH="$HOME/bin:$PATH" make -j$(cat /proc/cpuinfo | grep processor | wc -l) \
    && make install \
    && make clean

RUN set -x \
    && cd ~/kjsl \
    && git clone https://github.com/kevleyski/ffmpeg_vaapi_intel-hybrid-driver intel-hybrid-driver \
    && cd intel-hybrid-driver \
    && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/kjsl/lib/pkgconfig" ./autogen.sh \
    && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/kjsl/lib/pkgconfig" ./configure --prefix="$HOME/kjsl" \
    && PATH="$HOME/bin:$PATH" make -j$(cat /proc/cpuinfo | grep processor | wc -l) \
    && make install \
    && make clean

RUN set -x \
    && cd ~/kjsl \
    && git clone https://github.com/kevleyski/intel-vaapi-driver intel-vaapi-driver \
    && cd intel-vaapi-driver \
    && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/kjsl/lib/pkgconfig" ./autogen.sh \
    && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/kjsl/lib/pkgconfig" ./configure --prefix="$HOME/kjsl" \
    && PATH="$HOME/bin:$PATH" make -j$(cat /proc/cpuinfo | grep processor | wc -l) \
    && make install \
    && make clean

RUN set -x \
    && cd ~/kjsl \
    && git clone https://github.com/kevleyski/libva-utils libva-utils \
    && cd libva-utils \
    && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/kjsl/lib/pkgconfig" ./autogen.sh \
    && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/kjsl/lib/pkgconfig" ./configure --prefix="$HOME/kjsl" \
    && PATH="$HOME/bin:$PATH" make -j$(cat /proc/cpuinfo | grep processor | wc -l) \
    && make install \
    && make clean

# libSRT (dependency /usr/bin/tclsh)
RUN set -x \
    && cd ~/kjsl \
    && git clone https://github.com/kevleyski/srt srt \
    && cd srt \
    && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/kjsl/lib/pkgconfig" ./configure --prefix="$HOME/kjsl" --enable-static --disable-shared \
    && PATH="$HOME/bin:$PATH" make -j$(cat /proc/cpuinfo | grep processor | wc -l) \
    && make install \
    && make clean

## Build FFmpeg
FROM kjsl_ubuntu18_baseline AS kjsl_ffmpeg
RUN mkdir ~/kjsl/ffmpeg

COPY . ~/kjsl/ffmpeg

RUN cd ~/kjsl \
    && cd ffmpeg \
    && PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/kjsl/lib/pkgconfig" ./configure \
      --prefix="$HOME/kjsl" \
      --extra-cflags="-I$HOME/kjsl/include" \
      --extra-ldflags="-L$HOME/kjsl/lib" \
      --extra-libs="-lpthread -lm" \
      --bindir="$HOME/kjsl/bin" \
      --enable-ffplay \
      --enable-gpl \
      --disable-libxcb \
      --disable-xlib \
      --disable-lzma \
      --disable-alsa \
      --enable-libx264 \
      --enable-vaapi \
      --enable-nonfree \
      --enable-openssl \
      --enable-libsrt \
      --enable-libfreetype \
      --disable-doc \
      --pkg-config-flags="--static" \
    && PATH="$HOME/bin:$PATH" make -j$(cat /proc/cpuinfo | grep processor | wc -l) \
    && make install \
    && make distclean \
    && hash -r
