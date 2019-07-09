#! /bin/bash

PROTOC_VERSION=3.7.1
ARCHITECTURE="x86_64"

echo ""
echo "************************ Please confirm *******************************"
echo " Installing Protobuf $PROTOC_VERSION from source may take a long time. "
echo " Select n to skip the installation or y to install it." 
read -p " Continue installing Protobuf (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then

    read -p " Select your OS's architecture [x86_64/aarch_64], default is x86_64 " ARCHITECTURE_INPUT
    if [[ "$ARCHITECTURE_INPUT" != "" ]]; then
        if [[ "$ARCHITECTURE_INPUT" == "x86_64" || "$ARCHITECTURE_INPUT" == "aarch_64" ]]; then
            $ARCHITECTURE = $ARCHITECTURE_INPUT
        else
            echo "Unsupported architecture!"
            exit 0
        fi
    fi

	echo "";
	echo " Downloading the protocol compiler ";
	echo "";
    sudo apt update && sudo apt install wget
    export OS="linux"
    export PLATFORM=$OS-$ARCHITECTURE
	export PROTOC_DOWNLOAD_URL=https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOC_VERSION/protoc-$PROTOC_VERSION-$PLATFORM.zip
	wget "$PROTOC_DOWNLOAD_URL" -O protoc-$PROTOC_VERSION.zip
	unzip protoc-$PROTOC_VERSION.zip \
		-d protoc-$PROTOC_VERSION
	
    sudo cp -r protoc-$PROTOC_VERSION /usr/local
    sudo cp -r protoc-$PROTOC_VERSION/include/* /usr/local/include/
	
	echo "";
	echo " Refreshing shared library cache ";
	echo "By default, the Protocol Compiler will be installed to /usr/local";
	echo "";
    echo "export PATH=/usr/local/protoc-$PROTOC_VERSION/bin"'${PATH:+:${PATH}}' >> ~/.bashrc
	source ~/.bashrc

	if [[ -f ~/.zshrc ]]; then
		echo 'export LD_LIBRARY_PATH=/usr/local/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.zshrc
	fi

	sudo ldconfig
	
	echo "";
	echo "The installation completed";
	echo "";
else
	echo "";
	echo "Skipping Protoc installation";
	echo "";
fi
