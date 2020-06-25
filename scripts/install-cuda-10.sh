#!/usr/bin/env bash

CUDA_VERSION=10.1.243
CUDNN_VERSION=7.6.5.32
NCCL_VERSION=2.7.3

sudo apt-get purge cuda* cuda-repo-ubuntu* nvidia-machine-learning-repo-ubuntu*
sudo apt-get update && sudo apt-get install -y wget ca-certificates gcc g++
wget http://developer.download.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.243_418.87.00_linux.run
wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo dpkg -i nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt-key adv --fetch-keys http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

echo The following NEW packages will be installed:
echo "  CUDA Toolkit: $CUDA_VERSION"
echo "  cuDNN       : $CUDNN_VERSION"
echo "  NCCL        : $NCCL_VERSION"

chmod +x cuda_10.1.243_418.87.00_linux.run && \
sudo sh cuda_10.1.243_418.87.00_linux.run && \
sudo apt-get update && sudo apt-get install -y \
	libnccl2=$NCCL_VERSION-1+cuda10.1 \
	libnccl-dev=$NCCL_VERSION-1+cuda10.1 \
	libcudnn7=$CUDNN_VERSION-1+cuda10.1 \
	libcudnn7-dev=$CUDNN_VERSION-1+cuda10.1 && \
sudo apt-mark hold libcudnn7 libnccl2

echo 'export PATH=/usr/local/cuda-10.1/bin${PATH:+:${PATH}}' >> ~/.bashrc
echo 'export LIBRARY_PATH=/usr/local/cuda-10.1/lib64/stubs${LIBRARY_PATH:+:${LIBRARY_PATH}}' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-10.1/lib64:/usr/local/cuda-10.1/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc

if [[ -f ~/.zshrc ]]; then
	echo 'export PATH=/usr/local/cuda-10.1/bin${PATH:+:${PATH}}' >> ~/.zshrc
	echo 'export LIBRARY_PATH=/usr/local/cuda-10.1/lib64/stubs${LIBRARY_PATH:+:${LIBRARY_PATH}}' >> ~/.zshrc
	echo 'export LD_LIBRARY_PATH=/usr/local/cuda-10.1/lib64:/usr/local/cuda-10.1/extras/CUPTI/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.zshrc
fi
