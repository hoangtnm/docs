#!/usr/bin/env bash

set -e

CUDA='10.1'
CUDNN_VERSION='7.6.5.32-1'
NCCL_VERSION='2.7.3-1'

apt-get update && apt-get install -y --no-install-recommends \
	gnupg2 curl ca-certificates

#
# Install CUDA public GPG key
# and add NVIDIA repositories
#

apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub
echo 'deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /' > /etc/apt/sources.list.d/cuda.list
echo 'deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /' > /etc/apt/sources.list.d/nvidia-ml.list

#
# Install CUDA, cuDNN, and NCCL
#

apt-get update && apt-get install -y --no-install-recommends \
	build-essential \
	cuda-compat-10-1 \
	libcublas10=10.2.1.243-1 \ 
	libcublas-dev=10.2.1.243-1 \
	cuda-nvrtc-${CUDA/./-} \
	cuda-nvrtc-dev-${CUDA/./-} \
	cuda-cudart-${CUDA/./-} \
	cuda-cudart-dev-${CUDA/./-} \
	cuda-cufft-dev-${CUDA/./-} \
	cuda-curand-dev-${CUDA/./-} \
	cuda-cusolver-dev-${CUDA/./-} \
	cuda-cusparse-dev-${CUDA/./-} \
	cuda-command-line-tools-${CUDA/./-} \
	cuda-nvml-dev-${CUDA/./-} \
	cuda-libraries-${CUDA/./-} \
	cuda-libraries-dev-${CUDA/./-} \
	cuda-minimal-build-${CUDA/./-} \
	cuda-nvtx-${CUDA/./-} \
	cuda-nvprof-${CUDA/./-} \
	cuda-nvprof-${CUDA/./-} \
	cuda-npp-${CUDA/./-} \
	cuda-npp-dev-${CUDA/./-} \
	libnccl2=${NCCL_VERSION}+cuda${CUDA} \
	libnccl-dev=${NCCL_VERSION}+cuda${CUDA} \
	libcudnn7=${CUDNN_VERSION}+cuda${CUDA} \
	libcudnn7-dev=${CUDNN_VERSION}+cuda${CUDA} \
	&& ln -s /usr/local/cuda-10.1 /usr/local/cuda \
	&& apt-mark hold libcublas10 libcublas-dev libcudnn7 libnccl2

#
# Environment setup
#

shell="$0"
echo 'export PATH=/usr/local/cuda-10.1/bin${PATH:+:${PATH}}' >> ~/."${shell}rc"
echo 'export LIBRARY_PATH=/usr/local/cuda-10.1/lib64/stubs${LIBRARY_PATH:+:${LIBRARY_PATH}}' >> ~/."${shell}rc"
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-10.1/lib64:/usr/local/cuda-10.1/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/."${shell}rc"
