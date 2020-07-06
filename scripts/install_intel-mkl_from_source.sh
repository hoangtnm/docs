#!/usr/bin/env bash

set -e

DOWNLOAD_URL='http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/16533/l_mkl_2020.1.217.tgz'

echo Installing Intel MKL 2020 Update 1
apt-get update && apt-get install -y \
	build-essential cpio gcc g++ cmake doxygen

echo 'Downloading Intel MKL source code'
wget -O intel-mkl.zip "${DOWNLOAD_URL}"
unzip intel-mkl.zip
cd l_mkl_2020.1.217
./install.sh
