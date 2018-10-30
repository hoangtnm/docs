.PHONY: help
help:
	@echo "\nmake help starting."
	@echo "Make targets are:"
	@echo "  make help - shows this message"
	@echo "  make python3 - Installs Python 3.6.5"
	@echo "  make cuda - Installs CUDA Toolkit 10.0, cuDNN 7.3.1.20 and NCCL 2.3.5"
	@echo "  make intelmkl - Install Intel MKL"
	@echo "  make intelmkl-dnn - Install Intel MKL-DNN"
	@echo "  make openblas - Install OpenBLAS"
	@echo "  make opencv - Install OpenCV"
	@echo "  make caffe - Install Caffe"
	@echo "  make tensorflow - Install Tensorflow"
	@echo "  make clean - removes targets and intermediate files." 

.PHONY: all
all: prereqs python3 cuda intelmkl intelmkl-dnn openblas opencv caffe tensorflow

.PHONY: python3
python3:
	./install-python-3.6-from_source.sh
	
.PHONY: cuda
cuda:
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

.PHONY: opencv
opencv: 
	./install-opencv-from_source.sh

.PHONY: prereqs
prereqs:
	@chmod +x install-python-3.6-from_source.sh
	@chmod +x install-cuda-10.sh
	@chmod +x install-openblas-from_source.sh
	@chmod +x install-opencv-from_source.sh
	@chmod +x install-intel-mkl-from_source.sh
	@chmod +x install-intel-mkl-dnn-from_source.sh

.PHONY: clean
clean:
	@echo "\nmake clean starting."
