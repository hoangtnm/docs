#!/usr/bin/env bash
# See details at
# https://gist.github.com/akaanirban/621e63237e63bb169126b537d7a1d979
# https://blog.openmined.org/federated-learning-of-a-rnn-on-raspberry-pis

set -e

VERSION="v1.7.1"

sudo apt-get update && sudo apt-get install -y \
    libopenblas-dev libblas-dev m4 cmake cython python3-dev python3-yaml \
    python3-setuptools python3-wheel python3-pillow python3-numpy

sudo pip3 install ninja pyyaml typing_extensions \
    cffi future six requests dataclasses

git clone --depth 1 -b "${VERSION}" --recursive https://github.com/pytorch/pytorch
cd pytorch
# git submodule update --remote third_party/protobuf

export MAX_JOBS=3
export USE_CUDA=0
export USE_MKLDNN=0
export USE_NNPACK=0
export USE_QNNPACK=0
export USE_NUMPY=1
export USE_DISTRIBUTED=0
export NO_CUDA=1
export NO_DISTRIBUTED=1
export NO_MKLDNN=1 
export NO_NNPACK=1
export NO_QNNPACK=1
export ONNX_ML=1

# python3 setup.py clean --all
python3 setup.py build
# sudo -E python3 setup.py install
# sudo -E python3 setup.py bdist_wheel
python3 setup.py bdist_wheel
pip3 install dist/*.whl
