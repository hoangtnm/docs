#! /bin/bash

echo ""
echo "******************** Please confirm ***********************"
echo " Installing OpenBLAS from source may take a long time. "
echo " Select n to skip OpenBLAS installation or y to install it." 
read -p " Continue installing OpenBLAS (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	sudo apt update -y
	sudo apt install -y build-essential cmake cython git gcc g++ gfortran
	
	echo "";
	echo "Downloading and Building the Source Code";
	echo "";
	git clone https://github.com/xianyi/OpenBLAS.git
	cd OpenBLAS
	#make DYNAMIC_ARCH=1 FC=gfortran -j $(nproc)
	#sudo make DYNAMIC_ARCH=1 install
	make FC=gfortran -j $(nproc)
	sudo make install
	
	echo "";
	echo "Finalizing the Installation";
	echo "";
	rm -rf OpenBLAS
	echo 'export LD_LIBRARY_PATH=/opt/OpenBLAS/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc
	sudo sh -c "echo '/opt/OpenBLAS/lib' > /etc/ld.so.conf.d/openblas.conf"
	source ~/.bashrc
	sudo ldconfig
else
	echo "";
	echo "Skipping OpenBLAS installation";
	echo "";
fi
