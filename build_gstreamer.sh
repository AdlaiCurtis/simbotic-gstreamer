#!/usr/bin/env bash

pushd gstreamer
./autogen.sh
./configure --disable-gtk-doc
make -j$(nproc)
sudo make install
sudo ldconfig
popd

pushd gst-plugins-base
./autogen.sh --enable-iso-codes --enable-orc --disable-gtk-doc
make -j$(nproc)
sudo make install
sudo ldconfig
popd

pushd gst-plugins-good
./autogen.sh --enable-orc --disable-gtk-doc
make -j$(nproc)
sudo make install
sudo ldconfig
popd

pushd gst-plugins-ugly
./autogen.sh --enable-orc --disable-gtk-doc
make -j$(nproc)
sudo make install
sudo ldconfig
popd

pushd gst-libav
./autogen.sh --enable-orc --disable-gtk-doc
make -j$(nproc)
sudo make install
sudo ldconfig
popd

pushd libnice
 ./autogen.sh --with-gstreamer --enable-static --enable-static-plugins \
    --enable-shared --without-gstreamer-0.10 --disable-gtk-doc --enable-compile-warnings=no
make -j$(nproc)
sudo make install
sudo ldconfig
popd

pushd usrsctp
./bootstrap
./configure
make -j$(nproc)
sudo make install
sudo ldconfig
popd

pushd gst-plugins-bad
./autogen.sh --enable-orc --disable-gtk-doc --with-cuda-prefix=/usr/local/cuda
make -j$(nproc)
sudo make install
sudo ldconfig
popd
