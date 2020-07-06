#!/usr/bin/env bash

set -e

apt-get update && apt-get install -y \
	build-essential cmake cython git gcc g++ gfortran libblas-dev liblapack-dev

echo 'Downloading Numpy source code'
git clone --depth 1 https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS
#make DYNAMIC_ARCH=1 FC=gfortran -j $(nproc)
#sudo make DYNAMIC_ARCH=1 install
make FC=gfortran -j $(nproc)
make install

echo Finalizing the Installation
echo 'export LD_LIBRARY_PATH=/opt/OpenBLAS/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.bashrc

if [[ -f ~/.zshrc ]]; then
	echo 'export LD_LIBRARY_PATH=/opt/OpenBLAS/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}' >> ~/.zshrc
fi

update-alternatives \
	--install /usr/lib/libblas.so.3 libblas.so.3 /opt/OpenBLAS/lib/libopenblas.so.0 41 \
	--slave /usr/lib/liblapack.so.3 liblapack.so.3 /opt/OpenBLAS/lib/libopenblas.so.0

echo '/opt/OpenBLAS/lib' > /etc/ld.so.conf.d/openblas.conf
ldconfig
