#!/usr/bin/env bash

echo
echo Installing dependencies
echo
sudo apt-get update && sudo apt-get install -y \
	build-essential autoconf automake libtool curl make g++ unzip

echo
echo Downloading protobuf 'source' code
echo
VERSION=3.7.1
DOWNLOAD_URL=https://github.com/protocolbuffers/protobuf/releases/download/v$VERSION/protobuf-all-$VERSION.zip
wget "$DOWNLOAD_URL" -O protobuf.zip
unzip protobuf.zip

echo
echo Building and Installing the C++ Protocol Buffer runtime and the Protocol Buffer compiler '(protoc)'
echo
cd protobuf-$VERSION
./configure
make -j $(nproc)
make check -j $(nproc)
sudo make install

echo
echo Refreshing shared library cache
echo By default, the Protocol Compiler will be installed to /usr/local
echo
echo 'export LD_LIBRARY_PATH=/usr/local/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
source ~/.bashrc

if [[ -f ~/.zshrc ]]; then
	echo 'export LD_LIBRARY_PATH=/usr/local/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.zshrc
fi

sudo ldconfig

echo
echo Installing the protobuf runtime 'for' Python
echo
cd python
python setup.py build
python setup.py test
sudo python setup.py install

echo
echo The installation completed
echo
