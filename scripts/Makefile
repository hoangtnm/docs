.PHONY: help
help:
	@echo "\nmake help starting."
	@echo "Make targets are:"
	@echo "  make help - Show this message"
	@echo "  make all - Install the default options"
	@echo "  make driver - Install NVIDIA driver"
	@echo "  make bazel - Install Bazel"
	@echo "  make cmake - Install CMake"
	@echo "  make python3 - Install Python 3.7.7"
	@echo "  make cuda10 - Install CUDA Toolkit 10.1, cuDNN 7.6 and NCCL 2.5"
	@echo "  make intelmkl - Install Intel MKL"
	@echo "  make intelmkl-dnn - Install Intel MKL-DNN"
	@echo "  make openblas - Install OpenBLAS"
	@echo "  make blis - Install BLIS"
	@echo "  make numpy - Install Numpy"
	@echo "  make scipy - Install Scipy"
	@echo "  make sklearn - Install scikit-learn"
	@echo "  make protobuf - Install Protocol Buffers 3.7.1"
	@echo "  make opencv - Install OpenCV"
	@echo "  make caffe - Install Caffe"
	@echo "  make tensorflow - Install Tensorflow"
	@echo "  make clean - remove targets and intermediate files." 

.PHONY: all
all: prereqs driver cuda10 python3 openblas protobuf numpy scipy opencv caffe

.PHONY: driver
driver:
	./install-nvidia-driver.sh

.PHONY: bazel
bazel:
	./install-bazel.sh

.PHONY: cmake
cmake:
	./install-cmake-from_source.sh

.PHONY: python3
python3:
	./install-python3-from_source.sh
	
.PHONY: cuda10
cuda10:
	./install-cuda-10.sh
		
.PHONY: intelmkl
intelmkl:
	./install-intel-mkl-from_source.sh
	
.PHONY: intelmkl-dnn
intelmkl-dnn:
	./install-intel-mkl-dnn-from_source.sh
	
.PHONY: openblas
openblas:
	./install-openblas-from_source.sh
	
.PHONY: blis
blis:
	./install-blis-from_soure.sh
	
.PHONY: numpy
numpy:
	./install-numpy-from_source.sh
	
.PHONY: scipy
scipy:
	./install-scipy-from_source.sh
	
.PHONY: sklearn
sklearn:
	./install-sklearn-from_source.sh

.PHONY: protobuf
protobuf:
	./install-protobuf-from_source.sh

.PHONY: opencv
opencv: 
	./install-opencv-from_source.sh
	
.PHONY: caffe
caffe:
	./install-caffe-from_source.sh

.PHONY: prereqs
prereqs:
	@chmod +x install-nvidia-driver.sh
	@chmod +x install-bazel.sh
	@chmod +x install-cmake-from_source.sh
	@chmod +x install-python3-from_source.sh
	@chmod +x install-cuda-10.sh
	@chmod +x install-openblas-from_source.sh
	@chmod +x install-blis-from_soure.sh
	@chmod +x install-intel-mkl-from_source.sh
	@chmod +x install-intel-mkl-dnn-from_source.sh
	@chmod +x install-numpy-from_source.sh
	@chmod +x install-scipy-from_source.sh
	@chmod +x install-sklearn-from_source.sh
	@chmod +x install-protobuf-from_source.sh
	@chmod +x install-opencv-from_source.sh
	@chmod +x install-caffe-from_source.sh
	
.PHONY: clean
clean:
	@echo "\nmake clean starting."
