---
title: GreenPlanet
layout: default
parent: UCI
machine_name: "GreenPlanet"
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
[Request an account on {{ page.machine_name }}](https://webapps.ps.uci.edu/greenplanet/New_Accounts){:target="_blank"}.

## SSH Configuration
Add the following lines to `~/.ssh/config` on your local machine,
```sh
Host gp greenplanet gplogin1.ps.uci.edu gplogin2.ps.uci.edu
    HostName gplogin1.ps.uci.edu
    User <USERNAME>
    HostKeyAlias gplogin1.ps.uci.edu
    HostbasedAuthentication no
```
replacing `<USERNAME>` with your {{ page.machine_name }} username. Then, you can `ssh` to {{ page.machine_name }} with,
```sh
ssh gp
```

{: .note-title }
> Note
>
> `gplogin2.ps.uci.edu` is preferred over `gplogin1.ps.uci.edu` (`gplogin2` is faster, has 48 cores, new nodes, and allows to access the DFS-B disk which features faster I/O).
> Ideally, submit jobs on `ilg2.3`.
> [Full list of partitions on {{ page.machine_name }}](https://webapps.ps.uci.edu/greenplanet/slurm_partitions){:target="_blank"}.

### Password-less SSH
{% include ssh_public_key_authentication.md %}

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc`,
```sh
# Load modules
ml intel/2018.3 openmpi/3.1.2-slim

# ISSM
export ISSM_DIR=<PATH_TO_ISSM>
source $ISSM_DIR/etc/environment.sh
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to. Then, run,
```sh
source ~/.bashrc
```
or log out and log back in to apply this change.

## Installing ISSM on {{ page.machine_name }}
{{ page.machine_name }} will *only* be used to run the code: you will use your local machine for pre- and post-processing; you will never use {{ page.machine_name }}' Python.

Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- autotools
- petsc
- m1qn3

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
#!/bin/sh

export CXXFLAGS="-O3 -fPIC -std=c++11"

./configure \
    --prefix="${ISSM_DIR}" \
    --with-wrappers=no \
    --with-vendor=intel-gp \
    --with-kriging=no \
    --with-kml=no \
    --with-bamg=no \
    --without-Love \
    --with-mpi-include="/sopt/OpenMPI/3.1.2/intel-2018.3-slim/include" \
    --with-mpi-libflags="-L/sopt/OpenMPI/3.1.2/intel-2018.3-slim/lib -lmpi -lm -lmpi_mpifh" \
    --with-mkl-libflags="-L/sopt/MKL/2018.3/lib -mkl=cluster" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install"
```

## Cluster Class Settings

### MATLAB
Create file `$ISSM_DIR/src/m/greenplanet_settings.m` on the machine that you are doing model setup and results analysis on. This file will set up your personal settings so that that machine can send solution requests to {{ page.machine_name }} and retrieve results. For example, this file might include,
```matlab
cluster.login='<USERNAME>';
cluster.queue='ilg2.3';
cluster.port='';
cluster.codepath='<PATH_TO_ISSM_ON_CLUSTER>/bin/';
cluster.executionpath='<PATH_TO_ISSM_ON_CLUSTER>/execution/';
```
replacing `<USERNAME>` with your {{ page.machine_name }} username and entering your code path and execution path. These settings will be picked up automatically by MATLAB when you run `md.cluster=greenplanet()`.

## Running Jobs on {{ page.machine_name }}
On {{ page.machine_name }}, you can use up to 30 cores per node and up to 125GB of RAM per job (partition `ilg2.3`). The more nodes and the longer the requested time, the more you will have to wait in the queue, so choose your settings accordingly.  For example,
```matlab
md.cluster=greenplanet('numnodes',1,'cpuspernode',8);
md.cluster.time=10;
```
will request a maximum job time of 10 minutes and 8 cores on one node. If the run lasts longer than 10 minutes, it will be killed and you will not be able to retrieve your results.

If you want to check the status of your job and the queue that you are using, run,
```sh
squeue -u username
```

You can delete your job manually by typing,
```sh
scancel JOBID
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

{: .note-title }
> Note
>
> In the case where `md.settings.waitonlock > 0` and you need to load manually (e.g., connection interruption), it is necessary to set `md.private.runtimename=<LAUNCHSTRING>;` *before* calling `loadresultsfromcluster`.


## slurm
[A comparison of PBS to `slurm` commands](https://slurm.schedmd.com/rosetta.pdf){:target="_blank"}.

Useful commands:
- Graphical overview over {{ page.machine_name }} usage,
```sh
sview
```

- Get number of idle nodes,
```sh
sinfo --states=idle
```

- See a user's jobs,
```sh
squeue -u <USERNAME>
```

- Get more information on a user's jobs,
```sh
sacct -u <USERNAME> format=User,JobID,account,Timelimit,elapsed,ReqMem,MaxRss,ExitCode
```

- Get information on partition (for example, `ilg2.3`),
```sh
scontrol show partition=ilg2.3
```

- Get sorted list of users on partition,
```sh
squeue | grep -i ilg2.3 | awk '{print $4}' | sort | uniq -c | sort -rn
```
