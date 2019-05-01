#! /bin/bash

echo ""
echo "******************** Please confirm ***************************"
echo " Installing CUDA Toolkit may take a long time. "
echo " Select n to skip CUDA Toolkit installation or y to install it." 
read -p " Continue installing CUDA Toolkit (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	export CUDA_VERSION=10.0.130
	export NCCL_VERSION=2.4.2
	export CUDNN_VERSION=7.5.1.10
	sudo apt purge cuda* cuda-repo-ubuntu* nvidia-machine-learning-repo-ubuntu*
	sudo apt update && sudo apt install -y curl wget ca-certificates
	wget https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux \
		-o https://developer.nvidia.com/compute/cuda/10.0/Prod/local_installers/cuda_10.0.130_410.48_linux.run
	wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
	sudo dpkg -i nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
	
	echo "";
	echo "The following NEW packages will be installed:";
	echo "	CUDA Toolkit: $CUDA_VERSION";
	echo "	NCCL        : $NCCL_VERSION";
	echo "	cuDNN       : $CUDNN_VERSION";
	echo "";
	sudo apt update && sudo apt install gcc-6 g++-6
	sudo rm /usr/bin/gcc && sudo ln -s /usr/bin/gcc
	sudo rm /usr/bin/g++ && sudo ln -s /usr/bin/g++
	chmod +x cuda_10.0.130_410.48_linux.run
	sudo sh cuda_10.0.130_410.48_linux.run
	sudo apt install -y --no-install-recommends \
		libnccl2=$NCCL_VERSION-1+cuda10.0 \
		libnccl-dev=$NCCL_VERSION-1+cuda10.0 \
		libcudnn7=$CUDNN_VERSION-1+cuda10.0 \
		libcudnn7-dev=$CUDNN_VERSION-1+cuda10.0
	sudo ln -s /usr/local/cuda-10.0 /usr/local/cuda
	sudo apt-mark hold libnccl2
	sudo apt-mark hold libcudnn7
	echo 'export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}' >> ~/.bashrc
	echo 'export LIBRARY_PATH=/usr/local/cuda/lib64/stubs${LIBRARY_PATH:+:${LIBRARY_PATH}}' >> ~/.bashrc
	echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
	source ~/.bashrc
	sudo ldconfig
	echo "The installation completed!";
else
	echo "";
	echo "Skipping CUDA Toolkit installation";
	echo "";
fi
