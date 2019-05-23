#! /bin/bash

echo ""
echo "************************ Please confirm *******************************"
echo " Installing Scipy from source may take a long time. "
echo " Note : only install if cmake has been installed. "
echo " Select n to skip Scipy installation or y to install it." 
read -p " Continue installing Scipy (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then  
	echo "";
	echo "Installing Scipy"; 
	echo "";
	sudo apt update -y
	sudo apt install -y build-essential git gcc gfortran
	
	echo "";
	echo "Downloading and Building the Source Code";
	echo "";
	export SCIPY_VERSION=1.3.0
	export SCIPY_DOWNLOAD_URL=https://github.com/scipy/scipy/archive/v$SCIPY_VERSION.zip
	wget "$SCIPY_DOWNLOAD_URL" -O scipy.zip
	unzip scipy.zip
	cd scipy-$SCIPY_VERSION
	echo '[openblas]' >> site.cfg
	echo 'libraries = openblas' >> site.cfg
	bash -c 'echo "library_dirs = /opt/OpenBLAS/lib" >> site.cfg'
	bash -c 'echo "include_dirs = /opt/OpenBLAS/include" >> site.cfg'
	
	echo "";
	echo "Validating the Build";
	echo "";
	python setup.py config
	
	echo "";
	echo "Finalizing the installation";
	echo "";
	sudo python setup.py build --fcompiler=gnu95 -j $(nproc) install --prefix=/usr/local
else
	echo "";
	echo "Skipping Scipy installation";
	echo "";
fi
