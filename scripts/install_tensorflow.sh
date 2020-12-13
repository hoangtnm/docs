#!/usr/bin/env bash

set -e

VERSION='2.3'

# Uninstall existing TensorFlow packages 
python3 -m pip uninstall tensorflow*

# Install dependencies
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
export TF_CUDA_VERSION=10.2
export TF_CUDA_COMPUTE_CAPABILITIES="3.5,6.1,7.0,7.5,8.6"
export TF_CUDA_PATHS="/usr/local/cuda-10.2,/usr/lib/x86_64-linux-gnu,/usr/include"
export TF_CUDNN_VERSION=7
export TF_NCCL_VERSION=2
export TF_NEED_GCP=0
export TF_NEED_HDFS=0
export TF_NEED_S3=0
export TF_NEED_CUDA=1
export PYTHON_BIN_PATH="$(which python3)"
export TF_NEED_TENSORRT=0
yes "" | python3 configure.py

# Build TensorFlow package
bazel build --copt=-march=native --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" --config=opt tensorflow/tools/pip_package:build_pip_package
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

# Install the package
python3 -m pip --no-cache-dir install --upgrade /tmp/tensorflow_pkg/*.whl
