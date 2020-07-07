#!/usr/bin/env bash

set -e

VERSION='2.2'

# Uninstalling pip installation
python3 -m pip uninstall tensorflow*

#
# Installing dependencies
#

apt-get update && apt-get install -y \
	build-essential git
python3 -m pip install -U \
	pip six numpy wheel setuptools mock \
	keras_applications keras_preprocessing

echo 'Downloading TensorFlow source code'
git clone -b "r${VERSION}" --depth 1 https://github.com/tensorflow/tensorflow.git
cd tensorflow

# Configure the build
# See details at
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/tests/build-gpu.sh

export TF_NEED_GCP=1
export TF_NEED_HDFS=1
export TF_NEED_S3=1
export TF_NEED_CUDA=1
export TF_NEED_TENSORRT=0
yes "" | python3 configure.py

# Build TensorFlow package with GPU support
bazel build --copt=-march=native --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" --config=opt --config=v2 tensorflow/tools/pip_package:build_pip_package
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

# Install the built package
python3 -m pip --no-cache-dir install --upgrade /tmp/tensorflow_pkg/*.whl
