#! /bin/bash

echo ""
echo "******************** Please confirm ***************************"
echo " Installing CUDA Toolkit may take a long time. "
echo " Select n to skip CUDA Toolkit installation or y to install it." 
read -p " Continue installing CUDA Toolkit (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
  curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add -
  echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list
  echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list
  export CUDA_VERSION=10.0.130
  export CUDA_PKG_VERSION="10-0=$CUDA_VERSION-1"
  export NCCL_VERSION=2.3.5
  export CUDNN_VERSION=7.3.1.20
  echo "";
  echo "The following NEW packages will be installed:";
  echo "	CUDA Toolkit: $CUDA_VERSION";
  echo "	NCCL        : $NCCL_VERSION";
  echo "	cuDNN       : $CUDNN_VERSION";
  echo "";
  sudo apt update && apt-get install -y --no-install-recommends \
  	  cuda-cudart-$CUDA_PKG_VERSION \
	  cuda-compat-10-0=410.48-1 \
	  cuda-libraries-$CUDA_PKG_VERSION \
	  cuda-libraries-dev-$CUDA_PKG_VERSION \
	  cuda-nvtx-$CUDA_PKG_VERSION \
	  cuda-nvml-dev-$CUDA_PKG_VERSION \
	  cuda-minimal-build-$CUDA_PKG_VERSION \
	  cuda-command-line-tools-$CUDA_PKG_VERSION \
	  libnccl2=$NCCL_VERSION-2+cuda10.0 \
	  libnccl-dev=$NCCL_VERSION-2+cuda10.0 \
	  libcudnn7=$CUDNN_VERSION-1+cuda10.0 \
	  libcudnn7-dev=$CUDNN_VERSION-1+cuda10.0
  sudo ln -s cuda-10.0 /usr/local/cuda
  sudo apt-mark hold libnccl2
  sudo apt-mark hold libcudnn7

  echo 'export PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin${PATH:+:${PATH}}' >> ~/.bashrc
  echo 'export LIBRARY_PATH=/usr/local/cuda/lib64/stubs${LIBRARY_PATH:+:${LIBRARY_PATH}}' >> ~/.bashrc
  echo 'export LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
  source ~/.bashrc
  sudo ldconfig
  echo "The CUDA Toolkit installation completed!";
else
	echo "";
	echo "Skipping CUDA Toolkit installation";
	echo "";
fi
