#!/usr/bin/env bash

set -e

VERSION=3.13.0
PLATFORM="linux-$(arch)"
DOWNLOAD_URL="https://github.com/protocolbuffers/protobuf/releases/download/v${VERSION}/protoc-${VERSION}-${PLATFORM}.zip"

echo 'Downloading Protocol Compiler'
apt-get update && apt-get install -y wget
wget -O "protoc-${VERSION}.zip" "${DOWNLOAD_URL}"
unzip "protoc-${VERSION}.zip" -d "protoc-${VERSION}"

echo 'Installing Protocol Compiler'
cp protoc-${VERSION}/bin/* /usr/local/bin
cp protoc-${VERSION}/include/* /usr/local/include

echo 'Cleaning intermediate files'
rm -r protoc-${VERSION}*
