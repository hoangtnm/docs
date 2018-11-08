#! /bin/bash

echo ""
echo "**************** Please confirm ***********************"
echo " Installing BLIS from source may take a long time. "
echo " Select n to skip BLIS installation or y to install it." 
read -p " Continue installing BLIS (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then  
	echo "";
	echo "Installing BLIS"; 
	echo "";
	sudo apt update -y && sudo apt-get upgrade -y
	sudo apt install -y build-essential cmake make git
	
	echo "";
	echo "Downloading and Building the Source Code";
	echo "";
	git clone https://github.com/flame/blis.git
	cd blis
	./configure --enable-cblas --enable-threading=openmp auto
	make -j $(nproc)
	
	echo "";
	echo "Validating the Build";
	echo "";
	make check -j $(nproc)
	
	echo "";
	echo "Finalizing the installation";
	echo "The default installation location is $HOME/blis";
	echo "  libraries will be installed at $(HOME)/blis/lib";
	echo "  development headers will be installed at $(HOME)/blis/include/blis";
	echo "";
	make install
	bash -c 'echo "export LD_LIBRARY_PATH=$HOME/blis/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc'
else
	echo "";
	echo "Skipping BLIS installation";
	echo "";
fi
