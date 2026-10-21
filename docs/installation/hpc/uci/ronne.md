---
title: Ronne
layout: default
parent: UCI
machine_name: "Ronne"
has_toc: false
---

# {{ page.machine_name }} (UCI)
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

## Getting an Account
Send an email to Mathieu to request an account.

## SSH Configuration
Add the following lines to `~/.ssh/config` on your local machine,
```sh
Host ronne ronne.ics.uci.edu
    HostName ronne.ics.uci.edu
    User  <USERNAME>
```
replacing `<USERNAME>` with your {{ page.machine_name }} username. Then, you can `ssh` to {{ page.machine_name }} with,
```sh
ssh ronne
```

### Password-less SSH
{% include ssh_public_key_authentication.md %}

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc`,
```sh
# ISSM
export ISSM_DIR=<PATH_TO_ISSM>
source $ISSM_DIR/etc/environment.sh

# MATLAB alias
export LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libstdc++.so.6" # Bug with MATLAB: issmversion reports a bunch of undefined symbols
alias ma='matlab -nodesktop -nosplash -r "addpath ${ISSM_DIR}/src/m/dev; devpath;"'
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to (note that this should be a subdirectory of `/cluster/work/users/<USERNAME>/`). Then, run,
```sh
source ~/.bashrc
```
or log out and log back in to apply this change.

## Installing ISSM on {{ page.machine_name }}
Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- m1qn3

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
#!/bin/sh
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --enable-debugging \
    --with-numthreads=32 \
    --without-kml \
    --with-matlab-dir="/usr/local/matlab" \
    --with-mpi-include="${ISSM_DIR}/externalpackages/petsc/install/include" \
    --with-mpi-libflags="-L${ISSM_DIR}/externalpackages/petsc/install/lib -lmpi -lmpicxx -lmpifort" \
    --with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-blas-lapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
```

## Installing ISSM with CoDiPack (AD)
You will need to install the following additional packages:
- codipack 
- medipack
- gsl

Use the following configuration script (adapt to your needs, making sure to *not* include `--with-petsc-dir`),
```sh
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --enable-debugging \
    --enable-tape-alloc \
    --with-numthreads=20 \
    --without-kriging \
    --without-kml \
    --without-Love \
    --without-Sealevelchange \
    --with-matlab-dir="/usr/local/matlab" \
    --with-mpi-include="${ISSM_DIR}/externalpackages/petsc/install/include" \
    --with-mpi-libflags="-L${ISSM_DIR}/externalpackages/petsc/install/lib -lmpifort -lmpi" \
    --with-fortran-lib="-L/usr/lib/gcc/x86_64-linux-gnu/4.9/ -lgfortran" \
    --with-gsl-dir="${ISSM_DIR}/externalpackages/gsl/install" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-blas-lapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
    --with-codipack-dir="${ISSM_DIR}/externalpackages/codipack/install" \
    --with-medipack-dir="${ISSM_DIR}/externalpackages/medipack/install" \
```
