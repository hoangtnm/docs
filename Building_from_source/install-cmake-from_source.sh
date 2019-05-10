#!/bin/bash
#
# CMake installation script.
######################################################

echo "\nInstalling CMake\n"

sudo apt update && sudo apt install -y wget make qtbase5-dev libncurses5-dev
wget https://github.com/Kitware/CMake/releases/download/v3.14.3/cmake-3.14.3.tar.gz
tar xvzf cmake-3.14.3.tar.gz
cd cmake-3.14.3
./configure --qt-gui
./bootstrap
make -j $(nproc)
make install -j $(nproc)

echo "Installation completed."
