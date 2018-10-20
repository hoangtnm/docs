# Install OpenBlas in Ubuntu 18.04


### Introduction

OpenBLAS is an optimized BLAS library based on GotoBLAS2 1.13 BSD version.

Please read the documentation on the OpenBLAS wiki pages: <http://github.com/xianyi/OpenBLAS/wiki>.

### Dependencies

Building OpenBLAS requires the following to be installed:

* GNU Make
* A C compiler, e.g. GCC or Clang
* A Fortran compiler (optional, for LAPACK)
* IBM MASS (optional, see below)


## Clone the OpenBLAS repository

```sh
git clone https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS
```

### Normal compile

```sh
make -j`nproc`
```

Notes

- OpenBLAS doesn't support g77. Please use gfortran or other Fortran compilers. e.g. `make FC=gfortran`

- When building in an emulator (KVM,QEMU etc.) make sure that the combination of CPU features exposed to the virtual environment matches that of an existing CPU to allow detection of the cpu model to succeed. (With qemu, this can be done by passing `-cpu host` or a supported model name at invocation)

Simply invoking `make` (or `gmake` on BSD) will detect the CPU automatically.
To set a specific target CPU, use `make TARGET=xxx`, e.g. `make TARGET=NEHALEM`.
The full target list is in the file `TargetList.txt`.

### Debug version

A debug version can be built using `make DEBUG=1`.

### Install to a specific directory (optional)

Use `PREFIX=` when invoking `make`, for example

```sh
make install PREFIX=your_installation_directory
```

The default installation directory is `/opt/OpenBLAS`.

The directory structure is:

```
.
├── bin
├── include
│   ├── cblas.h
│   ├── f77blas.h
│   ├── lapacke_config.h
│   ├── lapacke.h
│   ├── lapacke_mangling.h
│   ├── lapacke_utils.h
│   └── openblas_config.h
└── lib
    ├── cmake
    │   └── openblas
    │       ├── OpenBLASConfig.cmake
    │       └── OpenBLASConfigVersion.cmake
    ├── libopenblas.a -> libopenblas_haswellp-r0.3.4.dev.a
    ├── libopenblas_haswellp-r0.3.4.dev.a
    ├── libopenblas_haswellp-r0.3.4.dev.so
    ├── libopenblas.so -> libopenblas_haswellp-r0.3.4.dev.so
    ├── libopenblas.so.0 -> libopenblas_haswellp-r0.3.4.dev.so
    └── pkgconfig
        └── openblas.pc
```

## Supported CPUs and Operating Systems

Please read `GotoBLAS_01Readme.txt`.

## Usage

Statically link with `libopenblas.a` or dynamically link with `-lopenblas` if OpenBLAS was
compiled as a shared library.

### Setting the number of threads using environment variables

Environment variables are used to specify a maximum number of threads.
For example,

```sh
export OPENBLAS_NUM_THREADS=4
export GOTO_NUM_THREADS=4
export OMP_NUM_THREADS=4
```

The priorities are `OPENBLAS_NUM_THREADS` > `GOTO_NUM_THREADS` > `OMP_NUM_THREADS`.

If you compile this library with `USE_OPENMP=1`, you should set the `OMP_NUM_THREADS`
environment variable; OpenBLAS ignores `OPENBLAS_NUM_THREADS` and `GOTO_NUM_THREADS` when
compiled with `USE_OPENMP=1`.

### Setting the number of threads at runtime

We provide the following functions to control the number of threads at runtime:

```c
void goto_set_num_threads(int num_threads);
void openblas_set_num_threads(int num_threads);
```

If you compile this library with `USE_OPENMP=1`, you should use the above functions too.

### Replace system BLAS/updating APT OpenBLAS in Ubuntu/Debian

Ubuntu and Debian provides 'alternatives' mechanism to comfortably replace BLAS and LAPACK libraries systemwide.

After successful build of OpenBLAS (with DYNAMIC_ARCH set to 1)

```sh
make clean
make DYNAMIC_ARCH=1
sudo make DYNAMIC_ARCH=1 install
```

One can redirect BLAS and LAPACK alternatives to point to source-built OpenBLAS First you have to install NetLib LAPACK reference implementation (to have alternatives to replace):

```sh
sudo apt install libblas-dev liblapack-dev
```

Then we can set alternative to our freshly-built library:

```sh
sudo update-alternatives --add /usr/lib/libblas.so.3 libblas.so.3 /opt/OpenBLAS/lib/libopenblas.so.0 41 \
   --slave /usr/lib/liblapack.so.3 liblapack.so.3 /opt/OpenBLAS/lib/libopenblas.so.0
```

Or remove redirection and switch back to APT-provided BLAS implementation order:

```sh
sudo update-alternatives --remove libblas.so.3 /opt/OpenBLAS/lib/libopenblas.so.0
```

### Specific instructions

To build from source the following packages are needed:

```sh
sudo apt-get install gcc gfortran python-dev libopenblas-dev liblapack-dev cython
```

To customize which BLAS is used, you can setup a `site.cfg` file. See the site.cfg.example file in the numpy source for the options you can set.

Note that Debian and Ubuntu package optimized BLAS libraries in a exchangeable way. You can install libraries such as ATLAS or OpenBLAS and change the default one used via the alternatives mechanism:

```sh
$ sudo apt-get install libopenblas-base libatlas3-base
$ update-alternatives --list libblas.so.3
/usr/lib/atlas-base/atlas/libblas.so.3
/usr/lib/libblas/libblas.so.3
/usr/lib/openblas-base/libopenblas.so.0

$ sudo update-alternatives --set libblas.so.3 /usr/lib/openblas-base/libopenblas.so.0
```

See /usr/share/doc/libatlas3-base/README.Debian for instructions on how to build optimized ATLAS packages for your specific CPU. 

You can also use a library you built yourself by preloading it. This does not require administrator rights.

```sh
LD_PRELOAD=/path/to/libatlas.so.3 ./my-application
```
