#! /bin/bash

echo ""
echo "************************************************ Please confirm *******************************************************"
echo " Installing Intel(R) Math Kernel Library (Intel(R) MKL) from source may take a long time. "
echo " Select n to skip Intel MKL installation or y to install it." 
read -p " Continue installing Intel MKL (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	echo "";
	echo "Installing Intel MKL 2019"; 
	echo "";
	sudo apt update -y && sudo apt-get upgrade -y
	sudo apt install -y build-essential cpio gcc g++ cmake doxygen
	echo "";
	echo "Downloading and Building the Source Code";
	echo "";
	export INTEL_MKL_DOWNLOAD_URL=http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/13575/l_mkl_2019.0.117.tgz
	wget "$INTEL_MKL_DOWNLOAD_URL" -O intel-mkl.zip
	unzip intel-mkl.zip
	cd l_mkl_2019.0.117
	./install.sh
	echo "The libraries and other components that are required to develop Intel MKL-DNN enabled applications under the /usr/local directory"
	echo "Shared libraries (/usr/local/lib): libiomp5.so, libmkldnn.so, libmklml_intel.so"
	echo "Header files (/usr/local/include): mkldnn.h, mkldnn.hpp, mkldnn_types.h"
else
	echo "";
	echo "Skipping Intel MKL installation";
	echo "";
fi
