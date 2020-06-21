#!/usr/bin/env bash

echo
echo "******************** Please confirm ***************************"
echo " Installing Python $VERSION may take a long time."
echo " Select n to skip the installation or y to install it." 
read -p " Continue installing Python $VERSION (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then

	VERSION=${1:-3.7.7}
	DOWNLOAD_URL=https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz

	echo
	echo Downloading Python $VERSION 'source' code
	echo
	sudo apt-get update && sudo apt-get install -y \
		software-properties-common build-essential curl wget \
		libexpat1-dev libssl-dev zlib1g-dev \
		libncurses5-dev libbz2-dev liblzma-dev \
		dpkg-dev libreadline-dev libsqlite3-dev \
		libffi-dev tcl-dev libgdbm-dev bluez libbluetooth-dev libglib2.0-dev \
		python3 python3-dev libboost-python-dev libboost-thread-dev \
		python3-tk tk tk-dev
	wget $DOWNLOAD_URL -O python.tar.tgz
	
	echo
	echo Building Python
	echo
	tar -zxf python.tar.tgz && cd Python-$VERSION
	./configure \
		--enable-shared \
		--enable-optimizations \
		--enable-loadable-sqlite-extensions \
		--enable-ipv6 \
		--with-assertions \
		--with-lto \
		--with-threads
	make -j $(nproc)
	sudo make altinstall -j $(nproc)
	# sudo make install -j $(nproc)
	
 	sudo update-alternatives --install /usr/local/bin/python python /usr/local/bin/python3.7 30
 	sudo update-alternatives --install /usr/local/bin/python3 python3 /usr/local/bin/python3.7 30
	sudo ldconfig

	echo
	echo Installing the latest version of pip3
	echo
	sudo python3 -m pip install -U pip
	# curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	# sudo python3 get-pip.py
else
	echo
	echo Skipping the installation
	echo
fi
