---
title: Vilje
layout: default
parent: Sigma2
machine_name: "Vilje"
nav_order: 4
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
> {{ page.machine_name }} was decommissioned in 2021. Documentation is maintained here in case it helps installation on [Sigma2 HPC systems in production](www.sigma2.no/hpc-and-storage-systems){:target="_blank"}.
>

## Getting an Account
[Apply for a Sigma2 account](https://www.sigma2.no/how-apply-user-account){:target="_blank"}.

## SSH Configuration
Add the following lines to `~/.ssh/config` on your local machine,
```sh
Host vilje vilje.hpc.ntnu.no
    HostName vilje.hpc.ntnu.no
    User <USERNAME>
```
replacing `<USERNAME>` with your {{ page.machine_name }} username (which should be your Sigma2 username). Then, you can `ssh` to {{ page.machine_name }} with,
```sh
ssh vilje
```

### Password-less SSH
{% include ssh_public_key_authentication.md %}

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc`,
```sh
export ISSM_DIR=<PATH_TO_ISSM>

# Load modules
module load intelcomp/17.0.0 mpt/2.14 petsc/3.7.4d
module load parmetis/4.0.3 mumps/5.0.2
module load automake
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to (note that this should be a subdirectory of `/cluster/work/users/<USERNAME>/`). Then, run,
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
export CXXFLAGS="-O2 -xAVX"
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --with-wrappers=no \
    --without-kriging \
    --with-mpi-include="/sw/sgi/mpt/mpt-2.14/include/" \
    --with-mpi-libflags="-L/sw/sgi/mpt/mpt-2.14/lib -lmpi -lmpi++" \
    --with-petsc-dir="/sw/sdev/Modules/petsc/petsc-3.7.4" \
    --with-metis-dir="/sw/sdev/Modules/parmetis/parmetis-4.0.3/include" \
    --with-mumps-dir="/sw/sdev/Modules/mumps/mumps-5.0.2" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
```

You can then make your configuration file executable (if it is not already) and execute it to compile and install ISSM,
```sh
chmod +x configure.sh
./configure.sh
make install
```

### Troubleshooting
Due to the fact that the Autotools on this machine are out of date, you should comment out the following line in `src/c/main/EnvironmentInit.cpp`,
```cpp
if(!my_rank) printf("(website: %s contact: %s)\n",PACKAGE_URL,PACKAGE_BUGREPORT);
```

## Cluster Class Settings
In order to connect to {{ page.machine_name }} from the machine that you are doing model setup and results analysis on, you will need to create a cluster class settings file for your chosen scripting interface.
<div class="issm-api-tabs">
<div class="tab" data-api="mat" markdown="1">
Create file `$ISSM_DIR/src/m/vilje_settings.m`, which might include,
```matlab
cluster.login='<USERNAME>';
cluster.queue='workq';
cluster.codepath='<PATH_TO_ISSM_ON_CLUSTER>/bin/';
cluster.executionpath='<PATH_TO_ISSM_ON_CLUSTER>/execution/';
cluster.accountname='nn4659k'; % this is for ice2ice
cluster.numnodes=1;
cluster.numprocess=8;
```
</div>
<div class="tab" data-api="py" markdown="1">
Create file `$ISSM_DIR/src/py/vilje_settings.py`, which might include,
```py
def vilje_settings(md):
    md.cluster.login='<USERNAME>'
    md.cluster.queue='workq'
    md.cluster.codepath='<PATH_TO_ISSM_ON_CLUSTER>/bin/'
    md.cluster.executionpath='<PATH_TO_ISSM_ON_CLUSTER>/execution/'
    md.cluster.accountname='nn4659k' # this is for ice2ice
    md.cluster.numnodes=1
    md.cluster.numprocess=8
    return md
```
</div>
</div>
replacing `<USERNAME>` with your {{ page.machine_name }} username and entering your code path and execution path (`<PATH_TO_ISSM_ON_CLUSTER>` should be in `/work/<USERNAME>/`). These settings will be picked up automatically by MATLAB when you run `md.cluster=vlije()`.
