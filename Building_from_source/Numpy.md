# Build Numpy from source


### Prerequisites

- Ubuntu 18.04 LTS

- Python 2 or Python 3.6.5 (must be installed exactly as same as [this guideline](https://github.com/hoangtnm/TrainingServer-docs/blob/master/Setup_python_3_dev_environment.md))

- C and Fortran compilers (typically `gcc` and `gfortran`).

- BLAS and LAPACK libraries (optional but strongly recommended for NumPy, required for SciPy):
  - typically ATLAS + [OpenBLAS](https://github.com/hoangtnm/TrainingServer-docs/blob/master/Building_from_source/OpenBLAS.md)
  - or [MKL](https://software.intel.com/en-us/mkl)

- Cython

### Clone the Numpy repository

```sh
mkdir -p /home/$USER/workspace/prebuilt_libraries/numpy
export NUMPY=/home/$USER/workspace

git clone https://github.com/numpy/numpy.git $NUMPY && cd $NUMPY
```

Then create `site.cfg` and edit it with nano or vim.

```sh
cp site.cfg.example site.cfg
vim site.cfg
```

### Modify site.cfg

Uncomment these lines:

```
....
[openblas]
libraries = openblas
library_dirs = /opt/OpenBLAS/lib
include_dirs = /opt/OpenBLAS/include
....
```

### Verify

```python
python setup.py config
```

The output should look something like this:

```
...
openblas_info:
  FOUND:
    libraries = ['openblas', 'openblas']
    library_dirs = ['/opt/OpenBLAS/lib']
    language = c
    define_macros = [('HAVE_CBLAS', None)]

  FOUND:
    libraries = ['openblas', 'openblas']
    library_dirs = ['/opt/OpenBLAS/lib']
    language = c
    define_macros = [('HAVE_CBLAS', None)]
...
```


### Parallel builds


If you need to use specific BLAS/LAPACK libraries, you can do

```shell
export BLAS=/path/to/libblas.so
export LAPACK=/path/to/liblapack.so
export ATLAS=/path/to/libatlas.so

# Installing with pip is preferable to using python setup.py install
# since pip will keep track of the package metadata, allow you to easily uninstall or upgrade numpy in the future
# sudo pip3 install .
```

From NumPy 1.10.0 on it’s also possible to do a parallel build with:

```shell
python setup.py build --fcompiler=gnu95 -j `nproc` install --prefix=/usr/local

# Install to your home directory
# python setup.py install --user
```

This will compile numpy on all CPUs and install it into the specified prefix. to perform a parallel in-place build, run:

```shell
python setup.py build_ext --fcompiler=gnu95 --inplace -j `nproc`
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
