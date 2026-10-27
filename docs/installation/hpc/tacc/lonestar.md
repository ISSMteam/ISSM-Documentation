---
title: Lonestar
layout: default
parent: TACC
machine_name: "Lonestar"
machine_version: "6"
has_toc: false
---

# {{ page.machine_name }} (TACC)
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

## Getting an Account
Coming soon...

## SSH Configuration
Add the following lines to `~/.ssh/config` on your local machine,
```sh
Host lonestar ls{{ page.machine_version }}.tacc.utexas.edu
    HostName ls{{ page.machine_version }}.tacc.utexas.edu
    User <USERNAME>
    HostKeyAlias ls{{ page.machine_version }}.tacc.utexas.edu
    HostbasedAuthentication no
```
replacing `<USERNAME>` with your {{ page.machine_name }}{{ page.machine_version }} username. Then, you can `ssh` to {{ page.machine_name }}{{ page.machine_version }} with,
```sh
ssh lonestar
```

### Password-less SSH
{% include ssh_public_key_authentication.md %}

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bash_login`:
```sh
export ISSM_DIR=<PATH_TO_ISSM>
source $ISSM_DIR/etc/environment.sh

module load intel/18.0.2
module load gsl
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to. Then, run,
```sh
source ~/.bashrc
```
or log out and log back in to apply this change.

## Installing ISSM on {{ page.machine_name }}
{{ page.machine_name }} will *only* be used to run the code: you will use your local machine for pre- and post-processing; you will never use {{ page.machine_name }}' MATLAB.

Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- petsc    (use the latest available version for {{ page.machine_name }})
- m1qn3

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-debugging \
    --enable-development \
    --enable-standalone-libraries \
    --with-wrappers=no \
    --with-vendor="intel-lonestar" \
    --with-fortran-lib="-L/opt/apps/gcc/6.3.0/lib64/ -lgfortran -L/opt/intel/compilers_and_libraries_2018.2.199/linux/compiler/lib/intel64/ -lifcore -lifport" \
    --with-mpi-include="/opt/cray/pe/mpt/7.7.3/gni/mpich-intel/16.0/include/" \
    --with-mpi-libflags="-L/opt/cray/pe/mpt/7.7.3/gni/mpich-intel/16.0/lib/ -lmpich" \
    --with-mkl-libflags="-L${TACC_MKL_LIB} -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install"
```

## Installing ISSM with Dakota on {{ page.machine_name }}
For Dakota to run, you you will still need to compile PETSc, and m1qn3. You will need to install the following *additional* packages in order:
- boost (use the {{ page.machine_name }} script)
- dakota (use the {{ page.machine_name }} script)

Use the following configuration script (adapt to your needs, making sure to *not* include `--with-petsc-dir`),
```sh
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-debugging \
    --enable-development \
    --enable-standalone-libraries \
    --with-wrappers=no \
    --with-vendor="intel-lonestar" \
    --with-fortran-lib="-L/opt/apps/gcc/6.3.0/lib64/ -lgfortran -L/opt/intel/compilers_and_libraries_2018.2.199/linux/compiler/lib/intel64/ -lifcore -lifport" \
    --with-mpi-include="/opt/cray/pe/mpt/7.7.3/gni/mpich-intel/16.0/include/" \
    --with-mpi-libflags="-L/opt/cray/pe/mpt/7.7.3/gni/mpich-intel/16.0/lib/ -lmpich" \
    --with-mkl-libflags="-L${TACC_MKL_LIB} -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-boost-dir="${ISSM_DIR}/externalpackages/boost/install" \
    --with-dakota-dir="${ISSM_DIR}/externalpackages/dakota/install"
```

## Cluster Class Settings
In order to connect to {{ page.machine_name }} from the machine that you are doing model setup and results analysis on, you will need to create a cluster class settings file for your chosen scripting interface.
<div class="issm-api-tabs">
<div class="tab" data-api="mat" markdown="1">
Create `$ISSM_DIR/src/m/lonestar_settings.m`, which might include,
```matlab
cluster.login='<USERNAME>';
cluster.codepath='<PATH_TO_ISSM_ON_CLUSTER>/bin/';
cluster.executionpath='<PATH_TO_ISSM_ON_CLUSTER>/bin/execution';
```
</div>
<div class="tab" data-api="py" markdown="1">
Cluster class `lonestar.py` still needs to be developed.
</div>
</div>
replacing `<USERNAME>` with your TACC username and entering your code path and execution path. These settings will be picked up automatically when you run `md.cluster=lonestar()`.

Note that the `executionpath' creates temporary binary files that can be removed once the job is complete. For this reason, you can set the path to be somewhere on the $SCRATCH filesystem, which provides unlimited temporary storage on {{ page.machine_name }}{{ page.machine_version }}.

## Running Jobs on {{ page.machine_name }}
On {{ page.machine_name }}, each node has 24 cores and you can use any multiple of 24 for the total number of processors. The more nodes and the longer the requested time, the more you will have to wait in the queue, so choose your settings wisely. For example, use,
<div class="issm-api-tabs">
<div class="tab" data-api="mat" markdown="1">
```matlab
md.cluster=lonestar('numnodes',2,'cpuspernode',12);
```
</div>
<div class="tab" data-api="py" markdown="1">
Cluster class `lonestar.py` still needs to be developed.
</div>
</div>
to have a job with 2 nodes and 12 CPUs per node for a total of 24 cores.

Before you run your job, make sure to open a port first and enter the port number in `md.cluster`. Here is a handy alias,
```sh
alias ls{{ page.machine_version }}tunnel='ssh -L 1099:localhost:22 ls{{ page.machine_version }}'
```
This will open port number 1099 that you can then use in ISSM so that you don't need to enter your password.

To submit a job on {{ page.machine_name }}, run,
```matlab
sbatch job.queue
```

If you want to check the status of your job and the node you are using on {{ page.machine_name }}, run,
```sh
showq -u <USERNAME>
```
replacing `<USERNAME>` with your TACC username.

You can delete a job manually with,
```sh
scancel <JOBID>
```
where `<JOBID>` is the ID of the job indicated in the MATLAB session. MATLAB also indicates the directory where you job is running, which contains the files `<JOBNAME>.outlog` and `<JOBNAME>.errlog`. The `outlog` file contains any information that would appear if you were running your job on your local machine and the `errlog` file contains any information pertaining to errors that the job encounters.

## Running PINNICLE on {{ page.machine_name }}
{{ page.machine_name }} supports containers with [Apptainer](https://apptainer.org){:target="_blank"}. A precompiled image with Tensorflow v.2 backend is available at `docker://chenggongdartmouth/pinnicle_ls6:v0.1`.

You need to build this apptainer image from the Docker image on {{ page.machine_name }}. First, create an interactive session in {{ page.machine_name }}' `gpu-a100-dev` or `gpu-a100`  queue,
```sh
idev -t 1:00:00 -N 1 -n 4 -p gpu-a100-dev
```
You will need to load the `cuda` and `apptainer` modules with,
```sh
module load cuda/11.4 cudnn/8.2.4 nccl/2.11.4
module load tacc-apptainer
```

`cd` to your `<YOUR_WORKING_PATH>` directory on {{ page.machine_name }}, which should look something like `/work/xxxxx/<USERNAME>/ls{{ page.machine_version }}`.

Build the apptainer image from the Docker image with `--nv`,
```sh
apptainer build --nv <YOUR_WORKING_PATH>/<YOUR_IMAGE_NAME> docker://chenggongdartmouth/pinnicle_ls6:v0.1
```

After building the image, you can run it with,
```sh
apptainer shell --nv <YOUR_WORKING_PATH>/<YOUR_IMAGE_NAME>
```

You can also submit a job in the queue with,
```sh
#!/bin/bash

#SBATCH -J job_name           # job name
#SBATCH -o output.%j          # output file named, output.jobID
#SBATCH -e error.%j           # error file named, error.jobID
#SBATCH -p gpu-a100           # queue name
#SBATCH -N 1                  # number of nodes requested
#SBATCH --ntasks-per-node 4   # tasks per node
#SBATCH -t 10:00:00           # time, hh:mm:ss
#SBATCH --mail-user=<EMAIL_ADDRESS>
#SBATCH --mail-type=all

module load cuda/11.4 cudnn/8.2.4 nccl/2.11.4
module load tacc-apptainer
apptainer exec --nv <YOUR_WORKING_PATH>/<YOUR_IMAGE_NAME> python test.py
```
