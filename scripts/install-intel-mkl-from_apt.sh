#!/usr/bin/env bash

echo
echo Installing Intel MKL Using APT Repository
echo

echo
echo Installing the GPG key
echo
sudo apt-key adv --fetch-keys https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB

echo
echo Adding the APT Repository
echo
# sudo sh -c 'echo deb https://apt.repos.intel.com/mkl all main > /etc/apt/sources.list.d/intel-mkl.list'
sudo wget https://apt.repos.intel.com/setup/intelproducts.list -O /etc/apt/sources.list.d/intelproducts.list


VERSION=2020
UPDATE=0
BUILD_NUMBER=088
sudo apt-get update && sudo apt-get install -y \
    intel-mkl-64bit-$VERSION.$UPDATE-$BUILD_NUMBER

update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so libblas.so-x86_64-linux-gnu /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so.3 libblas.so.3-x86_64-linux-gnu /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so liblapack.so-x86_64-linux-gnu /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so.3 liblapack.so.3-x86_64-linux-gnu /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
cat <<EOF > /etc/ld.so.conf.d/mkl.conf
/opt/intel/lib/intel64
/opt/intel/mkl/lib/intel64
EOF

sudo ldconfig
