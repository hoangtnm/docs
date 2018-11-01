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
	git clone https://github.com/numpy/numpy.git
	cd numpy
	cp site.cfg.example site.cfg
	sed -i 's/# [blis]/[blis]/g' site.cfg
	sed -i 's/# libraries = blis/libraries = blis/g' site.cfg
	sed -i 's/# library_dirs = \/home\/username\/blis/library_dirs = $HOME\/blis\/lib/g' site.cfg
	sed -i 's/# include_dirs = \/home\/username\/blis\/include\/blis/include_dirs = $HOME\/blis\/include\/blis/g' site.cfg
	
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