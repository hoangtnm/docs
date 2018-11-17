#! /bin/bash

echo ""
echo "************************ Please confirm *******************************"
echo " Installing Protobuf from source may take a long time. "
echo " Select n to skip Protobuf installation or y to install it." 
read -p " Continue installing Protobuf (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	echo "";
	echo "Installing Protobuf"; 
	echo "";
	sudo apt update -y
	sudo apt install -y build-essential autoconf automake libtool curl make g++ unzip
	
	export PROTOBUF_VERSION=3.6.1
	export PROTOBUF_DOWNLOAD_URL=https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protobuf-all-$PROTOBUF_VERSION.zip
	
	echo "";
	echo "Downloading and Building the Source Code";
	echo "";
	wget "$PROTOBUF_DOWNLOAD_URL" -O protobuf.zip
	unzip protobuf.zip
	cd protobuf-$PROTOBUF_VERSION
	./configure
	make -j $(nproc)
	make check -j $(nproc)
	sudo make install
	
	echo "";
	echo "Finalizing the Installation";
	echo "By default, the package will be installed to /usr/local";
	echo "";
	echo 'export LD_LIBRARY_PATH=/usr/local/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
	source ~/.bashrc
	sudo ldconfig
	echo "";
else
	echo "";
	echo "Skipping Protobuf installation";
	echo "";
fi
