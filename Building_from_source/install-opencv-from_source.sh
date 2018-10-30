#! /bin/bash

echo ""
echo "************************ Please confirm *******************************"
echo " Installing OpenCV from source may take a long time. "
echo " Select n to skip OpenCV installation or y to install it." 
echo " Note that if you installed opencv via pip3 it will be uninstalled"
read -p " Continue installing OpenCV (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	echo ""; 
	echo "Uninstalling pip installation";
	sudo pip3 uninstall opencv-contrib-python
	sudo pip3 uninstall opencv-python  
	echo "";
	echo "Installing OpenCV"; 
	echo "";
	sudo apt update -y && sudo apt-get upgrade -y
	sudo apt install -y build-essential cmake pkg-config
	sudo apt install -y libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
	sudo apt install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
	sudo apt install -y libxvidcore-dev libx264-dev
	sudo apt install -y libgtk2.0-dev libgtk-3-dev
	sudo apt install -y libatlas-base-dev gfortran
	
	export OPENCV_VERSION=3.4.3
	export OPENCV_DOWNLOAD_URL=https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip
	export OPENCV_CONTRIB_DOWNLOAD_URL=https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip
  
	export CURRENT_DIR=`pwd`
	wget "$OPENCV_DOWNLOAD_URL" -O opencv.zip
	wget "$OPENCV_CONTRIB_DOWNLOAD_URL" -O opencv_contrib.zip
	unzip opencv.zip
	unzip opencv_contrib.zip
	cd opencv-$OPENCV_VERSION/
	mkdir build
	cd build
	cmake -D CMAKE_BUILD_TYPE=RELEASE \
	      -D CMAKE_INSTALL_PREFIX=/usr/local \
	      -D INSTALL_PYTHON_EXAMPLES=OFF \
	      -D WITH_V4L=ON \
	      -D OPENCV_EXTRA_MODULES_PATH=$CURRENT_DIR/opencv_contrib-$OPENCV_VERSION/modules \
	      -D BUILD_DOCS=OFF \
	      -D BUILD_PERF_TESTS=OFF \
	      -D BUILD_TESTS=OFF \
	      -D BUILD_EXAMPLES=OFF ..
	make -j $(nproc)
	sudo make install
	sudo ldconfig
else
	echo "";
	echo "Skipping OpenCV installation";
	echo "";
fi
