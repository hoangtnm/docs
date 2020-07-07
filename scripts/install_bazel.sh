#!/usr/bin/env bash

set -e

VERSION='3.1.0'

apt-get update && apt-get install -y \
    curl openjdk-8-jdk \
    pkg-config zip g++ zlib1g-dev unzip

wget -O bazel_installer.sh "https://github.com/bazelbuild/bazel/releases/download/${VERSION}/bazel-${VERSION}-installer-linux-x86_64.sh"
chmod +x bazel_installer
./bazel_installer
rm bazel_installer

#
# Environment setup
#

shell="$0"

echo "export PATH=$HOME/bin"'${PATH:+:${PATH}}' >> ~/."${shell}rc"
