---
title: Sherlock
layout: default
parent: Other HPCs
machine_name: "Sherlock"
has_toc: false
---

# {{ page.machine_name }} (Stanford University)
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

## Getting an Account
To [request a Sherlock HPC account](https://www.sherlock.stanford.edu/){:target="_blank"} you will need a SUNet ID and the SUNet ID of a sponsoring faculty member.

## SSH Configuration
Add the following lines to `~/.ssh/config` on your local machine,
```sh
Host sherlock login.sherlock.stanford.edu
    ControlMaster auto
    ControlPersist yes
    ControlPath ~/.ssh/%l%r@%h:%p
    HostName login.sherlock.stanford.edu
    User <USERNAME>
```
replacing `<USERNAME>` with your {{ page.machine_name }} username. Then, you can `ssh` to {{ page.machine_name }} with,
```sh
ssh sherlock
```

To run ISSM on {{ page.machine_name }}, make sure you first establish an SSH connection to {{ page.machine_name }} from your local machine. That way, ISSM will not require you to enter your password every time a job is submitted or downloaded. Make sure your local machine's hostname is not too long otherwise this may not work. This may happen when, for example, you use a WiFi connection. In this case, you can force your hostname manually on your local machine with,
```sh
sudo hostname <HOSTNAME>
```
where `<HOSTNAME>` is a valid hostname of your choosing.

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc`:
```sh
export ISSM_DIR=<PATH_TO_LOCAL_COPY_OF_ISSM>
source $ISSM_DIR/etc/environment.sh

# Load modules
module load system subversion
module load impi/2019
module load imkl/2019
```
then, run,
```sh
source ~/.bashrc
```
or log out and log back in to apply this change.

## Installing ISSM on {{ page.machine_name }}
Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- autotools
- petsc        (use the {{ page.machine_name }} script)
- m1qn3

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-debugging \
    --with-numthreads=16 \
    --with-wrappers=no \
    --with-kml=no \
    --with-bamg=no \
    --with-mpi-include="/share/software/user/restricted/impi/2019/compilers_and_libraries_2019.0.117/linux/mpi/intel64/include" \
    --with-mpi-libflags="-L/data/apps/mpi/openmpi-1.8.3/gcc/4.8.3/lib -lmpicxx -lmpifort -lmpi" \
    --with-fortran-lib="-L/usr/lib/gcc/x86_64-redhat-linux/4.8.5/ -lgfortran" \
    --with-mkl-libflags="-L/share/software/user/restricted/imkl/2019/mkl/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/metis/install" \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}externalpackages/petsc/install"
```

## Cluster Class Settings

### MATLAB
Create file `$ISSM_DIR/src/m/sherlock_settings.m` on the machine that you are doing model setup and results analysis on. This file will set up your personal settings so that that machine can send solution requests to {{ page.machine_name }} and retrieve results. For example, this file might include,
```matlab
cluster.login='<USERNAME>';
cluster.codepath='<PATH_TO_ISSM_ON_CLUSTER>/bin/';
cluster.executionpath='<PATH_TO_ISSM_ON_CLUSTER>/execution/';
```
replacing `<USERNAME>` with your {{ page.machine_name }} username and `<PATH_TO_ISSM_ON_SHERLOCK>` to path to your ISSM installation on {{ page.machine_name }}. These settings will be picked up automatically by MATLAB when you run `md.cluster=sherlock()`.

## Running jobs on {{ page.machine_name }}
On {{ page.machine_name }}, you can use up to 48 cores per node (partition `ilg2.3`). The more nodes and the longer the requested time, the more you will have to wait in the queue. Also, you can only request up to 125GB of RAM per job, so choose your settings wisely. For example, use,
```matlab
md.cluster=sherlock('numnodes',1,'cpuspernode',8);
md.cluster.time=10;
```
to have a maximum job time of 10 minutes and 8 cores on one node. If the run lasts longer than 10 minutes, it will be killed and you will not be able to retrieve your results.

If you want to check the status of your job and the node you are using on {{ page.machine_name }}, run,
```sh
squeue -u <USERNAME>
```
replacing `<USERNAME>` with your {{ page.machine_name }} username.

You can delete a job manually with,
```sh
scancel <JOBID>
```
where `<JOBID>` is the ID of the job indicated in the MATLAB session. MATLAB also indicates the directory where you job is running, which contains the files `<JOBNAME>.outlog` and `<JOBNAME>.errlog`. The `outlog` file contains any information that would appear if you were running your job on your local machine and the `errlog` file contains any information pertaining to errors that the job encounters.

If you want to load results from the cluster manually (for example if you have an error due to a connection interruption), inspect your MATLAB session, using `$ISSM_DIR/execution/<LAUNCHSTRING>/<JOBNAME>.lock` to populate and run,
```matlab
md=loadresultsfromcluster(md,'<LAUNCHSTRING>','<JOBNAME>');
```

NOTE: In the case where `md.settings.waitonlock > 0` and you need to load manually (e.g., connection interruption), it is necessary to set `md.private.runtimename=<LAUNCHSTRING>;` *before* calling `loadresultsfromcluster`.

## slurm
[A comparison of PBS to `slurm` commands](https://slurm.schedmd.com/rosetta.pdf){:target="_blank"}.

Useful commands:
- Graphical overview of {{ page.machine_name }}' usage,
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

- Get information on a partition (for example, `ilg2.3`)
```sh
scontrol show partition=ilg2.3
```

- Get information on a partition (for example, `ilg2.3`)
```sh
squeue  | grep -i ilg2.3 | awk '{print $4}' | sort | uniq -c | sort -rn
```
