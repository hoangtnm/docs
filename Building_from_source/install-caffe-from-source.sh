#! /bin/bash

echo ""
echo "********************** Please confirm ****************************"
echo " Installing Caffe from source may take a long time. "
echo " Select n to skip Caffe installation or y to install it." 
read -p " Continue installing Caffe (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	sudo apt update -y && sudo apt-get upgrade -y
	sudo apt install build-essential \
		libhdf5-serial-dev \
		libboost-all-dev \
		libprotobuf-dev \
		libleveldb-dev \
		libsnappy-dev \
		liblmdb-dev \
		libopencv-dev \
		libgflags-dev \
		libgoogle-glog-dev \
		protobuf-compiler
	echo "";
	echo "Downloading and Building the Source Code";
	echo "";
	git clone https://github.com/weiliu89/caffe.git
	cd caffe
	git checkout ssd
	cp Makefile.config.example Makefile.config
	sed -i 's/# USE_CUDNN := 1/USE_CUDNN := 1/g' Makefile.config
	sed -i 's/# OPENCV_VERSION := 3/OPENCV_VERSION := 3/g' Makefile.config
	sed -i 's/# CUSTOM_CXX := g++/CUSTOM_CXX := g++/g' Makefile.config
	sed -i 's/# BLAS_INCLUDE := /path/to/your/blas//opt/OpenBLAS/include/g' Makefile.config
	sed -i 's/# BLAS_LIB := /path/to/your/blas/opt/OpenBLAS/lib/g' Makefile.config
	sed -i 's/PYTHON_INCLUDE := /usr/include/python2.7/#PYTHON_INCLUDE := /usr/include/python2.7/g' Makefile.config
	sed -i 's/# PYTHON_INCLUDE := /usr/include/python3.5m/PYTHON_INCLUDE := /usr/include/python3.6m/g' Makefile.config
	sed -i 's/#                 /usr/lib/python3.5/dist-packages/                 /usr/lib/python3.5/site-packages/g' Makefile.config
	sed -i 's/INCLUDE_DIRS := $(PYTHON_INCLUDE) /usr/local/include/
else
	echo "";
	echo "Skipping Caffe installation";
	echo "";
fi
