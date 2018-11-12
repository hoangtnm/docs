#! /bin/bash

echo ""
echo "***************** Please confirm ***********************"
echo " Installing Caffe from source may take a long time. "
echo " Select n to skip Caffe installation or y to install it." 
echo " Note that: OpenBLAS is required instead of ATLAS"
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
		libgflags-dev \
		libgoogle-glog-dev \
		protobuf-compiler
	
	echo "";
	echo "Downloading and Building the Source Code";
	echo "";
	git clone -b ssd https://github.com/weiliu89/caffe.git
	cd caffe
	cp Makefile.config.example Makefile.config
	
	echo "Please select which platform for the environment: Raspberry Pi 3 or PC with NVIDIA GPU";
	read -p " Raspberry or PC (rasp/pc) ? " CONTINUE
	if [[ "$CONTINUE" == "pc" || "$CONTINUE" == "PC" ]]; then
		sed -i 's/#\ USE_CUDNN\ :=\ 1/USE_CUDNN\ :=\ 1/g' Makefile.config
		sed -i 's/#\ OPENCV_VERSION\ :=\ 3/OPENCV_VERSION\ :=\ 3/g' Makefile.config
		sed -i 's/#\ CUSTOM_CXX\ :=\ g++/CUSTOM_CXX\ :=\ g++/g' Makefile.config
		sed -i 's/CUDA_ARCH\ :=\ -gencode\ arch=compute_20,code=sm_20\ \\//g' Makefile.config
		sed -i 's/-gencode\ arch=compute_20,code=sm_21\ \\//g' Makefile.config
		sed -i 's/\             -gencode arch=compute_30,code=sm_30/CUDA_ARCH\ :=\ -gencode arch=compute_30,code=sm_30/g' Makefile.config
		sed -i 's/#\ BLAS_INCLUDE\ :=\ \/path\/to\/your\/blas/BLAS_INCLUDE\ :=\ \/opt\/OpenBLAS\/include/g' Makefile.config
		sed -i 's/#\ BLAS_LIB\ :=\ \/path\/to\/your\/blas/BLAS_LIB\ :=\ \/opt\/OpenBLAS\/lib/g' Makefile.config
		sed -i 's/PYTHON_INCLUDE\ := \/usr\/include\/python2.7/#PYTHON_INCLUDE\ :=\ \/usr\/include\/python2.7/g' Makefile.config
		sed -i 's/#\ PYTHON_LIBRARIES\ :=\ boost_python3\ python3.5m/PYTHON_LIBRARIES\ :=\ boost_python3\ python3.6m/g' Makefile.config
		sed -i 's/#\ PYTHON_INCLUDE\ :=\ \/usr\/include\/python3.5m/PYTHON_INCLUDE\ :=\ \/usr\/local\/include\/python3.6m/g' Makefile.config
		sed -i 's/#\                 \/usr\/lib\/python3.5\/dist-packages/\                 \/usr\/local\/lib\/python3.6\/site-packages/g' Makefile.config
		sed -i 's/INCLUDE_DIRS\ :=\ $(PYTHON_INCLUDE)\ \/usr\/local\/include/INCLUDE_DIRS\ :=\ $(PYTHON_INCLUDE)\ \/usr\/local\/include\ \/usr\/include\/hdf5\/serial/g' Makefile.config
		sed -i 's/LIBRARY_DIRS\ :=\ $(PYTHON_LIB)\ \/usr\/local\/lib\ \/usr\/lib/LIBRARY_DIRS\ :=\ $(PYTHON_LIB)\ \/usr\/local\/lib\ \/usr\/lib\/x86_64-linux-gnu\/hdf5\/serial/g' Makefile.config
	elif [[ "$CONTINUE" == "rasp" || "$CONTINUE" == "RASP" ]]; then
		sudo apt install -y libatlas-base-dev \
		                 libopencv-dev \
				 python3-dev \
				 python-opencv \
				 sudo
		sed -i 's/#\ CPU_ONLY\ :=\ 1/CPU_ONLY\ :=\ 1/g' Makefile.config
		sed -i 's/#\ OPENCV_VERSION\ :=\ 3/OPENCV_VERSION\ :=\ 3/g' Makefile.config
		sed -i 's/#\ CUSTOM_CXX\ :=\ g++/CUSTOM_CXX\ :=\ g++/g' Makefile.config
		sed -i 's/BLAS\ :=\ open/BLAS\ :=\ atlas/g' Makefile.config
		sed -i 's/PYTHON_INCLUDE\ := \/usr\/include\/python2.7/#PYTHON_INCLUDE\ :=\ \/usr\/include\/python2.7/g' Makefile.config
		sed -i 's/#\ PYTHON_LIBRARIES\ :=\ boost_python3\ python3.5m/PYTHON_LIBRARIES\ :=\ boost_python3\ python3.5m/g' Makefile.config
		sed -i 's/#\ PYTHON_INCLUDE\ :=\ \/usr\/include\/python3.5m/PYTHON_INCLUDE\ :=\ \/usr\/include\/python3.5m/g' Makefile.config
		sed -i 's/#\                 \/usr\/lib\/python3.5\/dist-packages/\                 \/usr\/lib\/python3.5\/dist-packages/g' Makefile.config
		sed -i 's/INCLUDE_DIRS\ :=\ $(PYTHON_INCLUDE)\ \/usr\/local\/include/INCLUDE_DIRS\ :=\ $(PYTHON_INCLUDE)\ \/usr\/local\/include\ \/usr\/include\/hdf5\/serial/g' Makefile.config
		sed -i 's/LIBRARY_DIRS\ :=\ $(PYTHON_LIB)\ \/usr\/local\/lib\ \/usr\/lib/LIBRARY_DIRS\ :=\ $(PYTHON_LIB)\ \/usr\/local\/lib\ \/usr\/lib\/x86_64-linux-gnu\/hdf5\/serial/g' Makefile.config
	else
		echo "Skipping Caffe installation";
	fi
	echo "";
	echo "Building & Verifying";
	echo "";
	make all -j $(nproc)
	make test -j $(nproc) && make runtest -j $(nproc)
	make pycaffe -j $(nproc)
	
	echo "";
	echo "Finalizing the Installation";
	echo "";
	export PYTHONPATH=`pwd`/python:$PYTHONPATH
	# also add to bash_profile
	sudo bash -c 'echo "export PYTHONPATH=`pwd`/python:$PYTHONPATH" >> ~/.bash_profile'
	sudo bash -c 'echo "export PYTHONPATH=`pwd`/python:$PYTHONPATH" >> ~/.bashrc'
	source ~/.bash_profile
	source ~/.bashrc
else
	echo "";
	echo "Skipping Caffe installation";
	echo "";
fi
