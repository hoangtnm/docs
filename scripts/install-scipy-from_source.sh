#!/usr/bin/env bash

echo
echo "************************ Please confirm *******************************"
echo " Installing Scipy from source may take a long time. "
echo " Select n to skip the installation or y to install it." 
read -p " Continue installing Scipy (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then  
	echo
	echo Installing dependencies
	echo
	sudo apt-get update && sudo apst-get install -y \
		build-essential cmake git gcc gfortran
	
	echo
	echo Downloading Scipy 'source' code
	echo
	VERSION=1.4.1
	DOWNLOAD_URL=https://github.com/scipy/scipy/archive/v$VERSION.zip
	wget $DOWNLOAD_URL -O scipy.zip
	unzip scipy.zip && cd scipy-$VERSION
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
	echo Skipping Scipy installation
	echo
fi
