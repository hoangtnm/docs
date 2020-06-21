#!/usr/bin/env bash

echo
echo Installing dependencies
echo
sudo apt-get update && sudo apt-get install -y \
    wget make qtbase5-dev libncurses5-dev

echo
echo Downloading CMake 'source' code
echo
VERSION=3.14.3
wget https://github.com/Kitware/CMake/releases/download/v$VERSION/cmake-$VERSION.tar.gz
tar -xzf cmake-$VERSION.tar.gz
cd cmake-$VERSION
./configure --qt-gui
./bootstrap
make -j $(nproc)
sudo make install -j $(nproc)
