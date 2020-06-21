#!/usr/bin/env bash

echo
echo "******************* Please confirm *******************"
echo " Installing Numpy from source may take a long time. "
echo " Select n to skip the installation or y to install it." 
read -p " Continue installing Numpy (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then  
	echo
	echo Installing Numpy
	echo
	sudo apt-get update && sudo apt-get install -y \
		build-essential cmake git gcc gfortran
	sudo pip3 install cython
	sudo pip3 uninstall enum34
	
	echo
	echo Downloading and Building the Source Code
	echo
	VERSION=1.18.1
	DOWNLOAD_URL=https://github.com/numpy/numpy/archive/v$VERSION.zip
	wget $DOWNLOAD_URL -O numpy.zip
	unzip numpy.zip && cd numpy-$VERSION
	echo '[openblas]' >> site.cfg
	echo 'libraries = openblas' >> site.cfg
	echo 'library_dirs = /opt/OpenBLAS/lib' >> site.cfg
	echo 'include_dirs = /opt/OpenBLAS/include' >> site.cfg
	
	echo
	echo Validating the build
	echo
	python setup.py config
	
	echo
	echo Finalizing the installation
	echo
	sudo python setup.py build --fcompiler=gnu95 -j $(nproc) install --prefix=/usr/local
else
	echo
	echo Skipping the installation
	echo
fi
