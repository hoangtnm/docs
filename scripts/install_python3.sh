#!/usr/bin/env bash
#
# Build Python 3 from source and install it.
#
# Usage: install_python3 [version]

set -e

VERSION=${1:-3.7.8}
DOWNLOAD_URL="https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz"

echo "Downloading Python ${VERSION} source code"
apt-get update && apt-get install -y \
	software-properties-common build-essential curl wget \
	libexpat1-dev libssl-dev zlib1g-dev \
	libncurses5-dev libbz2-dev liblzma-dev \
	dpkg-dev libreadline-dev libsqlite3-dev \
	libffi-dev tcl-dev libgdbm-dev bluez libbluetooth-dev libglib2.0-dev \
	python3-dev python3-tk libboost-python-dev libboost-thread-dev tk-dev
wget -O python.tar.tgz "${DOWNLOAD_URL}"

echo "Building Python ${VERSION}"
tar -zxf python.tar.tgz
cd "Python-${VERSION}"
./configure \
	--enable-shared \
	--enable-optimizations \
	--enable-loadable-sqlite-extensions \
	--enable-ipv6 \
	--with-assertions \
	--with-lto \
	--with-threads
make -j $(nproc)
make altinstall
# make install

update-alternatives --install /usr/local/bin/python python /usr/local/bin/python3.7 30
update-alternatives --install /usr/local/bin/python3 python3 /usr/local/bin/python3.7 30
ldconfig

echo 'Installing the latest version of pip3'
python3 -m pip install -U pip
