.PHONY: help
help:
	@echo "\nmake help starting."
	@echo "Make targets are:"
	@echo "  make help - Show this message"
	@echo "  make all - Makes all targets"
	@echo "  make driver - Install NVIDIA driver"
	@echo "  make bazel - Install Bazel"
	@echo "  make cmake - Install CMake"
	@echo "  make python3 - Install Python 3.7.7"
	@echo "  make cuda - Install CUDA Toolkit 10.1, cuDNN 7.6 and NCCL 2.7"
	@echo "  make intelmkl - Install Intel MKL"
	@echo "  make openblas - Install OpenBLAS"
	@echo "  make numpy - Install Numpy"
	@echo "  make scipy - Install Scipy"
	@echo "  make sklearn - Install scikit-learn"
	@echo "  make protoc - Install Protocol Compiler 3.7.1"
	@echo "  make opencv - Install OpenCV"
	@echo "  make caffe - Install Caffe"
	@echo "  make tensorflow - Install Tensorflow"
	@echo "  make clean - Removes all temp files from all directories"

.PHONY: all
all: prereqs driver cuda python3 openblas protoc numpy scipy opencv caffe

.PHONY: driver
driver:
	sudo ./install_nvidia_driver.sh

.PHONY: bazel
bazel:
	sudo ./install_bazel.sh

.PHONY: cmake
cmake:
	sudo ./install_cmake.sh

.PHONY: python3
python3:
	sudo ./install_python3.sh
	
.PHONY: cuda
cuda:
	sudo ./install_cuda.sh
		
.PHONY: intelmkl
intelmkl:
	sudo ./install_intel-mkl_from_source.sh
	
.PHONY: openblas
openblas:
	sudo ./install_openblas.sh
	
.PHONY: numpy
numpy:
	sudo ./install_numpy.sh
	
.PHONY: scipy
scipy:
	sudo ./install_scipy.sh
	
.PHONY: sklearn
sklearn:
	sudo ./install_sklearn.sh

.PHONY: protoc
protoc:
	sudo ./install_protoc.sh

.PHONY: opencv
opencv:
	sudo ./install_opencv.sh

.PHONY: caffe
caffe:
	sudo ./install_caffe.sh

.PHONY: prereqs
prereqs:
	@chmod +x *.sh

.PHONY: clean
clean:
	@echo "make clean starting."
