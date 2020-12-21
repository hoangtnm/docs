#!/usr/bin/env bash

set -e

ONNXRUNTIME_REPO="https://github.com/Microsoft/onnxruntime"
ONNXRUNTIME_SERVER_BRANCH="master"

# Install dependencies
apt-get update && apt-get install -y \
    build-essential curl wget libcurl4-openssl-dev libssl-dev \
    python3 python3-dev git tar make cmake  \
    libopenmpi-dev libatlas-base-dev libopenblas-dev \
    libprotobuf-dev protobuf-compiler

python3 -m pip install -U pip
python3 -m pip install setuptools wheel numpy protobuf

# Build arguments
BUILDTYPE="MinSizeRel"
# if doing a 64-bit build change '--arm' to '--arm64'
ARCH="arm"

git clone --depth 1 --single-branch --branch ${ONNXRUNTIME_SERVER_BRANCH} \
    --recursive ${ONNXRUNTIME_REPO} onnxruntime
cd onnxruntime
# Clean intermediate files
# cmake --build --target clean
./build.sh \
    --use_openmp \
    --use_openblas \
    --config "${BUILDTYPE}" \
    --"{ARCH}" \
    --arm-parallel $(nproc) \
    --update \
    --build \
    --build_shared_lib \
    --build_wheel

# Build Output
ls -l build/Linux/${BUILDTYPE}/*.so
ls -l build/Linux/${BUILDTYPE}/dist/*.whl
python3 -m pip install build/Linux/${BUILDTYPE}/dist/*.whl
