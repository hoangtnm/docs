#!/usr/bin/env bash

set -e

VERSION='2.2'

echo 'Uninstalling pip installation'
sudo pip3 uninstall tensorflow*

echo 'Installing dependencies'
apt-get update && apt-get install -y build-essential git
python3 -m pip install -U \
	pip six numpy wheel setuptools mock \
	keras_applications keras_preprocessing

echo 'Downloading TensorFlow source code'
git clone -b "r${VERSION}" https://github.com/tensorflow/tensorflow.git
cd tensorflow

echo 'Configuring the build'
./configure

echo 'Making the TensorFlow package builder with GPU support'
bazel build -c opt --copt=-march=native --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" --config=cuda //tensorflow/tools/pip_package:build_pip_package

echo 'Building the package'
./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

echo 'The built package is located at /tmp/tensorflow_pkg'
echo 'Please run sudo `pip3 install -U /tmp/tensorflow_pkg/*.whl` to install the package'
