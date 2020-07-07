#!/usr/bin/env bash

set -e

echo 'Installing dependencies'
apt-get update && apt-get install -y \
	build-essential \
	libhdf5-serial-dev \
	libboost-all-dev \
	libleveldb-dev \
	libsnappy-dev \
	liblmdb-dev \
	libgflags-dev \
	libgoogle-glog-dev \
	git

echo 'Downloading Caffe source code'
git clone -b ssd https://github.com/weiliu89/caffe.git && cd caffe

echo 'Configuring Caffe'
cp Makefile.config.example Makefile.config
VERSION=$(python3 -V | sed 's/Python\ //' | cut -c1-3)
PYTHON_INCLUDE=$(which python${VERSION}m)
NUMPY_DIR=$(pip show numpy | grep Location | sed 's/Location:\ //')\/numpy\/core\/include
sed -i 's/^#\ USE_CUDNN/USE_CUDNN/' Makefile.config
sed -i 's/^#\ OPENCV_VERSION/OPENCV_VERSION/' Makefile.config
sed -i 's/^#\ CUSTOM_CXX/CUSTOM_CXX/' Makefile.config
sed -i '/.*-gencode.*sm_20.*/d' Makefile.config
sed -i '/.*-gencode.*sm_21.*/d' Makefile.config
sed -i 's/.*\(-gencode.*sm_30\)/CUDA_ARCH\ :=\ \1/' Makefile.config
sed -i 's/.*\(BLAS_INCLUDE\).*\/blas/\1\ :=\ \/opt\/OpenBLAS\/include/' Makefile.config
sed -i 's/.*\(BLAS_LIB\).*\/blas/\1\ :=\ \/opt\/OpenBLAS\/lib/' Makefile.config
sed -i '/.*python2.7.*/d' Makefile.config
sed -i "s/.*\(PYTHON_LIBRARIES.*boost_python3\) python3.5m/\1 python${VERSION}m/" Makefile.config
sed -i "s,.*\(PYTHON_INCLUDE\)\(.*\)\(\/usr\/include\/python3.5m\),\1\2$PYTHON_INCLUDE," Makefile.config
sed -i "s,.*dist-packages\/numpy.*,\t$NUMPY_DIR," Makefile.config
sed -i 's/^\(INCLUDE_DIRS.*\)/\1\ \/usr\/include\/hdf5\/serial/' Makefile.config
sed -i 's/^\(LIBRARY_DIRS.*\)/\1\ \/usr\/lib\/x86_64-linux-gnu\/hdf5\/serial/' Makefile.config

echo 'Building Caffe'
make all -j $(nproc)
make test -j $(nproc) && make runtest -j $(nproc)
make pycaffe -j $(nproc)

#
# Environment setup
#

shell="$0"

echo "export PYTHONPATH=$(pwd)/python:"'$PYTHONPATH' >> ~/."${shell}rc"
echo "You need to run source ~/.${shell}rc manually to make pycaffe importable"
