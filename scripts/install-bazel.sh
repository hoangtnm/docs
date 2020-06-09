#!/usr/bin/env bash

echo "Installing JDK 8";
sudo apt-get install -y curl openjdk-8-jdk

echo "Installing required packages";
sudo apt-get install -y pkg-config zip g++ zlib1g-dev unzip

echo "\nInstalling Bazel 0.21\n";
export BAZEL_VERSION=0.21.0
export BAZEL_DOWNLOAD_URL=https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-installer-linux-x86_64.sh
wget $BAZEL_DOWNLOAD_URL
chmod +x bazel-$BAZEL_VERSION-installer-linux-x86_64.sh
./bazel-$BAZEL_VERSION-installer-linux-x86_64.sh --user

echo "\nSet up your environment\n";
echo 'export PATH=$HOME/bin${PATH:+:${PATH}}' >> ~/.bashrc
source ~/.bashrc

echo "\nThe installation completed\n"
