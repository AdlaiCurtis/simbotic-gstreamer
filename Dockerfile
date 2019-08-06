ARG UBUNTU_VERSION=18.04

FROM nvidia/cudagl:10.0-devel-ubuntu${UBUNTU_VERSION} as base

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display

RUN apt-get update && apt-get install -y --no-install-recommends \
        mesa-utils && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils build-essential sudo git curl \
    autoconf autogen automake libtool autopoint

ENV DEBIAN_FRONTEND noninteractive
ENV TZ=America/Detroit
RUN apt-get update && apt-get install -y tzdata

RUN apt-get update && sudo apt-get install -y \
    gtk-doc-tools libglib2.0-dev bison flex gettext graphviz yasm \
    liborc-0.4-0 liborc-0.4-dev libvorbis-dev libcdparanoia-dev \
    libcdparanoia0 cdparanoia libvisual-0.4-0 libvisual-0.4-dev libvisual-0.4-plugins libvisual-projectm \
    vorbis-tools vorbisgain libopus-dev libopus-doc libopus0 libopusfile-dev libopusfile0 \
    libtheora-bin libtheora-dev libtheora-doc libvpx-dev libvpx-doc \
    libflac++-dev libavc1394-dev \
    libraw1394-dev libraw1394-tools libraw1394-doc libraw1394-tools \
    libtag1-dev libtagc0-dev libwavpack-dev wavpack \
    libfontconfig1-dev libfreetype6-dev \
    x11-xserver-utils libx11-dev libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev libx11-xcb-dev libxcb-glx0-dev \
    libasound2-dev libavcodec-dev libavformat-dev libswscale-dev \
    libwebrtc-audio-processing-dev libnvidia-encode-430 \
    libsrtp2-dev

RUN apt-get upgrade -y && apt-get autoremove

COPY nvidia-video/include/* /usr/local/cuda/include/

COPY bashrc /etc/bash.bashrc
RUN chmod a+rwx /etc/bash.bashrc

ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd -g ${GROUP_ID} sim && \
    useradd -m -l -u ${USER_ID} -g sim sim && \
    echo "sim:sim" | chpasswd && adduser sim sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER sim
WORKDIR /home/sim

RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain stable -y
ENV PATH=/home/sim/.cargo/bin:$PATH

RUN git clone -b 0.1.16 --single-branch https://gitlab.freedesktop.org/libnice/libnice.git
RUN git clone -b 1.16 --single-branch https://gitlab.freedesktop.org/gstreamer/gst-libav.git
RUN git clone -b 1.16 --single-branch https://gitlab.freedesktop.org/gstreamer/gstreamer.git
RUN git clone -b 1.16 --single-branch https://gitlab.freedesktop.org/gstreamer/gst-plugins-base.git
RUN git clone -b 1.16 --single-branch https://gitlab.freedesktop.org/gstreamer/gst-plugins-good.git
RUN git clone -b 1.16 --single-branch https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad.git
RUN git clone -b 1.16 --single-branch https://gitlab.freedesktop.org/gstreamer/gst-plugins-ugly.git

COPY build_gstreamer.sh build_gstreamer.sh
RUN sudo chmod +x build_gstreamer.sh
RUN ./build_gstreamer.sh

CMD ["bash"]

