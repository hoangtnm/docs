#!/usr/bin/env bash

set -e

VERSION='1.18.1'
DOWNLOAD_URL="https://github.com/numpy/numpy/archive/v${VERSION}.zip"

echo "Installing Numpy ${VERSION}"
apt-get update && apt-get install -y \
	build-essential cmake git gcc gfortran
pip3 install cython
pip3 uninstall enum34

echo 'Downloading Numpy source code'
wget -O numpy.zip "${DOWNLOAD_URL}"
unzip numpy.zip && cd "numpy-${VERSION}"
echo '[openblas]' >> site.cfg
echo 'libraries = openblas' >> site.cfg
echo 'library_dirs = /opt/OpenBLAS/lib' >> site.cfg
echo 'include_dirs = /opt/OpenBLAS/include' >> site.cfg

echo 'Validating the build'
python setup.py config

echo 'Installing Numpy'
python setup.py build --fcompiler=gnu95 -j $(nproc) install --prefix=/usr/local
