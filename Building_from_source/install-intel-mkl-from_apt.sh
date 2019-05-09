#! /bin/bash

echo ""
echo "************************************************ Please confirm *******************************************************"
echo " Installing Intel(R) Math Kernel Library (Intel(R) MKL) Using APT Repository. "
echo " Select n to skip Intel MKL installation or y to install it." 
read -p " Continue installing Intel MKL (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	echo "";
	echo "Installing Intel MKL 2019";
	echo "";
  echo "\nInstalling the GPG key for the repository\n";
  wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
  apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB
  
  echo "\nAdding the APT Repository\n";
  sudo sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list'
  sudo apt update
  sudo apt intel-mkl-2019.3-062
  update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so     libblas.so-x86_64-linux-gnu      /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
  update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so.3   libblas.so.3-x86_64-linux-gnu    /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
  update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so   liblapack.so-x86_64-linux-gnu    /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
  update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so.3 liblapack.so.3-x86_64-linux-gnu /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
  echo "/opt/intel/lib/intel64"     >  /etc/ld.so.conf.d/mkl.conf
  echo "/opt/intel/mkl/lib/intel64" >> /etc/ld.so.conf.d/mkl.conf
  sudo ldconfig
  echo "The libraries and other components that are required to develop Intel MKL-DNN enabled applications under the /usr/local directory";
  echo "Shared libraries (/usr/local/lib): libiomp5.so, libmkldnn.so, libmklml_intel.so";
  echo "Header files (/usr/local/include): mkldnn.h, mkldnn.hpp, mkldnn_types.h";
else
	echo "";
	echo "Skipping Intel MKL installation";
	echo "";
fi
