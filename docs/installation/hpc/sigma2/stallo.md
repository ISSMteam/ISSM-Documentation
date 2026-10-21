---
title: Stallo
layout: default
parent: Sigma2
machine_name: "Stallo"
nav_order: 3
has_toc: false
---

# {{ page.machine_name }} (Sigma2)
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

{: .warning-title }
> Warning
>
> {{ page.machine_name }} was decommissioned in 2021. Documentation is maintained here in case it helps installation on [Sigma2 HPC systems in production](www.sigma2.no/hpc-and-storage-systems){:target="_blank"}.
>

## Getting an Account
[Apply for a Sigma2 account](https://www.sigma2.no/how-apply-user-account){:target="_blank"}.

## SSH Configuration
Add the following lines to `~/.ssh/config` on your local machine,
```sh
Host stallo stallo.uit.no
    HostName stallo.uit.no
    User YOURSTALLOUSERNAME
```
replacing `<USERNAME>` with your {{ page.machine_name }} username (which should be your Sigma2 username). Then, you can `ssh` to {{ page.machine_name }} with,
```sh
ssh stallo
```

### Password-less SSH
{% include ssh_public_key_authentication.md %}

## Environment

{: .highlight-title }
> Note
>
> We were asked to avoid loading modules in `~/.bashrc` on {{ page.machine_name }}.

On {{ page.machine_name }}, add the following lines to `~/.bashrc`,
```sh
export ISSM_DIR=<PATH_TO_ISSM>
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to (note that this should be a subdirectory of `/cluster/work/users/<USERNAME>/`). Then, run,
```sh
source ~/.bashrc
```
or log out and log back in to apply this change.

## Installing ISSM on {{ page.machine_name }}
{{ page.machine_name }} will *only* be used to run the code: you will use your local machine for pre- and post-processing; you will never use {{ page.machine_name }}' Python.

Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- m1qn3

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
#!/bin/sh

# Load modules
module purge
module load CMake/3.8.0-GCCcore-6.3.0
module load Automake/1.15.1-GCCcore-6.3.0
module load libtool/2.4.6
#module load OpenSSL/1.1.0e-intel-2017a
module load PETSc/3.7.5-intel-2017a-downloaded-deps

# Configure ISSM
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --with-wrappers=no \
    --without-kriging \
    --with-mpi-include="/global/hds/software/cpu/eb3/impi/2017.1.132-iccifort-2017.1.132-GCC-6.3.0-2.27/include64" \
    --with-mpi-libflags="-L/global/hds/software/cpu/eb3/impi/2017.1.132-iccifort-2017.1.132-GCC-6.3.0-2.27/lib64 -lmpich -lmpichf90 -lmpichcxx -lmpl" \
    --with-mkl-libflags="-L/global/hds/software/cpu/eb3/imkl/2017.1.132-iimpi-2017a/mkl/lib/intel64 -lmkl_scalapack_lp64 -lmkl_blacs_intelmpi_lp64 -lmkl_intel_lp64 -lmkl_intel_thread -lmkl_core  -lmkl_scalapack_lp64 -lpthread" \
    --with-petsc-dir="/global/hds/software/cpu/eb3/PETSc/3.7.5-intel-2017a-downloaded-deps" \
    --with-metis-dir="/global/hds/software/cpu/eb3/PETSc/3.7.5-intel-2017a-downloaded-deps" \
    --with-mumps-dir="/global/hds/software/cpu/eb3/PETSc/3.7.5-intel-2017a-downloaded-deps" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
    --with-hypre-dir="/global/hds/software/cpu/eb3/PETSc/3.7.5-intel-2017a-downloaded-deps"
```

You can then make your configuration file executable (if it is not already) and execute it to compile and install ISSM,
```sh
chmod +x configure.sh
./configure.sh
module purge
module load CMake/3.8.0-GCCcore-6.3.0
module load Automake/1.15.1-GCCcore-6.3.0
module load libtool/2.4.6
module load PETSc/3.7.5-intel-2017a-downloaded-deps
make install
```

## Cluster Class Settings

### Python
Create file `$ISSM_DIR/src/py/stallo_settings.py` on the machine that you are doing model setup and results analysis on. This file will set up your personal settings so that that machine can send solution requests to {{ page.machine_name }} and retrieve results. For example, this file might include,
```python
def stallo_settings(md):
    md.login='<USERNAME>'
    md.queue='normal'
    md.codepath='<PATH_TO_ISSM_ON_CLUSTER>/bin/'
    md.executionpath='<PATH_TO_ISSM_ON_CLUSTER>/execution/'
    md.accountname='nn4659k' # this is for ice2ice
    md.numnodes=1
    md.numprocess=16
    return md
```
replacing `<USERNAME>` with your {{ page.machine_name }} username and entering your code path and execution path (`<PATH_TO_ISSM_ON_CLUSTER>` should be in `/global/work/<USERNAME>/`). These settings will be picked up automatically by MATLAB when you run `md.cluster=stallo()`.
