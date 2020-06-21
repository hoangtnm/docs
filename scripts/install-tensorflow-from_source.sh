#!/usr/bin/env bash

echo
echo "*************************** Please confirm ****************************"
echo " Installing TensorFlow from source may take a long time."
echo " Select n to skip TensorFlow installation or y to install it." 
echo " Note that: if you installed tensorflow via pip3 it will be uninstalled"
echo "            an CUDA-Enabled GPU card is required"
echo "            CUDA Toolkit's version must be 10.1"
read -p " Continue installing TensorFlow (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	echo
	echo Uninstalling pip installation
	echo
	sudo pip3 uninstall tensorflow tensorflow-gpu
	
	echo
	echo Installing dependencies
	echo
	sudo apt-get update && sudo apt-get install -y build-essential git
	sudo pip install pip six numpy wheel setuptools mock
	sudo pip install -U keras_applications keras_preprocessing
	
	echo
	echo Downloading TensorFlow 'source' code
	echo
	VERSION=2.2
	git clone -b r$VERSION https://github.com/tensorflow/tensorflow.git
	cd tensorflow
	
	echo
	echo Configuring the build
	echo
	./configure
	
	echo
	echo Making the TensorFlow package builder with GPU support
	echo
	bazel build -c opt --copt=-march=native --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" --config=cuda //tensorflow/tools/pip_package:build_pip_package
	
	echo
	echo Building the package
	echo
	./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg

	echo
	echo The built package is located at /tmp/tensorflow_pkg
	echo 'Please run sudo `pip3 install -U /tmp/tensorflow_pkg/*.whl` to install the package'
	
	# echo
	# echo Installing the package
	# echo
	# sudo pip3 install -U /tmp/tensorflow_pkg/tensorflow-1.13.1-cp36-cp36m-linux_x86_64.whl
else
	echo
	echo Skipping TensorFlow installation
	echo
fi
