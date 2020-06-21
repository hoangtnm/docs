#!/usr/bin/env bash

echo
echo Installing Intel MKL from 'source' may take a long 'time'
echo Select n to skip the installation or y to install it
read -p " Continue installing Intel MKL (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	echo
	echo Installing Intel MKL 2020 Update 1
	echo
	sudo apt-get update && sudo apt-get install -y \
		build-essential cpio gcc g++ cmake doxygen

	echo
	echo Downloading Intel MKL 'source' code
	echo
	DOWNLOAD_URL=http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/16533/l_mkl_2020.1.217.tgz
	wget $DOWNLOAD_URL -O intel-mkl.zip && unzip intel-mkl.zip
	cd l_mkl_2020.1.217 && ./install.sh
else
	echo
	echo Skipping the installation
	echo
fi
