---
title: Māui
layout: default
parent: Other HPCs
machine_name: "Māui"
has_toc: false
---

# {{ page.machine_name }} (NeSI)
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

{: .warning-title }
> Warning
>
> {{ page.machine_name }} has been decommissioned and New Zealand eScience Infrastructure (NeSI) has integrated with Research and Education Advanced Network New Zealand (REANNZ). Documentation is maintained here in case it helps installation on [REANNZ HPC systems in production](https://docs.nesi.org.nz/){:target="_blank"}.
>

## Getting an Account
[Apply for a REANNZ account](https://docs.nesi.org.nz/Getting_Started/Getting_Started_Overview/){:target="_blank"}.

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc`,
```sh
# Load modules
module swap PrgEnv-cray PrgEnv-intel

# ISSM
export ISSM_DIR=<PATH_TO_ISSM>
source $ISSM_DIR/etc/environment.sh
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to (note that this should be a subdirectory of `/nesi/project/nesiXXXXX/`). Then, run,
```sh
source ~/.bashrc
```
or log out and log back in to apply this change.

## Installing ISSM on {{ page.machine_name }}
{{ page.machine_name }} will *only* be used to run the code: you will use your local machine for pre- and post-processing; you will never use {{ page.machine_name }}' Python.

Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- m1qn3    (use install-maui.sh)

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
#!/bin/sh

# Compilers
export CXX=CC
export CC=cc
export FC=ftn

# Configure ISSM
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --with-wrappers=no \
    --without-kriging \
    --without-kml \
    --without-Gia \
    --without-Love \
    --with-mpi-include="${CRAY_MPICH2_DIR}/include" \
    --with-mpi-libflags="-L${CRAY_MPICH2_DIR}/lib -lmpich -lmpl -lfmpich -lmpichcxx -lmpichf90" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
    --with-petsc-dir="${PETSC_DIR}" \
    --with-metis-dir="${CRAY_TPSL_PREFIX_DIR}" \
    --with-mumps-dir="${CRAY_TPSL_PREFIX_DIR}"
```
