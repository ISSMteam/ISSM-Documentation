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
You automatically have access to {{ page.machine_name }} if you are part of Dartmouth's Thayer School of Engineering. To request access to Amundsen, please send an email to Helene Seroussi.

# SSH Configuration
{{ page.machine_name }} is actually a cluster of 12 independent servers, so you need to first choose which one you are going to log into. [Check cluster usage](https://cluster-usage.thayer.dartmouth.edu/).

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
Babylon's home directory is on a very small drive. Make sure to install ISSM in `/jumbo/ice/ISSM/` (Ask Colin to give you permission),
```sh
cd /jumbo/ice/ISSM/
mkdir <USERNAME>
```
replacing `<USERNAME>` with your username. This is where you should clone ISSM and do your work.

You can clone ISSM and install the following packages:
- PETSc 3.26    (`./install-3.26-babylon.sh` or later)
- triangle      (`./install-linux.sh`)

Use the following configuration script (adapt to your needs):
```sh
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --enable-debugging \
    --with-numthreads=20 \
    --with-matlab-dir="/thayerfs/apps/matlabR2026a" \
    --with-mpi-include="/usr/lib/x86_64-linux-gnu/openmpi/include" \
    --with-mpi-libflags="-L/usr/lib/x86_64-linux-gnu/openmpi/lib -lmpi_usempif08 -lmpi_usempi_ignore_tkr -lmpi_mpifh -lmpi" \
    --with-fortran-lib="-L/usr/lib/gcc/x86_64-linux-gnu/15 -lgfortran" \
    --with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install" \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-parmetis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-blas-lapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
```

## Installing ISSM with CoDiPack (AD)
You will need to install the following *additional* packages:
- codipack
- medipack
