#!/usr/bin/env bash

echo
echo "********************* Please confirm **********************"
echo " Installing OpenBLAS from source may take a long time. "
echo " Select n to skip the installation or y to install it." 
read -p " Continue installing OpenBLAS (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	sudo apt-get update && sudo apt-get install -y \
		build-essential cmake cython git gcc g++ gfortran libblas-dev liblapack-dev
	
	echo
	echo Downloading Numpy 'source' code
	echo
	git clone https://github.com/xianyi/OpenBLAS.git && cd OpenBLAS
	#make DYNAMIC_ARCH=1 FC=gfortran -j $(nproc)
	#sudo make DYNAMIC_ARCH=1 install
	make FC=gfortran -j $(nproc)
	sudo make install
	
	echo
	echo Finalizing the Installation
	echo
	echo 'export LD_LIBRARY_PATH=/opt/OpenBLAS/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc

	if [[ -f ~/.zshrc ]]; then
		echo 'export LD_LIBRARY_PATH=/opt/OpenBLAS/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.zshrc
	fi

	sudo echo '/opt/OpenBLAS/lib' > /etc/ld.so.conf.d/openblas.conf
	sudo update-alternatives \
		--install /usr/lib/libblas.so.3 libblas.so.3 /opt/OpenBLAS/lib/libopenblas.so.0 41 \
		--slave /usr/lib/liblapack.so.3 liblapack.so.3 /opt/OpenBLAS/lib/libopenblas.so.0
	sudo ldconfig
else
	echo
	echo Skipping the installation
	echo
fi
