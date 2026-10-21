---
title: Cambridge
layout: default
parent: Other HPCs
machine_name: "University of Cambridge' HPC"
has_toc: false
---

# {{ page.machine_name }}
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

## Getting an Account
[Request a University of Cambridge Research Computing Services account](https://www.hpc.cam.ac.uk/access-csd3){:target="_blank"}.

## SSH Configuration
Add the following lines to `~/.ssh/config` on your local machine if are not on the campus network,
```sh
Host camhpc darwin login.hpc.cam.ac.uk
    HostName login.hpc.cam.ac.uk
    User <USERNAME>
    ProxyCommand ssh <USERNAME>@citadel.ch.cam.ac.uk nc %h %p 2> /dev/null
    HostKeyAlias login.hpc.cam.ac.uk
```
replacing `<USERNAME>` with your {{ page.machine_name }} username.

If you are on the campus network, you don't need to go through citadel and you can log in directly:
```sh
Host camhpc darwin login.hpc.cam.ac.uk
    HostName login.hpc.cam.ac.uk
    User <USERNAME>
```

Then, you can `ssh` to {{ page.machine_name }} with,
```sh
ssh camhpc
```

### Password-less SSH
{% include ssh_public_key_authentication.md %}

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc`,
```sh
# Load modules
module load petsc/3.6.4

# ISSM
export ISSM_DIR=<PATH_TO_ISSM>
source $ISSM_DIR/etc/environment.sh
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to (note that this should be a subdirectory of `/cluster/work/users/<USERNAME>/`). Then, run,
```sh
source ~/.bashrc
```
or log out and log back in to apply this change.

## Installing ISSM on {{ page.machine_name }}
{{ page.machine_name }} will *only* be used to run the code: you will use your local machine for pre- and post-processing; you will never use {{ page.machine_name }}' MATLAB.

Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- autotools
- m1qn3

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
#!/bin/sh

export CXXFLAGS="-DMPICH_IGNORE_CXX_SEEK -DMPICH_SKIP_MPICXX"
./configure \
    --prefix="${ISSM_DIR}" \
    --with-wrappers=no \
    --with-kml=no \
    --with-bamg=no \
    --with-mpi-include="/usr/local/Cluster-Apps/intel/impi/4.1.3.045/include64" \
    --with-mpi-libflags="-L/usr/local/Cluster-Apps/intel/impi/4.1.3.045/lib64 -lmpi" \
    --with-mkl-libflags="-L/usr/local/Cluster-Apps/intel/mkl/10.3.10.319/composer_xe_2011_sp1.10.319/mkl/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" \
    --with-metis-dir="/usr/local/Cluster-Apps/petsc/3.6.4/intel12.1-impi" \
    --with-petsc-dir="/usr/local/Cluster-Apps/petsc/3.6.4/intel12.1-impi" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
    --with-mumps-dir="/usr/local/Cluster-Apps/petsc/3.6.4/intel12.1-impi"
```

## Cluster Class Settings

### MATLAB
Create file `$ISSM_DIR/src/m/camhpc_settings.m` on the machine that you are doing model setup and results analysis on. This file will set up your personal settings so that that machine can send solution requests to {{ page.machine_name }} and retrieve results. For example, this file might include,
```matlab
cluster.login='<USERNAME>';
cluster.partition='sandybridge';
cluster.project='ARNOLD-SL3';
cluster.port=0;
cluster.codepath='<PATH_TO_ISSM_ON_CLUSTER>/bin/';
cluster.executionpath='<PATH_TO_ISSM_ON_CLUSTER>/execution/';
cluster.numnodes=1;
cluster.cpuspernode=3;
cluster.time=2;
```
replacing `<USERNAME>` with your {{ page.machine_name }} username and entering your code path and execution path. These settings will be picked up automatically by MATLAB when you run `md.cluster=camhpc()`.

## Running Jobs on {{ page.machine_name }}
On {{ page.machine_name }}, the more nodes and the longer the requested time, the more you will have to wait in the queue, so choose your settings accordingly. For example,
```matlab
md.cluster=camhpc('numnodes',1,'cpuspernode',8);
md.cluster.time=10;
```
will request a maximum job time of 10 minutes and 8 cores on one node. If the run lasts longer than 10 minutes, it will be killed and you will not be able to retrieve your results.

If you want to check the status of your job and the queue that you are using, run,
```sh
squeue -u username
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
