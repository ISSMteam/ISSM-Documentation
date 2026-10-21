---
title: Frontera
layout: default
parent: TACC
machine_name: "Frontera"
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
Host frontera.tacc.utexas.edu frontera
     HostName frontera.tacc.utexas.edu
     User <USERNAME>
```
replacing `<USERNAME>` with your TACC username. Then, you can `ssh` to {{ page.machine_name }} with,
```sh
ssh frontera
```

Make sure to also include the following in your `~/.ssh/config`,
```sh
Host *
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h-%p
    ControlPersist yes
```
which will allow you to use an existing SSH connection for multiple sessions. As long as you have an active connection, SSH will not need a password or token to create a new session. You may need to run `mkdir ~/.ssh/sockets` if this directory does not exist.

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc` or `~/.bash_login`:
```sh
export ISSM_DIR=<PATH_TO_ISSM>
source $ISSM_DIR/etc/environment.sh
module load intel/23.1.0
module load impi/21.9.0
module load petsc/3.21
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to. Then, run,
```sh
source ~/.bashrc
```
or
```sh
source ~/.bash_login
```
(depending on which shell profile file you modified) or log out and log back in to apply this change.

## Installing ISSM on {{ page.machine_name }}
{{ page.machine_name }} will *only* be used to run the code: you will use your local machine for pre- and post-processing; you will never use {{ page.machine_name }}' MATLAB. You can check out ISSM and install the following packages:
- m1qn3

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
export CC=mpicc
export CXX=mpicxx
export FC=mpifort
export CXXFLAGS="-g -O3 -std=c++11 -fp-model=precise"

./configure \
    --prefix="${ISSM_DIR}" \
    --enable-debugging \
    --enable-development \
    --with-wrappers=no \
    --with-mpi-include="${TACC_IMPI_INC}" \
    --with-mpi-libflags="-L${TACC_IMPI_LIB}/release_mt -lmpi -lmpifort -lifcore" \
    --with-mkl-libflags="-L${TACC_MKL_LIB} -qmkl=parallel" \
    --with-petsc-dir="${TACC_PETSC_DIR}" \
    --with-petsc-arch="${ISSM_ARCH}" \
    --with-metis-dir="${TACC_PETSC_DIR}" \
    --with-mumps-dir="${TACC_PETSC_DIR}" \
    --with-scalapack-dir="${TACC_PETSC_DIR}" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install"
```

## Installing ISSM with CoDiPack (AD) on {{ page.machine_name }}
You will need to install the following *additional* packages in order:
- codipack
- medipack

Use the following configuration script (adapt to your needs, making sure to *not* include `--with-petsc-dir`),
```sh
export CC=mpicc
export CXX=mpicxx
export FC=mpifort
export CXXFLAGS="-g -O3 -std=c++11 -fp-model=precise"

./configure \
    --prefix="${ISSM_DIR}" \
    --enable-debugging \
    --enable-development \
    --enable-tape-alloc \
    --with-wrappers=no \
    --without-kriging \
    --without-kml \
    --without-Love \
    --without-Sealevelchange \
    --with-mpi-include="${TACC_IMPI_INC}" \
    --with-mpi-libflags="-L${TACC_IMPI_LIB}/release_mt -lmpi -lmpifort -lifcore" \
    --with-mkl-libflags="-L${TACC_MKL_LIB} -qmkl=parallel -lptscotchparmetisv3 -lptscotch -lptscotcherr -lscotch -lscotcherr -lptesmumps -lscalapack" \
    --with-metis-dir="${TACC_PETSC_DIR}" \
    --with-mumps-dir="${TACC_PETSC_DIR}" \
    --with-parmetis-dir="${TACC_PETSC_DIR}" \
    --with-codipack-dir="${ISSM_DIR}/externalpackages/codipack/install" \
    --with-medipack-dir="${ISSM_DIR}/externalpackages/medipack/install" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install"
```

## Installing ISSM with MATLAB on {{ page.machine_name }}
If you want to use {{ page.machine_name }} to process the model after running it and keep the data  on {{ page.machine_name }}, you can install ISSM with a MATLAB interface. Before doing the following steps, you should [check with TACC to make sure you have the access to MATLAB](https://docs.tacc.utexas.edu/software/matlab/){:target="_blank"} on {{ page.machine_name }}.

You will need to [use interactive mode](https://docs.tacc.utexas.edu/software/idev/){:target="_blank"} to compile ISSM with MATLAB.

Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- triangle
- m1qn3

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-debugging \
    --enable-development \
    --with-matlab-dir="/home1/apps/matlab/2023a/" \
    --with-mpi-include="${TACC_IMPI_INC}" \
    --with-mpi-libflags="-L${TACC_IMPI_LIB}/release_mt -lmpi" \
    --with-mkl-libflags="-L${TACC_MKL_LIB} -mkl=parallel" \
    --with-petsc-dir="${TACC_PETSC_DIR}" \
    --with-petsc-arch="${ISSM_ARCH}" \
    --with-metis-dir="${TACC_PETSC_DIR}/${PETSC_ARCH}" \
    --with-mumps-dir="${TACC_PETSC_DIR}/${PETSC_ARCH}" \
    --with-scalapack-dir="${TACC_PETSC_DIR}/${PETSC_ARCH}" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
    --with-triangle-dir="${ISSM_DIR}/externalpackages/triangle/install"
```

You will need to compile ISSM serially with `make install`.

Remember, {{ page.machine_name }} is a remote cluster, use `matlab -nodesktop -nosplash -r "addpath $ISSM_DIR/src/m/dev; devpath;` when running MATLAB.

Before downloading the `.outbin`, you will need to set
```matlab
md.cluster.name = oshostname()
md.miscellaneous.name = '<OUTBIN_FILENAME>'
```
then run,
```matlab
md=loadresultsfromcluster(md, 'runtimename', '<EXECUTION_DIR>')
```
to load the results.

## Cluster Class Settings

### MATLAB
Create file `$ISSM_DIR/src/m/frontera_settings.m` on the machine that you are doing model setup and results analysis on. This file will set up your personal settings so that that machine can send solution requests to {{ page.machine_name }} and retrieve results. For example, this file might include,
```matlab
cluster.login='<USERNAME>';
cluster.codepath='<PATH_TO_ISSM_ON_CLUSTER>/bin/';
cluster.executionpath='<PATH_TO_ISSM_ON_CLUSTER>/execution/';
```
replacing `<USERNAME>` with your TACC username and entering your code path and execution path. These settings will be picked up automatically by MATLAB when you run `md.cluster=frontera()`.

Note that the `executionpath' creates temporary binary files that can be removed once the job is complete. For this reason, you can set the path to be somewhere on the $SCRATCH filesystem, which provides unlimited temporary storage on {{ page.machine_name }}.

## Running Jobs on {{ page.machine_name }}
On {{ page.machine_name }}, each node has 56 cores and you can use any multiple of 56 for the total number of processors. he more nodes and the longer the requested time, the more you will have to wait in the queue, so choose your settings wisely.

The most commonly used queues are `normal`, `development`, and `flex`. [More details on {{ page.machine_name }}' queues](https://docs.tacc.utexas.edu/hpc/frontera/#queues){:target="_blank"}.

{: .highlight-title }
> Note
>
> In order to use `normal` queue, you will have to request at least `3` nodes.

For example, use,
```matlab
md.cluster=frontera('numnodes',3);
```

Before you run your job, make sure to have an active open SSH connection to {{ page.machine_name }} so that you don't need to enter your password.

To manually submit a job on {{ page.machine_name }}, run,
```sh
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

## Using DeepXDE
{{ page.machine_name }} supports containers with [Apptainer](https://apptainer.org){:target="_blank"}. A precompiled DeepXDE image with Tensorflow v.2` backend is available at `docker://chenggongdartmouth/deepxde:v1.2` or at `docker://mkrish234/deepxde:v0.3`.

You might need to build an apptainer image from the Docker image in {{ page.machine_name }}. First find the path to your login node on {{ page.machine_name }} with `pwd`. Then, allocate a compute node with,
```sh
idev -m 60 -p rtx -N 1 -n 8
```

You will need to load the `apptainer` module with,
```sh
module load tacc-apptainer
```

Then, build the apptainer image from the Docker image with,
```sh
apptainer build <PATH_TO_LOGIN_NODE>/deepxde docker://<DOCKER_IMAGE>
```

The following is an example of using DeepXDE to run a script`./test.py` on {{ page.machine_name }} (with GPU node),
```sh
#!/bin/bash
#SBATCH -J job_name           # job name
#SBATCH -o output.%j          # output file named, output.jobID
#SBATCH -e error.%j           # error file named, error.jobID
#SBATCH -p rtx                # queue name
#SBATCH -N 1                  # number of nodes requested
#SBATCH --ntasks-per-node 4   # tasks per node
#SBATCH -t 10:00:00           # time, hh:mm:ss
#SBATCH --mail-user=<EMAIL_ADDRESS>
#SBATCH --mail-type=all

module load tacc-apptainer
stdbuf -i0 -o0 -e0 apptainer exec --nv --bind ~/:/mnt ~/deepxde python -u /mnt/test.py
```
