---
title: Unity
layout: default
parent: Other HPCs
machine_name: "Unity"
has_toc: false
---

# {{ page.machine_name }} (Massachusetts Green High Performance Computing Center, MGHPCC)
{: .no_toc }
----

## Getting an account
Anyone with a Dartmouth NetID can request an account. See [RC's documentation](https://rc.dartmouth.edu/hpc/unity/).

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc`,
```sh
# Load modules
module load openmpi/4.1.6 petsc/3.22.1

# ISSM
export ISSM_DIR=<PATHTODIR>
source $ISSM_DIR/etc/environment.sh
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to. Then, run,
```sh
source ~/.bashrc
```
or log out and log back in to apply this change.

## Installing ISSM on {{ page.machine_name }}
Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"}. You do not need to install any external packages.

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
#!/bin/sh

export CXXFLAGS="-g -O3 -std=c++11 -fno-fast-math"

./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --with-wrappers=no \
    --with-mpi-include="${MPI_HOME}/include" \
    --with-petsc-dir="${PETSC_DIR}" \
    --with-blas-lapack-dir="${NETLIB_LAPACK_SPACK_ROOT}" \
    --with-scalapack-dir="${NETLIB_SCALAPACK_SPACK_ROOT}" \
    --with-mumps-dir="${MUMPS_SPACK_ROOT}" \
    --with-metis-dir="${METIS_SPACK_ROOT}" \
    --with-parmetis-dir="${PARMETIS_SPACK_ROOT}" \
```
