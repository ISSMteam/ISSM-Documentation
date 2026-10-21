---
title: Unity
layout: default
parent: HPC
machine_name: "Unity"
---

# Unity (Masachusetts Green High Performance Computing Center, MGHPCC)
{: .no_toc }
----

## Getting an account
Anyone with a Dartmouth NetID can request an account. See [RC's documentation](https://rc.dartmouth.edu/hpc/unity/).

## Environment
On Unity, add the following lines to ```~/.bashrc```:

```sh
#modules
module load openmpi/4.1.6 petsc/3.22.1

#ISSM
export ISSM_DIR=<PATHTODIR>
source $ISSM_DIR/etc/environment.sh
```

## Installing ISSM on Unity
You do not need to install any external package.
Use the following configuration script (adapt to your needs):

```sh
export CXXFLAGS="-g -O3 -std=c++11 -fno-fast-math"
./configure \
   --prefix=$ISSM_DIR \
   --with-wrappers=no \
   --with-mpi-include="$MPI_HOME/include" \
   --with-petsc-dir="$PETSC_DIR" \
   --with-blas-lapack-dir="$NETLIB_LAPACK_SPACK_ROOT" \
   --with-scalapack-dir="$NETLIB_SCALAPACK_SPACK_ROOT" \
   --with-mumps-dir="$MUMPS_SPACK_ROOT" \
   --with-metis-dir="$METIS_SPACK_ROOT" \
   --with-parmetis-dir="$PARMETIS_SPACK_ROOT" \
   --enable-development
```
