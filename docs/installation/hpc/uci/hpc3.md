---
title: HPC3
layout: default
parent: UCI
machine_name: "HPC3"
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
[Request an account on {{ page.machine_name }}](https://rcic.uci.edu/account/getting-account.html){:target="_blank"}.

## SSH Configuration
Add the following lines to `~/.ssh/config` on your local machine,
```sh
Host hpc3 hpc3.oit.uci.edu
  HostName hpc3.oit.uci.edu
  User <USERNAME>
  HostKeyAlias hpc3.uci.edu
  HostbasedAuthentication no
```
replacing `<USERNAME>` with your {{ page.machine_name }} username (which should be your Dartmouth NetID). Then, you can `ssh` to {{ page.machine_name }} with,
```sh
ssh hpc3
```

### Password-less SSH
{% include ssh_public_key_authentication.md %}

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc`,
```sh
# Load modules
module load cmake/2.8.10.2

# ISSM
export ISSM_DIR=<PATH_TO_ISSM>
source $ISSM_DIR/etc/environment.sh
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to (note that this should be a subdirectory of `/pub/<USERNAME>/`). Then, run,
```sh
source ~/.bashrc
```
or log out and log back in to apply this change.

## Installing ISSM on {{ page.machine_name }}
{{ page.machine_name }} will *only* be used to run the code: you will use your local machine for pre- and post-processing; you will never use {{ page.machine_name }}' Python.

Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- autotools
- petsc        (you will need to submit a job and compile PETSc manually; do not build the tests as they not work on the cluster)
- m1qn3

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
#!/bin/sh
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-debugging \
    --enable-development \
    --with-wrappers=no \
    --with-numthreads=16 \
    --with-kml=no \
    --with-bamg=no \
    --with-mpi-include="/data/apps/mpi/openmpi-1.8.3/gcc/4.8.3/include" \
    --with-mpi-libflags="-L/data/apps/mpi/openmpi-1.8.3/gcc/4.8.3/lib -lmpi_cxx -lmpi -lmpi_usempi" \
    --with-fortran-lib="-L/data/apps/gcc/4.7.3/lib64 -lgfortran" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/metis/install" \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
    --with-blas-lapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install"
```

## Cluster Class Settings

### MATLAB
Create file `$ISSM_DIR/src/m/hpc_settings.m` on the machine that you are doing model setup and results analysis on. This file will set up your personal settings so that that machine can send solution requests to {{ page.machine_name }} and retrieve results. For example, this file might include,
```matlab
cluster.login='<USERNAME>';
cluster.port=8000;
cluster.queue='pub64';
cluster.codepath='<PATH_TO_ISSM_ON_CLUSTER>/bin/';
cluster.executionpath='<PATH_TO_ISSM_ON_CLUSTER>/execution/';
```
replacing `<USERNAME>` with your {{ page.machine_name }} username and entering your code path and execution path (`<PATH_TO_ISSM_ON_CLUSTER>` should be in `/pub/<USERNAME>/`). These settings will be picked up automatically by MATLAB when you run `md.cluster=hpc()`.

The list of available queues is:
- `pub64`
- `free64`
- `free48`
- `free*,pub64`
- `free*`

## Running Jobs on {{ page.machine_name }}
On {{ page.machine_name }}, you can use up to 64 cores per node. The more nodes and the longer the requested time, the more you will have to wait in the queue, so choose your settings accordingly. For example,
```matlab
md.cluster=hpc('numnodes',1,'cpuspernode',8);
```
will request a job of 8 cores on one node. If the run lasts longer than 10 minutes, it will be killed and you will not be able to retrieve your results.

If you want to check the status of your job and the queue that you are using, run,
```sh
qstat -u <USERNAME>
```

You can delete your job manually by typing,
```sh
qdel <JOB_ID>
```
where `<JOB_ID>` is the job ID reported on your local machine when you submitted your solution request. Also reported is the directory where you can find log files associated with the run (i.e. `<JOB_ID>.outlog` and `<JOB_ID>.errlog`). The `outlog` contains the information that would normally be printed to the console if you were running the job on your local machine. Likewise, the `errlog` contains any information printed in case of error.

If you would like to load results from the cluster manually (for example, if you encountered an error due to network disconnection), run,
```matlab
md=loadresultsfromcluster(md,'runtimename','<EXEC_DIR>');
```
where `<EXEC_DIR>` is the parent of the job on your local machine, for example,
```sh
${ISSM_DIR}/execution/<EXEC_DIR>/<JOB_ID>.lock
```
