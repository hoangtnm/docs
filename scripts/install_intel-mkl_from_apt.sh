#!/usr/bin/env bash

set -e

VERSION=2020
UPDATE=0
BUILD_NUMBER=088

echo Installing Intel MKL Using APT Repository

# Installing the GPG key
apt-key adv --fetch-keys https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS-2019.PUB

# Adding the APT Repository
# echo 'deb https://apt.repos.intel.com/mkl all main' > /etc/apt/sources.list.d/intel-mkl.list
wget -O /etc/apt/sources.list.d/intelproducts.list https://apt.repos.intel.com/setup/intelproducts.list


apt-get update && apt-get install -y \
    "intel-mkl-64bit-${VERSION}.${UPDATE}-${BUILD_NUMBER}"

update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so libblas.so-x86_64-linux-gnu /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
update-alternatives --install /usr/lib/x86_64-linux-gnu/libblas.so.3 libblas.so.3-x86_64-linux-gnu /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so liblapack.so-x86_64-linux-gnu /opt/intel/mkl/lib/intel64/libmkl_rt.so 50
update-alternatives --install /usr/lib/x86_64-linux-gnu/liblapack.so.3 liblapack.so.3-x86_64-linux-gnu /opt/intel/mkl/lib/intel64/libmkl_rt.so 50

cat <<EOF > /etc/ld.so.conf.d/mkl.conf
/opt/intel/lib/intel64
/opt/intel/mkl/lib/intel64
EOF

ldconfig
