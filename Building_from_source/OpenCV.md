# Build OpenCV from source


### Prerequisites

- Ubuntu 18.04 LTS or Raspbian

- Python 2 or Python 3.6.5 (must be installed exactly as same as [this guideline](https://github.com/hoangtnm/TrainingServer-docs/blob/master/Setup_python_3_dev_environment.md))


### Install OpenCV dependencies

```
#! /bin/bash
sudo apt update
sudo apt install -y \
     build-essential wget cmake unzip pkg-config \
     libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev \
     libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
     libxvidcore-dev libx264-dev \
     libgtk2.0-dev libgtk-3-dev \
     libatlas-base-dev gfortran
```

### Download the official OpenCV source

```
export OPENCV=/home/$USER/workspace/OpenCV
mkdir -p $OPENCV && cd $OPENCV
export OPENCV_VERSION=3.4.3
export OPENCV_DOWNLOAD_URL=https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip
export OPENCV_CONTRIB_DOWNLOAD_URL=https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip
wget "$OPENCV_DOWNLOAD_URL" -O opencv.zip
wget "$OPENCV_CONTRIB_DOWNLOAD_URL" -O opencv_contrib.zip
unzip opencv.zip
unzip opencv_contrib.zip
```

### Configure OpenCV with CMake & Build

```
cd opencv-${OPENCV_VERSION}
mkdir -p build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D OPENCV_EXTRA_MODULES_PATH=$OPENCV/opencv_contrib-${OPENCV_VERSION}/modules \
      -D WITH_V4L=ON \
      -D BUILD_DOCS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_EXAMPLES=OFF ..
make -j`nproc`
sudo make install
sudo ldconfig
```

By default , `pip` is being automatically installed along as Python. But maybe it isn't there for some reason. In this case, you can manually install `pip` using `get-pip`.

```shell
mkdir /home/$USER/workspace && cd /home/$USER/workspace
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
```
