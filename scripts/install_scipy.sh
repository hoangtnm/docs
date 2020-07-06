#!/usr/bin/env bash

set -e

VERSION='1.4.1'
DOWNLOAD_URL="https://github.com/scipy/scipy/archive/v${VERSION}.zip"

echo 'Installing dependencies'
sudo apt-get update && sudo apst-get install -y \
	build-essential cmake git gcc gfortran

echo 'Downloading Scipy source code'
wget -O scipy.zip "${DOWNLOAD_URL}"
unzip scipy.zip && cd "scipy-${VERSION}"

echo 'Validating the build'
echo '[openblas]' >> site.cfg
echo 'libraries = openblas' >> site.cfg
echo 'library_dirs = /opt/OpenBLAS/lib' >> site.cfg
echo 'include_dirs = /opt/OpenBLAS/include' >> site.cfg
python setup.py config

echo 'Installing Scipy'
python setup.py build --fcompiler=gnu95 -j $(nproc) install --prefix=/usr/local
