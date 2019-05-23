#! /bin/bash

echo ""
echo "******************** Please confirm ***************************"
echo " Installing Python 3.6 may take a long time. "
echo " Select n to skip Python 3.6 installation or y to install it." 
read -p " Continue installing Python 3.6.8 (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	echo "";
	echo "Installing Python 3.6.8";
	echo "";
	echo "Downloading and Building the the Source Code";
	echo "";
	export PYTHON_VERSION=3.6.8
	export PYTHON_DOWNLOAD_URL=https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz
	sudo apt update && sudo apt install --no-install-recommends -y \
		software-properties-common build-essential curl \
		dpkg-dev libssl-dev libreadline-dev libbz2-dev libsqlite3-dev zlib1g-dev python-tk python3-tk tk-dev \
		python-minimal
	wget "$PYTHON_DOWNLOAD_URL" -O python.tar.tgz
	tar -zxvf python.tar.tgz
	cd Python-$PYTHON_VERSION
	./configure --enable-shared --enable-ipv6 --enable-optimizations --enable-loadable-sqlite-extensions 
	make -j $(nproc)
	echo "";
	echo "Finalizing the Installation"
	echo "";
	sudo make install -j $(nproc)
	
	echo "";
	echo "Updating pip3 to the latest version";
	echo "";
	sudo rm /usr/bin/python && sudo ln -s /usr/local/bin/python3 /usr/bin/python
	echo 'export LD_LIBRARY_PATH=/usr/local/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
	source ~/.bashrc
	sudo ldconfig
	curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	sudo python3 get-pip.py
else
	echo "";
	echo "Skipping Python 3.6.5 installation";
	echo "";
fi
