#! /bin/bash

echo ""
echo "************************ Please confirm *******************************"
echo " Installing TensorFlow from source may take a long time. "
echo " Select n to skip TensorFlow installation or y to install it." 
echo " Note that: if you installed tensorflow via pip3 it will be uninstalled"
echo "            the computer must be equipped with an NVIDIA GPU"
read -p " Continue installing TensorFlow (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	echo ""; 
	echo "Uninstalling pip installation";
	sudo pip3 uninstall tensorflow tensorflow-gpu
	echo "";
	echo "Installing TensorFlow"; 
	echo "";
	sudo apt update -y && sudo apt-get upgrade -y
	sudo apt install -y build-essential git
	
	echo "";
	echo "Downloading the Source Code";
	echo "";
	export TENSORFLOW_VERSION=1.12
	git clone https://github.com/tensorflow/tensorflow.git
	cd tensorflow
	git checkout r$TENSORFLOW_VERSION
	
	echo "";
	echo "Configuring the build";
	echo "";
	./configure << EOF
	/usr/local/bin/python3
	/usr/local/lib/python3.6/site-packages
	\n
	\n
	\n
	\n
	y
	10.0
	\n
	\n
	\n
	\n
	1.3
	\n
	\n
	\n
	\n
	-march=native
	\n
	EOF
	
	echo "";
	echo "Making the TensorFlow package builder with GPU support";
	echo "";
	bazel build -c opt --copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-mfpmath=both --copt=-msse4.2 --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" --config=cuda //tensorflow/tools/pip_package:build_pip_package
	
	echo "";
	echo "Building the package";
	echo "";
	./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
	
	echo "";
	echo "Installing the package";
	echo "";
	sudo pip3 install --upgrade /tmp/tensorflow_pkg/tensorflow-version-tags.whl
else
	echo "";
	echo "Skipping TensorFlow installation";
	echo "";
fi
