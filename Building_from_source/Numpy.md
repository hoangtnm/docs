# Build Numpy from source


### Prerequisites

- Ubuntu 18.04 LTS

- Python 2 or Python 3.6.5 (must be installed exactly as same as [this guideline](https://github.com/hoangtnm/TrainingServer-docs/blob/master/Setup_python_3_dev_environment.md))

- C and Fortran compilers (typically `gcc` and `gfortran`).

- BLAS and LAPACK libraries (optional but strongly recommended for NumPy, required for SciPy):
  - typically ATLAS + [OpenBLAS](https://github.com/xianyi/OpenBLAS/)
  - or [MKL](https://software.intel.com/en-us/mkl)

- Cython

### Clone the Numpy repository

```shell
mkdir -p /home/$USER/workspace/prebuilt_libraries/numpy
export NUMPY=/home/$USER/workspace

git clone https://github.com/numpy/numpy.git $NUMPY && cd $NUMPY
```

### Parallel builds

If you need to use specific BLAS/LAPACK libraries, you can do

```shell
export BLAS=/path/to/libblas.so
export LAPACK=/path/to/liblapack.so
export ATLAS=/path/to/libatlas.so
```

From NumPy 1.10.0 on it’s also possible to do a parallel build with:

```shell
python setup.py build -j `nproc` install --prefix=/usr/local
```

This will compile numpy on all CPUs and install it into the specified prefix. to perform a parallel in-place build, run:

```shell
python setup.py build_ext --inplace -j `nproc`
```

### FORTRAN ABI mismatch

If your blas/lapack/atlas is built with g77, you must use g77 when building numpy and scipy

If your atlas is built with gfortran, you must build numpy/scipy with gfortran

This applies for most other cases where different FORTRAN compilers might have been used

### Disabling ATLAS and other accelerated libraries

Usage of ATLAS and other accelerated libraries in NumPy can be disabled via:

```shell
BLAS=None LAPACK=None ATLAS=None python setup.py build
```
