#! /bin/bash

echo ""
echo "************************ Please confirm *******************************"
echo " Installing Scipy from source may take a long time. "
echo " Select n to skip Scipy installation or y to install it." 
read -p " Continue installing Scipy (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then  
	echo "";
	echo "Installing Scipy"; 
	echo "";
	sudo apt update -y && sudo apt-get upgrade -y
	sudo apt install -y build-essential cmake git gcc gfortran
	
	echo "";
	echo "Downloading and Building the Source Code";
	echo "";
	export SCIPY_VERSION=1.1.0
	export SCIPY_DOWNLOAD_URL=https://github.com/scipy/scipy/archive/v$SCIPY_VERSION.zip
	wget "$SCIPY_DOWNLOAD_URL" -O scipy.zip
	unzip scipy.zip
	cd scipy-$SCIPY_VERSION
	echo '[blis]' >> site.cfg
	echo 'libraries = blis' >> site.cfg
	bash -c 'echo "library_dirs = $HOME/blis/lib" >> site.cfg'
	bash -c 'echo "include_dirs = $HOME/blis/include/blis" >> site.cfg'
	
	echo "";
	echo "Validating the Build";
	echo "";
	python setup.py config
	
	echo "";
	echo "Finalizing the installation";
	echo "";
	python setup.py build --fcompiler=gnu95 -j $(nproc) install --prefix=/usr/local
else
	echo "";
	echo "Skipping Scipy installation";
	echo "";
fi
