#!/usr/bin/env bash

function config_opencv_with_cuda()
{
  cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D WITH_CUDA=ON \
        # -D WITH_CUDNN=ON \
        -D ENABLE_FAST_MATH=1 \
        -D CUDA_FAST_MATH=1 \
        -D WITH_CUBLAS=1 \
        -D WITH_V4L=ON \
        -D WITH_FFMPEG=ON \
        -D WITH_GSTREAMER=ON \
        -D BUILD_opencv_cnn_3dobj=OFF \
        -D BUILD_opencv_dnn_modern=OFF \
        -D OPENCV_EXTRA_MODULES_PATH=$CURRENT_DIR/opencv_contrib-$VERSION/modules \
        -D BUILD_DOCS=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D BUILD_TESTS=OFF \
        -D BUILD_EXAMPLES=OFF ..
}


function config_opencv_without_cuda()
{
  cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D INSTALL_PYTHON_EXAMPLES=OFF \
        -D WITH_V4L=ON \
        -D WITH_FFMPEG=ON \
        -D WITH_GSTREAMER=ON \
        -D BUILD_opencv_cnn_3dobj=OFF \
        -D BUILD_opencv_dnn_modern=OFF \
        -D OPENCV_EXTRA_MODULES_PATH=$CURRENT_DIR/opencv_contrib-$VERSION/modules \
        -D BUILD_DOCS=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D BUILD_TESTS=OFF \
        -D BUILD_EXAMPLES=OFF ..
}


echo
echo "************************ Please confirm *******************************"
echo " Installing OpenCV from source may take a long time. "
echo " Select n to skip the installation or y to install it."
echo " Note that if you installed opencv via pip3 it will be uninstalled"
read -p " Continue installing OpenCV (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
    echo
    echo Uninstalling pip installation
    sudo pip3 uninstall opencv-python opencv-contrib-python
    
    echo
    echo Installing dependencies
    echo
    sudo apt-get update && sudo apt-get install -y \
      build-essential cmake pkg-config \
      libjpeg-dev libtiff5-dev libpng12-dev \
      libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
      libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
      libxvidcore-dev libx264-dev \
      libgtk2.0-dev libgtk-3-dev \
      gfortran
    
    VERSION=3.4.9
    DOWNLOAD_URL=https://github.com/opencv/opencv/archive/$VERSION.zip
    CONTRIB_DOWNLOAD_URL=https://github.com/opencv/opencv_contrib/archive/$VERSION.zip
    CURRENT_DIR=$(pwd)

    wget $DOWNLOAD_URL -O opencv.zip
    wget $CONTRIB_DOWNLOAD_URL -O opencv_contrib.zip
    unzip opencv.zip && unzip opencv_contrib.zip
    cd opencv-$VERSION
    mkdir build && cd build
    
    if [[ -d /usr/local/cuda ]]; then
      config_opencv_with_cuda
    else
      config_opencv_without_cuda
    fi

    make -j $(nproc) && \
    sudo make install
    sudo ldconfig
else
    echo
    echo Skipping OpenCV installation
    echo
fi
