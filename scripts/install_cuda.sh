#!/usr/bin/env bash

set -e

CUDA='11.0'
CUDNN_VERSION='8.0.4.30'
NCCL_VERSION='2.8.3'

apt-get update && apt-get install -y --no-install-recommends \
	gnupg2 curl ca-certificates

# Install CUDA public GPG key
# and add NVIDIA repositories
apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
echo 'deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /' > /etc/apt/sources.list.d/cuda.list
echo 'deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /' > /etc/apt/sources.list.d/nvidia-ml.list

# Install CUDA, cuDNN, and NCCL
apt-get update && apt-get install -y --no-install-recommends \
	build-essential \
	build-essential \
	cuda-cudart-11-0=11.0.221-1 \
	cuda-compat-11-0 \
	cuda-nvml-dev-11-0=11.0.167-1 \
	cuda-command-line-tools-11-0=11.0.3-1 \
	cuda-nvprof-11-0=11.0.221-1 \
	libnpp-dev-11-0=11.1.0.245-1 \
	cuda-libraries-dev-11-0=11.0.3-1 \
	cuda-minimal-build-11-0=11.0.3-1 \
	libcublas-dev-11-0=11.2.0.252-1 \
	libcusparse-11-0=11.1.1.245-1 \
	libcusparse-dev-11-0=11.1.1.245-1 \
	cuda-libraries-11-0=11.0.3-1 \
	libnpp-11-0=11.1.0.245-1 \
	cuda-nvtx-11-0=11.0.167-1 \
	libcublas-11-0=11.2.0.252-1 \
	libcudnn8=${CUDNN_VERSION}-1+cuda${CUDA} \
	libcudnn8-dev=${CUDNN_VERSION}-1+cuda${CUDA} \
	libnccl2=${NCCL_VERSION}-1+cuda${CUDA} \
	libnccl-dev=${NCCL_VERSION}-1+cuda${CUDA} \
	&& ln -s /usr/local/cuda-11.0 /usr/local/cuda \
	&& apt-mark hold libcudnn8 libcudnn7-dev libnccl2 libnccl-dev

# Environment setup
shell="$0"
echo 'export PATH=/usr/local/cuda-11.0/bin${PATH:+:${PATH}}' >> ~/."${shell}rc"
echo 'export LIBRARY_PATH=/usr/local/cuda-11.0/lib64/stubs${LIBRARY_PATH:+:${LIBRARY_PATH}}' >> ~/."${shell}rc"
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.0/lib64:/usr/local/cuda-11.0/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/."${shell}rc"
