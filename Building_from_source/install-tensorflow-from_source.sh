#! /bin/bash

echo ""
echo "**************************** Please confirm **********************************"
echo " Installing TensorFlow from source may take a long time."
echo " Select n to skip TensorFlow installation or y to install it." 
echo " Note that: if you installed tensorflow via pip3 it will be uninstalled"
echo "            an CUDA-Enabled GPU card is required"
echo "            CUDA Toolkit's version must be 10.0"
read -p " Continue installing TensorFlow (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	echo ""; 
	echo "Uninstalling pip installation";
	echo "";
	sudo pip3 uninstall tensorflow tensorflow-gpu
	
	echo "";
	echo "Installing TensorFlow"; 
	echo "";
	sudo apt update -y
	sudo apt install -y build-essential git
	
	echo "";
	echo "Install the TensorFlow pip package dependencies";
	echo "";
	sudo pip install pip six numpy wheel setuptools mock
	sudo pip install --no-deps keras_applications==1.0.6 keras_preprocessing==1.0.5
	
	echo "";
	echo "Downloading the Source Code";
	echo "";
	export TENSORFLOW_VERSION=1.13
	git clone https://github.com/tensorflow/tensorflow.git
	cd tensorflow
	git checkout r$TENSORFLOW_VERSION
	
	echo "";
	echo "Configuring the build";
	echo "";
	./configure
	
	echo "";
	echo "Making the TensorFlow package builder with GPU support";
	echo "";
	bazel build -c opt --copt=-march=native --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" --config=cuda //tensorflow/tools/pip_package:build_pip_package
	
	echo "";
	echo "Building the package";
	echo "";
	./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
	
	echo "";
	echo "Installing the package";
	echo "";
	sudo pip3 install --upgrade /tmp/tensorflow_pkg/tensorflow-1.13.1-cp36-cp36m-linux_x86_64.whl
else
	echo "";
	echo "Skipping TensorFlow installation";
	echo "";
fi
