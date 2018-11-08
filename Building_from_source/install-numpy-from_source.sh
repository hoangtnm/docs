#! /bin/bash

echo ""
echo "************************ Please confirm *******************************"
echo " Installing Numpy from source may take a long time. "
echo " Select n to skip Numpy installation or y to install it." 
read -p " Continue installing Numpy (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then  
	echo "";
	echo "Installing Numpy"; 
	echo "";
	sudo apt update -y && sudo apt-get upgrade -y
	sudo apt install -y build-essential cmake git gcc gfortran
	sudo pip3 install cython
	
	echo "";
	echo "Downloading and Building the Source Code";
	echo "";
	export NUMPY_VERSION=1.15.3
	export NUMPY_DOWNLOAD_URL=https://github.com/opencv/opencv/archive/v$NUMPY_VERSION.zip
	wget "$NUMPY_DOWNLOAD_URL" -O numpy.zip
	unzip numpy.zip
	cd numpy-$NUMPY_VERSION
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
	echo "Skipping Numpy installation";
	echo "";
fi
