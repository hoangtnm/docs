#!/usr/bin/env bash

echo ""
echo "************************ Please confirm *******************************"
echo " Installing Scikit-learn from source may take a long time. "
echo " Select n to skip Scikit-learn installation or y to install it." 
read -p " Continue installing Scikit-learn (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	echo "";
	echo "Installing Scikit-learn"; 
	echo "";
	sudo apt-get update
	sudo pip3 install pytest setuptools
	
	export SKLEARN_VERSION=0.21.1
	export SKLEARN_DOWNLOAD_URL=https://github.com/scikit-learn/scikit-learn/archive/$SKLEARN_VERSION.zip
	wget "$SKLEARN_DOWNLOAD_URL" -O sklearn.zip
	unzip sklearn.zip
	cd scikit-learn-$SKLEARN_VERSION/
	sudo pip3 install --editable .
else
	echo "";
	echo "Skipping Scikit-learn installation";
	echo "";
fi
