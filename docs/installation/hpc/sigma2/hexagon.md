---
title: Hexagon
layout: default
parent: Sigma2
machine_name: "Hexagon"
nav_order: 2
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
> {{ page.machine_name }} was decommissioned in 2017. Documentation is maintained here in case it helps installation on [Sigma2 HPC systems in production](www.sigma2.no/hpc-and-storage-systems){:target="_blank"}.
>

## Getting an Account
[Apply for a Sigma2 account](https://www.sigma2.no/how-apply-user-account){:target="_blank"}.

## SSH Configuration
Add the following lines to `~/.ssh/config` on your local machine,
```sh
Host hexagon hexagon.hpc.uib.no
    HostName hexagon.hpc.uib.no
    User <USERNAME>
```
replacing `<USERNAME>` with your {{ page.machine_name }} username (which should be your Sigma2 username). Then, you can `ssh` to {{ page.machine_name }} with,
```sh
ssh fram
```

### Password-less SSH
{% include ssh_public_key_authentication.md %}

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc`,
```sh
export ISSM_DIR=<PATH_TO_ISSM>
export CRAYPE_LINK_TYPE=dynamic

# Load modules
module unload xtpe-interlagos
module unload notur
module switch PrgEnv-cray/5.2.40 PrgEnv-gnu
module load craype-barcelona
module load automake
module load cray-petsc
module load cray-tpsl
module load cray-mpich
module load gsl
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to (note that this should be subdirectory of `/cluster/work/users/<USERNAME>/`). Then, run,
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

# Configure ISSM
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --with-mpi-include="${CRAY_MPICH2_DIR}/include" \
    --with-mpi-libflags="-L${CRAY_MPICH2_DIR}/lib -lmpich -lmpl -lfmpich -lmpichcxx -lmpichf90" \
    --with-petsc-dir="${PETSC_DIR}" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
    --with-metis-dir="${CRAY_TPSL_PREFIX_DIR}" \
    --with-mumps-dir="${CRAY_TPSL_PREFIX_DIR}" \
    --with-gsl-dir="/work/apps/gsl/1.16-gnu/"
```

Note that `$ISSM_DIR` should resolve to some subdirectory of `/work/` so that it is accessible to the cluster nodes.

### Troubleshooting
When running the Autotools, you may run into the following error message,
```sh
src/c/Makefile.am:9: Libtool library used but `LIBTOOL' is undefined
src/c/Makefile.am:9:   The usual way to define `LIBTOOL' is to add `LT_INIT'
src/c/Makefile.am:9:   to `configure.ac' and run `aclocal' and `autoconf' again.
src/c/Makefile.am:9:   If `LT_INIT' is in `configure.ac', make sure
src/c/Makefile.am:9:   its definition is in aclocal's search path.
```
Running `libtoolize` should resolve this issue.

Due to the fact that the Autotools on this machine are out of date, you should comment out the following line in `src/c/main/EnvironmentInit.cpp`,
```cpp
if(!my_rank) printf("(website: %s contact: %s)\n",PACKAGE_URL,PACKAGE_BUGREPORT);
```

## Cluster Class Settings

### Python
Create file `$ISSM_DIR/src/py/hexagon_settings.py` on the machine that you are doing model setup and results analysis on. This file will set up your personal settings so that that machine can send solution requests to {{ page.machine_name }} and retrieve results. For example, this file might include,
```python
def hexagon_settings(md):
    md.login='<USERNAME>'
    md.queue='normal'
    md.codepath='<PATH_TO_ISSM_ON_CLUSTER>/bin/'
    md.executionpath='<PATH_TO_ISSM_ON_CLUSTER>/execution/'
    md.accountname='bjerknes'
    md.numnodes=1
    return md
```
replacing `<USERNAME>` with your {{ page.machine_name }} username and entering your code path and execution path. These settings will be picked up automatically by MATLAB when you run `md.cluster=hexagon()`.

## Running Jobs on {{ page.machine_name }} (NEEDS TO BE UPDATED)
{{ page.machine_name }} is intended for large jobs. As on Vilje, the accounting is done as if you are using 32 processes per nodes even if you are using less. So, if you don't need a large amount of memory for your model, try to restrict the number of nodes you are using. The scheduler also prioritizes jobs with high CPU counts. [Scheduler job priorities](https://www.sigma2.no/documentation/jobs/submitting/job_scheduling.html){:target="_blank"}.

There are some limitations to the resources that a single user can ask for,
- 4096 CPU cores (total number used by all running jobs)
- 8-22 running (active) jobs (depending on load)
- 2 idle jobs

If you want to check the ordering of the queue and your jobs position you can use in your active {{ page.machine_name }} session:
```sh
showq          # display jobs
showq -u $USER # display jobs for $USER
showq -i       # display only jobs in eligible (idle) queue waiting for execution
```
