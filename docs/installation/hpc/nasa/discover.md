---
title: Discover
layout: default
parent: NASA
machine_name: "Discover"
has_toc: false
---

# {{ page.machine_name }} (NASA NCCS)
{: .no_toc }

## Table of Contents
{: .no_toc }
1. TOC
{:toc}
---

Comprehensive information on access to and use of [NASA Center for Climate Simulation (NCCS) systems](https://www.nccs.nasa.gov/){:target="_blank"}.

## Getting an Account
New users will have to ask a NASA- or JPL-employed PI to request an account for them on NAS HECC. They will need the group ID of the PI in order to submit this request.

First, the PI should use the following procedure:
- navigate to the [NAS HECC 'Account Request System' page](https://www.nas.nasa.gov/hecc/portal/accounts){:target="_blank"}
- select option '3. I want to request a NASA identity for one of my new users'
- provide the requested information

Then, the user needs to request an account with the following procedure:
- navigate to the [NAS HECC 'Account Request System' page](https://www.nas.nasa.gov/hecc/portal/accounts){:target="_blank"}
- select option '2. I want to request and account for myself'
- provide the group ID for the PI that initiated the request
- the PI will then receive an email to approve the request

{: .highlight-title }
> Note
>
> All users must complete NASA's Basic IT Security Training.

Then, an NCCS account has to be created by the new user:
- navigate to [the NCCS website](https://www.nccs.nasa.gov/nccs-users/instructional/account-set-up){:target="_blank"}
- submit a NAMS request
- the PI will receive an email to approve the request

## Environment
On {{ page.machine_name }}, add the following lines to `~/.bashrc`,
```sh
# Load modules
module purge
module load comp/intel/2021.4.0
module load mpi/impi/2021.4.0
module load cmake/3.28.2

# ISSM
export ISSM_DIR=<PATH_TO_ISSM>
source $ISSM_DIR/etc/environment.sh
```
replacing `<PATH_TO_ISSM>` with the path to the directory that you cloned the ISSM source code repository to (note that this should be a subdirectory of `/discover/nobackup/<USERNAME>/`). Then, run,
```sh
source ~/.bashrc
```
or log out and log back in to apply this change.

## Installing ISSM on {{ page.machine_name }}
{{ page.machine_name }} will *only* be used to run the code: you will use your local machine for pre- and post-processing; you will never use {{ page.machine_name }}' MATLAB.

Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- m1qn3
- PETSc    (use the latest script for {{ page.machine_name }})

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
#!/bin/sh

export CXXFLAGS="-g -O3"

# Configure ISSM
./configure \
    --prefix="${ISSM_DIR}" \
    --enable-development \
    --enable-debugging \
    --without-wrappers \
    --without-Love \
    --without-kml \
    --without-Sealevelchange \
    --with-mpi-include="/usr/local/intel/oneapi/2021/mpi/2021.4.0/include" \
    --with-mpi-libflags="-L/usr/local/intel/oneapi/2021/mpi/2021.4.0/lib -lmpicxx -lmpifort" \
    --with-mkl-libflags="-L/usr/local/intel/oneapi/2021/mkl/2021.4.0/lib/intel64 -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm" \
    --with-m1qn3-dir="${ISSM_DIR}externalpackages/m1qn3/install" \
    --with-metis-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-petsc-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-scalapack-dir="${ISSM_DIR}/externalpackages/petsc/install" \
    --with-mumps-dir="${ISSM_DIR}/externalpackages/petsc/install"
```

You can then make your configuration file executable (if it is not already) and execute it to compile and install ISSM,
```sh
chmod +x configure.sh
./configure.sh
make install
```

## Installing ISSM on {{ page.machine_name }} with Dakota
For an installation of ISSM with Dakota, the following *additional* external packages are required:
- gsl       install-static.sh
- boost     install-1.55-discover.sh
- dakota    install-6.2-discover.sh
- chaco     install.sh

Then, you will need to add the following lines to your configuration script,
```sh
    --with-dakota-dir="${ISSM_DIR}/externalpackages/dakota/install" \
    --with-boost-dir="${ISSM_DIR}/externalpackages/boost/install" \
    --with-chaco-dir="${ISSM_DIR}/externalpackages/chaco/install"
```

## Cluster Class Settings

### MATLAB
Create file `$ISSM_DIR/src/m/pfe_settings.m` on the machine that you are doing model setup and results analysis on. This file will set up your personal settings so that that machine can send solution requests to {{ page.machine_name }} and retrieve results. For example, this file might include,
```matlab
cluster.login='<USERNAME>';
cluster.name='discover.nccs.nasa.gov';
cluster.queue='nccs';
modules={'comp/intel/2021.4.0' 'mpi/impi/2021.4.0' 'cmake/3.28.2'};
cluster.codepath='<PATH_TO_ISSM_ON_CLUSTER>/bin';
cluster.executionpath='<PATH_TO_ISSM_ON_CLUSTER>/execution/';
cluster.grouplist='s5692';
cluster.port=1099;
```
replacing `<USERNAME>` with your {{ page.machine_name }} username and entering your code path and execution path (`<PATH_TO_ISSM_ON_CLUSTER>` should be in `/cluster/work/users/<USERNAME>/`). These settings will be picked up automatically by MATLAB when you run `md.cluster=discover()`.

To determine your `grouplist`, on {{ page.machine_name }} run,
```sh
groups <USERNAME>
```

Make sure your `modules` list matches those set in `~/.bashrc` on {{ page.machine_name }}.

## Running Jobs on {{ page.machine_name }}
On {{ page.machine_name }}, the more nodes and time requested, the longer your job will have to wait in the queue, so choose your settings accordingly. For example,
```matlab
md.cluster=discover('numnodes',8,'time',30,'processor','west','queue','debug');
md.cluster.time=10;
```
to have a maximum job time of 10 minutes and 8 westmere nodes. If the run lasts longer than 10 minutes, it will be killed and you will not be able to retrieve your results.

More info about [available queues on {{ page.machine_name }}](https://www.nccs.nasa.gov/discover-qos/){:target="_blank"}.

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

