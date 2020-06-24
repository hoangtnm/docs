#!/usr/bin/env bash

echo Installing JDK 8
sudo apt-get update && sudo apt-get install -y curl openjdk-8-jdk

echo Installing dependencies
sudo apt-get install -y pkg-config zip g++ zlib1g-dev unzip

VERSION=3.99.0
echo Installing Bazel $VERSION
DOWNLOAD_URL=https://github.com/bazelbuild/bazel/releases/download/$VERSION/bazel-$VERSION-installer-linux-x86_64.sh
wget $DOWNLOAD_URL
chmod +x bazel-$VERSION-installer-linux-x86_64.sh
./bazel-$VERSION-installer-linux-x86_64.sh --user

echo Adding bazel to PATH
echo 'export PATH=$HOME/bin${PATH:+:${PATH}}' >> ~/.bashrc
