---
title: Babylon/Amundsen
layout: default
parent: Dartmouth
machine_name: "Babylon/Amundsen"
has_toc: false
---

# {{ page.machine_name }} (Dartmouth Research Computing)
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

# Getting an Account
You automatically have access to the {{ page.machine_name }} machine if you are part of Dartmouth's Thayer School of Engineering. To request access to Amundsen, please send an email to Helene Seroussi.

# SSH Configuration
{{ page.machine_name }} is actually a cluster of 12 independent servers, so you need to first choose which one you are going to log into. [Check cluster usage](https://cluster-usage.thayer.dartmouth.edu/){:target="_blank"}.

Add the following lines to `~/.ssh/config` on your local machine:
```sh
Host babylon babylon?.thayer.dartmouth.edu
    Hostname babylon?.thayer.dartmouth.edu
    User <USERNAME>
```
replacing `<USERNAME>` with your {{ page.machine_name }} username (which should be your Dartmouth NetID). Then, you can `ssh` to {{ page.machine_name }} with,
```sh
ssh babylon<N>
```
or
```sh
ssh amundsen<N>
```
where `<N>` is the number of the machine you want to access.

## Password-less SSH
This machine does not support public key authentication.

# Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc`,
```sh
# Load modules
module unload paraview/6.1.0

# ISSM
export ISSM_DIR=<PATH_TO_ISSM>

export FC=gfortran
export F77=gfortran
export F90=gfortran
export CC=gcc
export CXX=g++

source $ISSM_DIR/etc/environment.sh
alias ma='LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libstdc++.so.6" /thayerfs/apps/matlab/bin/matlab -nodesktop -nosplash -r "addpath ${ISSM_DIR}/src
/m/dev; devpath;"'
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to. Then, run,
```sh
source ~/.bashrc
```
or log out and log back in to apply this change.

# Installing ISSM on {{ page.machine_name }}
{{ page.machine_name }} have both Intel and GNU compilers. Installation should be done with the GNU compilers following the [detailed instructions for compiling ISSM on Linux](../../linux).

Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- petsc       (use the latest available version for {{ page.machine_name }})
- triangle    (install-linux.sh)

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
export CC=gcc
export CXX=g++
export F90=gfortran
export FC=gfortran

./configure \
    --prefix="${ISSM_DIR}" \
    --enable-debugging \
    --enable-development \
    --with-numthreads=20 \
    --with-matlab-dir="/thayerfs/apps/matlab/" \
    --with-fortran-lib="-L/usr/lib/gcc/x86_64-linux-gnu/15 -lgfortran" \
    --with-mpi-include="/usr/lib/x86_64-linux-gnu/openmpi/include" \
    --with-mpi-libflags="-L/usr/lib/x86_64-linux-gnu/openmpi/lib -lmpi_usempif08 -lmpi_usempi_ignore_tkr -lmpi_mpifh -lmpi" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-parmetis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-blas-lapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
    --with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install"
```

## Installing ISSM with CoDiPack (AD)
You will need to install the following *additional* packages:
- codipack
- medipack

Use the following configuration script (adapt to your needs, make sure to NOT include `--with-petsc-dir`),
```sh
export CC=gcc
export CXX=g++
export F90=gfortran
export FC=gfortran
export CXXFLAGS="-g -O3 -fPIC -std=c++11 -DCODI_ForcedInlines"
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --enable-debugging \
    --enable-tape-alloc \
    --with-numthreads=32 \
    --without-kriging \
    --without-kml \
    --without-Love \
    --without-Sealevelchange \
    --with-matlab-dir="/thayerfs/apps/matlab/" \
    --with-fortran-lib="-L/usr/lib/gcc/x86_64-linux-gnu/15 -lgfortran" \
    --with-mpi-include="/usr/lib/x86_64-linux-gnu/openmpi/include" \
    --with-mpi-libflags="-L/usr/lib/x86_64-linux-gnu/openmpi/lib -lmpi_usempif08 -lmpi_usempi_ignore_tkr -lmpi_mpifh -lmpi" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-parmetis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-blas-lapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
    --with-codipack-dir="${ISSM_DIR}/externalpackages/codipack/install" \
    --with-medipack-dir="${ISSM_DIR}/externalpackages/medipack/install"
```
