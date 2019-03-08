#! /bin/bash

echo ""
echo "**************** Please confirm ***********************"
echo " Installing BLIS from source may take a long time. "
echo " Select n to skip BLIS installation or y to install it." 
read -p " Continue installing BLIS (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then  
	echo "\nInstalling BLIS\n"; 
	sudo apt update -y
	sudo apt install -y build-essential cmake make git
	
	echo "\nDownloading and Building the Source Code\n";
	git clone https://github.com/flame/blis.git
	cd blis
	./configure --enable-cblas --enable-threading=openmp auto
	make -j $(nproc)
	
	echo "\nValidating the Build\n";
	make check -j $(nproc)
	
	echo "\nFinalizing the installation\n";
	echo "The default installation location is $HOME/blis";
	echo "  libraries will be installed at $(HOME)/blis/lib";
	echo "  development headers will be installed at $(HOME)/blis/include/blis\n";
	make install
	bash -c 'echo "export LD_LIBRARY_PATH=$HOME/blis/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc'
else
	echo "\nSkipping BLIS installation\n";
fi
