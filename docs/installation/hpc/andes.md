---
title: Andes (Dartmouth RC)
layout: default
parent: High-Performance Computing (HPC)
---

# Andes (Dartmouth RC)
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----


## Getting an account
Go to <a href="https://dashboard.dartmouth.edu/research/hpc_account" target="_blank">
  the Dartmouth Research Computing Accounts page.
</a>


you will need a Dartmouth NetID. If applicable, make sure you are added to the ICE DartFS Lab share and the ice Slurm account. Ask to make the ice Slurm account your default.

## ssh configuration
You can add the following lines to `~/.ssh/config` on your local machine:

```sh
Host andes andes8.dartmouth.edu
   Hostname andes8.dartmouth.edu
   User USERNAME
   GSSAPIAuthentication yes
   GSSAPIDelegateCredentials yes
```
and replace `USERNAME` by your Dartmouth NetID. Once this is done, you can ssh Andes by simply doing:

```
ssh andes
```

## Password-less ssh

Andes officially suggests using GSSAPI for passwordless access, see ​here.

On your local machine, you will need to enter:
```sh
kinit -f -l 7d username@KIEWIT.DARTMOUTH.EDU
```
with your NetID at username and the password for NetID to request a ticket for 7 days (or any time period you need), then you can use ssh andes without entering a password.

If you can't log in anymore (or if you get weird error messages saying that permissions to access your home directory are denied), you will need to destroy all active Kerberos authorization tickets. To do this:

- Connect to discovery8: ```ssh NetID@discovery8.dartmouth.edu```
- Once on discovery8 (even with the error thrown), do: ```kdestroy -A```
- exit out of discovery8, go back to your ```~/.ssh/config``` and comment out the GSSAPI lines with a ```#```
- on your computer (or totten, whichever you're using) run: ```kdestroy -A```
- Now try to ```ssh``` into discovery8 again with your password and it should work!

## Environment
On Andes, add the following lines to ```~/.bashrc```:

```sh
export ISSM_DIR=PATHTODIR
source $ISSM_DIR/etc/environment.sh

#load modules
module purge
module load module load cmake/3.23.2
module load intel-compilers/23.2
module load mkl/19.3
```

Use:
```sh
source ~/.bashrc
```
or Log out and log back in to apply this change.

Installing ISSM on Andes
Andes will only be used to run the code, you will use your local machine for pre and post-processing, you will never use Andes's MATLAB. You can check out ISSM and install the following packages:

- PETSc 3.23 (use the andes script, `install-3.23-andes.sh`)
- m1qn3

Use the following configuration script (adapt to your needs):

```sh
export CC=mpicc
export CXX=mpicxx
export FC=mpifort
export CXXFLAGS="-g -O3 -std=c++11 -fp-model=precise"
./configure \
   --prefix=$ISSM_DIR \
   --with-wrappers=no \
   --with-petsc-dir="$ISSM_DIR/externalpackages/petsc/install" \
   --with-m1qn3-dir="$ISSM_DIR/externalpackages/m1qn3/install" \
   --with-mpi-include="$ISSM_DIR/externalpackages/petsc/install/include" \
   --with-mpi-libflags="-L$ISSM_DIR/externalpackages/petsc/install/lib -lmpi -lmpifort -lifcore"\
   --with-metis-dir="$ISSM_DIR/externalpackages/petsc/install" \
   --with-mkl-libflags="$MKL_LIB" \
   --with-scalapack-dir="$ISSM_DIR/externalpackages/petsc/install" \
   --with-mumps-dir="$ISSM_DIR/externalpackages/petsc/install" \
   --enable-development
```

It is highly recommended to use batch or interactive job to compile ISSM, since the login node has very limited computational resources.

To request resources for an interactive job:

```sh
srun --nodes=1 --ntasks-per-node=16 --pty /bin/bash
```

## Installing ISSM with CoDiPack (AD) on Andes
You will need to install the following additional packages in the below order:

- codipack
- medipack
- adjointpetsc (use the andes script, `install-andes.sh`)

Use the following configuration script:

```sh
export CC=mpicc
export CXX=mpicxx
export FC=mpifort
export CXXFLAGS="-g -O2 -fPIC -std=c++11 -DCODI_ForcedInlines -fp-model=precise"
export LDFLAGS="-L/optnfs/common/intel/compilers_and_libraries_2023.2.0/compiler/2023.2.0/linux/compiler/lib/intel64_lin/ -lifcoremt"
./configure \
   --prefix=$ISSM_DIR \
   --with-wrappers=no \
   --without-kriging \
   --without-Love \
   --without-Sealevelchange \
   --with-m1qn3-dir="$ISSM_DIR/externalpackages/m1qn3/install" \
   --with-mpi-include="$ISSM_DIR/externalpackages/petsc/install/include" \
   --with-mpi-libflags="-L$ISSM_DIR/externalpackages/petsc/install/lib -lmpi -lmpifort"\
   --with-petsc-dir="$ISSM_DIR/externalpackages/petsc/install" \
   --with-adjointpetsc-dir="$ISSM_DIR/externalpackages/adjointpetsc/install" \
   --with-metis-dir="$ISSM_DIR/externalpackages/petsc/install" \
   --with-parmetis-dir="$ISSM_DIR/externalpackages/petsc/install" \
   --with-blas-lapack-dir="$ISSM_DIR/externalpackages/petsc/install" \
   --with-scalapack-dir="$ISSM_DIR/externalpackages/petsc/install" \
   --with-mumps-dir="$ISSM_DIR/externalpackages/petsc/install" \
   --with-codipack-dir="$ISSM_DIR/externalpackages/codipack/install" \
   --with-medipack-dir="$ISSM_DIR/externalpackages/medipack/install" \
   --with-fortran-lib="-L/usr/lib64/ -lgfortran" \
   --enable-tape-alloc \
   --enable-development \
   --enable-debugging
```

## andes_settings.m
You have to add a file in `$ISSM_DIR/src/m` entitled `andes_settings.m` with your personal settings on your local ism install:

```sph
cluster.login='yourNetID';
cluster.codepath='/dartfs/rc/lab/I/ICE/yourpath/trunk-jpl/bin/';
cluster.executionpath='/dartfs/rc/lab/I/ICE/yourpath/trunk-jpl/execution/';
```

use your NetID for the login and enter your code path and execution path. These settings will be picked up automatically by matlab when you do `md.cluster= andes()`

The file sytem on Andes is called DartFS (or DarFS-hpc). Your home directory on DartFS is only 50GB, it would be better to use the lab folder which has 1TB:

```sh
/dartfs/rc/lab/I/ICE/yourpath/
```

You can read more <a href="https://services.dartmouth.edu/TDClient/1806/Portal/KB/ArticleDet?ID=64619" target="_blank">
  here
</a>.


## Running jobs on Andes

On Andes, you can use up to 64 cores per node. The more nodes, memory, and the longer the requested time, the more you will have to wait in the queue. So choose your settings wisely:

```md.cluster = andes('numnodes',1,'cpuspernode',8);```

to have a job of 8 cores on one node.

See cluster details <a href="https://services.dartmouth.edu/TDClient/1806/Portal/KB/ArticleDet?ID=134058" target="_blank">
  here
</a>.

Each node has it's own time limit for jobs that are being run from the queue, but they tend to be 10 or 30 days. You can find the time limit of each node by entering on Andes:

```sh
sinfo
```

If you are running something interactively on Andes, there may be a credential limit for the DartFS system of 10 hours. Read more <a href="https://services.dartmouth.edu/TDClient/1806/Portal/KB/ArticleDet?ID=76691" target="_blank">
  here
</a>.


Now if you want to check the status of your job and the node you are using, type in the bash with the Andes session:

```sh
squeue -u username
```

You can delete your job manually by typing:
```sh
scancel JOBID
```

where ```JOBID``` is the ID of your job (indicated in the Matlab session). Matlab indicates too the directory of your job where you can find the files ```JOBNAME.outlog``` and ```JOBNAME.errlog```. The outlog file contains the information that would appear if you were running your job on your local machine and the errlog file contains the error information in case the job encounters an error.

If you want to load results from the cluster manually (for example if you have an error due to an internet interruption), you find in the information Matlab gave you ```$ISSM_DIR/execution/LAUNCHSTRING/JOBNAME.lock```, you copy the LAUNCHSTRING and you type in MATLAB:

```sh
md=loadresultsfromcluster(md,'LAUNCHSTRING','JOBNAME');
```
Obs.: in the case where md.settings.waitonlock>0 and you need to load manually (e.g., internet interruption), it is necessary to set md.private.runtimename=LAUNCHSTRING; before calling loadresultsfromcluster.

## Other notes about running on Andes

If you want to use more than one node (not recommended), the current (temporary) solution is to:

- start the job
- go to Andes and see which nodes andes is using (see squeue usage below)
- cancel the job (see scancel usage below)
- find the .queue script for your run and manually edit the start of the mpirun command to look like:
```sh
mpirun -n 40 --hosts $NODELIST
```
where `$NODELIST` is the list of nodes separated by commas (e.g., q03,q09).

- restart your run with:

```sh
sbatch <filename>.queue
```
If you do not do this, then your job will run on just one node.

To get more information about your job while it's running, from Andes you can ssh into the node given by ```squeue -u username``` and then run ``htop``. Once in htop, if you want to see information for a specific user, type ```u`` and then start typing the user ID until the correct one is highlighted and hit ENTER. You can also get more information about a job by entering:

```sh
scontrol show job JOBID
```

If your job is in the queue for a long time, there may be several reasons for this. First, try reducing the amount of time you're requesting. Another thing to try is to add the following line to your ```<run_name>.queue``` file and restarting your job:

```sh
#SBATCH --partition preemptable
```

This may give you access to some idle nodes, but note that your job can be stopped if a higher priority job wants your resources.

## slurm

A comparison of PBS to Slurm commands can be found
<a href="http://slurm.schedmd.com/rosetta.pdf" target="_blank">here</a>.

An overview of Slurm is found
<a href="https://services.dartmouth.edu/TDClient/1806/Portal/KB/ArticleDet?ID=132625" target="_blank">here</a>.


Useful commands:

Get number of idle nodes:

```sh
sinfo --states=idle
```
See jobs of <username>:
```sh
squeue -u <username>
```
Get more information on jobs of user:
```sh
sacct -u <username> --format=User,JobID,account,Timelimit,elapsed,ReqMem,MaxRss,ExitCode
```
## Running jobs with GPU
Andes has 12 GPU nodes: g01-g12. To submit a job to these nodes, you will need to specify with
```sh
#SBATCH --partition gpuq
#SBATCH --gres=gpu:1
```
where 1 means to use 1 GPU.
