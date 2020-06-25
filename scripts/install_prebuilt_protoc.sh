#!/usr/bin/env bash

# 
#  Download Protocol Compiler, which is used to compile .proto files
#

VERSION=3.7.1
PLATFORM=linux-$(arch)
DOWNLOAD_URL=https://github.com/protocolbuffers/protobuf/releases/download/v$VERSION/protoc-$VERSION-$PLATFORM.zip

sudo apt-get update && sudo apt-get install -y wget
wget $DOWNLOAD_URL -O protoc-$VERSION.zip
unzip protoc-$VERSION.zip -d protoc-$VERSION

sudo cp protoc-$VERSION/bin/* /usr/local
sudo cp protoc-$VERSION/include/* /usr/local/include

# 
# Clean intermediate files
# 

rm -r protoc-$VERSION*
