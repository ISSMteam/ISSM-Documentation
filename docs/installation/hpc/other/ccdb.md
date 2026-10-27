---
title: CCDB
layout: default
parent: Other HPCs
machine_name: "CCDB HPCs"
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
[Request a CCDB account](https://docs.alliancecan.ca/wiki/Apply_for_a_CCDB_account){:target="_blank"}.

## SSH Configuration
[Instructions for connecting to {{ page.machine_name }} via SSH](https://docs.alliancecan.ca/wiki/SSH){:target="_blank"}.

## Environment
On { page.machine_name }}, add the following lines to `~/.bashrc`,
```sh
# Load modules
module load gcc openmpi matlab metis parmetis imkl petsc

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
Clone the [ISSM source code repository on GitHub](https://github.com/ISSMteam/ISSM){:target="_blank"} and install the following packages:
- m1qn3

Follow the [detailed instructions for compiling ISSM on Linux](../../linux), and use the following configuration script (adapt to your needs),
```sh
./configure \
    --prefix="${ISSM_DIR}" \
    --with-numthreads=2 \
    --with-mpi-include="/some/path/just/to/enable" \
    --with-mpi-libflags="-lmpi_cxx -lmpi_mpifh -lmpi" \
    --with-fortran-lib="-L${EBROOTGCC}/lib64 -lgfortran" \
    --with-mkl-libflags="-lmkl_gf_lp64 -lmkl_sequential  -lmkl_core -lmkl_blacs_openmpi_lp64 -lmkl_scalapack_lp64" \
    --with-petsc-dir="${EBROOTPETSC}" \
    --with-mumps-dir="${EBROOTPETSC}" \
    --with-m1qn3-dir="${ISSM_DIR}/externalpackages/m1qn3/install" \
```

## Cluster Class Settings
In order to connect to {{ page.machine_name }} from the machine that you are doing model setup and results analysis on, you will need to create a cluster class settings file for your chosen scripting interface.
<div class="issm-api-tabs">
<div class="tab" data-api="mat" markdown="1">
Create `$ISSM_DIR/src/m/computecanada_settings.m`, which might include,
```matlab
cluster.login='<USERNAME>';
cluster.port=0;
cluster.codepath='<PATH_TO_ISSM_ON_CLUSTER>/bin/';
cluster.executionpath='<PATH_TO_ISSM_ON_CLUSTER>/execution/';
```
</div>
<div class="tab" data-api="py" markdown="1">
Cluster class `computecanada.py` still needs to be developed.
</div>
</div>
replacing `<USERNAME>` with your CCDB username and entering your code path and execution path. These settings will be picked up automatically when you run `md.cluster=computecanada()`.
