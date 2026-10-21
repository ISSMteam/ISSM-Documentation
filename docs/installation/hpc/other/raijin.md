---
title: Raijin
layout: default
parent: Other HPCs
machine_name: "Raijin"
has_toc: false
---

# {{ page.machine_name }} (NCI Australia)
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

{: .warning-title }
> Warning
>
> {{ page.machine_name }} was decommissioned in 2020. Documentation is maintained here in case it helps installation on [NCI HPC systems in production](https://nci.org.au/infrastructure/hpc-systems){:target="_blank"}.
>

## Environment
On {{ page.machine_name }}, add the following lines to `~/.cshrc`,
```sh
# Load modules
module load intel-cc/15.0.3.187
module load intel-fc/15.0.3.187
module load intel-mkl/15.0.3.187
module load fftw3-mkl/15.0.3.187
module load openmpi/1.10.2
module load cmake/3.4.0
module load petsc/3.6.3
module load scotch/6.0.0_esmumps
module load metis/5.1.0

# Compilers
MPI_LINK_FLAGS=$(mpicc --showme:link)

# ISSM
setenv ISSM_DIR <PATH_TO_ISSM>
source $ISSM_DIR/etc/environment.csh
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to. Then, run,
```sh
source ~/.cshrc
```
or log out and log back in to apply this change.

## Installing ISSM on {{ page.machine_name }}
{{ page.machine_name }} will *only* be used to run the code: you will use your local machine for pre- and post-processing; you will never use {{ page.machine_name }}' MATLAB.

Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- m1qn3

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
#!/bin/sh

# Compilers
CC=mpicc CXX=mpic++ F77=mpif77 F90=mpif90

# ISSM configuration
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --with-wrappers=no \
    --with-numthreads=16 \
    --with-mpi-include="."  \
    --with-mpi-libflags="" \
    --with-petsc-dir="/apps/petsc/3.6.3" \
    --with-metis-dir="/apps/metis/5.1.0" \
    --with-mumps-dir="/apps/petsc/3.6.3" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
```
