#! /bin/bash

echo ""
echo "************************ Please confirm *******************************"
echo " Installing BLIS from source may take a long time. "
echo " Select n to skip BLIS installation or y to install it." 
read -p " Continue installing BLIS (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then  
	echo "";
	echo "Installing OpenCV"; 
	echo "";
	sudo apt update -y && sudo apt-get upgrade -y
	sudo apt install -y build-essential cmake git
	
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
	echo "";
	make install
else
	echo "";
	echo "Skipping BLIS installation";
	echo "";
fi
