#!/usr/bin/env bash

set -e

VERSION='3.14.3'

echo 'Installing CMake dependencies'
apt-get update && apt-get install -y \
    wget make qtbase5-dev libncurses5-dev

echo 'Downloading CMake source code'
wget "https://github.com/Kitware/CMake/releases/download/v${VERSION}/cmake-${VERSION}.tar.gz"
tar -xzf "cmake-${VERSION}.tar.gz"
cd "cmake-${VERSION}"
./configure --qt-gui
./bootstrap
make -j $(nproc)
make install
