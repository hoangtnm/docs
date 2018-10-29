#! /bin/bash

echo ""
echo "************************************************ Please confirm *******************************************************"
echo " Installing Intel(R) Math Kernel Library for Deep Neural Networks (Intel(R) MKL-DNN) from source may take a long time. "
echo " Select n to skip Intel MKL-DNN installation or y to install it." 
read -p " Continue installing Intel MKL-DNN (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	echo "";
	echo "Installing Intel MKL-DNN"; 
	echo "";
	sudo apt update -y && sudo apt-get upgrade -y
	sudo apt install -y build-essential unzip gcc g++ cmake doxygen
	echo "";
	echo "Downloading and Building the Source Code";
	echo "";
	export INTEL_MKL_VERSION=0.16
	export INTEL_MKL_DOWNLOAD_URL=https://github.com/intel/mkl-dnn/archive/v$INTEL_MKL_VERSION.zip
	wget "$INTEL_MKL_DOWNLOAD_URL" -O mkl-dnn.zip
	unzip mkl-dnn.zip
	cd mkl-dnn-$INTEL_MKL_VERSION
	cd scripts && ./prepare_mkl.sh && cd ..
	mkdir -p build && cd build && cmake .. && make -j $(nproc)
	echo "";
	echo "Validating the Build";
	echo "";
	make test -j $(nproc)
	echo "";
	echo "Finalizing the Installation"
	sudo make install -j $(nproc)
	echo "The libraries and other components that are required to develop Intel MKL-DNN enabled applications under the /usr/local directory"
	echo "Shared libraries (/usr/local/lib): libiomp5.so, libmkldnn.so, libmklml_intel.so"
	echo "Header files (/usr/local/include): mkldnn.h, mkldnn.hpp, mkldnn_types.h"
else
	echo "";
	echo "Skipping Intel MKL-DNN installation";
	echo "";
fi
