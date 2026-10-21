---
title: Epica
layout: default
parent: Dartmouth
machine_name: "Epica"
has_toc: false
---

# {{ page.machine_name }} (hosted by EAPS)
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

## Getting an Account
Send an email to Ed and request an account (make sure to ask him to add you to the `issm` group).

{{ page.machine_name }} has several drives. Your home directory is on a small drive, and `/data1` is for backups only. Make sure to install ISSM in `/data2`,
```sh
cd /data2/issm/
mkdir <USERNAME>
```
replacing `<USERNAME>` with your username. This is where you should checkout ISSM and do your work.

## SSH Configuration
Add the following lines to `~/.ssh/config` on your local machine,
```sh
Host epica epica.dartmouth.edu
    HostName epica.dartmouth.edu
    User <USERNAME>
```
replacing `<USERNAME>` with your *{{ page.machine_name }}*. Then, you can `ssh` to {{ page.machine_name }} with,
```sh
ssh epica
```

### Password-less SSH
{% include ssh_public_key_authentication.md %}

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc`,
```sh
export ISSM_DIR=<PATH_TO_ISSM>
source $ISSM_DIR/etc/environment.sh

# MATLAB alias
export LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libstdc++.so.6"
alias ma='matlab -nodesktop -nosplash -r "addpath $ISSM_DIR/src/m/dev; devpath;"'
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to. Then, run,
```sh
source ~/.bashrc
```
or log out and log back in to apply this change.

## Installing ISSM on {{ page.machine_name }}
Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- autotools
- petsc        (3.25 or later)
- triangle

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --enable-debugging \
    --with-numthreads=10 \
    --with-matlab-dir="/usr/local/MATLAB/{{ site.matlab_ver }}" \
    --with-mpi-include="${ISSM_DIR}/externalpackages/petsc/install/include"  \
    --with-mpi-libflags="-L${ISSM_DIR}/externalpackages/petsc/install/lib -lmpi -lmpicxx -lmpifort"\
    --with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-blas-lapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install/" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install/"
```
and to avoid conflicts with MATLAB's own dynamic libraries, use the following alias,
```sh
alias ma='LD_PRELOAD=/lib/x86_64-linux-gnu/libstdc++.so.6 matlab -nodesktop -nosplash -r "addpath ${ISSM_DIR}/src/m/dev; devpath;"'
```

## Installing ISSM with CoDiPack (AD)
You will need to install the following *additional* packages in the following order:
- codipack
- medipack
- adjointpetsc    (use the generic script, `install.sh`)

Use the following configuration script,
```sh
TBD
```
