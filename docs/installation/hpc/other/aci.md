---
title: ACI
layout: default
parent: Other HPCs
machine_name: "ACI"
has_toc: false
---

# {{ page.machine_name }} (Penn State)
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

## Getting an Account
New users have to ask Byron for an account.

## SSH Configuration
You can add the following lines to `~/.ssh/config` on your local machine,
```sh
Host aci aci-b.aci.ics.psu.edu
    HostName aci-b.aci.ics.psu.edu
    User <USERNAME>
    HostbasedAuthentication no
```
replacing `<USERNAME>` with your {{ page.machine_name }} username. Once this is done, you can SSH to {{ page.machine_name }} with,
```sh
ssh aci
```

### Password-less SSH
{% include ssh_public_key_authentication.md %}

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc`,
```sh
# Load modules
module load intel/16.0.3
module load mkl/11.3.3
module load impi/5.1.3

# ISSM
export ISSM_DIR=<PATH_TO_ISSM>
source $ISSM_DIR/etc/environment.sh
alias cdi="cd ${ISSM_DIR}"
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to (note that this should be a subdirectory of `/gpfs/`, *not* your home directory). Then, run,
```sh
source ~/.bashrc
```
or log out and log back in to apply this change.

## Installing ISSM on {{ page.machine_name }}
{{ page.machine_name }} will *only* be used to run the code: you will use your local machine for pre- and post-processing; you will never use {{ page.machine_name }}' MATLAB.

Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- autotools
- petsc        (you will need to submit a job and compile PETSc manually; do not build the tests as they not work on the cluster)
- m1qn3

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
#!/bin/sh

./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --with-wrappers=no \
    --with-mpi-include="/opt/intel/compilers_and_libraries_2016.3.210/linux/mpi/intel64/include/" \
    --with-mpi-libflags="-L/opt/intel/compilers_and_libraries_2016.3.210/linux/mpi/intel64/lib/ -lmpicxx -lmpifort -lmpi -lmpigi -lifcore -lifport" \
    --with-mkl-libflags="-L/opt/intel/compilers_and_libraries_2016.3.210/linux/mkl/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core" \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install"
```

## Cluster Class Settings
In order to connect to {{ page.machine_name }} from the machine that you are doing model setup and results analysis on, you will need to create a cluster class settings file for your chosen scripting interface.
<div class="issm-api-tabs">
<div class="tab" data-api="mat" markdown="1">
Create `$ISSM_DIR/src/m/aci_settings.m`, which might include,
```matlab
cluster.name='aci';
cluster.login='eps5217';
cluster.queue='brp106_a_g_sc_default';
cluster.codepath='<PATH_TO_ISSM_ON_CLUSTER>/bin/';
cluster.executionpath='/gpfs/scratch/<USERNAME>/ISSM/execution/';
cluster.nodes=1;
cluster.ppn=20;
cluster.time=3*60;
```
</div>
<div class="tab" data-api="py" markdown="1">
Cluster class `aci.py` still needs to be developed.
</div>
</div>
replacing `<USERNAME>` with your {{ page.machine_name }} username and entering your code path and execution path (should be in scratch space, for example, `/gpfs/scratch/<USERNAME>/ISSM/execution`). These settings will be picked up automatically when you run `md.cluster=aci()`.

Make sure your module list includes `pkgsrc`, `comp-intel/2016.2.181`, and `mpi-sgi/mpt`.

## Running Jobs on {{ page.machine_name }}
On {{ page.machine_name }}, the more nodes and the longer the requested time, the more you will have to wait in the queue, so choose your settings wisely. For example, use,
<div class="issm-api-tabs">
<div class="tab" data-api="mat" markdown="1">
```matlab
md.cluster=aci('numnodes',8,'time',30,'processor','wes','queue','devel');
md.cluster.time=10;
```
</div>
<div class="tab" data-api="py" markdown="1">
Cluster class `aci.py` still needs to be developed.
</div>
</div>
to have a maximum job time of 10 minutes and 8 `westmere` nodes. If the run lasts longer than 10 minutes, it will be killed and you will not be able to retrieve your results.

If you want to check the status of your job and the node you are using on {{ page.machine_name }}, run,
```sh
qstat -u <USERNAME>
```

You can delete a job manually with,
```sh
qdel <JOBID>
```
where `<JOBID>` is the ID of the job indicated in the MATLAB session. MATLAB also indicates the directory where you job is running, which contains the files `<JOBNAME>.outlog` and `<JOBNAME>.errlog`. The `outlog` file contains any information that would appear if you were running your job on your local machine and the `errlog` file contains any information pertaining to errors that the job encounters.

To watch your current jobs,
```sh
watch qstat  -a
```

If you want to load results from the cluster manually (for example if you have an error due to a connection interruption), inspect your MATLAB session, using `$ISSM_DIR/execution/<LAUNCHSTRING>/<JOBNAME>.lock` to populate and run,
```matlab
md=loadresultsfromcluster(md,'<LAUNCHSTRING>','<JOBNAME>');
```
