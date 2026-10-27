---
title: Andes
layout: default
parent: Dartmouth
machine_name: "Andes"
has_toc: false
---

# {{ page.machine_name }} (Dartmouth Research Computing)
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
----

## Getting an Account
To [request a Dartmouth HPC account](https://dashboard.dartmouth.edu/research/hpc_account){:target="_blank"} you will need a Dartmouth NetID. If applicable, make sure you are added to the ICE DartFS Lab share and the `ice` Slurm account and ask that the `ice` Slurm account be made the default for your HPC account.

## SSH Configuration
Add the following lines to `~/.ssh/config` on your local machine,
```sh
Host andes andes8.dartmouth.edu
    Hostname andes8.dartmouth.edu
    User <USERNAME>
    GSSAPIAuthentication yes
    GSSAPIDelegateCredentials yes
```
replacing `<USERNAME>` with your {{ page.machine_name }} username (which should be your Dartmouth NetID). Then, you can `ssh` to {{ page.machine_name }} with,
```sh
ssh andes
```

### Password-less SSH
[Dartmouth *officially* suggests using `GSSAPI` for password-less SSH access](https://services.dartmouth.edu/TDClient/1806/Portal/KB/ArticleDet?ID=89203){:target="_blank"}.

On your local machine, run,
```sh
kinit -f -l 7d <USERNAME>@KIEWIT.DARTMOUTH.EDU
```
replacing `<USERNAME>` with your Dartmouth NetID. `-l 7d` requests a ticket with a 7-day lifetime; adjust this option as needed. Enter your Dartmouth NetIS password when prompted. Subsequent SSH connections to {{ page.machine_name }} will not require a password.

### Troubleshooting
If you can't log in anymore (or if you get an error message about wrong permission for your home directory), you will need to destroy all active Kerberos authorization tickets. To do this:
- Connect to {{ page.machine_name }}: ```ssh NetID@andes8.dartmouth.edu```
- Once on {{ page.machine_name }} (even with the error thrown), do: ```kdestroy -A```
- Exit out of {{ page.machine_name }}, go back to your ```~/.ssh/config``` and comment out the GSSAPI lines with a ```#```
- On your local computer (or Totten, whichever you're using) run: ```kdestroy -A```
- Now try to `ssh` to {{ page.machine_name }} again with your password and it should work!

In some instances, the return key produces `^M` and the password cannot be entered. If this happens, run,
```sh
stty sane
```

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc`,
```sh
export ISSM_DIR=<PATH_TO_ISSM>
source $ISSM_DIR/etc/environment.sh

# Load modules
module purge
module load cmake/3.23.2
module load intel-compilers/23.2
module load mkl/19.3
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

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
export CC=mpicc
export CXX=mpicxx
export FC=mpifort
export CXXFLAGS="-g -O3 -std=c++11 -fp-model=precise"
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --with-wrappers=no \
    --with-mpi-include="${ISSM_DIR}/externalpackages/petsc/install/include" \
    --with-mpi-libflags="-L${ISSM_DIR}/externalpackages/petsc/install/lib -lmpi -lmpifort -lifcore" \
    --with-mkl-libflags="${MKL_LIB}" \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install"
```
It is highly recommended to use batch or interactive job to compile ISSM since the login node has very limited computational resources. 

To request resources for an interactive job,
```sh
srun --nodes=1 --ntasks-per-node=16 --pty /bin/bash
```

## Installing ISSM with CoDiPack (AD) on {{ page.machine_name }}
You will need to install the following *additional* packages in order:
- codipack
- medipack
- adjointpetsc   (use the {{ page.machine_name }} script)

Use the following configuration script (adapt to your needs, making sure to *not* include `--with-petsc-dir`),
```sh
export CC=mpicc
export CXX=mpicxx
export FC=mpifort
export CXXFLAGS="-g -O2 -fPIC -std=c++11 -DCODI_ForcedInlines -fp-model=precise"
export LDFLAGS="-L/optnfs/common/intel/compilers_and_libraries_2023.2.0/compiler/2023.2.0/linux/compiler/lib/intel64_lin/ -lifcoremt"

./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --enable-debugging \
    --enable-tape-alloc \
    --with-wrappers=no \
    --without-kriging \
    --without-Love \
    --without-Sealevelchange \
    --with-mpi-include="${ISSM_DIR}/externalpackages/petsc/install/include" \
    --with-mpi-libflags="-L${ISSM_DIR}/externalpackages/petsc/install/lib -lmpi -lmpifort"\
    --with-fortran-lib="-L/usr/lib64/ -lgfortran" \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-adjointpetsc-dir="${ISSM_DIR}/externalpackages/adjointpetsc/install" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-parmetis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-blas-lapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-codipack-dir="${ISSM_DIR}/externalpackages/codipack/install" \
    --with-medipack-dir="${ISSM_DIR}/externalpackages/medipack/install"
```

## Cluster Class Settings
In order to connect to {{ page.machine_name }} from the machine that you are doing model setup and results analysis on, you will need to create a cluster class settings file for your chosen scripting interface.
<div class="issm-api-tabs">
<div class="tab" data-api="mat" markdown="1">
Create `$ISSM_DIR/src/m/andes_settings.m`, which might include,
```matlab
cluster.login='<USERNAME>';
cluster.codepath='<PATH_TO_ISSM_ON_CLUSTER>/bin/';
cluster.executionpath='<PATH_TO_ISSM_ON_CLUSTER>/execution/';
```
</div>
<div class="tab" data-api="py" markdown="1">
Cluster class `andes.py` still needs to be developed.
</div>
</div>
replacing `<USERNAME>` with your Dartmouth NetID and entering your code path and execution path. These settings will be picked up automatically when you run `md.cluster=andes()`.

The file system on {{ page.machine_name }} is called DartFS (or DarFS-hpc). Your home directory on DartFS is only 50GB, so it is better to use the lab folder, which has 1TB,
```sh
/dartfs/rc/lab/I/ICE/yourpath/
```
More about [Research Computing accounts](https://services.dartmouth.edu/TDClient/1806/Portal/KB/Article/64619/Research-Computing-Accounts){:target="_blank"}.

## Running jobs on {{ page.machine_name }}
On {{ page.machine_name }}, you can use up to 64 cores per node. The more nodes and the longer the requested time, the more you will have to wait in the queue, so choose your settings wisely. For example, use,
<div class="issm-api-tabs">
<div class="tab" data-api="mat" markdown="1">
```matlab
md.cluster=discovery('numnodes',1,'cpuspernode',8);
```
</div>
<div class="tab" data-api="py" markdown="1">
Cluster class `andes.py` still needs to be developed.
</div>
</div>
to have a job of 8 cores on one node.

More about [cluster details](https://services.dartmouth.edu/TDClient/1806/Portal/KB/ArticleDet?ID=134058){:target="_blank"} (requires Dartmouth NetID).

Each node has it's own time limit for jobs that are being run from the queue, but they tend to be 10 or 30 days. You can find the time limit of each node on {{ page.machine_name }} by running,
```sh
sinfo
```

If you are running something interactively on {{ page.machine_name }}, there may be a credential limit for the DartFS system of 10 hours. More about [Dart FS system](https://services.dartmouth.edu/TDClient/1806/Portal/KB/ArticleDet?ID=76691){:target="_blank"} (requires Dartmouth NetID).

If you want to check the status of your job and the node you are using on {{ page.machine_name }}, run,
```sh
squeue -u <USERNAME>
```
replacing `<USERNAME>` with your Dartmouth NetID.

You can delete a job manually with,
```sh
scancel <JOBID>
```
where `<JOBID>` is the ID of the job indicated in the MATLAB session. MATLAB also indicates the directory where you job is running, which contains the files `<JOBNAME>.outlog` and `<JOBNAME>.errlog`. The `outlog` file contains any information that would appear if you were running your job on your local machine and the `errlog` file contains any information pertaining to errors that the job encounters.

If you want to load results from the cluster manually (for example if you have an error due to a connection interruption), inspect your MATLAB session, using `$ISSM_DIR/execution/<LAUNCHSTRING>/<JOBNAME>.lock` to populate and run,
```matlab
md=loadresultsfromcluster(md,'<LAUNCHSTRING>','<JOBNAME>');
```

{: .note-title }
> Note
>
> In the case where `md.settings.waitonlock > 0` and you need to load manually (e.g., connection interruption), it is necessary to set `md.private.runtimename=<LAUNCHSTRING>;` *before* calling `loadresultsfromcluster`.

## Other Notes About Running on {{ page.machine_name }}

If you want to use more than one node (not recommended), the current (temporary) solution is to:
1. start the job
2. go to {{ page.machine_name }} and see which nodes discovery is using (see `squeue` usage below)
3. cancel the job (see `scancel` usage below)
4. find the `.queue` script for your run and manually edit the start of the `mpirun` command to look like,
```sh
mpirun -n 40 --hosts <NODELIST>
```
where `<NODELIST>` is the list of nodes separated by commas (e.g., `q03,q09`).
5. restart your run with,
```sh
sbatch <FILENAME>.queue
```
If you do not do this, your job will will run on just one node.

To get more information about your job while it's running, `ssh` from {{ page.machine_name }} to the node given by `squeue -u <USERNAME>` and then run `htop`. Once in `htop`, if you want to see information for a specific user, type `u` and then start typing the user ID until the correct one is highlighted and hit ENTER. 
You can also get more information about a job by entering,
```sh
scontrol show job <JOBID>
```

There may be several reasons for a job being in the queue for a long time. First, try reducing the amount of time you're requesting. Another thing to try is to add the following line to your `<run_name>.queue` file and restarting your job,
```sh
#SBATCH --partition preemptable
```
This may give you access to some idle nodes, but note that your job can be stopped if a higher priority job wants your resources.

## slurm
[A comparison of PBS to `slurm` commands](https://slurm.schedmd.com/rosetta.pdf){:target="_blank"}.

[Overview of `slurm`](https://services.dartmouth.edu/TDClient/1806/Portal/KB/ArticleDet?ID=132625){:target="_blank"} (requires Dartmouth NetID).

Useful commands:
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

## Running jobs with GPUs
{{ page.machine_name }} has 12 GPU nodes: g01-g12. To submit a job to these nodes, you will need to specify,
```sh
#SBATCH --partition gpuq
#SBATCH --gres=gpu:1
```
where `1` means to use 1 GPU.
