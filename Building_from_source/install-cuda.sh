#! /bin/bash

echo ""
echo "************************ Please confirm *******************************"
echo " Installing CUDA Toolkit from source may take a long time. "
echo " Select n to skip CUDA Toolkit installation or y to install it." 
read -p " Continue installing CUDA Toolkit (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
  curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add -
  echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list
  echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list
  
  export CUDA_VERSION=10.0.130
  export CUDA_PKG_VERSION="10-0=$CUDA_VERSION-1"
  sudo apt update && apt-get install -y --no-install-recommends \
          cuda-cudart-$CUDA_PKG_VERSION \
          cuda-compat-10-0=410.48-1
  sudo ln -s cuda-10.0 /usr/local/cuda

  export NCCL_VERSION=2.3.5
  sudo apt update && apt-get install -y --no-install-recommends \
          cuda-libraries-$CUDA_PKG_VERSION \
          cuda-libraries-dev-$CUDA_PKG_VERSION \
          cuda-nvtx-$CUDA_PKG_VERSION \
          cuda-nvml-dev-$CUDA_PKG_VERSION \
          libnccl2=$NCCL_VERSION-2+cuda10.0 && \
          cuda-minimal-build-$CUDA_PKG_VERSION \
          cuda-command-line-tools-$CUDA_PKG_VERSION \
          libnccl-dev=$NCCL_VERSION-2+cuda10.0 && \
          apt-mark hold libnccl2

  echo 'export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}' >> ~/.bashrc
  echo 'export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
  source ~/.bashrc
	sudo ldconfig
else
	echo "";
	echo "Skipping CUDA Toolkit installation";
	echo "";
fi
