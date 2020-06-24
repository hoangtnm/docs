#!/usr/bin/env bash

echo
echo Downloading the protocol compiler
echo

VERSION=3.7.1
PLATFORM=linux-$(arch)
DOWNLOAD_URL=https://github.com/protocolbuffers/protobuf/releases/download/v$VERSION/protoc-$VERSION-$PLATFORM.zip

sudo apt-get update && sudo apt-get install -y wget
wget "$DOWNLOAD_URL" -O protoc-$VERSION.zip
unzip protoc-$VERSION.zip -d protoc-$VERSION

sudo cp -r protoc-$VERSION /usr/local
sudo cp -r protoc-$VERSION/include/* /usr/local/include/

echo Refreshing shared library cache
echo By default, the Protocol Compiler will be installed to /usr/local
echo "export PATH=/usr/local/protoc-$VERSION/bin"'${PATH:+:${PATH}}' >> ~/.bashrc

if [[ -f ~/.zshrc ]]; then
	echo "export PATH=/usr/local/protoc-$VERSION/bin"'${PATH:+:${PATH}}' >> ~/.zshrc
fi

sudo ldconfig
