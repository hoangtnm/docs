#! /bin/bash

echo ""
echo "******************** Please confirm ***************************"
echo " Installing CUDA Toolkit may take a long time. "
echo " Select n to skip CUDA Toolkit installation or y to install it." 
read -p " Continue installing CUDA Toolkit (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	export CUDA_VERSION=9.2.148
	export CUDA_PKG_VERSION="9-2=$CUDA_VERSION-1"
	export NCCL_VERSION=2.3.7
	export CUDNN_VERSION=7.4.1.5
	sudo apt install -y curl wget ca-certificates
	wget http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1710/x86_64/cuda-repo-ubuntu1710_9.2.148-1_amd64.deb
	wget https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1604/x86_64/nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_amd64.deb
	sudo dpkg -i cuda-repo-ubuntu1710_9.2.148-1_amd64.deb
	sudo dpkg -i nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_amd64.deb
	rm cuda-repo-ubuntu1710_9.2.148-1_amd64.deb
	rm nvidia-machine-learning-repo-ubuntu1604_1.0.0-1_amd64.deb
	sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1710/x86_64/7fa2af80.pub
	
	echo "";
	echo "The following NEW packages will be installed:";
	echo "	CUDA Toolkit: $CUDA_VERSION";
	echo "	NCCL        : $NCCL_VERSION";
	echo "	cuDNN       : $CUDNN_VERSION";
	echo "";
	sudo apt update && sudo apt install -y cuda \
		libnccl2=$NCCL_VERSION-1+cuda9.2 \
		libnccl-dev=$NCCL_VERSION-1+cuda9.2 \
		libcudnn7=$CUDNN_VERSION-1+cuda9.2 \
		libcudnn7-dev=$CUDNN_VERSION-1+cuda9.2
	sudo ln -s /usr/local/cuda-9.2 /usr/local/cuda
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
