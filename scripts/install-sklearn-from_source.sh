#!/usr/bin/env bash

echo
echo "************************ Please confirm *******************************"
echo " Installing Scikit-learn from source may take a long time. "
echo " Select n to skip Scikit-learn installation or y to install it." 
read -p " Continue installing Scikit-learn (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	echo
	echo Installing Scikit-learn
	echo
	sudo pip3 install pytest setuptools
	
	VERSION=0.21.1
	DOWNLOAD_URL=https://github.com/scikit-learn/scikit-learn/archive/$VERSION.zip
	wget $DOWNLOAD_URL -O sklearn.zip
	unzip sklearn.zip && cd scikit-learn-$VERSION
	sudo pip3 install --editable .
else
	echo
	echo Skipping the installation
	echo
fi
